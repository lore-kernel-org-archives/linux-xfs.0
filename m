Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3426B7F51
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 10:19:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8ECAEAC001
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 08:19:38 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id 5EcmTEBtVwGaMbBB for
	<xfs@oss.sgi.com>; Fri, 14 Feb 2014 08:19:34 -0800 (PST)
Date: Fri, 14 Feb 2014 11:19:33 -0500 (EST)
From: Laurence Oberman <loberman@redhat.com>
Message-ID: <461400101.2501294.1392394773671.JavaMail.zimbra@redhat.com>
In-Reply-To: <532438291.2495843.1392394364516.JavaMail.zimbra@redhat.com>
Subject: Tasks blocked in xlog_grant_log_space
MIME-Version: 1.0
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
To: xfs@oss.sgi.com
Cc: Leonardo Menezes Vaz <lvaz@redhat.com>

Hello

I have a customer seeing multiple tasks blocked in xlog_grant_log_space
This lands up hitting the hungtask timer for pdflush.

I have seen on the list that this issue is still out there.
I also don't see outstanding I/O requests on the XFS file system that experienced this block.

The last hung_task timeout was on dm-9 
ffff81011c78c080 ffff81081a43bc00 xfs    /dev/vgautocomp/lv_autocomp /bb/autocomp

crash> gendisk ffff810814d24400 | grep in_flight
  in_flight = 0, 

So just wondering if I am hitting an existing bug or if its a new one.

This is an older 2.6.18 kernel

INFO: task pdflush:3204 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pdflush       D 0000000000000004     0  3204   2247          3205  3203 (L-TLB)
 ffff81401f523850 0000000000000046 ffff81401f523814 0000001300000001
 ffff81201fe6ac00 000000000000000a ffff81381f8f20c0 ffff8111141b3040
 000071fd5f0f7541 000000000005edb9 ffff81381f8f22a8 0000001b1f523940
Call Trace:
 [<ffffffff889cc3f7>] :xfs:xfs_bmap_search_multi_extents+0x9d/0xda
 [<ffffffff800de66e>] alternate_node_alloc+0x70/0x8c
 [<ffffffff80063823>] schedule_timeout+0x1e/0xad
 [<ffffffff88a04565>] :xfs:kmem_zone_zalloc+0x1e/0x2f
 [<ffffffff800495cc>] add_wait_queue_exclusive+0x28/0x38
 [<ffffffff889f3505>] :xfs:xlog_grant_log_space+0xc6/0x25c
 [<ffffffff8008e7f7>] default_wake_function+0x0/0xe
 [<ffffffff889f4199>] :xfs:xfs_log_reserve+0xad/0xc9
 [<ffffffff889fc549>] :xfs:xfs_trans_reserve+0xe4/0x1c5
 [<ffffffff889ef3bc>] :xfs:xfs_iomap_write_allocate+0xe0/0x329
 [<ffffffff8002239a>] __up_read+0x19/0x7f
 [<ffffffff889eff0e>] :xfs:xfs_iomap+0x217/0x28d
 [<ffffffff88a04f48>] :xfs:xfs_map_blocks+0x2d/0x63
 [<ffffffff88a05b8e>] :xfs:xfs_page_state_convert+0x2b1/0x546
 [<ffffffff88a05f6f>] :xfs:xfs_vm_writepage+0xa7/0xe0
 [<ffffffff8001d1d1>] mpage_writepages+0x1bf/0x37d
 [<ffffffff88a05ec8>] :xfs:xfs_vm_writepage+0x0/0xe0
 [<ffffffff8005a8a6>] do_writepages+0x20/0x2f
 [<ffffffff8002fa24>] __writeback_single_inode+0x1a2/0x31c
 [<ffffffff80021143>] sync_sb_inodes+0x1b7/0x271
 [<ffffffff800a2be5>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80050ce2>] writeback_inodes+0x82/0xd8
 [<ffffffff800cc304>] wb_kupdate+0xd4/0x14e
 [<ffffffff800562a9>] pdflush+0x0/0x1fb
 [<ffffffff800563fa>] pdflush+0x151/0x1fb
 [<ffffffff800cc230>] wb_kupdate+0x0/0x14e
 [<ffffffff80032722>] kthread+0xfe/0x132
 [<ffffffff8009f808>] request_module+0x0/0x14d
 [<ffffffff8005dfb1>] child_rip+0xa/0x11
 [<ffffffff800a2be5>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032624>] kthread+0x0/0x132
 [<ffffffff8005dfa7>] child_rip+0x0/0x11

If I check tasks in UN there are multiple tasks all blocke din the same XFS grant_log block

crash> < last-un | grep -B2 -A3 grant
 #0 [ffff81194eaa9c58] schedule at ffffffff80062f90
 #1 [ffff81194eaa9d30] schedule_timeout at ffffffff80063823
 #2 [ffff81194eaa9d80] xlog_grant_log_space at ffffffff889f35ec [xfs]
 #3 [ffff81194eaa9de0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81194eaa9e30] xfs_inactive at ffffffff88a036a4 [xfs]
 #5 [ffff81194eaa9e70] xfs_fs_clear_inode at ffffffff88a0e1e1 [xfs]
--
 #0 [ffff81248e1a3b18] schedule at ffffffff80062f90
 #1 [ffff81248e1a3bf0] schedule_timeout at ffffffff80063823
 #2 [ffff81248e1a3c40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff81248e1a3ca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81248e1a3cf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff81248e1a3da0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff81154866fb18] schedule at ffffffff80062f90
 #1 [ffff81154866fbf0] schedule_timeout at ffffffff80063823
 #2 [ffff81154866fc40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff81154866fca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81154866fcf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff81154866fda0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff811612de9b18] schedule at ffffffff80062f90
 #1 [ffff811612de9bf0] schedule_timeout at ffffffff80063823
 #2 [ffff811612de9c40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff811612de9ca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff811612de9cf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff811612de9da0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff81380493fb18] schedule at ffffffff80062f90
 #1 [ffff81380493fbf0] schedule_timeout at ffffffff80063823
 #2 [ffff81380493fc40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff81380493fca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81380493fcf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff81380493fda0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff81311106bb18] schedule at ffffffff80062f90
 #1 [ffff81311106bbf0] schedule_timeout at ffffffff80063823
 #2 [ffff81311106bc40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff81311106bca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81311106bcf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff81311106bda0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff811bc0f63ca8] schedule at ffffffff80062f90
 #1 [ffff811bc0f63d80] schedule_timeout at ffffffff80063823
 #2 [ffff811bc0f63dd0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff811bc0f63e30] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff811bc0f63e80] xfs_free_eofblocks at ffffffff88a004c6 [xfs]
 #5 [ffff811bc0f63ef0] xfs_file_release at ffffffff88a08759 [xfs]
--
 #0 [ffff8102b5479b18] schedule at ffffffff80062f90
 #1 [ffff8102b5479bf0] schedule_timeout at ffffffff80063823
 #2 [ffff8102b5479c40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff8102b5479ca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff8102b5479cf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff8102b5479da0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff8113c4587ca8] schedule at ffffffff80062f90
 #1 [ffff8113c4587d80] schedule_timeout at ffffffff80063823
 #2 [ffff8113c4587dd0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff8113c4587e30] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff8113c4587e80] xfs_free_eofblocks at ffffffff88a004c6 [xfs]
 #5 [ffff8113c4587ef0] xfs_file_release at ffffffff88a08759 [xfs]
--
 #0 [ffff810f542a9c18] schedule at ffffffff80062f90
 #1 [ffff810f542a9cf0] schedule_timeout at ffffffff80063823
 #2 [ffff810f542a9d40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff810f542a9da0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff810f542a9df0] xfs_remove at ffffffff88a01be2 [xfs]
 #5 [ffff810f542a9e70] xfs_vn_unlink at ffffffff88a0b536 [xfs]
--
 #0 [ffff810c22c0fca8] schedule at ffffffff80062f90
 #1 [ffff810c22c0fd80] schedule_timeout at ffffffff80063823
 #2 [ffff810c22c0fdd0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff810c22c0fe30] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff810c22c0fe80] xfs_free_eofblocks at ffffffff88a004c6 [xfs]
 #5 [ffff810c22c0fef0] xfs_file_release at ffffffff88a08759 [xfs]
--
 #0 [ffff811d7ba67b18] schedule at ffffffff80062f90
 #1 [ffff811d7ba67bf0] schedule_timeout at ffffffff80063823
 #2 [ffff811d7ba67c40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff811d7ba67ca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff811d7ba67cf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff811d7ba67da0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff81163a643b18] schedule at ffffffff80062f90
 #1 [ffff81163a643bf0] schedule_timeout at ffffffff80063823
 #2 [ffff81163a643c40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff81163a643ca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81163a643cf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff81163a643da0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff81114bec3c18] schedule at ffffffff80062f90
 #1 [ffff81114bec3cf0] schedule_timeout at ffffffff80063823
 #2 [ffff81114bec3d40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff81114bec3da0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81114bec3df0] xfs_remove at ffffffff88a01be2 [xfs]
 #5 [ffff81114bec3e70] xfs_vn_unlink at ffffffff88a0b536 [xfs]
--
 #0 [ffff810c7efb5c28] schedule at ffffffff80062f90
 #1 [ffff810c7efb5d00] schedule_timeout at ffffffff80063823
 #2 [ffff810c7efb5d50] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff810c7efb5db0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff810c7efb5e00] xfs_free_eofblocks at ffffffff88a004c6 [xfs]
 #5 [ffff810c7efb5e70] xfs_file_release at ffffffff88a08759 [xfs]
--
 #0 [ffff811122bc5a78] schedule at ffffffff80062f90
 #1 [ffff811122bc5b50] schedule_timeout at ffffffff80063823
 #2 [ffff811122bc5ba0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff811122bc5c00] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff811122bc5c50] xfs_setattr at ffffffff88a00c87 [xfs]
 #5 [ffff811122bc5d00] xfs_vn_setattr at ffffffff88a0ac9c [xfs]
--
 #0 [ffff81086d937b18] schedule at ffffffff80062f90
 #1 [ffff81086d937bf0] schedule_timeout at ffffffff80063823
 #2 [ffff81086d937c40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff81086d937ca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81086d937cf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff81086d937da0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff8109fb17fc58] schedule at ffffffff80062f90
 #1 [ffff8109fb17fd30] schedule_timeout at ffffffff80063823
 #2 [ffff8109fb17fd80] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff8109fb17fde0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff8109fb17fe30] xfs_inactive at ffffffff88a036a4 [xfs]
 #5 [ffff8109fb17fe70] xfs_fs_clear_inode at ffffffff88a0e1e1 [xfs]
--
 #0 [ffff810a25eb1ca8] schedule at ffffffff80062f90
 #1 [ffff810a25eb1d80] schedule_timeout at ffffffff80063823
 #2 [ffff810a25eb1dd0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff810a25eb1e30] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff810a25eb1e80] xfs_free_eofblocks at ffffffff88a004c6 [xfs]
 #5 [ffff810a25eb1ef0] xfs_file_release at ffffffff88a08759 [xfs]
--
 #0 [ffff810aa7ce7ca8] schedule at ffffffff80062f90
 #1 [ffff810aa7ce7d80] schedule_timeout at ffffffff80063823
 #2 [ffff810aa7ce7dd0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff810aa7ce7e30] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff810aa7ce7e80] xfs_free_eofblocks at ffffffff88a004c6 [xfs]
 #5 [ffff810aa7ce7ef0] xfs_file_release at ffffffff88a08759 [xfs]
--
 #0 [ffff8118d00afb18] schedule at ffffffff80062f90
 #1 [ffff8118d00afbf0] schedule_timeout at ffffffff80063823
 #2 [ffff8118d00afc40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff8118d00afca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff8118d00afcf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff8118d00afda0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff810c1c289c78] schedule at ffffffff80062f90
 #1 [ffff810c1c289d50] schedule_timeout at ffffffff80063823
 #2 [ffff810c1c289da0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff810c1c289e00] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff810c1c289e50] xfs_inactive at ffffffff88a036a4 [xfs]
 #5 [ffff810c1c289e90] xfs_fs_clear_inode at ffffffff88a0e1e1 [xfs]
--
 #0 [ffff811cddf61b18] schedule at ffffffff80062f90
 #1 [ffff811cddf61bf0] schedule_timeout at ffffffff80063823
 #2 [ffff811cddf61c40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff811cddf61ca0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff811cddf61cf0] xfs_create at ffffffff88a017b0 [xfs]
 #5 [ffff811cddf61da0] xfs_vn_mknod at ffffffff88a0b300 [xfs]
--
 #0 [ffff811ab01f5a78] schedule at ffffffff80062f90
 #1 [ffff811ab01f5b50] schedule_timeout at ffffffff80063823
 #2 [ffff811ab01f5ba0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff811ab01f5c00] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff811ab01f5c50] xfs_setattr at ffffffff88a00c87 [xfs]
 #5 [ffff811ab01f5d00] xfs_vn_setattr at ffffffff88a0ac9c [xfs]
--
 #0 [ffff81381800fca8] schedule at ffffffff80062f90
 #1 [ffff81381800fd80] schedule_timeout at ffffffff80063823
 #2 [ffff81381800fdd0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff81381800fe30] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81381800fe80] xfs_free_eofblocks at ffffffff88a004c6 [xfs]
 #5 [ffff81381800fef0] xfs_file_release at ffffffff88a08759 [xfs]
--
 #0 [ffff81401f523780] schedule at ffffffff80062f90
 #1 [ffff81401f523858] schedule_timeout at ffffffff80063823
 #2 [ffff81401f5238a8] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff81401f523908] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81401f523958] xfs_iomap_write_allocate at ffffffff889ef3bc [xfs]
 #5 [ffff81401f523a18] xfs_iomap at ffffffff889eff0e [xfs]
--
 #0 [ffff811903be3c58] schedule at ffffffff80062f90
 #1 [ffff811903be3d30] schedule_timeout at ffffffff80063823
 #2 [ffff811903be3d80] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff811903be3de0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff811903be3e30] xfs_inactive at ffffffff88a036a4 [xfs]
 #5 [ffff811903be3e70] xfs_fs_clear_inode at ffffffff88a0e1e1 [xfs]
--
 #0 [ffff811ac8983ca8] schedule at ffffffff80062f90
 #1 [ffff811ac8983d80] schedule_timeout at ffffffff80063823
 #2 [ffff811ac8983dd0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff811ac8983e30] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff811ac8983e80] xfs_free_eofblocks at ffffffff88a004c6 [xfs]
 #5 [ffff811ac8983ef0] xfs_file_release at ffffffff88a08759 [xfs]
--
 #0 [ffff810f2c6b1c78] schedule at ffffffff80062f90
 #1 [ffff810f2c6b1d50] schedule_timeout at ffffffff80063823
 #2 [ffff810f2c6b1da0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff810f2c6b1e00] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff810f2c6b1e50] xfs_inactive at ffffffff88a036a4 [xfs]
 #5 [ffff810f2c6b1e90] xfs_fs_clear_inode at ffffffff88a0e1e1 [xfs]
--
 #0 [ffff813e780d7c28] schedule at ffffffff80062f90
 #1 [ffff813e780d7d00] schedule_timeout at ffffffff80063823
 #2 [ffff813e780d7d50] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff813e780d7db0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff813e780d7e00] xfs_free_eofblocks at ffffffff88a004c6 [xfs]
 #5 [ffff813e780d7e70] xfs_file_release at ffffffff88a08759 [xfs]
--
 #0 [ffff8112c912fca8] schedule at ffffffff80062f90
 #1 [ffff8112c912fd80] schedule_timeout at ffffffff80063823
 #2 [ffff8112c912fdd0] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff8112c912fe30] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff8112c912fe80] xfs_free_eofblocks at ffffffff88a004c6 [xfs]
 #5 [ffff8112c912fef0] xfs_file_release at ffffffff88a08759 [xfs]
--
 #0 [ffff81170f357c18] schedule at ffffffff80062f90
 #1 [ffff81170f357cf0] schedule_timeout at ffffffff80063823
 #2 [ffff81170f357d40] xlog_grant_log_space at ffffffff889f3505 [xfs]
 #3 [ffff81170f357da0] xfs_trans_reserve at ffffffff889fc549 [xfs]
 #4 [ffff81170f357df0] xfs_remove at ffffffff88a01be2 [xfs]
 #5 [ffff81170f357e70] xfs_vn_unlink at ffffffff88a0b536 [xfs]

Thanks
Laurence

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
