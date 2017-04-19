Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from firestarter.dermichi.com ([194.177.153.153]:48862 "EHLO
        firestarter.dermichi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763371AbdDSNBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 09:01:20 -0400
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[192.168.34.111])
        by firestarter.dermichi.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim)
        (envelope-from <mw@dermichi.com>)
        id 1d0pES-0005lP-6l
        for linux-xfs@vger.kernel.org; Wed, 19 Apr 2017 15:01:16 +0200
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
References: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
 <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
 <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
Date: Wed, 19 Apr 2017 15:01:15 +0200
MIME-Version: 1.0
In-Reply-To: <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

> * dmesg output from hung tasks
[25012.200938] INFO: task kworker/u12:0:39771 blocked for more than 120
seconds.
[25012.201036]       Tainted: G            E   4.11.0-rc5-mw #1
[25012.201125] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25012.201220] kworker/u12:0   D    0 39771      2 0x00000000
[25012.201229] Workqueue: writeback wb_workfn (flush-9:127)
[25012.201231] Call Trace:
[25012.201241]  ? __schedule+0x2e0/0x910
[25012.201295]  ? xfs_buf_rele+0x5b/0x390 [xfs]
[25012.201300]  ? schedule+0x32/0x80
[25012.201344]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
[25012.201385]  ? xlog_grant_head_check+0x9a/0x110 [xfs]
[25012.201428]  ? xfs_log_reserve+0xd4/0x1f0 [xfs]
[25012.201468]  ? xfs_trans_reserve+0x182/0x1f0 [xfs]
[25012.201507]  ? xfs_trans_alloc+0xb4/0x130 [xfs]
[25012.201548]  ? xfs_iomap_write_allocate+0x1ea/0x360 [xfs]
[25012.201578]  ? xfs_bmapi_read+0x29f/0x320 [xfs]
[25012.201617]  ? xfs_map_blocks+0x1c8/0x240 [xfs]
[25012.201654]  ? xfs_do_writepage+0x257/0x710 [xfs]
[25012.201657]  ? invalid_page_referenced_vma+0x80/0x80
[25012.201661]  ? write_cache_pages+0x207/0x480
[25012.201696]  ? xfs_submit_ioend+0x170/0x170 [xfs]
[25012.201731]  ? xfs_vm_writepages+0xba/0xf0 [xfs]
[25012.201735]  ? __writeback_single_inode+0x3d/0x330
[25012.201737]  ? writeback_sb_inodes+0x23d/0x470
[25012.201741]  ? __writeback_inodes_wb+0x87/0xb0
[25012.201743]  ? wb_writeback+0x28e/0x320
[25012.201746]  ? wb_workfn+0x2d2/0x3a0
[25012.201748]  ? wb_workfn+0x2d2/0x3a0
[25012.201752]  ? process_one_work+0x15e/0x420
[25012.201754]  ? worker_thread+0x65/0x4b0
[25012.201756]  ? rescuer_thread+0x390/0x390
[25012.201759]  ? kthread+0x104/0x140
[25012.201762]  ? kthread_park+0x80/0x80
[25012.201764]  ? do_group_exit+0x39/0xb0
[25012.201767]  ? ret_from_fork+0x26/0x40
[25012.201777] INFO: task rm:44141 blocked for more than 120 seconds.
[25012.201868]       Tainted: G            E   4.11.0-rc5-mw #1
[25012.201957] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25012.202051] rm              D    0 44141  43912 0x00000000
[25012.202054] Call Trace:
[25012.202059]  ? __schedule+0x2e0/0x910
[25012.202097]  ? xfs_dir_open+0x59/0x70 [xfs]
[25012.202102]  ? schedule+0x32/0x80
[25012.202144]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
[25012.202183]  ? xlog_grant_head_check+0x9a/0x110 [xfs]
[25012.202223]  ? xfs_log_reserve+0xd4/0x1f0 [xfs]
[25012.202262]  ? xfs_trans_reserve+0x182/0x1f0 [xfs]
[25012.202299]  ? xfs_trans_alloc+0xb4/0x130 [xfs]
[25012.202339]  ? xfs_remove+0x13d/0x310 [xfs]
[25012.202379]  ? xfs_vn_unlink+0x55/0xa0 [xfs]
[25012.202383]  ? vfs_rmdir+0xac/0x120
[25012.202386]  ? do_rmdir+0x1c9/0x1e0
[25012.202389]  ? entry_SYSCALL_64_fastpath+0x1e/0xad
[25012.202392] INFO: task rm:44149 blocked for more than 120 seconds.
[25012.202483]       Tainted: G            E   4.11.0-rc5-mw #1
[25012.202571] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25012.202665] rm              D    0 44149  43923 0x00000000
[25012.202668] Call Trace:
[25012.202672]  ? __schedule+0x2e0/0x910
[25012.202676]  ? schedule+0x32/0x80
[25012.202716]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
[25012.202754]  ? xlog_grant_head_check+0x9a/0x110 [xfs]
[25012.202793]  ? xfs_log_reserve+0xd4/0x1f0 [xfs]
[25012.202831]  ? xfs_trans_reserve+0x182/0x1f0 [xfs]
[25012.202867]  ? xfs_trans_alloc+0xb4/0x130 [xfs]
[25012.202906]  ? xfs_remove+0x13d/0x310 [xfs]
[25012.202945]  ? xfs_vn_unlink+0x55/0xa0 [xfs]
[25012.202949]  ? vfs_unlink+0xe7/0x180
[25012.202952]  ? do_unlinkat+0x289/0x310
[25012.202955]  ? entry_SYSCALL_64_fastpath+0x1e/0xad
[25012.202958] INFO: task rsync:44358 blocked for more than 120 seconds.
[25012.203050]       Tainted: G            E   4.11.0-rc5-mw #1
[25012.203138] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25012.203233] rsync           D    0 44358  44355 0x00000000
[25012.203235] Call Trace:
[25012.203239]  ? __schedule+0x2e0/0x910
[25012.203242]  ? walk_component+0x4b/0x630
[25012.203245]  ? schedule+0x32/0x80
[25012.203284]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
[25012.203322]  ? xlog_grant_head_check+0x9a/0x110 [xfs]
[25012.203361]  ? xfs_log_reserve+0xd4/0x1f0 [xfs]
[25012.203400]  ? xfs_trans_reserve+0x182/0x1f0 [xfs]
[25012.203436]  ? xfs_trans_alloc+0xb4/0x130 [xfs]
[25012.203476]  ? xfs_link+0x123/0x2d0 [xfs]
[25012.203478]  ? __d_lookup+0x60/0x130
[25012.203517]  ? xfs_vn_link+0x65/0xa0 [xfs]
[25012.203520]  ? vfs_link+0x21a/0x2e0
[25012.203524]  ? SyS_link+0x22a/0x260
[25012.203527]  ? entry_SYSCALL_64_fastpath+0x1e/0xad
[25012.203530] INFO: task rsync:44370 blocked for more than 120 seconds.
[25012.203622]       Tainted: G            E   4.11.0-rc5-mw #1
[25012.203710] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25012.203804] rsync           D    0 44370  44365 0x00000000
[25012.203806] Call Trace:
[25012.203811]  ? __schedule+0x2e0/0x910
[25012.203814]  ? schedule+0x32/0x80
[25012.203852]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
[25012.203889]  ? xlog_grant_head_check+0x9a/0x110 [xfs]
[25012.203928]  ? xfs_log_reserve+0xd4/0x1f0 [xfs]
[25012.203965]  ? xfs_trans_reserve+0x182/0x1f0 [xfs]
[25012.204002]  ? xfs_trans_alloc+0xb4/0x130 [xfs]
[25012.204041]  ? xfs_vn_update_time+0x5d/0x150 [xfs]
[25012.204044]  ? file_update_time+0xb7/0x110
[25012.204083]  ? xfs_file_aio_write_checks+0x176/0x1d0 [xfs]
[25012.204120]  ? xfs_file_buffered_aio_write+0x7a/0x260 [xfs]
[25012.204156]  ? xfs_file_write_iter+0x10b/0x150 [xfs]
[25012.204159]  ? __vfs_write+0xeb/0x160
[25012.204162]  ? vfs_write+0xb3/0x1a0
[25012.204165]  ? SyS_write+0x52/0xc0
[25012.204167]  ? entry_SYSCALL_64_fastpath+0x1e/0xad
[25012.204171] INFO: task rsync:44480 blocked for more than 120 seconds.
[25012.204283]       Tainted: G            E   4.11.0-rc5-mw #1
[25012.204393] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25012.204529] rsync           D    0 44480  44477 0x00000000
[25012.204531] Call Trace:
[25012.204536]  ? __schedule+0x2e0/0x910
[25012.204539]  ? walk_component+0x4b/0x630
[25012.204542]  ? schedule+0x32/0x80
[25012.204581]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
[25012.204619]  ? xlog_grant_head_check+0x9a/0x110 [xfs]
[25012.204658]  ? xfs_log_reserve+0xd4/0x1f0 [xfs]
[25012.204696]  ? xfs_trans_reserve+0x182/0x1f0 [xfs]
[25012.204732]  ? xfs_trans_alloc+0xb4/0x130 [xfs]
[25012.204772]  ? xfs_link+0x123/0x2d0 [xfs]
[25012.204774]  ? __d_lookup+0x60/0x130
[25012.204814]  ? xfs_vn_link+0x65/0xa0 [xfs]
[25012.204817]  ? vfs_link+0x21a/0x2e0
[25012.204820]  ? SyS_link+0x22a/0x260
[25012.204823]  ? entry_SYSCALL_64_fastpath+0x1e/0xad
[25012.204827] INFO: task rsync:44581 blocked for more than 120 seconds.
[25012.204951]       Tainted: G            E   4.11.0-rc5-mw #1
[25012.205062] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25012.205200] rsync           D    0 44581  44580 0x00000000
[25012.205202] Call Trace:
[25012.205207]  ? __schedule+0x2e0/0x910
[25012.205245]  ? xfs_trans_free_items+0x75/0xa0 [xfs]
[25012.205249]  ? schedule+0x32/0x80
[25012.205286]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
[25012.205321]  ? xlog_grant_head_check+0xf8/0x110 [xfs]
[25012.205362]  ? xfs_log_reserve+0xd4/0x1f0 [xfs]
[25012.205401]  ? xfs_trans_reserve+0x182/0x1f0 [xfs]
[25012.205438]  ? xfs_trans_alloc+0xb4/0x130 [xfs]
[25012.205469]  ? xfs_attr_set+0x1d4/0x440 [xfs]
[25012.205473]  ? d_splice_alias+0x185/0x3c0
[25012.205509]  ? xfs_xattr_set+0x4e/0x90 [xfs]
[25012.205515]  ? __vfs_setxattr+0x64/0x80
[25012.205520]  ? __vfs_setxattr_noperm+0x62/0x190
[25012.205523]  ? vfs_setxattr+0xa0/0xb0
[25012.205526]  ? setxattr+0x141/0x190
[25012.205531]  ? __check_object_size+0x173/0x19e
[25012.205535]  ? strncpy_from_user+0x48/0x160
[25012.205539]  ? path_setxattr+0xad/0xe0
[25012.205542]  ? SyS_lsetxattr+0xd/0x10
[25012.205545]  ? entry_SYSCALL_64_fastpath+0x1e/0xad
[25133.028169] INFO: task kworker/1:0:24106 blocked for more than 120
seconds.
[25133.028288]       Tainted: G            E   4.11.0-rc5-mw #1
[25133.028397] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25133.028535] kworker/1:0     D    0 24106      2 0x00000000
[25133.028595] Workqueue: xfs-eofblocks/md127 xfs_eofblocks_worker [xfs]
[25133.028598] Call Trace:
[25133.028606]  ? __schedule+0x2e0/0x910
[25133.028609]  ? schedule+0x32/0x80
[25133.028655]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
[25133.028697]  ? xlog_grant_head_check+0x9a/0x110 [xfs]
[25133.028739]  ? xfs_log_reserve+0xd4/0x1f0 [xfs]
[25133.028779]  ? xfs_trans_reserve+0x182/0x1f0 [xfs]
[25133.028817]  ? xfs_trans_alloc+0xb4/0x130 [xfs]
[25133.028857]  ? xfs_free_eofblocks+0x120/0x1e0 [xfs]
[25133.028897]  ? xfs_inode_free_eofblocks+0x11e/0x140 [xfs]
[25133.028936]  ? xfs_inode_ag_walk.isra.13+0x19b/0x2b0 [xfs]
[25133.028973]  ? xfs_inode_clear_eofblocks_tag+0x70/0x70 [xfs]
[25133.028978]  ? intel_cpufreq_target+0x170/0x170
[25133.028982]  ? update_load_avg+0x858/0xa00
[25133.028985]  ? radix_tree_next_chunk+0x101/0x310
[25133.028989]  ? radix_tree_gang_lookup_tag+0xe4/0x150
[25133.029024]  ? xfs_inode_clear_eofblocks_tag+0x70/0x70 [xfs]
[25133.029062]  ? xfs_perag_get_tag+0x3d/0xe0 [xfs]
[25133.029097]  ? xfs_inode_clear_eofblocks_tag+0x70/0x70 [xfs]
[25133.029132]  ? xfs_inode_ag_iterator_tag+0x70/0xa0 [xfs]
[25133.029166]  ? xfs_eofblocks_worker+0x23/0x30 [xfs]
[25133.029169]  ? process_one_work+0x15e/0x420
[25133.029171]  ? worker_thread+0x65/0x4b0
[25133.029173]  ? rescuer_thread+0x390/0x390
[25133.029176]  ? kthread+0x104/0x140
[25133.029179]  ? kthread_park+0x80/0x80
[25133.029182]  ? do_group_exit+0x39/0xb0
[25133.029185]  ? ret_from_fork+0x26/0x40
[25133.029188] INFO: task kworker/u12:0:39771 blocked for more than 120
seconds.
[25133.029303]       Tainted: G            E   4.11.0-rc5-mw #1
[25133.029412] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25133.029549] kworker/u12:0   D    0 39771      2 0x00000000
[25133.029556] Workqueue: writeback wb_workfn (flush-9:127)
[25133.029558] Call Trace:
[25133.029563]  ? __schedule+0x2e0/0x910
[25133.029600]  ? xfs_buf_rele+0x5b/0x390 [xfs]
[25133.029605]  ? schedule+0x32/0x80
[25133.029647]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
[25133.029687]  ? xlog_grant_head_check+0x9a/0x110 [xfs]
[25133.029728]  ? xfs_log_reserve+0xd4/0x1f0 [xfs]
[25133.029768]  ? xfs_trans_reserve+0x182/0x1f0 [xfs]
[25133.029807]  ? xfs_trans_alloc+0xb4/0x130 [xfs]
[25133.029846]  ? xfs_iomap_write_allocate+0x1ea/0x360 [xfs]
[25133.029876]  ? xfs_bmapi_read+0x29f/0x320 [xfs]
[25133.029914]  ? xfs_map_blocks+0x1c8/0x240 [xfs]
[25133.029950]  ? xfs_do_writepage+0x257/0x710 [xfs]
[25133.029954]  ? invalid_page_referenced_vma+0x80/0x80
[25133.029957]  ? write_cache_pages+0x207/0x480
[25133.029992]  ? xfs_submit_ioend+0x170/0x170 [xfs]
[25133.030027]  ? xfs_vm_writepages+0xba/0xf0 [xfs]
[25133.030031]  ? __writeback_single_inode+0x3d/0x330
[25133.030033]  ? writeback_sb_inodes+0x23d/0x470
[25133.030037]  ? __writeback_inodes_wb+0x87/0xb0
[25133.030039]  ? wb_writeback+0x28e/0x320
[25133.030042]  ? wb_workfn+0x2d2/0x3a0
[25133.030044]  ? wb_workfn+0x2d2/0x3a0
[25133.030047]  ? process_one_work+0x15e/0x420
[25133.030049]  ? worker_thread+0x65/0x4b0
[25133.030051]  ? rescuer_thread+0x390/0x390
[25133.030054]  ? kthread+0x104/0x140
[25133.030057]  ? kthread_park+0x80/0x80
[25133.030059]  ? do_group_exit+0x39/0xb0
[25133.030062]  ? ret_from_fork+0x26/0x40
[25133.030070] INFO: task rm:44141 blocked for more than 120 seconds.
[25133.030182]       Tainted: G            E   4.11.0-rc5-mw #1
[25133.030291] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[25133.030428] rm              D    0 44141  43912 0x00000000
[25133.030430] Call Trace:
[25133.030435]  ? __schedule+0x2e0/0x910
[25133.030472]  ? xfs_dir_open+0x59/0x70 [xfs]
[25133.030477]  ? schedule+0x32/0x80
[25133.030518]  ? xlog_grant_head_wait+0xca/0x200 [xfs]
[25133.030557]  ? xlog_grant_head_check+0x9a/0x110 [xfs]
[25133.030597]  ? xfs_log_reserve+0xd4/0x1f0 [xfs]
[25133.030635]  ? xfs_trans_reserve+0x182/0x1f0 [xfs]
[25133.030671]  ? xfs_trans_alloc+0xb4/0x130 [xfs]
[25133.030711]  ? xfs_remove+0x13d/0x310 [xfs]
[25133.030751]  ? xfs_vn_unlink+0x55/0xa0 [xfs]
[25133.030755]  ? vfs_rmdir+0xac/0x120
[25133.030758]  ? do_rmdir+0x1c9/0x1e0
[25133.030761]  ? entry_SYSCALL_64_fastpath+0x1e/0xad

