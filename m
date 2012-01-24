Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O570CY192545 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 23:07:00 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id aBT2wbaT2bq3eVBg for <xfs@oss.sgi.com>;
	Mon, 23 Jan 2012 21:06:58 -0800 (PST)
Message-ID: <4F1E3C71.1020303@sandeen.net>
Date: Mon, 23 Jan 2012 23:06:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: log recovery fails at mount
References: <20120124024340.GA6689@starfish.mcs.anl.gov>
In-Reply-To: <20120124024340.GA6689@starfish.mcs.anl.gov>
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
To: John Valdes <valdes@anl.gov>
Cc: xfs@oss.sgi.com

On 1/23/12 8:43 PM, John Valdes wrote:
> All,
> 
> We have an XFS which fails to mount due to an internal error according
> to the messages reported to syslog:
> 
>   kernel: Filesystem md4: Disabling barriers, trial barrier write failed

>   kernel: XFS mounting filesystem md4
>   kernel: Starting XFS recovery on filesystem: md4 (logdev: internal)
>   kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1676 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff887fca71
>   kernel: 
>   kernel: 
>   kernel: Call Trace:
>   kernel:  [<ffffffff887fb1cc>] :xfs:xfs_free_ag_extent+0x433/0x67e
>   kernel:  [<ffffffff887fca71>] :xfs:xfs_free_extent+0xa9/0xc9
>   kernel:  [<ffffffff8882d874>] :xfs:xlog_recover_process_efi+0x112/0x16c
>   kernel:  [<ffffffff888476c8>] :xfs:xfs_fs_fill_super+0x0/0x3dc
>   kernel:  [<ffffffff8882ea53>] :xfs:xlog_recover_process_efis+0x4f/0x8d
>   kernel:  [<ffffffff8882eaa5>] :xfs:xlog_recover_finish+0x14/0x9e
>   kernel:  [<ffffffff888476c8>] :xfs:xfs_fs_fill_super+0x0/0x3dc
>   kernel:  [<ffffffff888336c6>] :xfs:xfs_mountfs+0x47a/0x5ac
>   kernel:  [<ffffffff88833daa>] :xfs:xfs_mru_cache_create+0x113/0x143
>   kernel:  [<ffffffff888478cb>] :xfs:xfs_fs_fill_super+0x203/0x3dc
>   kernel:  [<ffffffff800e7401>] get_sb_bdev+0x10a/0x16c
>   kernel:  [<ffffffff800e6d9e>] vfs_kern_mount+0x93/0x11a
>   kernel:  [<ffffffff800e6e67>] do_kern_mount+0x36/0x4d
>   kernel:  [<ffffffff800f1865>] do_mount+0x6a9/0x719
>   kernel:  [<ffffffff80009165>] __handle_mm_fault+0x9f6/0x103b
>   kernel:  [<ffffffff8000c816>] _atomic_dec_and_lock+0x39/0x57
>   kernel:  [<ffffffff8002cc44>] mntput_no_expire+0x19/0x89
>   kernel:  [<ffffffff8000769e>] find_get_page+0x21/0x51
>   kernel:  [<ffffffff8002239a>] __up_read+0x19/0x7f
>   kernel:  [<ffffffff80067225>] do_page_fault+0x4cc/0x842
>   kernel:  [<ffffffff80008d64>] __handle_mm_fault+0x5f5/0x103b
>   kernel:  [<ffffffff800cee54>] zone_statistics+0x3e/0x6d
>   kernel:  [<ffffffff8000f470>] __alloc_pages+0x78/0x308
>   kernel:  [<ffffffff8004c0df>] sys_mount+0x8a/0xcd
>   kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
>   kernel: 
>   kernel: Failed to recover EFIs on filesystem: md4
>   kernel: XFS: log mount finish failed
> 
> xfs_repair is unwilling to repair the fs since it sees unwritten data
> in the xfs log:
> 
>   prompt# xfs_repair /dev/md4
>   Phase 1 - find and verify superblock...
>   Phase 2 - using internal log
>           - zero log...
>   ERROR: The filesystem has valuable metadata changes in a log which needs to
>   be replayed.  Mount the filesystem to replay the log, and unmount it before
>   re-running xfs_repair.  If you are unable to mount the filesystem, then use
>   the -L option to destroy the log and attempt a repair.
>   Note that destroying the log may cause corruption -- please attempt a mount
>   of the filesystem before doing this.
> 
> Of course, since I can't mount the fs, I can't replay the log.  Before
> zeroing out the log w/ xfs_repair -L, I was wondering if there is any
> way to tell how critical the metadata in the log is?  I've run

try:

# xfs_metadump /dev/md4 md4.metadump
# xfs_mdrestore md4.metadump md4.img
# xfs_repair -L md4.img

that'll repair a metadata image and you can see how much it runs into.

> "xfs_logprint", but not being an XFS developer, I don't understand the
> info it's showing me.  Is there anyway to glean something useful from
> xfs_logprint?  For reference, I've put a copy of the complete output
> at http://www.mcs.anl.gov/~valdes/xfslog.txt (warning, it's over 3.7
> million lines long and about 192 MB big).
> 
> The system with this problem is running RHEL 5.7 with the bundled XFS
> modules, eg:
> 
>   prompt# modinfo xfs
>   filename:       /lib/modules/2.6.18-274.3.1.el5/kernel/fs/xfs/xfs.ko
>   license:        GPL
>   description:    SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
>   author:         Silicon Graphics, Inc.
>   srcversion:     4A41C05CBD42F5525F11CBD
>   depends:        
>   vermagic:       2.6.18-274.3.1.el5 SMP mod_unload gcc-4.1
>   module_sig:     883f3504e58268794abe3920d1168f112bb7209e2721679ef3b2971313fad2364b5a43f2ab33e0a0a59bf02c12aca5e46c326a106f838129e0ab4867
> 
> although the XFS itself was built on an earlier version of RHEL 5, FWIW.
> 
> The details and history of the problem XFS are:
> 
> - It's ~20TB built on an md stripe of two 3ware RAID6 arrays.
> 
> - The problem showed up after a drive in one of the 3ware RAIDs
>   failed, causing the controller to hang, which took that RAID (scsi
>   device) offline:
> 
>     kernel: sd 7:0:0:0: WARNING: (0x06:0x002C): Command (0x2a) timed out, resetting card.
>     kernel: 3w-9xxx: scsi7: ERROR: (0x06:0x001F): Microcontroller not ready during reset sequence.
>     kernel: 3w-9xxx: scsi7: ERROR: (0x06:0x001F): Microcontroller not ready during reset sequence.
>     kernel: 3w-9xxx: scsi7: ERROR: (0x06:0x002B): Controller reset failed during scsi host reset.
>     kernel: sd 7:0:0:0: scsi: Device offlined - not ready after error recovery
>     last message repeated 99 times
>     kernel: sd 7:0:0:0: rejecting I/O to offline device
>     last message repeated 50 times
>     kernel: sd 7:0:0:0: SCSI error: return code = 0x00010000
>     kernel: end_request: I/O error, dev sdd, sector 2292015744
>     kernel: sd 7:0:0:0: rejecting I/O to offline device
>     last message repeated 436 times
>     kernel: Device md4, XFS metadata write error block 0xd03f0 in md4
>     kernel: Buffer I/O error on device md4, logical block 723454688
>     kernel: lost page write due to I/O error on md4
>     kernel: Buffer I/O error on device md4, logical block 723454689
>     [...]
>     kernel: sd 7:0:0:0: rejecting I/O to offline device
>     kernel: I/O error in filesystem ("md4") meta-data dev md4 block 0x48c2598aa       ("xlog_iodone") error 5 buf count 3584
>     kernel: xfs_force_shutdown(md4,0x2) called from line 1061 of file fs/xfs/xfs_log.c.  Return address = 0xffffffff8867404a
>     kernel: Filesystem md4: Log I/O Error Detected.  Shutting down filesystem: md4
>     kernel: Please umount the filesystem, and rectify the problem(s)
>     kernel: Filesystem md4: xfs_log_force: error 5 returned.
> 
>   I was able to fully shutdown the system after this, although I did
>   need to power cycle it in order to get the 3ware controller back
>   online (the controller does have a functional battery, so in theory
>   data in its write cache should have been preserved, although
>   messages at reboot suggest otherwise).  Nevertheless, upon reboot,
>   the XFS mounted fine:
> 
>     kernel: 3w-9xxx: scsi7: AEN: ERROR (0x04:0x005F): Cache synchronization failed; some data lost:unit=0.
>     kernel: 3w-9xxx: scsi7: AEN: WARNING (0x04:0x0008): Unclean shutdown detected:unit=0.
>     [...]
>     kernel: SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
>     kernel: SGI XFS Quota Management subsystem
>     kernel: Filesystem md4: Disabling barriers, trial barrier write failed
>     kernel: XFS mounting filesystem md4
>     kernel: Starting XFS recovery on filesystem: md4 (logdev: internal)
>     kernel: Ending XFS recovery on filesystem: md4 (logdev: internal)
> 
> - The XFS continued working fine for about 2 weeks, but then it started
>   reporting internal erros (XFS_WANT_CORRUPTED_RETURN):
> 
>     kernel: XFS internal error XFS_WANT_CORRUPTED_RETURN at line 295 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff8864a345
>     kernel: 
>     kernel: 
>     kernel: Call Trace:
>     kernel:  [<ffffffff8864889f>] :xfs:xfs_alloc_fixup_trees+0x2ba/0x2cb
>     kernel:  [<ffffffff8865e89b>] :xfs:xfs_btree_init_cursor+0x31/0x1a3
>     kernel:  [<ffffffff8864a345>] :xfs:xfs_alloc_ag_vextent_near+0x773/0x8e2
>     kernel:  [<ffffffff8864a4df>] :xfs:xfs_alloc_ag_vextent+0x2b/0xfc
>     kernel:  [<ffffffff8864ad5f>] :xfs:xfs_alloc_vextent+0x2ce/0x3ff
>     kernel:  [<ffffffff886595ca>] :xfs:xfs_bmap_btalloc+0x673/0x8c1
>     kernel:  [<ffffffff88659f09>] :xfs:xfs_bmapi+0x6ec/0xe79
>     kernel:  [<ffffffff8867b0c7>] :xfs:xlog_ticket_alloc+0xc8/0xed
>     kernel:  [<ffffffff8867b199>] :xfs:xfs_log_reserve+0xad/0xc9
>     kernel:  [<ffffffff886764de>] :xfs:xfs_iomap_write_allocate+0x202/0x329
>     kernel:  [<ffffffff88676f0e>] :xfs:xfs_iomap+0x217/0x28d
>     kernel:  [<ffffffff8868bf48>] :xfs:xfs_map_blocks+0x2d/0x63
>     kernel:  [<ffffffff8868cb8e>] :xfs:xfs_page_state_convert+0x2b1/0x546
>     kernel:  [<ffffffff8001c452>] generic_make_request+0x211/0x228
>     kernel:  [<ffffffff8868cf6f>] :xfs:xfs_vm_writepage+0xa7/0xe0
>     kernel:  [<ffffffff8001d1d1>] mpage_writepages+0x1bf/0x37d
>     kernel:  [<ffffffff8868cec8>] :xfs:xfs_vm_writepage+0x0/0xe0
>     kernel:  [<ffffffff8005a8a6>] do_writepages+0x20/0x2f
>     kernel:  [<ffffffff8002fa24>] __writeback_single_inode+0x1a2/0x31c
>     kernel:  [<ffffffff80021143>] sync_sb_inodes+0x1b7/0x271
>     kernel:  [<ffffffff800a2be5>] keventd_create_kthread+0x0/0xc4
>     kernel:  [<ffffffff80050ce2>] writeback_inodes+0x82/0xd8
>     kernel:  [<ffffffff800cc304>] wb_kupdate+0xd4/0x14e
>     kernel:  [<ffffffff800562a9>] pdflush+0x0/0x1fb
>     kernel:  [<ffffffff800563fa>] pdflush+0x151/0x1fb
>     kernel:  [<ffffffff800cc230>] wb_kupdate+0x0/0x14e
>     kernel:  [<ffffffff80032722>] kthread+0xfe/0x132
>     kernel:  [<ffffffff8005dfb1>] child_rip+0xa/0x11
>     kernel:  [<ffffffff800a2be5>] keventd_create_kthread+0x0/0xc4
>     kernel:  [<ffffffff80032624>] kthread+0x0/0x132
>     kernel:  [<ffffffff8005dfa7>] child_rip+0x0/0x11
> 
> - Once this started happening, I shutdown the system again, but this
>   time at reboot, the XFS failed to mount, w/ the error given at the
>   top of this email.
> 
> Does anyone have any suggestions on how to recover from this state, or
> is my only option xfs_repair -L and hope that there isn't any
> corruption?  This XFS is part of a scratch filesystem (we have a large
> PVFS filesystem built on top of this XFS plus 7 other identical ones
> on other servers), so if it ended up being corrupted, it wouldn't been
> the end of the world, but it would represent a lot of lost work.
> 
> Thanks for any help.
> 
> John
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
