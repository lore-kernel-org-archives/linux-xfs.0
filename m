Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3C9jxIt143524 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 04:45:59 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DAF914BCECD
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 02:49:19 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Qc5VzvtgyEADwywB for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2011 02:49:19 -0700 (PDT)
Date: Tue, 12 Apr 2011 19:49:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fs corruption
Message-ID: <20110412094917.GY31057@dastard>
References: <31377534.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <31377534.post@talk.nabble.com>
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
To: stress_buster <leo1783@yahoo.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 12, 2011 at 02:33:07AM -0700, stress_buster wrote:
> 
> My dmesg output shows the below trace. It repeats over and over again.
> 
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1545 of file
> fs/xfs/xfs_alloc.c.  Caller 0xffffffff881a8961
> 
> Call Trace:
>  [<ffffffff881a6e27>] :xfs:xfs_free_ag_extent+0x19e/0x67e
>  [<ffffffff881a8961>] :xfs:xfs_free_extent+0xa9/0xc9
>  [<ffffffff881d96cf>] :xfs:xlog_recover_process_efi+0x112/0x16c
>  [<ffffffff881f31b4>] :xfs:xfs_fs_fill_super+0x0/0x3e4
>  [<ffffffff881da8c2>] :xfs:xlog_recover_process_efis+0x4f/0x8d
>  [<ffffffff881da914>] :xfs:xlog_recover_finish+0x14/0xad
>  [<ffffffff881f31b4>] :xfs:xfs_fs_fill_super+0x0/0x3e4
>  [<ffffffff881df420>] :xfs:xfs_mountfs+0x498/0x5e2
>  [<ffffffff881dfb42>] :xfs:xfs_mru_cache_create+0x113/0x143
>  [<ffffffff881f33b7>] :xfs:xfs_fs_fill_super+0x203/0x3e4
>  [<ffffffff800e544f>] get_sb_bdev+0x10a/0x16c
>  [<ffffffff800e4dec>] vfs_kern_mount+0x93/0x11a
>  [<ffffffff800e4eb5>] do_kern_mount+0x36/0x4d
>  [<ffffffff800ef2ed>] do_mount+0x6a9/0x719
>  [<ffffffff80008d84>] __handle_mm_fault+0x5f2/0xfaa
>  [<ffffffff80022127>] __up_read+0x19/0x7f
>  [<ffffffff80067b88>] do_page_fault+0x4fe/0x874
>  [<ffffffff8012c580>] inode_doinit_with_dentry+0x86/0x47c
>  [<ffffffff800cd378>] zone_statistics+0x3e/0x6d
>  [<ffffffff8000f2ff>] __alloc_pages+0x78/0x308
>  [<ffffffff8004c9fd>] sys_mount+0x8a/0xcd
>  [<ffffffff8005e116>] system_call+0x7e/0x83
> 
> Failed to recover EFIs on filesystem: cciss/c0d0
> XFS: log mount finish failed
> 
> Can someone shed some light on what is happening here?

You have a corrupted free space btree. How it occurred, I have no
idea.

> Also what the next steps I need to take to repair the fs? (assuming my xfs
> fs is corrupted)
> Will running xfs_repair be good enough in this case?

That's all you can do. If it's really important, and you don't have
a backup, I'd suggest mounting with "-o ro,norecovery" and taking a
backup first....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
