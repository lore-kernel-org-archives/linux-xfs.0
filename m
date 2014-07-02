Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 716B67F54
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 07:04:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 629DF304053
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 05:04:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4FFm6BCJ4bTJqRxg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Jul 2014 05:04:49 -0700 (PDT)
Date: Wed, 2 Jul 2014 08:04:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
Message-ID: <20140702120441.GA51757@bfoster.bfoster>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mail list <xfs@oss.sgi.com>

On Wed, Jul 02, 2014 at 11:57:25AM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> 
> Hi,
> 
> I got this error:
> 
> 
> <0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.186436] r8169 0000:06:00.0 eth0: link up
> <0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.615073] PM: restore of devices complete after 2735.034 msecs
> <0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626346] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c39fe9
> <0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626346] <0.4>
> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626348] CPU: 0 PID: 28875
> Comm: kworker/0:2 Tainted: P           O 3.11.10-11-desktop #1
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626348] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7516/MS-7516, BIOS V1.5 10/10/2008
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626388] Workqueue: xfs-eofblocks/sde5 xfs_eofblocks_worker [xfs]
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626390]  0000000000000002 ffffffff815a0252 00000000002a61c2 ffffffffa0c38996
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626391]  ffff8800b7025680 ffff88022eb74180 ffff880121c3fe50 0000000000000002
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626393]  0000000000000000 0000000100000000 0000000000000000 0000000000000001
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626393] Call Trace:
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626403]  [<ffffffff81004a28>] dump_trace+0x88/0x310
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626406]  [<ffffffff81004d80>] show_stack_log_lvl+0xd0/0x1d0
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626408]  [<ffffffff810061bc>] show_stack+0x1c/0x50
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626411]  [<ffffffff815a0252>] dump_stack+0x50/0x89
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626425]  [<ffffffffa0c38996>] xfs_free_ag_extent+0x226/0x860 [xfs]
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626468]  [<ffffffffa0c39fe9>] xfs_free_extent+0xb9/0xf0 [xfs]
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626510]  [<ffffffffa0c4c39e>] xfs_bmap_finish+0x11e/0x170 [xfs]
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626560]  [<ffffffffa0c6b4c0>] xfs_itruncate_extents+0x190/0x340 [xfs]
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626623]  [<ffffffffa0c33633>] xfs_free_eofblocks+0x1e3/0x260 [xfs]
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626659]  [<ffffffffa0c291ef>] xfs_inode_free_eofblocks+0x6f/0x150 [xfs]
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626688]  [<ffffffffa0c27f82>] xfs_inode_ag_walk.isra.10+0x1c2/0x310 [xfs]
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626716]  [<ffffffffa0c28a8e>] xfs_inode_ag_iterator_tag+0x6e/0xb0 [xfs]
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626744]  [<ffffffffa0c28d82>] xfs_eofblocks_worker+0x12/0x20 [xfs]
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626763]  [<ffffffff8106ac78>] process_one_work+0x168/0x490
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626765]  [<ffffffff8106b914>] worker_thread+0x114/0x3a0
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626768]  [<ffffffff81071c3f>] kthread+0xaf/0xc0
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626771]  [<ffffffff815addfc>] ret_from_fork+0x7c/0xb0
> <0.5> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626776] XFS (sde5): xfs_do_force_shutdown(0x8) called from line 916 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa0c4c3d8
> <0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.706440] XFS (sde5): Corruption of in-memory data detected.  Shutting down filesystem
> <0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.706440] XFS (sde5): Please umount the filesystem and rectify the problem(s)
> 

This is the background eofblocks scanner attempting to free preallocated
space on a file. The scanner looks for files that have been recently
grown and since been flushed to disk (i.e., no longer concurrently being
written to) and trims the post-eof preallocation that comes along with
growing files.

The corruption errors at xfs_alloc.c:1602,1629 on v3.11 fire if the
extent we are attempting to free is already accounted for in the
by-block allocation btree. IOW, this is attempting to free an extent
that the allocation metadata thinks is already free.

> 
> Brief description:
> 
> 
>  * It happens only on restore from hibernation.

Interesting, could you elaborate a bit more on the behavior this system
is typically subjected to? i.e., is this a server that sees a constant
workload that is also frequently hibernated/awakened?

>  * It happens randomly, spaced a month or two.
>  * It happens always on the same partition, the one that holds /home
>    (I have 10 XFS partitions spread on 4 internal hard disks, and a few
>    more external). It is a new disk, 2 TB, traditional MBR partitions.
>  * Disk has no defects, or at least so says smartctl long test.
>  * When it happens, recovery is impossible: xfs_repair does not seem to
>    find anything, or maybe it does, silently; but on system reuse,
>    it crashes again, fast.
>  * Thus recovery procedure is to use "xfsdump" to get a backup copy,
>    reformat the partition, and recover the files with xfsrestore.
> 
> 
> The worst issue for me is that "xfs_repair" fails to repair it.
> 
> I do not have more info than what appears on the logs, but four times (two
> different kernels):
> 
> cer@Telcontar:~> zgrep XFS_WANT_CORRUPTED_GOTO /var/log/messages*xz
> /var/log/messages-20140402.xz:<0.1> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111787] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1629 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
> /var/log/messages-20140402.xz:<0.1> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298345] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
> /var/log/messages-20140506.xz:<0.1> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.851374] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
> /var/log/messages-20140629.xz:<0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626346] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c39fe9
> cer@Telcontar:~>
> 
> 
> The first time that this happened I used a rescue usb stick (openSUSE 13.1
> xfce). xfs_repair said to mount the partition to force re-play the log. When
> I did, mount hung. It was unkillable. Reboot of system hung. I then used
> "xfs_repair -L" on that disk, which succeeded with no error report. On
> reuse, the system crashed soon: you can see above two entries on the same
> day.
> 
> This last time, I simply rebooted to runlevel 3, logon as root, perform the
> backup, format, restore. No testing, I was in a real hurry, and even so took
> hours.
> 

So you have reproduced this, reformatted with mkfs, restored from
backups and continued to reproduce the problem? And still only on this
particular partition?

This is interesting because the corruption appears to be associated with
post-eof space, which is generally transient. The worst case is that
this space is trimmed off files when they are evicted from cache, such
as during a umount. To me, that seems to correlate with a more
recent/runtime problem rather than something that might be lingering on
disk, but we don't really know for sure.

> 
> I suppose that to diagnose this further you will want data extracted from
> the filesystem: you have to tell me what operations to perform to obtain
> that data the next time it happens, without me having to ask here for your
> help. It may happen tomorrow, or in two months time, so I have to be
> prepared for it. And as usual, it may happen at the worst time, when I have
> work to be done in a hurry, as this last time (or I would have asked you).
> 
> The only data I have is the system logs.
> 
> I don't suppose that the "xfs_dump" archive contains anything of interest?
> 
> - From what I have googled, one suspect is something wrong in that
> partition. It was created using gparted, as the rest of the disk. This last
> time I used "YaST" to reformat it, not mkfs.xfs.
> 
> 
> 
> Wait! I have a "dd" copy of the entire partition (500 GB), made on March
> 16th, 5 AM, so hard data could be obtained from there. I had forgotten. I'll
> get something for you now:
> 
> 
> Telcontar:/data/storage_d/old_backup # xfs_info xfs_copy_home
> meta-data=/dev/sdf2              isize=256    agcount=4, agsize=122341568
> blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=489366272, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=238948, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Telcontar:/data/storage_d/old_backup #
> 
> 
> I could do a "xfs_metadump" on it - just tell me what options to use, and
> where can the result be uploaded to, if big.
> 

A metadump would be helpful, though that only gives us the on-disk
state. What was the state of this fs at the time the dd image was
created? I'm curious if something like an 'rm -rf *' on the metadump
would catch any other corruptions or if this is indeed limited to
something associated with recent (pre)allocations.

Run 'xfs_metadump <src> <tgtfile>' to create a metadump that will
obfuscate filenames by default. It should also be compressible. In the
future, it's probably worth grabbing a metadump as a first step (before
repair, zeroing the log, etc.) so we can look at the fs in the state
most recent to the crash.

Brian

> 
> 
> Current versions:
> 
> Linux Telcontar 3.11.10-11-desktop #1 SMP PREEMPT Mon May 12 13:37:06 UTC 2014 (3d22b5f) x86_64 x86_64 x86_64 GNU/Linux
> 
> xfs_repair version 3.1.11
> 
> CPU:  Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz
> 
> System:  openSUSE Linux 13.1, 64 bit.
> 
> 
> - -- Cheers
>        Carlos E. R.
> 
>        (from 13.1 x86_64 "Bottle" at Telcontar)
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (GNU/Linux)
> 
> iEYEARECAAYFAlOz14UACgkQtTMYHG2NR9XWLgCfRXInLwE/FrToinuYjpgWQyu6
> dA4AnjAP0DdUvOnsdZfLVaI7wm+c7U0N
> =vxuS
> -----END PGP SIGNATURE-----
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
