Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Mar 2007 06:45:26 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l25EjG6p009021
	for <linux-xfs@oss.sgi.com>; Mon, 5 Mar 2007 06:45:18 -0800
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1HOEQw-0005Qh-A2
	for linux-xfs@oss.sgi.com; Mon, 05 Mar 2007 15:45:02 +0100
Received: from pool-71-163-240-183.washdc.fios.verizon.net ([71.163.240.183])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 05 Mar 2007 15:45:02 +0100
Received: from chaweber by pool-71-163-240-183.washdc.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 05 Mar 2007 15:45:02 +0100
From: Chuck Weber <chaweber@gmail.com>
Subject: xfs partial dismount issue
Date: Mon, 5 Mar 2007 13:13:28 +0000 (UTC)
Message-ID: <loom.20070305T141214-502@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi everyone, I have a long running problem perhaps you can help with. I
will include as much detail as I can. I can set up a spare server-disk
set for testing if you have any bright ideas.

We use XFS for samba and nfs on x86_64 Fedora Proliant DL585/385
servers. Our busiest server has disk partitions go away. The other
servers do not show this behavior ever. The partitions show as mounted,
but access to the partition just hangs. Open file count, process count
and load average rise until the server becomes very unresponsive. Even
if we catch it before the high load average, because it cannot unmount
the partition, it must be powered off and back on to restart. Upon
restart all partitions mount properly and everything is fine for days or
months. There is nothing in log files that I have noticed. With sar, I
can track the files open and process count rise. I believed this to be a
hardware issue and embarked on replacing parts along the partition
chain. I recently replaced the actual server and saw the same issue the
next week, so I don't think it is hardware. The problem is related to
XFS/Samba/acl/load usage I think, as I have 2-8 directories set up as
samba shares in a given partition. When the problem occurs, first I
cannot access a directory, shortly afterward I cannot access the entire
partition. This problem has affected 3 partitions so far. Over the last
3 months this has occurred every week or 2.


Configuration:

Proliant DL585, 8GB ram, 2 proc with 3 smartarray 6404 4 channel U320
raid cards. 6 MSA30 dual channel disk carriers with 14 drives each in
raid with 2 parity stripes. We started with 72 GB drives and have
updated 1 carrier each with 146 GB and 300 GB drives. Each disk carrier
is mounted as a single partition, store1 through store6. Example of last
mounting problem partition below:


/dev/cciss/c3d0p1 on /share/store3 type xfs (rw,logbufs=8) 

/dev/cciss/c3d0p1 814G 677G 138G 84% /share/store3

meta-data=/dev/cciss/c3d0p1 isize=2048 agcount=32, agsize=6668186 blks

= sectsz=512 

data = bsize=4096 blocks=213381952, imaxpct=25

= sunit=0 swidth=0 blks, unwritten=1

naming =version 2 bsize=4096 

log =internal bsize=4096 blocks=32768, version=1

= sectsz=512 sunit=0 blks

realtime =none extsz=65536 blocks=0, rtextents=0

I have added nobarrier and noatime mount options recently from the list
but don't see that they affect the problem.

For the 300 Gb disk carrier I am using LVM as it runs into a 6404 2TB
limit but I only am using 3-400 GB on it so far.

All servers are running x86_64 Fedora so I hope not to have the stack
issue.

The Dl585/3raid controllers/6 disk chassis without problems runs Fedora
Core 2 and acts as an NFS server to some computational computers.
Another DL585 with only 1 raid controller acts as windows home directory
and mail store server. It runs Fedora Core 4/ samba 3.023a. These
servers would show the same xfs_info as above on their raid partitions.
Both of these servers have no problems and very long uptimes. 


Our problem server started as Fedora Core 2 and whatever samba we used
then. When it first had problems, I upgraded to FC 4 and then to FC5
with samba 3.0.24. I have applied all current HP firmware throughout
this process. I have changed out power, disks, disk carriers, scsi
cables, and raid controllers. I finally swapped the DL585 for a DL385
with 4 processors and 16 GB ram. None of this made a difference. Fedora
core 5 2.6.18 and 19 kernels dumped within 1 day of booting with a
spinlock error, so I am now running the latest FC5 2.6.17 kernel, which
does include the 17.13 patch. I have run HP diagnostics for hours with
no results. I have taken the active server offline and run xfs_repair on
the partitions. I have reformatted one of the partitions. I have been
formatting the partitions with an inode size of 2k and no other options.

Current rpms, but note that I have used different versions on this
server from FC2 to present and downloaded/built acl/attr/xfsprogs at
times all with no difference in my problem:

acl-2.2.34-1.2

attr-2.4.28-1.2

samba-3.0.24-1.fc5

xfsprogs-2.7.3-1.2.1

kernel-2.6.17-1.2187_FC5

I could move to ext3, but in my one recent test it ran into trouble just
copying acled files from an XFS partition to it. XFS performance seems
quite good, with my limiting factor being AD user/group id times. 

All I can think of now is some resource/tuning/formatting/kernel change.
I would appreciate any suggestions you can come up with.

Thanks,
Chuck 
 
