Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4E837F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 03:17:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B8B3AC004
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 01:17:32 -0700 (PDT)
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]) by cuda.sgi.com with
	ESMTP id 7TLGsILQx8rDyLts (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 01:17:29 -0700 (PDT)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 5EF3B3EE1C2
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 17:17:28 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 5269345DEFB
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 17:17:28 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 397C545DEF9
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 17:17:28 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 20E141DB803C
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 17:17:28 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
	(g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 90D751DB8041
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 17:17:27 +0900 (JST)
Message-ID: <53708354.2060103@jp.fujitsu.com>
Date: Mon, 12 May 2014 17:16:20 +0900
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
MIME-Version: 1.0
Subject: xfs: processes are stuck at xlog_grant_head_wait()
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, esandeen@redhat.com

Hi all,

Processes are stuck at xlog_grant_head_wait() when I ran a heavy stress
test (xfstests, ltpstress and fsstress concurrently) on linux-next
(3.15.0-rc4-next-20140506) kernel.
I got the crash dump, then I think this problem is similar as a problem
fixed by the following commit. 

-------------------------------------------------
commit 2c6e24ce1aa6b3b147c75d488c2797ee258eb22b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 15 09:17:49 2013 +1100

    xfs: prevent deadlock trying to cover an active log
-------------------------------------------------

2c6e24ce1 is already applied to the kernel, so I don't know why this problem
is occurred...

The information through crash dump is as follows.
The backtrace of stuck processes are such as the following, so
they are waiting for more log space.

PID: 24009  TASK: ffff8800035d4420  CPU: 4   COMMAND: "fsstress"
 #0 [ffff880004aefb28] __schedule at ffffffff816395c5
 #1 [ffff880004aefb90] schedule at ffffffff81639ac9
 #2 [ffff880004aefba0] xlog_grant_head_wait at ffffffffa023585d [xfs]
 #3 [ffff880004aefbf0] xlog_grant_head_check at ffffffffa02359de [xfs]
 #4 [ffff880004aefc30] xfs_log_reserve at ffffffffa023935f [xfs]
 #5 [ffff880004aefc68] xfs_trans_reserve at ffffffffa01f1114 [xfs]
 #6 [ffff880004aefcb0] xfs_vn_update_time at ffffffffa01e70b6 [xfs]
 #7 [ffff880004aefcf0] update_time at ffffffff811f4f05
 #8 [ffff880004aefd20] file_update_time at ffffffff811f51b0
 #9 [ffff880004aefd60] xfs_file_aio_write_checks at ffffffffa01de7bb [xfs]
#10 [ffff880004aefda8] xfs_file_dio_aio_write at ffffffffa024a03b [xfs]
#11 [ffff880004aefe10] xfs_file_write_iter at ffffffffa01deacc [xfs]
#12 [ffff880004aefe40] new_sync_write at ffffffff811d975e
#13 [ffff880004aefef8] vfs_write at ffffffff811d9f87
#14 [ffff880004aeff38] sys_write at ffffffff811daba5
#15 [ffff880004aeff80] system_call_fastpath at ffffffff8163dd59
    RIP: 00007f5fecd40c70  RSP: 00007ffff5ba9ad8  RFLAGS: 00010246
    RAX: 0000000000000001  RBX: ffffffff8163dd59  RCX: 0000000000000000
    RDX: 000000000000e000  RSI: 00007f5fe8001000  RDI: 0000000000000003
    RBP: 0000000000000003   R8: 0000000000000000   R9: 0000000000100000
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000000
    R13: 000000000007d000  R14: 000000000000e000  R15: 0000000000000026
    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

In addition, kworker which related to XFS are also stuck because
of the same reason. Therefore, I think no one can free the log space...

PID: 306    TASK: ffff8800145751c0  CPU: 6   COMMAND: "kworker/u16:3"
 #0 [ffff88003385d798] __schedule at ffffffff816395c5
 #1 [ffff88003385d800] schedule at ffffffff81639ac9
 #2 [ffff88003385d810] xlog_grant_head_wait at ffffffffa023585d [xfs]
 #3 [ffff88003385d860] xlog_grant_head_check at ffffffffa02359de [xfs]
 #4 [ffff88003385d8a0] xfs_log_reserve at ffffffffa023935f [xfs]
 #5 [ffff88003385d8d8] xfs_trans_reserve at ffffffffa01f1114 [xfs]
 #6 [ffff88003385d920] xfs_setfilesize_trans_alloc at ffffffffa01d1ff0 [xfs]
 #7 [ffff88003385d950] xfs_vm_writepage at ffffffffa01d30b1 [xfs]
 #8 [ffff88003385da08] __writepage at ffffffff8116f483
 #9 [ffff88003385da20] write_cache_pages at ffffffff8116fe55
#10 [ffff88003385db38] generic_writepages at ffffffff8117010d
#11 [ffff88003385db98] xfs_vm_writepages at ffffffffa01d2873 [xfs]
#12 [ffff88003385dbc8] do_writepages at ffffffff8117138e
#13 [ffff88003385dbd8] __writeback_single_inode at ffffffff81202da0
#14 [ffff88003385dc18] writeback_sb_inodes at ffffffff8120380a
#15 [ffff88003385dcb0] __writeback_inodes_wb at ffffffff81203a5f
#16 [ffff88003385dcf8] wb_writeback at ffffffff812042d3
#17 [ffff88003385dd70] bdi_writeback_workfn at ffffffff8120687c
#18 [ffff88003385de20] process_one_work at ffffffff8108e78b
#19 [ffff88003385de68] worker_thread at ffffffff8108f5ab
#20 [ffff88003385dec8] kthread at ffffffff81096651
#21 [ffff88003385df50] ret_from_fork at ffffffff8163dcac

PID: 2032   TASK: ffff88000bb60da0  CPU: 5   COMMAND: "kworker/5:2"
 #0 [ffff8800000479d0] __schedule at ffffffff816395c5
 #1 [ffff880000047a38] schedule at ffffffff81639ac9
 #2 [ffff880000047a48] xlog_grant_head_wait at ffffffffa023585d [xfs]
 #3 [ffff880000047a98] xlog_grant_head_check at ffffffffa02359de [xfs]
 #4 [ffff880000047ad8] xfs_log_reserve at ffffffffa023935f [xfs]
 #5 [ffff880000047b10] xfs_trans_reserve at ffffffffa01f1114 [xfs]
 #6 [ffff880000047b58] xfs_free_eofblocks at ffffffffa01d6577 [xfs]
 #7 [ffff880000047bd0] xfs_inode_free_eofblocks at ffffffffa01e2b9a [xfs]
 #8 [ffff880000047bf8] xfs_inode_ag_walk at ffffffffa01e10ef [xfs]
 #9 [ffff880000047da0] xfs_inode_ag_iterator_tag at ffffffffa01e24b6 [xfs]
#10 [ffff880000047df8] xfs_icache_free_eofblocks at ffffffffa01e27dd [xfs]
#11 [ffff880000047e08] xfs_eofblocks_worker at ffffffffa01e280b [xfs]
#12 [ffff880000047e20] process_one_work at ffffffff8108e78b
#13 [ffff880000047e68] worker_thread at ffffffff8108f5ab
#14 [ffff880000047ec8] kthread at ffffffff81096651
#15 [ffff880000047f50] ret_from_fork at ffffffff8163dcac

PID: 9291   TASK: ffff880022a728e0  CPU: 3   COMMAND: "kworker/3:0"
 #0 [ffff880005101c60] __schedule at ffffffff816395c5
 #1 [ffff880005101cc8] schedule at ffffffff81639ac9
 #2 [ffff880005101cd8] xlog_grant_head_wait at ffffffffa023585d [xfs]
 #3 [ffff880005101d28] xlog_grant_head_check at ffffffffa02359de [xfs]
 #4 [ffff880005101d68] xfs_log_reserve at ffffffffa023935f [xfs]
 #5 [ffff880005101da0] xfs_trans_reserve at ffffffffa01f1114 [xfs]
 #6 [ffff880005101de8] xfs_fs_log_dummy at ffffffffa01e09f5 [xfs]
 #7 [ffff880005101e08] xfs_log_worker at ffffffffa0238bc8 [xfs]
 #8 [ffff880005101e20] process_one_work at ffffffff8108e78b
 #9 [ffff880005101e68] worker_thread at ffffffff8108f5ab
#10 [ffff880005101ec8] kthread at ffffffff81096651
#11 [ffff880005101f50] ret_from_fork at ffffffff8163dcac

Thanks,
Masayoshi Mizuma

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
