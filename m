Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbdGZKfE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jul 2017 06:35:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 567DAC0587D1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2017 10:35:04 +0000 (UTC)
Date: Wed, 26 Jul 2017 06:35:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [BUG] xfs/305 hangs 4.10-rc4 kernel
Message-ID: <20170726103502.GA59833@bfoster.bfoster>
References: <20170125145215.GC28388@bfoster.bfoster>
 <20170126032950.GM1859@eguan.usersys.redhat.com>
 <20170126184427.GA39683@bfoster.bfoster>
 <20170127025219.GR1859@eguan.usersys.redhat.com>
 <20170130181224.GC8737@bfoster.bfoster>
 <20170130215952.GA11230@bfoster.bfoster>
 <20170204114700.GH1859@eguan.usersys.redhat.com>
 <20170206175908.GI57865@bfoster.bfoster>
 <20170213164307.GA25568@bfoster.bfoster>
 <20170726050952.GT9167@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170726050952.GT9167@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2017 at 01:09:52PM +0800, Eryu Guan wrote:
> Hi Brian,
> 
> [sorry for bringing up an old thread, but this seems relavent]
> 
> On Mon, Feb 13, 2017 at 11:43:07AM -0500, Brian Foster wrote:
> > On Mon, Feb 06, 2017 at 12:59:08PM -0500, Brian Foster wrote:
> > > On Sat, Feb 04, 2017 at 07:47:00PM +0800, Eryu Guan wrote:
> > > > On Mon, Jan 30, 2017 at 04:59:52PM -0500, Brian Foster wrote:
> > > > > 
> > > > > I reproduced an xfs_wait_buftarg() unmount hang once that looks like a
> > > > > separate issue (occurs after the test, long after quotaoff has
> > > > > completed). I haven't reproduced that one again nor the original hang in
> > > > > 100+ iterations so far. Care to give the following a whirl in your
> > > > > environment? Thanks.
> > > > 
> > > > I applied your test patch on top of 4.10-rc4 stock kernel and hit
> > > > xfs/305 hang at 82nd iteration. I attached the dmesg and sysrq-w log.
> > > > You can login the same RH internal test host if that's helpful, I left
> > > > the host running in the hang state.
> > > > 
> > > 
> > > Ok, that's not too surprising. It does look like we are in some kind of
> > > live lock situation. xfs_quota is spinning on the dqpurge and two or
> > > three fsstress workers are spinning on xfs_iget() retries via bulkstat.
> > > 
> > > I'm going to hard reboot this box and try to restart this test with some
> > > customized tracepoints to try and get more data..
> > > 
> > 
> > I managed to get enough data to manufacture the problem locally. It
> > looks like quotaoff is racy with respect to inode allocation.
> > 
> > The latter can allocate an inode, populate the incore data structures,
> > etc. and set i_flags to XFS_INEW until the inode is fully populated. If
> > inode allocation races with quotaoff such that the alloc doesn't yet see
> > the quota off state and thus grabs a new dquot reference, it's possible
> > for the subsequent xfs_qm_dqrele_all_inodes() scan from the quota off
> > path to simply skip the associated inode because of its XFS_INEW state.
> > The associated ->i_[ugp]dquot is thus never released and the dqpurge
> > spins indefinitely.
> > 
> > I reproduce this locally by running quotaoff during an artificial delay
> > in xfs_finish_inode_setup() right before XFS_INEW is cleared. The least
> > intrusive way I can think of dealing with this is to account XFS_INEW
> > inodes as "skipped" inodes during the ag walk (for dqrele_all_inodes()
> > only) and restart the scan until they are completed.
> 
> Is xfs/305 supposed to pass with 4.13-rc2 kernel now? I know there're
> some quota patches went in XFS recently, but I'm not sure if there's any
> known leftover bug.
> 
> Anyway, I hit a test hang with 4.13-rc2 kernel with xfs/305 again, test
> configuration is rmapbt XFS with 4k block size on ppc64le host. But I
> haven't tried to reproduce it yet. Just want to confirm with you first.
> 

I believe it is still possible for quotaoff to deadlock the log. It is
not shown below, but I assume you have a blocked xfs_quota process
attempting to run a quotaoff..? How big is your fs/log?

I sent a patch a while ago, but it wasn't safe because it could
potentially lead to nested transactions in the quotaoff context. We
don't have a proper fix for this as of yet.

Brian

> Thanks,
> Eryu
> 
> [ 9219.858228] run fstests xfs/305 at 2017-07-24 04:25:26 
> [ 9220.209846] XFS (vda5): Unmounting Filesystem 
> [ 9220.393077] XFS (vda5): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk! 
> [ 9220.393861] XFS (vda5): Mounting V5 Filesystem 
> [ 9220.400258] XFS (vda5): Ending clean mount 
> [ 9220.459884] XFS (vda5): Unmounting Filesystem 
> [ 9220.663924] XFS (vda5): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk! 
> [ 9220.664542] XFS (vda5): Mounting V5 Filesystem 
> [ 9220.669948] XFS (vda5): Ending clean mount 
> [ 9220.670681] XFS (vda5): Quotacheck needed: Please wait. 
> [ 9220.698900] XFS (vda5): Quotacheck: Done. 
> [ 9245.913313] XFS (vda5): Unmounting Filesystem 
> [ 9246.386313] XFS (vda5): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk! 
> [ 9246.387058] XFS (vda5): Mounting V5 Filesystem 
> [ 9246.568249] XFS (vda5): Ending clean mount 
> [ 9246.570422] XFS (vda5): Quotacheck needed: Please wait. 
> [ 9247.212955] XFS (vda5): Quotacheck: Done. 
> [ 9271.562000] XFS (vda5): Unmounting Filesystem 
> [ 9271.920984] XFS (vda5): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk! 
> [ 9271.921746] XFS (vda5): Mounting V5 Filesystem 
> [ 9271.975980] XFS (vda5): Ending clean mount 
> [ 9271.979411] XFS (vda5): Quotacheck needed: Please wait. 
> [ 9272.686058] XFS (vda5): Quotacheck: Done. 
> [ 9459.464674] INFO: task kworker/u16:0:31345 blocked for more than 120 seconds. 
> [ 9459.465111]       Tainted: G        W       4.13.0-rc2 #1 
> [ 9459.465381] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
> [ 9459.465789] kworker/u16:0   D    0 31345      2 0x00000880 
> [ 9459.466245] Workqueue: writeback wb_workfn (flush-253:0) 
> [ 9459.466519] Call Trace: 
> [ 9459.466664] [c00000009a9872d0] [c0000001fc1ca200] 0xc0000001fc1ca200 (unreliable) 
> [ 9459.467081] [c00000009a9874a0] [c00000000001ad18] __switch_to+0x2e8/0x430 
> [ 9459.467435] [c00000009a987500] [c00000000093a8e8] __schedule+0x3a8/0xaf0 
> [ 9459.467780] [c00000009a9875d0] [c00000000093b070] schedule+0x40/0xb0 
> [ 9459.468173] [c00000009a987600] [d000000004fd4cd4] xlog_grant_head_wait+0x114/0x320 [xfs] 
> [ 9459.468797] [c00000009a987660] [d000000004fd5044] xlog_grant_head_check+0x164/0x1a0 [xfs] 
> [ 9459.469242] [c00000009a9876b0] [d000000004fd99d8] xfs_log_reserve+0xd8/0x280 [xfs] 
> [ 9459.469685] [c00000009a987700] [d000000004fd1a84] xfs_trans_reserve+0x244/0x2b0 [xfs] 
> [ 9459.470141] [c00000009a987750] [d000000004fd330c] xfs_trans_alloc+0xec/0x190 [xfs] 
> [ 9459.470595] [c00000009a9877b0] [d000000004f9bdf8] xfs_setfilesize_trans_alloc.isra.9+0x38/0x90 [xfs] 
> [ 9459.471116] [c00000009a9877f0] [d000000004f9bfc4] xfs_submit_ioend+0x174/0x1c0 [xfs] 
> [ 9459.471572] [c00000009a987830] [d000000004f9c124] xfs_vm_writepages+0x114/0x140 [xfs] 
> [ 9459.471994] [c00000009a9878b0] [c0000000002624ac] do_writepages+0x4c/0x110 
> [ 9459.472339] [c00000009a9878e0] [c000000000368fd4] __writeback_single_inode+0x64/0x500 
> [ 9459.472756] [c00000009a987940] [c000000000369b4c] writeback_sb_inodes+0x2dc/0x5b0 
> [ 9459.473173] [c00000009a987a50] [c000000000369f04] __writeback_inodes_wb+0xe4/0x150 
> [ 9459.473590] [c00000009a987ab0] [c00000000036a23c] wb_writeback+0x2cc/0x420 
> [ 9459.473935] [c00000009a987b80] [c00000000036aea8] wb_workfn+0x138/0x4c0 
> [ 9459.474290] [c00000009a987c90] [c00000000010b828] process_one_work+0x198/0x480 
> [ 9459.474696] [c00000009a987d30] [c00000000010bb98] worker_thread+0x88/0x510 
> [ 9459.474970] [c00000009a987dc0] [c000000000113920] kthread+0x160/0x1a0 
> [ 9459.475240] [c00000009a987e30] [c00000000000b524] ret_from_kernel_thread+0x5c/0xb8 
> [ 9459.475579] INFO: task fsstress:2190 blocked for more than 120 seconds. 
> [ 9459.475846]       Tainted: G        W       4.13.0-rc2 #1 
> [ 9459.476054] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
> [ 9459.476365] fsstress        D    0  2190   2188 0x00040080 
> [ 9459.476577] Call Trace: 
> [ 9459.476684] [c0000001ea0276e0] [0000000000000001] 0x1 (unreliable) 
> [ 9459.476949] [c0000001ea0278b0] [c00000000001ad18] __switch_to+0x2e8/0x430 
> [ 9459.477210] [c0000001ea027910] [c00000000093a8e8] __schedule+0x3a8/0xaf0 
> [ 9459.477466] [c0000001ea0279e0] [c00000000093b070] schedule+0x40/0xb0 
> [ 9459.477779] [c0000001ea027a10] [d000000004fd4cd4] xlog_grant_head_wait+0x114/0x320 [xfs] 
> [ 9459.478142] [c0000001ea027a70] [d000000004fd5044] xlog_grant_head_check+0x164/0x1a0 [xfs] 
> [ 9459.478529] [c0000001ea027ac0] [d000000004fd99d8] xfs_log_reserve+0xd8/0x280 [xfs] 
> [ 9459.478890] [c0000001ea027b10] [d000000004fd1a84] xfs_trans_reserve+0x244/0x2b0 [xfs] 
> [ 9459.479247] [c0000001ea027b60] [d000000004fd330c] xfs_trans_alloc+0xec/0x190 [xfs] 
> [ 9459.479604] [c0000001ea027bc0] [d000000004fa1be8] xfs_free_file_space+0x288/0x430 [xfs] 
> [ 9459.479963] [c0000001ea027cd0] [d000000004fabef0] xfs_file_fallocate+0x190/0x3b0 [xfs] 
> [ 9459.480280] [c0000001ea027d90] [c000000000321148] vfs_fallocate+0x178/0x300 
> [ 9459.480539] [c0000001ea027de0] [c000000000322630] SyS_fallocate+0x60/0xe0 
> [ 9459.480804] [c0000001ea027e30] [c00000000000b184] system_call+0x58/0x6c 
> [ 9459.481071] INFO: task fsstress:2191 blocked for more than 120 seconds. 
> [ 9459.481338]       Tainted: G        W       4.13.0-rc2 #1 
> [ 9459.481548] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
> [ 9459.481862] fsstress        D    0  2191   2188 0x00040080 
> [ 9459.482076] Call Trace: 
> [ 9459.482185] [c0000001ea073800] [c00000000001ad18] __switch_to+0x2e8/0x430 
> [ 9459.482455] [c0000001ea073860] [c00000000093a8e8] __schedule+0x3a8/0xaf0 
> [ 9459.482725] [c0000001ea073930] [c00000000093b070] schedule+0x40/0xb0 
> [ 9459.483039] [c0000001ea073960] [d000000004fd4cd4] xlog_grant_head_wait+0x114/0x320 [xfs] 
> [ 9459.483406] [c0000001ea0739c0] [d000000004fd5044] xlog_grant_head_check+0x164/0x1a0 [xfs] 
> [ 9459.483770] [c0000001ea073a10] [d000000004fd99d8] xfs_log_reserve+0xd8/0x280 [xfs] 
> [ 9459.484130] [c0000001ea073a60] [d000000004fd1a84] xfs_trans_reserve+0x244/0x2b0 [xfs] 
> [ 9459.484490] [c0000001ea073ab0] [d000000004fd330c] xfs_trans_alloc+0xec/0x190 [xfs] 
> [ 9459.484842] [c0000001ea073b10] [d000000004fbbe80] xfs_vn_update_time+0x60/0x1f0 [xfs] 
> [ 9459.485155] [c0000001ea073b70] [c00000000034e530] file_update_time+0xf0/0x170 
> [ 9459.485508] [c0000001ea073bc0] [d000000004fac408] xfs_file_aio_write_checks+0x1f8/0x270 [xfs] 
> [ 9459.485913] [c0000001ea073c50] [d000000004fac73c] xfs_file_dio_aio_write+0xcc/0x360 [xfs] 
> [ 9459.486269] [c0000001ea073cb0] [d000000004facd80] xfs_file_write_iter+0xd0/0x1d0 [xfs] 
> [ 9459.486584] [c0000001ea073d00] [c000000000324210] __vfs_write+0x120/0x200 
> [ 9459.486841] [c0000001ea073d90] [c000000000325c88] vfs_write+0xc8/0x240 
> [ 9459.487100] [c0000001ea073de0] [c000000000327a80] SyS_write+0x60/0x110 
> [ 9459.487363] [c0000001ea073e30] [c00000000000b184] system_call+0x58/0x6c 
> [ 9459.487622] INFO: task fsstress:2192 blocked for more than 120 seconds. 
> [ 9459.487879]       Tainted: G        W       4.13.0-rc2 #1 
> [ 9459.488087] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
> [ 9459.488451] fsstress        D    0  2192   2188 0x00040080 
> [ 9459.488631] Call Trace: 
> [ 9459.488713] [c0000001ea07b6a0] [c0000001ea07b740] 0xc0000001ea07b740 (unreliable) 
> [ 9459.488939] [c0000001ea07b870] [c00000000001ad18] __switch_to+0x2e8/0x430 
> [ 9459.489119] [c0000001ea07b8d0] [c00000000093a8e8] __schedule+0x3a8/0xaf0 
> [ 9459.489301] [c0000001ea07b9a0] [c00000000093b070] schedule+0x40/0xb0 
> [ 9459.489509] [c0000001ea07b9d0] [d000000004fd4cd4] xlog_grant_head_wait+0x114/0x320 [xfs] 
> [ 9459.489749] [c0000001ea07ba30] [d000000004fd5044] xlog_grant_head_check+0x164/0x1a0 [xfs] 
> [ 9459.489984] [c0000001ea07ba80] [d000000004fd99d8] xfs_log_reserve+0xd8/0x280 [xfs] 
> [ 9459.490218] [c0000001ea07bad0] [d000000004fd1a84] xfs_trans_reserve+0x244/0x2b0 [xfs] 
> [ 9459.490450] [c0000001ea07bb20] [d000000004fd330c] xfs_trans_alloc+0xec/0x190 [xfs] 
> [ 9459.490687] [c0000001ea07bb80] [d000000004fc1364] xfs_create+0x1b4/0x7d0 [xfs] 
> [ 9459.490922] [c0000001ea07bcc0] [d000000004fbdb38] xfs_generic_create+0x2f8/0x440 [xfs] 
> [ 9459.491132] [c0000001ea07bd50] [c000000000336fe8] vfs_mknod+0x1c8/0x260 
> [ 9459.491311] [c0000001ea07bda0] [c00000000033da58] SyS_mknodat+0x2d8/0x310 
> [ 9459.491489] [c0000001ea07be30] [c00000000000b184] system_call+0x58/0x6c 
> [ 9459.491666] INFO: task fsstress:2193 blocked for more than 120 seconds. 
> [ 9459.491840]       Tainted: G        W       4.13.0-rc2 #1 
> [ 9459.491977] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
> [ 9459.492190] fsstress        D    0  2193   2188 0x00040080 
> [ 9459.492329] Call Trace: 
> [ 9459.492400] [c0000001ea043740] [0000000600000007] 0x600000007 (unreliable) 
> [ 9459.492576] [c0000001ea043910] [c00000000001ad18] __switch_to+0x2e8/0x430 
> [ 9459.492751] [c0000001ea043970] [c00000000093a8e8] __schedule+0x3a8/0xaf0 
> [ 9459.492936] [c0000001ea043a40] [c00000000093b070] schedule+0x40/0xb0 
> [ 9459.493151] [c0000001ea043a70] [d000000004fd4cd4] xlog_grant_head_wait+0x114/0x320 [xfs] 
> [ 9459.493386] [c0000001ea043ad0] [d000000004fd5044] xlog_grant_head_check+0x164/0x1a0 [xfs] 
> [ 9459.493621] [c0000001ea043b20] [d000000004fd99d8] xfs_log_reserve+0xd8/0x280 [xfs] 
> [ 9459.493856] [c0000001ea043b70] [d000000004fd1a84] xfs_trans_reserve+0x244/0x2b0 [xfs] 
> [ 9459.494087] [c0000001ea043bc0] [d000000004fd330c] xfs_trans_alloc+0xec/0x190 [xfs] 
> [ 9459.494318] [c0000001ea043c20] [d000000004fc1f6c] xfs_link+0x17c/0x370 [xfs] 
> [ 9459.494560] [c0000001ea043cc0] [d000000004fbc568] xfs_vn_link+0x68/0xc0 [xfs] 
> [ 9459.494770] [c0000001ea043d10] [c00000000033785c] vfs_link+0x34c/0x480 
> [ 9459.494942] [c0000001ea043d70] [c00000000033e0c0] SyS_linkat+0x2a0/0x370 
> [ 9459.495118] [c0000001ea043e30] [c00000000000b184] system_call+0x58/0x6c 
> [ 9459.495290] INFO: task fsstress:2194 blocked for more than 120 seconds. 
> [ 9459.495462]       Tainted: G        W       4.13.0-rc2 #1 
> [ 9459.495597] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
> [ 9459.495801] fsstress        D    0  2194   2188 0x00040080 
> [ 9459.495942] Call Trace: 
> [ 9459.496011] [c0000001ea01b900] [0000000000000001] 0x1 (unreliable) 
> [ 9459.496183] [c0000001ea01bad0] [c00000000001ad18] __switch_to+0x2e8/0x430 
> [ 9459.496357] [c0000001ea01bb30] [c00000000093a8e8] __schedule+0x3a8/0xaf0 
> [ 9459.496531] [c0000001ea01bc00] [c00000000093b070] schedule+0x40/0xb0 
> [ 9459.496709] [c0000001ea01bc30] [c0000000003670b4] wb_wait_for_completion+0x84/0xd0 
> [ 9459.496919] [c0000001ea01bc90] [c000000000368530] sync_inodes_sb+0xd0/0x330 
> [ 9459.497094] [c0000001ea01bd60] [c00000000036fd84] sync_inodes_one_sb+0x24/0x40 
> [ 9459.497301] [c0000001ea01bd80] [c00000000032b978] iterate_supers+0x1b8/0x1f0 
> [ 9459.497509] [c0000001ea01bdf0] [c0000000003702a0] sys_sync+0x50/0xe0 
> [ 9459.497682] [c0000001ea01be30] [c00000000000b184] system_call+0x58/0x6c 
> [ 9459.497857] INFO: task fsstress:2195 blocked for more than 120 seconds. 
> [ 9459.498027]       Tainted: G        W       4.13.0-rc2 #1 
> [ 9459.498165] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
> [ 9459.498376] fsstress        D    0  2195   2188 0x00040080 
> [ 9459.498514] Call Trace: 
> [ 9459.498586] [c0000001ea057ad0] [c00000000001ad18] __switch_to+0x2e8/0x430 
> [ 9459.498761] [c0000001ea057b30] [c00000000093a8e8] __schedule+0x3a8/0xaf0 
> [ 9459.498935] [c0000001ea057c00] [c00000000093b070] schedule+0x40/0xb0 
> [ 9459.499107] [c0000001ea057c30] [c0000000003670b4] wb_wait_for_completion+0x84/0xd0 
> [ 9459.499322] [c0000001ea057c90] [c000000000368530] sync_inodes_sb+0xd0/0x330 
> [ 9459.499496] [c0000001ea057d60] [c00000000036fd84] sync_inodes_one_sb+0x24/0x40 
> [ 9459.499703] [c0000001ea057d80] [c00000000032b978] iterate_supers+0x1b8/0x1f0 
> [ 9459.499914] [c0000001ea057df0] [c0000000003702a0] sys_sync+0x50/0xe0 
> [ 9459.500089] [c0000001ea057e30] [c00000000000b184] system_call+0x58/0x6c 
> [ 9459.500265] INFO: task fsstress:2196 blocked for more than 120 seconds. 
> [ 9459.500440]       Tainted: G        W       4.13.0-rc2 #1 
> [ 9459.500577] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
> [ 9459.500787] fsstress        D    0  2196   2188 0x00040080 
> [ 9459.500930] Call Trace: 
> [ 9459.501003] [c0000001ea03b8d0] [c00000000001ad18] __switch_to+0x2e8/0x430 
> [ 9459.501179] [c0000001ea03b930] [c00000000093a8e8] __schedule+0x3a8/0xaf0 
> [ 9459.501359] [c0000001ea03ba00] [c00000000093b070] schedule+0x40/0xb0 
> [ 9459.501576] [c0000001ea03ba30] [d000000004fd4cd4] xlog_grant_head_wait+0x114/0x320 [xfs] 
> [ 9459.501813] [c0000001ea03ba90] [d000000004fd5044] xlog_grant_head_check+0x164/0x1a0 [xfs] 
> [ 9459.502051] [c0000001ea03bae0] [d000000004fd99d8] xfs_log_reserve+0xd8/0x280 [xfs] 
> [ 9459.502288] [c0000001ea03bb30] [d000000004fd1a84] xfs_trans_reserve+0x244/0x2b0 [xfs] 
> [ 9459.502521] [c0000001ea03bb80] [d000000004fd330c] xfs_trans_alloc+0xec/0x190 [xfs] 
> [ 9459.502755] [c0000001ea03bbe0] [d000000004fbbe80] xfs_vn_update_time+0x60/0x1f0 [xfs] 
> [ 9459.502962] [c0000001ea03bc40] [c0000000003508dc] touch_atime+0xec/0x110 
> [ 9459.503164] [c0000001ea03bc80] [d000000004fab4c8] xfs_file_dio_aio_read+0x168/0x170 [xfs] 
> [ 9459.503396] [c0000001ea03bcd0] [d000000004fab954] xfs_file_read_iter+0x114/0x140 [xfs] 
> [ 9459.503601] [c0000001ea03bd10] [c000000000324010] __vfs_read+0x120/0x200 
> [ 9459.503776] [c0000001ea03bda0] [c000000000325adc] vfs_read+0xac/0x190 
> [ 9459.503948] [c0000001ea03bde0] [c000000000327970] SyS_read+0x60/0x110 
> [ 9459.504123] [c0000001ea03be30] [c00000000000b184] system_call+0x58/0x6c 
> [ 9459.504298] INFO: task fsstress:2197 blocked for more than 120 seconds. 
> [ 9459.504467]       Tainted: G        W       4.13.0-rc2 #1 
> [ 9459.504608] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
> [ 9459.504813] fsstress        D    0  2197   2188 0x00040080 
> [ 9459.504952] Call Trace: 
> [ 9459.505022] [c0000001ea00f6c0] [0000000500000002] 0x500000002 (unreliable) 
> [ 9459.505195] [c0000001ea00f890] [c00000000001ad18] __switch_to+0x2e8/0x430 
> [ 9459.505373] [c0000001ea00f8f0] [c00000000093a8e8] __schedule+0x3a8/0xaf0 
> [ 9459.505552] [c0000001ea00f9c0] [c00000000093b070] schedule+0x40/0xb0 
> [ 9459.505756] [c0000001ea00f9f0] [d000000004fd4cd4] xlog_grant_head_wait+0x114/0x320 [xfs] 
> [ 9459.505991] [c0000001ea00fa50] [d000000004fd5044] xlog_grant_head_check+0x164/0x1a0 [xfs] 
> [ 9459.506226] [c0000001ea00faa0] [d000000004fd99d8] xfs_log_reserve+0xd8/0x280 [xfs] 
> [ 9459.506460] [c0000001ea00faf0] [d000000004fd1a84] xfs_trans_reserve+0x244/0x2b0 [xfs] 
> [ 9459.506698] [c0000001ea00fb40] [d000000004fd330c] xfs_trans_alloc+0xec/0x190 [xfs] 
> [ 9459.506931] [c0000001ea00fba0] [d000000004fc1364] xfs_create+0x1b4/0x7d0 [xfs] 
> [ 9459.507161] [c0000001ea00fce0] [d000000004fbdb38] xfs_generic_create+0x2f8/0x440 [xfs] 
> [ 9459.507370] [c0000001ea00fd70] [c000000000337208] vfs_mkdir+0x188/0x270 
> [ 9459.507544] [c0000001ea00fdc0] [c00000000033dbfc] SyS_mkdirat+0x13c/0x150 
> [ 9459.507716] [c0000001ea00fe30] [c00000000000b184] system_call+0x58/0x6c 
> [ 9459.507893] INFO: task fsstress:2198 blocked for more than 120 seconds. 
> [ 9459.508064]       Tainted: G        W       4.13.0-rc2 #1 
> [ 9459.508201] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
> [ 9459.508412] fsstress        D    0  2198   2188 0x00040080 
> [ 9459.508551] Call Trace: 
> [ 9459.508621] [c0000001ea02b3f0] [0000000600000002] 0x600000002 (unreliable) 
> [ 9459.508796] [c0000001ea02b5c0] [c00000000001ad18] __switch_to+0x2e8/0x430 
> [ 9459.508967] [c0000001ea02b620] [c00000000093a8e8] __schedule+0x3a8/0xaf0 
> [ 9459.509144] [c0000001ea02b6f0] [c00000000093b070] schedule+0x40/0xb0 
> [ 9459.509357] [c0000001ea02b720] [d000000004fd4cd4] xlog_grant_head_wait+0x114/0x320 [xfs] 
> [ 9459.509593] [c0000001ea02b780] [d000000004fd5044] xlog_grant_head_check+0x164/0x1a0 [xfs] 
> [ 9459.509830] [c0000001ea02b7d0] [d000000004fd99d8] xfs_log_reserve+0xd8/0x280 [xfs] 
> [ 9459.510066] [c0000001ea02b820] [d000000004fd1a84] xfs_trans_reserve+0x244/0x2b0 [xfs] 
> [ 9459.510302] [c0000001ea02b870] [d000000004fd330c] xfs_trans_alloc+0xec/0x190 [xfs] 
> [ 9459.510535] [c0000001ea02b8d0] [d000000004fc1364] xfs_create+0x1b4/0x7d0 [xfs] 
> [ 9459.510768] [c0000001ea02ba10] [d000000004fbdb38] xfs_generic_create+0x2f8/0x440 [xfs] 
> [ 9459.510975] [c0000001ea02baa0] [c000000000339fb4] lookup_open+0x654/0x790 
> [ 9459.511151] [c0000001ea02bb60] [c00000000033b784] do_last+0x554/0x8d0 
> [ 9459.511323] [c0000001ea02bc00] [c00000000033bbb4] path_openat+0xb4/0x3c0 
> [ 9459.511496] [c0000001ea02bc90] [c00000000033d584] do_filp_open+0x74/0xf0 
> [ 9459.511670] [c0000001ea02bdc0] [c0000000003238e0] do_sys_open+0x1b0/0x2d0 
> [ 9459.511844] [c0000001ea02be30] [c00000000000b184] system_call+0x58/0x6c 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
