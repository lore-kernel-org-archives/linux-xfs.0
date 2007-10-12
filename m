Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Oct 2007 12:52:30 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9CJqKLS001946
	for <xfs@oss.sgi.com>; Fri, 12 Oct 2007 12:52:23 -0700
Date: Fri, 12 Oct 2007 15:52:22 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Repeated XFS Crash on x86_64 fiesty
In-Reply-To: <470F2A1E.9070503@openenterprise.co.uk>
Message-ID: <Pine.LNX.4.64.0710121551470.16962@p34.internal.lan>
References: <470F2A1E.9070503@openenterprise.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Gregory <nick@openenterprise.co.uk>
Cc: xfs@oss.sgi.com

Have you run memtest86?  Have you checked the CPU?  Is it an AMD64 CPU 
where the memory controller is onboard (and .. if damaged/overheating) 
could cause problems with the memory?

On Fri, 12 Oct 2007, Nick Gregory wrote:

> Hi,
>
> I run a number of x86_64 ubuntu feisty (2.6.20-16-server) systems. Each has a 
> near identical hardware spec i.e. the systems have a large (>6TB) xfs storage 
> partition sat on top of a raid 6 array (using the Areca ARC-1160).
>
> Over the last couple of months one system has has its xfs filesystem crash on 
> a semi frequent basis (1-2 times a week). Googling around the error it first 
> seemed to be memory related so I've done a swap for a some new ecc memory - 
> unfortunately the problem persists.
>
> The filesystem is reasonable active but the issue doesn't seem to be load 
> related as the issue seems to occur at random times of the day.
>
> Can anyone give me any insight on the best place to start looking to track 
> down the issue?
>
> Thanks in advance
>
> Nick
>
> XFS Crash dmesg:
>
> [44537.156249] XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of 
> file fs/xfs/xfs_alloc.c.  Caller 0xffffffff8824e188
> [44537.156321]
> [44537.156321] Call Trace:
> [44537.156391]  [<ffffffff8824c6c2>] :xfs:xfs_free_ag_extent+0x1b2/0x700
> [44537.156416]  [<ffffffff8824e188>] :xfs:xfs_free_extent+0xc8/0x110
> [44537.156443]  [<ffffffff8825c982>] :xfs:xfs_bmap_finish+0x102/0x190
> [44537.156482]  [<ffffffff8827e28c>] :xfs:xfs_itruncate_finish+0x1ac/0x300
> [44537.156513]  [<ffffffff88297976>] :xfs:xfs_setattr+0x8a6/0xf30
> [44537.156557]  [<ffffffff882a3ee3>] :xfs:xfs_vn_setattr+0x143/0x190
> [44537.156578]  [<ffffffff8022dee4>] notify_change+0x164/0x330
> [44537.156589]  [<ffffffff802d742e>] do_truncate+0x4e/0x70
> [44537.156597]  [<ffffffff8020d56a>] permission+0xca/0x140
> [44537.156602]  [<ffffffff80211e59>] may_open+0x1e9/0x260
> [44537.156609]  [<ffffffff8021b598>] open_namei+0x2a8/0x680
> [44537.156613]  [<ffffffff8021b157>] cp_new_stat+0xe7/0x100
> [44537.156617]  [<ffffffff802a3860>] autoremove_wake_function+0x0/0x30
> [44537.156625]  [<ffffffff80228a6c>] do_filp_open+0x1c/0x40
> [44537.156658]  [<ffffffff80219eda>] do_sys_open+0x5a/0x100
> [44537.156666]  [<ffffffff8026111e>] system_call+0x7e/0x83
> [44537.156675]
> [44537.156685] xfs_force_shutdown(sda3,0x8) called from line 4272 of file 
> fs/xfs/xfs_bmap.c.  Return address = 0xffffffff8825c9be
> [44537.157614] Filesystem "sda3": Corruption of in-memory data detected. 
> Shutting down filesystem: sda3
> [44537.157664] Please umount the filesystem, and rectify the problem(s)
>
>
> On remount of the file system:
>
> [45035.275936] xfs_force_shutdown(sda3,0x1) called from line 424 of file 
> fs/xfs/xfs_rw.c.  Return address = 0xffffffff8829bf3a
> [45035.275948] xfs_force_shutdown(sda3,0x1) called from line 424 of file 
> fs/xfs/xfs_rw.c.  Return address = 0xffffffff8829bf3a
> [45039.698366] XFS mounting filesystem sda3
> [45039.822294] Starting XFS recovery on filesystem: sda3 (logdev: internal)
> [45040.330263] XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of 
> file fs/xfs/xfs_alloc.c.  Caller 0xffffffff8824e188
> [45040.330319]
> [45040.330320] Call Trace:
> [45040.330358]  [<ffffffff8824c6c2>] :xfs:xfs_free_ag_extent+0x1b2/0x700
> [45040.330382]  [<ffffffff8824e188>] :xfs:xfs_free_extent+0xc8/0x110
> [45040.330413]  [<ffffffff88289fce>] :xfs:xlog_recover_finish+0x1be/0x2d0
> [45040.330440]  [<ffffffff8828e087>] :xfs:xfs_mountfs+0xa77/0xca0
> [45040.330451]  [<ffffffff8025dc60>] generic_unplug_device+0x0/0x30
> [45040.330457]  [<ffffffff8020c002>] _atomic_dec_and_lock+0x42/0x80
> [45040.330481]  [<ffffffff88294e87>] :xfs:xfs_mount+0x997/0xa80
> [45040.330503]  [<ffffffff882a6ca8>] :xfs:xfs_fs_fill_super+0x98/0x230
> [45040.330511]  [<ffffffff80267692>] __down_write_nested+0x12/0xb0
> [45040.330516]  [<ffffffff80232a0e>] strlcpy+0x4e/0x80
> [45040.330523]  [<ffffffff802e1fc2>] get_filesystem+0x12/0x40
> [45040.330528]  [<ffffffff802d8e4f>] sget+0x3bf/0x3e0
> [45040.330533]  [<ffffffff802d87a0>] set_bdev_super+0x0/0x10
> [45040.330541]  [<ffffffff802d9aff>] get_sb_bdev+0x11f/0x190
> [45040.330559]  [<ffffffff882a6c10>] :xfs:xfs_fs_fill_super+0x0/0x230
> [45040.330570]  [<ffffffff802d9366>] vfs_kern_mount+0xc6/0x170
> [45040.330579]  [<ffffffff802d946a>] do_kern_mount+0x4a/0x80
> [45040.330586]  [<ffffffff802e3f89>] do_mount+0x6f9/0x7a0
> [45040.330592]  [<ffffffff80208b48>] __handle_mm_fault+0x668/0xab0
> [45040.330601]  [<ffffffff8020e6e0>] link_path_walk+0xd0/0xf0
> [45040.330608]  [<ffffffff80222db1>] __up_read+0x21/0xb0
> [45040.330614]  [<ffffffff8026a299>] do_page_fault+0x4b9/0x890
> [45040.330623]  [<ffffffff80208923>] __handle_mm_fault+0x443/0xab0
> [45040.330629]  [<ffffffff802c6074>] zone_statistics+0x34/0x80
> [45040.330652]  [<ffffffff8023e53b>] __get_free_pages+0x1b/0x40
> [45040.330661]  [<ffffffff8024e38b>] sys_mount+0x9b/0x100
> [45040.330670]  [<ffffffff8026111e>] system_call+0x7e/0x83
> [45040.330680]
> [45040.365771] Ending XFS recovery on filesystem: sda3 (logdev: internal)
>
>
>
>
