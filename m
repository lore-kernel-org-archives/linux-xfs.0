Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC7D57CBF
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 01:01:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD0778F8033
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 23:01:25 -0700 (PDT)
Received: from mail-qa0-f44.google.com (mail-qa0-f44.google.com
	[209.85.216.44]) by cuda.sgi.com with ESMTP id YcTLDtrhrUo0xuj0
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Jul 2013 23:01:24 -0700 (PDT)
Received: by mail-qa0-f44.google.com with SMTP id hu16so229787qab.3
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 23:01:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130726020318.GD21982@dastard>
References: <1374759524-10061-1-git-send-email-zwu.kernel@gmail.com>
	<20130726020318.GD21982@dastard>
Date: Fri, 26 Jul 2013 14:01:23 +0800
Message-ID: <CAEH94LiXtG=DD+Qn4kbNT_Y_Qn65wVYrpYvHKXOob6wru3SeDw@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix an assertion failure
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>

No, it still raised the same assertion as below:

[  521.715103] XFS: Assertion failed: !(bip->bli_item.li_flags &
XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 940
[  521.716378] ------------[ cut here ]------------
[  521.716934] kernel BUG at fs/xfs/xfs_message.c:108!
[  521.717364] invalid opcode: 0000 [#1] SMP
[  521.717364] Modules linked in:
[  521.717364] CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.11.0-rc2+ #959
[  521.717364] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  521.717364] Workqueue: writeback bdi_writeback_workfn (flush-8:0)
[  521.717364] task: ffff880293531fd0 ti: ffff88029353c000 task.ti:
ffff88029353c000
[  521.717364] RIP: 0010:[<ffffffff812dc6f2>]  [<ffffffff812dc6f2>]
assfail+0x22/0x30
[  521.717364] RSP: 0018:ffff88029353d5f8  EFLAGS: 00010292
[  521.717364] RAX: 0000000000000068 RBX: ffff880289f603a0 RCX: 0000000000000006
[  521.717364] RDX: 0000000000000006 RSI: ffff880293532758 RDI: ffff880293531fd0
[  521.717364] RBP: ffff88029353d5f8 R08: 0000000000000000 R09: 0000000000000001
[  521.717364] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880291e4a480
[  521.717364] R13: ffff880289f603a0 R14: ffffffff81342b2f R15: ffff8801b43a0810
[  521.717364] FS:  0000000000000000(0000) GS:ffff88029fc00000(0000)
knlGS:0000000000000000
[  521.717364] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  521.717364] CR2: 00000000f75045e4 CR3: 000000029094c000 CR4: 00000000000006f0
[  521.717364] Stack:
[  521.717364]  ffff88029353d628 ffffffff813428df ffff880289f603a0
0000000000000002
[  521.717364]  ffff880291e4a480 0000000000000001 ffff88029353d668
ffffffff81342b2f
[  521.717364]  0000000000000000 ffff880289f603a0 ffff880276231fc0
ffffffffffffffff
[  521.717364] Call Trace:
[  521.717364]  [<ffffffff813428df>] xfs_buf_item_relse+0x4f/0xd0
[  521.717364]  [<ffffffff81342b2f>] xfs_buf_item_unlock+0x1cf/0x1f0
[  521.717364]  [<ffffffff8133ac3d>] xfs_trans_free_items+0x7d/0xb0
[  521.717364]  [<ffffffff8133b35c>] xfs_trans_cancel+0x13c/0x1b0
[  521.717364]  [<ffffffff812d8d89>] xfs_iomap_write_allocate+0x249/0x350
[  521.717364]  [<ffffffff812c6af2>] xfs_map_blocks+0x2e2/0x350
[  521.717364]  [<ffffffff812c7a76>] xfs_vm_writepage+0x236/0x5e0
[  521.717364]  [<ffffffff8115174a>] __writepage+0x1a/0x50
[  521.717364]  [<ffffffff81152065>] write_cache_pages+0x225/0x4a0
[  521.717364]  [<ffffffff81151730>] ? mapping_tagged+0x20/0x20
[  521.717364]  [<ffffffff8115232d>] generic_writepages+0x4d/0x70
[  521.717364]  [<ffffffff812c5e60>] xfs_vm_writepages+0x50/0x70
[  521.717364]  [<ffffffff81153cb1>] do_writepages+0x21/0x50
[  521.717364]  [<ffffffff811d4050>] __writeback_single_inode+0x40/0x230
[  521.717364]  [<ffffffff811d52b1>] writeback_sb_inodes+0x291/0x460
[  521.717364]  [<ffffffff811d551f>] __writeback_inodes_wb+0x9f/0xd0
[  521.717364]  [<ffffffff811d579b>] wb_writeback+0x24b/0x2e0
[  521.717364]  [<ffffffff8115185a>] ? global_dirtyable_memory+0x1a/0x60
[  521.717364]  [<ffffffff811d7386>] bdi_writeback_workfn+0x1d6/0x3d0
[  521.717364]  [<ffffffff8107734b>] process_one_work+0x1eb/0x4f0
[  521.717364]  [<ffffffff810772e9>] ? process_one_work+0x189/0x4f0
[  521.717364]  [<ffffffff81077adb>] worker_thread+0x11b/0x370
[  521.717364]  [<ffffffff810779c0>] ? rescuer_thread+0x330/0x330
[  521.717364]  [<ffffffff8107ff8a>] kthread+0xea/0xf0
[  521.717364]  [<ffffffff8107fea0>] ? flush_kthread_work+0x1b0/0x1b0
[  521.717364]  [<ffffffff818b6adc>] ret_from_fork+0x7c/0xb0
[  521.717364]  [<ffffffff8107fea0>] ? flush_kthread_work+0x1b0/0x1b0
[  521.717364] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
89 f1 41 89 d0 48 c7 c6 f0 b5 c7 81 48 89 fa 31 c0 48 89 e5 31 ff e8
de fb ff ff <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
55 48
[  521.717364] RIP  [<ffffffff812dc6f2>] assfail+0x22/0x30
[  521.717364]  RSP <ffff88029353d5f8>
[  521.754783] ---[ end trace e13298ca69cdb092 ]---

I applied your patch as below:

[root@f17 linux-2.6]# git diff
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index bfc4e0c..98308f4 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -601,11 +601,9 @@ xfs_buf_item_unlock(
                        }
                }
        }
-       if (clean)
-               xfs_buf_item_relse(bp);
-       else if (aborted) {
+       if (clean || aborted) {
                if (atomic_dec_and_test(&bip->bli_refcount)) {
-                       ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
+                       ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
                        xfs_buf_item_relse(bp);
                }
        } else
[root@f17 linux-2.6]#

On Fri, Jul 26, 2013 at 10:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jul 25, 2013 at 09:38:44PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   When running the compilebench, one assertion failure was found.
>> This related line of code was introduced by commit 5f6bed76c0.
>>
>> commit 5f6bed76c0c85cb4d04885a5de00b629deee550b
>> Author: Dave Chinner <david@fromorbit.com>
>> Date:   Thu Jun 27 16:04:52 2013 +1000
>>
>>     xfs: Introduce an ordered buffer item
>
> Ok, so the assert was introduced there, and for good reason: if we
> are about to free the xfs_buf_log_item, then it better not still be
> referenced by the AIL.
>
>> XFS: Assertion failed: !(bip->bli_item.li_flags & XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 942
>> ------------[ cut here ]------------
>> kernel BUG at fs/xfs/xfs_message.c:108!
>> invalid opcode: 0000 [#1] SMP
>> Modules linked in:
>> CPU: 0 PID: 40 Comm: kworker/u2:1 Not tainted 3.11.0-rc2+ #955
>> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>> Workqueue: writeback bdi_writeback_workfn (flush-8:0)
> ....
>>  [<ffffffff813428df>] xfs_buf_item_relse+0x4f/0xd0
>>  [<ffffffff81342aeb>] xfs_buf_item_unlock+0x18b/0x1e0
>>  [<ffffffff8133ac3d>] xfs_trans_free_items+0x7d/0xb0
>>  [<ffffffff8133b35c>] xfs_trans_cancel+0x13c/0x1b0
>>  [<ffffffff812d8d89>] xfs_iomap_write_allocate+0x249/0x350
>>  [<ffffffff812c6af2>] xfs_map_blocks+0x2e2/0x350
>>  [<ffffffff812c7a76>] xfs_vm_writepage+0x236/0x5e0
>
> And what we see here is a buffer item being released and freed after
> a cancelled allocation transaction while it is in the AIL. That's
> indicative of a bug in the buffer item code, and will cause
> user-after-free issues. Hence:
>
>> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
>> index bfc4e0c..b4d42ae 100644
>> --- a/fs/xfs/xfs_buf_item.c
>> +++ b/fs/xfs/xfs_buf_item.c
>> @@ -939,7 +939,6 @@ xfs_buf_item_relse(
>>       xfs_buf_log_item_t      *bip = bp->b_fspriv;
>>
>>       trace_xfs_buf_item_relse(bp, _RET_IP_);
>> -     ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
>
> Removing the assert is not going to fix the bug that it is telling
> us is ocurring.
>
> Indeed, it points out that the calling code - xfs_buf_item_unlock()
> - is probably doing the wrong this. i.e. that it assumes that a
> clean buffer item is only referenced in this transaction and so it
> can unconditionally free it. That's an invalid assumption, and
> exactly the situation that the above assert was designed to catch.
>
> Can you try the patch below? It should fix the problem....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> xfs: use reference counts to free clean buffer items
>
> From: Dave Chinner <dchinner@redhat.com>
>
> When a transaction is cancelled and the buffer log item is clean in
> the transaction, the buffer log item is unconditionally freed. If
> the log item is in the AIL, however, this leads to a use after free
> condition as the item still has other users.
>
> In this case, xfs_buf_item_relse() should only be called on clean
> buffer items if the reference count has dropped to zero. This
> ensures only the last user frees the item.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 9358504..3a944b1 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -613,11 +613,9 @@ xfs_buf_item_unlock(
>                         }
>                 }
>         }
> -       if (clean)
> -               xfs_buf_item_relse(bp);
> -       else if (aborted) {
> +       if (clean || aborted) {
>                 if (atomic_dec_and_test(&bip->bli_refcount)) {
> -                       ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
> +                       ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
>                         xfs_buf_item_relse(bp);
>                 }
>         } else



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
