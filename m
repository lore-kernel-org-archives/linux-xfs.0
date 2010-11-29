Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT5dt5O109968 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 23:39:56 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C60713F7713
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 21:41:36 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id DdS2xxpIQRJPMPYN
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 21:41:36 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 00D9B6C0AF
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 23:41:35 -0600 (CST)
Message-ID: <4CF33D0F.6080404@hardwarefreak.com>
Date: Sun, 28 Nov 2010 23:41:35 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: performance
References: <AANLkTi=u8dX0ehPN3Rv3FQ+84htY3AYEv0eboGgC7_qi@mail.gmail.com>	<20101129001112.GA28672@dastard>	<AANLkTikom6jpkuZquTfinGpaqz4Gp0y8niYN7yWQgmzj@mail.gmail.com>	<20101129015937.GB28672@dastard>	<AANLkTikw086Z_66cz_U-EdFQx14TXP6XmiG-KyLN4BLo@mail.gmail.com>
	<AANLkTi=-y0v4MzyU+qWPmvazouDu0N3gqSvVTU1z4Gke@mail.gmail.com>
In-Reply-To: <AANLkTi=-y0v4MzyU+qWPmvazouDu0N3gqSvVTU1z4Gke@mail.gmail.com>
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

Yclept Nemo put forth on 11/28/2010 9:57 PM:

> Pheww... I'm relieved to learn that my performance degradation will be
> alleviated with this hard-drive update. Which also means I need no
> longer be so obsessive-compulsive when tweaking the second incarnation
> of my XFS file-system.

You can also alleviate this problem with careful planning.  Have a /boot
and / filesystem that are painfully small, making / just large enough to
hold the OS files, log files, etc.  Make one or more XFS filesystems to
hold your data.  If one of these becomes slow due to hitting the 85%+
mark, you can simply copy all the data to an external device or NFS
mounted directory, delete and then remake the filesystem, preferably
larger if you have free space on the drive.  When you copy all the files
back to the new filesystem, your performance will be restored.  The
catch is you need to make the new on bigger by at least 15-20%, more if
you have the space, to prevent arriving at the same situation soon after
doing all this.

> As I understand an XFS system is demarcated into several allocation
> groups each containing a superblock as well as private inode and
> free-space btrees, and thus increasing the AG count increases
> parallelization. I simply assumed the process was CPU-bound, not disk
> bound. Though by mentioning spindles, I realized it makes sense to
> limit the amount of parallel access to a single hard drive; I've often
> noticed XFS come to a crawl when I simultaneously call multiple
> intensive IO operations.

You didn't notice XFS come to a crawl.  You noticed your single disk
come to a crawl.  Even 15k rpm SAS drives max out at ~300 seeks/sec.  A
5.4k rpm laptop SATA drive will be lucky to sustain 100 seeks/sec.  A
cheap SATA SSD will do multiple thousands of seeks/sec, as will a RAID
array with 8 or more 15k SAS drives and a decent sized write cache, say
256MB or more.

Multiple AGs really shine with large RAID arrays with many spindles.
They are far less relevant WRT performance of a single disk.

> You mention an eight-core machine (8c?). Since I operate a dual-core
> system, would it make sense to increase my AG count slightly, to five
> or six?

Dave didn't mention the disk configuration of his "workstation".  I'm
guessing he's got a local RAID setup with 8-16 drives.  AG count has a
direct relationship to the storage hardware, not the number of CPUs
(cores) in the system.  If you have a 24 core system (2x Magny Cours)
and a single disk, creating an FS with 24 AGs will give you nothing, and
may actually impede performance due to all the extra head seeking across
those 24 AGs.

> Hm.. I was going to wait till 2.6.39 but I think I'll enable delayed
> logging right now!

Delayed logging can definitely help increase write throughput to a
single disk.  It pushes some of the I/O bottleneck into CPU/memory
territory for a short period of time.  Keep in mind that data must
eventually be written to disk, so you are merely delaying the physical
disk bottleneck for a while, as the name implies.  Also note that it
will do absolutely nothing for read performance.

> Now for the implementation of transferring the data to new XFS
> partition/hard-drive...
> I was originally going to use  "rsync -avxAHX" until I stumbled across
> this list's thread, "ENOSPC at 90% with plenty of inodes" which
> mentioned xfsdump and xfsrestore. I now have three questions:

If xfsdump/xfsrestore don't turn out to be a viable solution...

Just create a new big XFS filesystem on the new disk, such as you have
now, with the defaults.  Enter runlevel 2, stop every daemon you can
without blowing things up, and "cp -a" everything over to the new
filesystem.  Modify /etc/lilo or /etc/grub accordingly on the new disk
to use the new disk, and burn an MBR to the new disk.  Reboot the
machine, enter BIOS, set new disk as boot, and boot.  It should be that
simple.  If it doesn't work, change the boot disk in the BIOS, boot the
old disk, and troubleshoot.

This is pretty much exactly what I did when I replaced the drive in my
home MX/Samba/etc server about a year ago, although I had many
partitions instead of one, all EXT2 not XFS, and probably many more
daemons running that your workstation.  I copied each FS separately, and
avoided /proc, which turned out to be a mistake.  There are apparently a
few things in /proc that the kernel doesn't create new on each boot, so
I had to go back and copy those individually-can't recall now exactly
what they were.  Anyway, cp _everything_ over, and ignore any errors,
and you should be ok.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
