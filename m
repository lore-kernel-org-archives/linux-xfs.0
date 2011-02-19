Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1J3otwl256181 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 21:50:55 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D9D32EAA88
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 19:53:35 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id yH9S9GIz50QGzCCS
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 19:53:35 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 4345F6C043
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 21:53:35 -0600 (CST)
Message-ID: <4D5F3EBF.3030309@hardwarefreak.com>
Date: Fri, 18 Feb 2011 21:53:35 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: External log size limitations
References: <4D5C1D77.1060000@spinpro.com>
	<20110217003233.GH13052@dastard>	<4D5E8FAD.9080802@spinpro.com>
	<4D5ECEC5.2020701@hardwarefreak.com> <4D5ED70B.7030504@spinpro.com>
In-Reply-To: <4D5ED70B.7030504@spinpro.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Fist, sorry for the length.  I can tend to get windy talking shop. :)

Andrew Klaassen put forth on 2/18/2011 2:31 PM:

> It's IBM and LSI gear, so I'm crossing my fingers that a Linux install
> will be relatively painless.

Ahh, good.  At least, so far it seems so. ;)

> I thought that the filesystem block size was still limited to the kernel
> page size, which is 4K on x86 systems.
> 
> http://oss.sgi.com/projects/xfs/
> 
> "The maximum filesystem block size is the page size of the kernel, which
> is 4K on x86 architecture."
> 
> Is this no longer true?  It would be awesome news if it wasn't.

My mistake.  It would appear you are limited to the page size, which, as
I mentioned, is still 8 KiB for most distros.  If you roll your own
kernel you can obviously tweak this, but to what end?  The kernel team's
trend is toward smaller page sizes for greater memory usage efficiency.

> My quick calculations were based on worst-case random read, which is
> what we were seeing with the Exastore.  They had a 64K blocksize * 48
> disks * 70 seeks per second = 215 MB/s, which is exactly what we were
> seeing under load.  Under heavy random load, I'm worried that XFS has to
> either thrash the disks with 4K reads and writes ~or~ introduce
> unnecessary latency by doing read-combining and write-combining and/or
> predictive elevator hanky-panky.

I think you're giving too much weight to the filesystem block size WRT
random read IO throughput.  Once you seek to the start of the file
location on disk, there is no more effort involved in reading the next
128 disk sectors whether the XFS block size is 8 sectors or 128 sectors.
 And for files smaller than 64 KiB you're actually _decreasing_ your
seek performance when using 64 KiB blocks.  For instance, if you have a
file that is 16 KiB and you have a 4 KiB block size, you'll head seek to
the start of the file, read 4 blocks (32 sectors), and then the head is
free to seek to the next request.  With a 64 KiB block size, you seek to
the start of the 16 KiB file, then read 128 sectors, the last 96 sectors
being being empty, or contents of another file, and you just wasted time
reading 96 sectors instead of allowing the head to seek to the next request.

So, using a smaller block size doesn't give you decreased performance
for large files, but it gives you better performance for small files.

Also, 215 MB/s random IO seems absolutely horrible for 48 drives.  Are
these 15k FC/SAS drives or 7.2k SATA drives?  A single 15k drive should
sustain ~250-300 seeks/sec, a 7.2K drive about 100-150.  70 seeks/sec is
below 5.4K laptop drive territory.

Additionally, tweaking things like

/sys/block/[dev]/queue/max_hw_sectors_kb
/sys/block/[dev]/queue/nr_requests

and the elevator

/sys/block/[dev]/queue/scheduler

Will affect this performance more than the FS block size.

> I miscounted; it's 48 drives split into 6 hardware RAID-5 arrays.

Eeuuww.  RAID 5 is not known for stellar random read performance (nor
stellar anything performance, especially horrible for random writes).
Quite the opposite.

A suggestion.  You'd lose about 38% of your current space if my math is
correct, but reconfiguring each of those as hardware RAID 10 instead of
5, and concatenating them with mdraid or LVM should give you at
_minimum_ a 2:1 boost in sustained random read IOPS and bandwidth,
probably much much much more.  Random writes would be much higher still.

If you can get by with that much less space I'd go with six 8 disk HW
RAID 10s in the new setup assuming you have 6 LSI HBAs.  Whatever the
number of HBAs, create a RAID 10 on each with an equal number of drives
on each HBA.  It doesn't make sense to have more than one RAID pack on a
single HBA--just slows it down considerably.  If they did that with
these RAID 5s that could explain some of the performance issue.  I'd set
the LSI RAID 10 stripe size to between 64KB - 256KB depending on your
average file size.  I'd then concatenate the resulting 6 devices (or
however many there be) with mdadm or LVM (mdadm is probably a little
faster, LVM more flexible).

Then when creating your XFS filesystem, specify agcount=48 or
(agcount=#HBAs*8) in this case, which will get you 8 allocation groups
per HW array, in essence 2 AGs per stripe count spindle--8 disks, 4
striped mirror pairs, 4 stripe spindles.  This should get you the
parallelism you need for high performance multiuser random IO workloads.

This all assumes a highly loaded server with a lot of access to multiple
different files.  If your access pattern is one heavy hitter app against
only a few big files, getting parallelism via lots of allocation groups
on concatenated storage may not be the way to go.  In that case we'd
need to go with multiple layer striping, with HW RAID 10 and software
RAID 0 across them.

I didn't recommend this because trying to get average size files broken
up into chunks that fit neatly across a layered stripe is almost
impossible, and you end up with weird allocation patterns on disk,
wasted space issues, etc.  I think it's better to use smallish HW
stripes, no SW stripes, in an instance like this, and allow XFS to drive
the parallelism via allocation groups.  This yields better file layout
on disk and better space utilization.

In addition, using concatenation, as we recently learned from an OP who
went through it (unfortunately), with this setup you can lose an entire
hardware array and the FS can keep chugging along after a repair.  You
simply lose any files on the dead array.

> Is there a way to monitor log operations to find out how much is being
> used at a given time?

Point in time?  Probably not.  I'm sure there's a counter somewhere but
I'm not familiar with it.  What you should be concerned with isn't
necessarily how much of the journal log is being used at any point in
time, but how fast the data is moving through the log.  This is why the
speed of the log device is critical, and the size is not.  Recall that
the max log size is 2GB.

> All the metadata eventually has to be written to the main array, so
> doesn't that ultimately become the limiting factor on metadata
> throughput under sustained load?

The answer is:  it depends on the workload.  Add another "depends" when
using delaylog.  For example, a given directory inode may be modified
multiple times during a very short period of time.  'rm -rf' on a huge
directory is a good example of this.  A huge number of modifications to
the directory are performed, but with delaylog they will be consolidated
and coalesced into a single or a few actual writes into the journal and
filesystem instead of many thousands of writes.  These types of
operations are historically where the metadata bottleneck lurked.  If
you simply have 1000 users hitting a fileserver and each user writes a
file every minute or so, you'll never see a metadata bottleneck.  If you
have _and_ one user decides to delete a directory with 100k files in it,
then you have a metadata bottleneck, at least, if you're not using
delaylog.  If you are using it you won't see much of a bottleneck.
Although you'll see some pretty high CPU usage for a 100k file delete
operation.  But the load on the on disk journal log will be relatively
light.

Please keep us posted.  I'm really interested to see what you end up
doing with this and how it performs afterward.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
