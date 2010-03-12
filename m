Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2CBk69O248752 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 05:46:06 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EECA1421961
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 03:47:38 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id lcsH7suzPcBiscwb
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 03:47:38 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 257F46C3DB
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 05:47:38 -0600 (CST)
Message-ID: <4B9A2A00.1050304@hardwarefreak.com>
Date: Fri, 12 Mar 2010 05:48:16 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: XFS buffered sequential read performance low after kernel upgrade
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

Hello,

I'm uncertain whether this is the best place to bring this up.  I've been
lurking a short while and it seems almost all posts here deal with dev
issues.  On the off chance this is an appropriate forum, here goes.

I believe I recently ran into my first "issue" with XFS.  Up to now I've
been pleased as punch with XFS' performance and features.  I rolled a new
kernel the other day going from vanilla kernel.org 2.6.31.1 to 2.6.32.9.
This is an i386 binary small mem kernel running on a dual Intel P6 class
system.  I tried 2.6.33 but apparently my version of gcc in Debian Lenny is
too old.  Anyway, I'm noticing what I believe to be a fairly substantial
decrease in sequential read performance after upgrading my kernel.

The SUT (system under test) has one single platter WD 500GB 7.2K rpm SATA
disk, Sil 3512 chip, sata_sil driver, NCQ disabled, elevator=deadline, disk
carved as follows and with the following mount options and xfs_info:

Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sda1     ext2     92M  5.9M   81M   7% /boot
/dev/sda2     ext2     33G  6.9G   25G  22% /
/dev/sda6      xfs     94G  2.0G   92G   3% /home
/dev/sda7      xfs     94G   20G   74G  21% /samba

/dev/sda1       /boot           ext2    defaults                0       1
/dev/sda2       /               ext2    errors=remount-ro       0       2
/dev/sda5       none            swap    sw                      0       0
/dev/sda6       /home           xfs     defaults                0       0
/dev/sda7       /samba          xfs     defaults                0       0

~$ xfs_info /home
meta-data=/dev/sda6              isize=256    agcount=4, agsize=6103694 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=24414775, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=11921, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

~$ xfs_info /samba
meta-data=/dev/sda7              isize=256    agcount=4, agsize=6103694 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=24414775, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=11921, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

hdparm test results for the filesystems:

/dev/sda2:
 Timing O_DIRECT disk reads:  236 MB in  3.01 seconds =  78.48 MB/sec
/dev/sda2:
 Timing buffered disk reads:  172 MB in  3.03 seconds =  56.68 MB/sec

/dev/sda6:
 Timing O_DIRECT disk reads:  238 MB in  3.00 seconds =  79.21 MB/sec
/dev/sda6:
 Timing buffered disk reads:  116 MB in  3.03 seconds =  38.27 MB/sec

/dev/sda7:
 Timing O_DIRECT disk reads:  238 MB in  3.01 seconds =  79.10 MB/sec
/dev/sda7:
 Timing buffered disk reads:  114 MB in  3.00 seconds =  37.99 MB/sec

Note that XFS is giving up almost 20MB/s to EXT2 in the hdparm read tests
through the Linux buffer cache.  IIRC hdparm is supposed to ignore the
filesystem, according to the man page, but I don't think this is true given
the that the O_DIRECT read performance for the EXT2 partition and both XFS
partitions is identical.  Going through the buffer cache cuts XFS read
performance in half compared to O_DIRECT.  EXT2 fares much better, losing
about a third of its O_DIRECT performance to the buffer cache.

Some dd read tests:

~$ dd if=/dev/sda2 of=/dev/null bs=4096 count=100000
100000+0 records in
100000+0 records out
409600000 bytes (410 MB) copied, 5.69972 s, 71.9 MB/s

~$ dd if=/dev/sda6 of=/dev/null bs=4096 count=100000
100000+0 records in
100000+0 records out
409600000 bytes (410 MB) copied, 7.53601 s, 54.4 MB/s

~$ dd if=/dev/sda7 of=/dev/null bs=4096 count=100000
100000+0 records in
100000+0 records out
409600000 bytes (410 MB) copied, 8.25571 s, 49.6 MB/s

Same thing with dd.  The XFS partitions lag behind EXT2 by about 20MB/s,
although the overall numbers are better for dd than hdparm which seems to be
my general experience using the two utils.

Some small dd write tests:
EXT2
~$ dd if=/dev/zero of=/test.xfs bs=4096 count=100000
100000+0 records in
100000+0 records out
409600000 bytes (410 MB) copied, 5.72976 s, 71.5 MB/s

XFS
~$ dd if=/dev/zero of=/home/stan/test.xfs bs=4096 count=100000
100000+0 records in
100000+0 records out
409600000 bytes (410 MB) copied, 5.97482 s, 69.6 MB/s

XFS
~$ dd if=/dev/zero of=/samba/test.xfs bs=4096 count=100000
100000+0 records in
100000+0 records out
409600000 bytes (410 MB) copied, 5.91914 s, 68.8 MB/s

XFS seems to keep right up with EXT2 in the write tests.  The 35GB EXT2
partition is on the outer edge of the platter, following inward by the 100GB
XFS /home partition and then the 100GB /samba partition.  I think the slight
performance difference in the dd write tests is mostly due to partition
placement on the platter.

I don't recall doing any testing as formal as this with the old kernel.
However, I don't recall sub 40MB/s XFS read numbers from hdparm.  That
really surprised me when I went kicking the tires on the new kernel.  IIRC,
on the previous kernel, buffered sequential read performance was pretty much
the same for EXT2 and XFS, with XFS showing a small but significant lead in
write performance.

So, finally, my question:  Is there a known issue with XFS performance in
kernel 2.6.32.x, or is there something I need to tweak manually in the mount
options or other in 2.6.32.x that was automatic in the previous kernel?  I
created the filessytems on 2.6.21.1 if that has any bearing.

Thanks in advance for any answers or advice you may be able to provide.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
