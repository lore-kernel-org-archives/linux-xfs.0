Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 00:45:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M7jS3u010065
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 00:45:29 -0700
Received: from smtpout.eastlink.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86C6152B65E
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 00:46:50 -0700 (PDT)
Received: from smtpout.eastlink.ca (smtpout.eastlink.ca [24.222.0.30]) by cuda.sgi.com with ESMTP id BhRL6PFMuNLvvP72 for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 00:46:50 -0700 (PDT)
Received: from ip04.eastlink.ca ([24.222.39.52])
 by mta02.eastlink.ca (Sun Java System Messaging Server 6.2-4.03 (built Sep 22
 2005)) with ESMTP id <0K9400365QNOUNJ2@mta02.eastlink.ca> for xfs@oss.sgi.com;
 Wed, 22 Oct 2008 04:40:36 -0300 (ADT)
Received: from peter by llama.cordes.ca with local (Exim 3.36 #1 (Debian))
	id 1KsYKV-0005c1-00	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 04:40:31 -0300
Date: Wed, 22 Oct 2008 04:40:31 -0300
From: Peter Cordes <peter@cordes.ca>
Subject: small logs that fit in RAID controller cache are (sometimes) faster
Message-id: <20081022074031.GA19754@cordes.ca>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

 I've been playing with external vs. internal logs, and log sizes, on
a HW RAID controller w/256MB of battery-backed cache.  I'm getting the
impression that for a single-threaded untar workload at least, a small
log (5 or 20MB) is actually faster 128MB.  I think when the log is
small enough relative to the RAID controller's write-back cache, the
writes don't have to wait for actual disk.  It's (maybe) like having
the log on a ramdisk.  Battery-backed write caches on RAID controllers
make nobarrier safe (right?), so that's what I was using.

 With a 20MB external log (on an otherwise-idle RAID1, while the
filestem is on a RAID6), during a small-file portion of the tar
extraction, I saw log write speeds of over 100MB/s (average over 10s,
with dstat, which is like iostat)  1 second peaks of 115MB/s.  The
disk's max sequential write is more like 80MB/s, which is the peak I
was seeing with a 128MB log.

 The only workload I'm testing with varying log sizes is untarring
/home onto a fresh filesystem, so single-threaded creation of 121744
files totalling 12.1GB.  There were a few very large directories
(10000 files) of mostly small files (25% < 512B, 50% < 1.5k, 95% <
32k, 99.5% < 100k)[1].  There are also some large files on the FS
(maybe an ISO image or something).  Watching disk throughput during
the untar, there is a log-bound portion and a large-file portion that
hardly has any log I/O. (The tar was compressed with lzop to 6.9GB,
and read over gigE NFS.  I primed the cache so there is no NFS traffic
for about the first half of the test, and it's never read-limited.
Max NFS read speed is > 100MB/s, and I never saw more than 50MB/s
during the untar. (NFS server is one of the 16GB-RAM compute nodes, so
easily caching the whole file for when the writes evict some of the
tar.lzo from the cache on the master node.)  Highest user-time CPU
usage is about half of a single CPU, system time never hit a full CPU
either, so those weren't limiting factors.

 untar times:
110s w/  a 128MB internal log (note that the max sequential write is
           at least ~3x higher for the RAID6 the internal log is on)
116s w/  a 128MB external log
113s with a 96MB external log
110s with a 64MB external log
115s with a 20MB external log
110s with a  5MB external log

 (although IIRC I did see 105s with a 5 or 20MB external log.  Sorry,
wasn't recording all the timings I did, since I wasn't planning to
post...  Also, sometimes I was seeing 130s times with the 128MB
external log, but maybe that was before I was so consistent with my
method for priming the cache, so it was being read-limited...  Now I
cat twice to /dev/null, then dd bs=1024k count=3200 to /dev/null to
make sure the first half of the file really wants to stay in the cache.)

 I'm thinking of creating the FS with a 96MB external log, but I
haven't tested with parallel workloads with logs < 128MB.  This RAID
array also holds /home (on the first 650GB of array), while this FS
(/data) is the last 2.2TB.  /home uses an internal log, so if
someone's keeping /home busy and someone else is keeping /data busy,
their logs won't both be going to the RAID6.  (I also use agcount=8 on
/data, agcount=7 on /home.  Although I/O will probably be bursty, and
not loading /home and /data at the same time, my main concern is to
avoid scattering files in too many places.  fewer AGs = more locality
for a bunch of sequentially created files, right?  I have 8 spindles
in the RAID, so that seemed like a good amount of AGs.  RAID6 doesn't
like small scattered writes _at_ _all_.)

 Basically, I really want to ask if my mkfs parameters look good
before I let users start filling up the filesystems and running jobs
on the cluster, making it hard to redo the mkfs.  Am I doing anything
that looks silly?


 mkfs: (from xfsprogs 2.10.1 patches with the sw+agcount usability fix)

mkfs.xfs -i attr=2 -d su=64k,sw=6,agcount=8 -n size=16k /dev/sdb2 -L data \
-l lazy-count=1,logdev=/dev/raid1/data-xfslog,size=$((1024*1024*96))
meta-data=/dev/sdb2              isize=256    agcount=8, agsize=70172688 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=561381403, imaxpct=5
         =                       sunit=16     swidth=96 blks
naming   =version 2              bsize=16384  ascii-ci=0
log      =/dev/raid1/data-xfslog bsize=4096   blocks=24576, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

mount -o noatime,usrquota,nobarrier,inode64,largeio,swalloc,logbsize=256k,logdev=/dev/raid1/data-xfslog
 noikeep is the default, since I don't use dmapi, otherwise I would
include it, too.  And yes, the XFS log is on LVM, near the start of
the disk.

 BTW, is there a way to mount the root filesystem with inode64?  If I
put that in my fstab, it only tries to do it with a remount (which
doesn't work), because I guess Ubuntu's initrd doesn't have mount
options from /etc/fstab.  I made my root fs 10GB, and with imaxpct=8,
so the 32bit inode allocator should do ok.


 I found -n size=16k helps with random deletion speed, IIRC.  I only
use that on the big RAID6 filesystems, not / or /var/tmp, since users
won't be making their huge data file directories anywhere else.
Bonnie++ ends up with highly fragmented directories (xfs_bmap) after
random-order file creation.

/dev/sdb1 and /dev/sdb2 both have their starts full-stripe aligned
(I used parted, and set unit s (sectors), since my strip width is
768sectors.  I used a GPT disklabel, since DOS wraps at 2TB)


 The hardware is a Dell PERC 6/E on an 8-disk 500GB (Seagate) SATA
7200RPM RAID6 (PERC 6/E = LSI MegaRAID SAS 1078 w/256MB of battery
backed cache.  It talks to an External box of hard drives (MD1000)
over a 4-lane (IIRC) SAS cable.)  The computer is a Dell PE1950
(equipped with a single quad core 2GHz Harpertown CPU (12MB cache
total), with 8GB of DDR2-667MHz on a 5000X chipset).  Linux 2.6.27
(Ubuntu Intrepid server kernel, which uses the deadline scheduler by
default.  Otherwise running Ubuntu AMD64 Hardy (current stable), but
it's new hardware that's better supported by a newer kernel.)

 The RAID1 (holding the external log) is on a PERC 6/I (similar
hardware, but hooked up to the interal SATA backplane in the server,
instead of the external MD1000.)  I'm not sure if it's a separate card
with its own 256MB of cache, or if it shares the 256MB with the RAID6
on the PERC 6/E.  (I opened up the case when the machine first arrived
(just sight-seeing, of course :), but I don't think I looked carefully
enough to rule out there being another RAID controller somewhere...)
If it's shared, that would explain why 128MB slows down.  Otherwise, I
don't know, since 128MB should still fit easily in the 256MB of cache.
The RAID1 and RAID6 are both set for adaptive readahead in the
controller BIOS, and with a 64kB stripe size on the RAID6.  I use
blockdev --setra 512 /dev/sda  # the internal RAID1
blockdev --setra 8192 /dev/sdb  # the RAID6

 I don't have time to edit my other benchmark numbers into a presentable
format right now (I have lots of bonnie++ single-threaded and parallel
results for various XFS parameters), but if anyone wants them, email
me and I'll post my notes.  


[1] This is pretty typical of what phylogenetics (trying to make
evolutionary trees based on DNA sequences of current life) grad
students and profs do on the cluster: generate output file for
combinations of (random subsets of) data sets and parameters.
Plus they compile software and extract tar files of source code, etc.
Probably we're most likely to be I/O bound when reading, since most
number crunching takes a lot of CPU for each output file, but
summarizing the data at the end usually involves reading all the
output files.  But I don't want it to be slow when people untar
something, or whatever.  The machine is an NFS server (over bonded
gigE) for a 650GB /home and a 2.2TB /data both on the same 8-disk
RAID6.  12 compute nodes will run jobs that write to those FSes
(usually slowly), while interactive users will mostly be local on the
master node.

 The large amount of small files people usually generate is why I
didn't go with LUSTRE.  It, or PVFS, might still be useful to make a
scratch filesystem out of the 500GB disks in each compute node,
though. :)

 Thanks,

-- 
#define X(x,y) x##y
Peter Cordes ;  e-mail: X(peter@cor , des.ca)

"The gods confound the man who first found out how to distinguish the hours!
 Confound him, too, who in this place set up a sundial, to cut and hack
 my day so wretchedly into small pieces!" -- Plautus, 200 BC
