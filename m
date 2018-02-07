Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:53727 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754528AbeBGRUV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 12:20:21 -0500
Received: by mail-wm0-f46.google.com with SMTP id t74so4588701wme.3
        for <linux-xfs@vger.kernel.org>; Wed, 07 Feb 2018 09:20:21 -0800 (PST)
From: Avi Kivity <avi@scylladb.com>
Subject: xfs_buf_lock vs aio
Message-ID: <a0531d16-d872-548d-4821-273c072973e6@scylladb.com>
Date: Wed, 7 Feb 2018 19:20:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

As usual, I'm having my lovely io_submit()s sleeping. This time some 
detailed traces. 4.14.15.


kthreadd  8146 [013]  3580.418079:                xfs:xfs_ilock: dev 9:0 
ino 0x50000a9f flags ILOCK_EXCL caller kretprobe_trampoline
             7fffa0858572 xfs_ilock ([kernel.kallsyms])
             7fff8105f5a0 kretprobe_trampoline ([kernel.kallsyms])
             7fffa0849416 xfs_dio_write_end_io ([kernel.kallsyms])
             7fff812bc935 iomap_dio_complete ([kernel.kallsyms])
             7fff812bca17 iomap_dio_complete_work ([kernel.kallsyms])
             7fff8109dd19 process_one_work ([kernel.kallsyms])
             7fff8109e79d worker_thread ([kernel.kallsyms])
             7fff810a43b9 kthread ([kernel.kallsyms])
             7fff81802335 ret_from_fork ([kernel.kallsyms])


Here we have an I/O completion on some inode, taking ILOCK. So far so good.


kthreadd  8146 [013]  3580.418081:            xfs:xfs_ilock_ret: 
(ffffffffa08564e0 <- ffffffffa0853357)
             7fff8105f5a0 kretprobe_trampoline ([kernel.kallsyms])
             7fffa0849416 xfs_dio_write_end_io ([kernel.kallsyms])
             7fff812bc935 iomap_dio_complete ([kernel.kallsyms])
             7fff812bca17 iomap_dio_complete_work ([kernel.kallsyms])
             7fff8109dd19 process_one_work ([kernel.kallsyms])
             7fff8109e79d worker_thread ([kernel.kallsyms])
             7fff810a43b9 kthread ([kernel.kallsyms])
             7fff81802335 ret_from_fork ([kernel.kallsyms])


ILOCK taken without sleeping.


kthreadd  8146 [013]  3580.418103:           sched:sched_switch: 
kworker/13:3:8146 [120] D ==> kworker/13:0:8144 [120]
             7fff817dd0a5 __schedule ([kernel.kallsyms])
             7fff817dd5c6 schedule ([kernel.kallsyms])
             7fff817e1656 schedule_timeout ([kernel.kallsyms])
             7fff817de181 wait_for_completion ([kernel.kallsyms])
             7fff8109d51d flush_work ([kernel.kallsyms])
             7fffa086e29d xlog_cil_force_lsn ([kernel.kallsyms])
             7fffa086bfd6 _xfs_log_force ([kernel.kallsyms])
             7fffa086c1fc xfs_log_force ([kernel.kallsyms])
             7fffa08444d6 xfs_buf_lock ([kernel.kallsyms])
             7fffa084479b _xfs_buf_find ([kernel.kallsyms])
             7fffa0844a1a xfs_buf_get_map ([kernel.kallsyms])
             7fffa087b766 xfs_trans_get_buf_map ([kernel.kallsyms])
             7fffa0811c14 xfs_btree_get_bufl ([kernel.kallsyms])
             7fffa08024d2 xfs_bmap_extents_to_btree ([kernel.kallsyms])
             7fffa0805d68 xfs_bmap_add_extent_unwritten_real 
([kernel.kallsyms])
             7fffa0806a88 xfs_bmapi_convert_unwritten ([kernel.kallsyms])
             7fffa080c3e0 xfs_bmapi_write ([kernel.kallsyms])
             7fffa08553c9 xfs_iomap_write_unwritten ([kernel.kallsyms])
             7fffa0849416 xfs_dio_write_end_io ([kernel.kallsyms])
             7fff812bc935 iomap_dio_complete ([kernel.kallsyms])
             7fff812bca17 iomap_dio_complete_work ([kernel.kallsyms])
             7fff8109dd19 process_one_work ([kernel.kallsyms])
             7fff8109e79d worker_thread ([kernel.kallsyms])
             7fff810a43b9 kthread ([kernel.kallsyms])
             7fff81802335 ret_from_fork ([kernel.kallsyms])



Forcing the log, so sleeping with ILOCK taken.


reactor-29  3336 [029]  3580.420137: xfs:xfs_ilock: dev 9:0 ino 
0x50000a9f flags ILOCK_EXCL caller kretprobe_trampoline
             7fffa0858572 xfs_ilock ([kernel.kallsyms])
             7fff8105f5a0 kretprobe_trampoline ([kernel.kallsyms])
             7fff8127314c file_update_time ([kernel.kallsyms])
             7fffa0849ab9 xfs_file_aio_write_checks ([kernel.kallsyms])
             7fffa0849bce xfs_file_dio_aio_write ([kernel.kallsyms])
             7fffa084a13f xfs_file_write_iter ([kernel.kallsyms])
             7fff812ab24f aio_write ([kernel.kallsyms])
             7fff812ab90e do_io_submit ([kernel.kallsyms])
             7fff812ac4c0 sys_io_submit ([kernel.kallsyms])
             7fff81005917 do_syscall_64 ([kernel.kallsyms])
             7fff81802115 return_from_SYSCALL_64 ([kernel.kallsyms])
                      697 io_submit (/usr/lib64/libaio.so.1.0.1)
                       48 [unknown] ([unknown])
                   140e50 reactor_backend_epoll::~reactor_backend_epoll 
(/usr/bin/scylla)
         e90974ffff83087f [unknown] ([unknown])


io_submit(), same inode.


reactor-29  3336 [029]  3580.420141:           sched:sched_switch: 
reactor-29:3336 [120] D ==> swapper/29:0 [120]
             7fff817dd0a5 __schedule ([kernel.kallsyms])
             7fff817dd5c6 schedule ([kernel.kallsyms])
             7fff817e09bd rwsem_down_write_failed ([kernel.kallsyms])
             7fff817d29c7 call_rwsem_down_write_failed ([kernel.kallsyms])
             7fff817e00bd down_write ([kernel.kallsyms])
             7fffa08585b0 xfs_ilock ([kernel.kallsyms])
             7fff8105f5a0 kretprobe_trampoline ([kernel.kallsyms])
             7fff8127314c file_update_time ([kernel.kallsyms])
             7fffa0849ab9 xfs_file_aio_write_checks ([kernel.kallsyms])
             7fffa0849bce xfs_file_dio_aio_write ([kernel.kallsyms])
             7fffa084a13f xfs_file_write_iter ([kernel.kallsyms])
             7fff812ab24f aio_write ([kernel.kallsyms])
             7fff812ab90e do_io_submit ([kernel.kallsyms])
             7fff812ac4c0 sys_io_submit ([kernel.kallsyms])
             7fff81005917 do_syscall_64 ([kernel.kallsyms])
             7fff81802115 return_from_SYSCALL_64 ([kernel.kallsyms])
                      697 io_submit (/usr/lib64/libaio.so.1.0.1)
                       48 [unknown] ([unknown])
                   140e50 reactor_backend_epoll::~reactor_backend_epoll 
(/usr/bin/scylla)
         e90974ffff83087f [unknown] ([unknown])


io_submit() stalls. Later, task 8146 relinquishes the lock, which (after 
passing through another worker thread), is finally acquired by 
io_submit() which the continues.


I see to ways two fix this. One is to make sure that we don't need to 
force the log during completion. Is there something I can do to make 
this happen? More log space, less log space, magic mount option?


The other is to check that ILOCK can be taken exclusively in 
xfs_file_dio_aio_write, if IOCB_NOWAIT. If this is the way to go, I 
might venture a patch.



