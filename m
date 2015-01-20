Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6A307F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 17:13:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 440F5AC010
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 15:13:02 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HEZohxKj2LFfuS7n for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 15:13:00 -0800 (PST)
Date: Wed, 21 Jan 2015 10:05:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug in AGI buffer logging?
Message-ID: <20150120230555.GG16552@dastard>
References: <20150120222658.GA6521@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150120222658.GA6521@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Tue, Jan 20, 2015 at 11:26:58PM +0100, Jan Kara wrote:
>   Hello,
> 
>   so I was trying to track down occasional reports like:
> [  +0.007156] XFS (md0): Mounting V5 Filesystem
> [  +0.200782] XFS (md0): Starting recovery (logdev: internal)
> [  +0.125313] XFS (md0): Unknown buffer type 0!
> [  +0.042793] XFS (md0): _xfs_buf_ioapply: no ops on block 0xaea8802/0x1
> [  +0.000145] ffff8800ffc53800: 58 41 47 49 00 00 00 01 00 00 00 02 00 ae
> a8 80  XAGI............
> [  +0.000179] ffff8800ffc53810: 00 00 13 00 00 00 00 76 00 00 00 01 00 00
> 00 0e  .......v........
> [  +0.000179] ffff8800ffc53820: 00 01 f4 00 ff ff ff ff ff ff ff ff ff ff
> ff ff  ................
> [  +0.000178] ffff8800ffc53830: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff  ................
> ...
> 
> from our users with current kernels. What happens is that log contains AGI
> buffer but blf_flags is 0 so we don't know how to set the buffer operations
> during log recovery. After some experiments I've noticed that when we log
> agi_unlinked buckets e.g. in xfs_iunlink_remove(), we don't set buffer
> type. We just call
> 		xfs_trans_log_buf(tp, agibp, offset,
>                                   (offset + sizeof(xfs_agino_t) - 1));

That is probably a bug, but I'm not sure that's the instance of the
bug you're looking for.

That is, after we remove the inode from the AGI unlinked list, the
same transaction then frees the inode back to the free list. This
then results in the AGI buffer being re-read and modified to update
the free inode counter, which is then logged again via
xfs_ialloc_log_agi() which does:

	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGI_BUF);

and hence the AGI buffer in the transaction is correctly marked with
the AGI type by the time it is committed and formatted.

xfs_iunlink(), OTOH, doesn't modify the AGI in any other way, so it
probably the cause of the problem.

> and thus buffer may be logged without blf_flags set appropriately. Am I
> missing something or is that code really buggy? If it's really a bug I can
> try to fix that but I'd think that it would require somewhat larger changes
> so that similar bugs are avoided in future so I'm asking first before
> investing significant amount of time into it.

The way to avoid such bugs in the future is to add an ASSERT to
xfs_buf_item_format() to check that the type is in range, such as
the patch I've included below.

[   50.128479] fill (5284) used greatest stack depth: 11408 bytes left
[   51.458331] XFS: Assertion failed: xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF, file: fs/xfs/xfs_buf_item.c, line: 322
[   51.460347] ------------[ cut here ]------------
[   51.461067] kernel BUG at fs/xfs/xfs_message.c:106!
....
[   51.464316] Call Trace:
[   51.464316]  [<ffffffff81543775>] xfs_buf_item_format+0x95/0x5f0
[   51.464316]  [<ffffffff8153c6b7>] ? kmem_alloc+0x77/0xf0
[   51.464316]  [<ffffffff81542ded>] xfs_log_commit_cil+0x42d/0x580
[   51.464316]  [<ffffffff8153be57>] xfs_trans_commit+0xb7/0x260
[   51.464316]  [<ffffffff8151637d>] xfs_bmap_finish+0xcd/0x1b0
[   51.464316]  [<ffffffff81530271>] xfs_inactive_ifree+0x1e1/0x250
[   51.464316]  [<ffffffff81530412>] xfs_inactive+0x132/0x1f0
[   51.464316]  [<ffffffff81536d76>] xfs_fs_evict_inode+0xa6/0x100
[   51.464316]  [<ffffffff81200f28>] evict+0xb8/0x190
[   51.464316]  [<ffffffff81201865>] iput+0xf5/0x180
[   51.464316]  [<ffffffff811f5060>] do_unlinkat+0x1d0/0x300
[   51.464316]  [<ffffffff81e00515>] ? sysret_check+0x22/0x5d
[   51.464316]  [<ffffffff810e965d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[   51.464316]  [<ffffffff8182463b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   51.464316]  [<ffffffff811f61cb>] SyS_unlinkat+0x1b/0x40
[   51.464316]  [<ffffffff81e004e9>] system_call_fastpath+0x12/0x17
[   51.464316] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 89 e5 48 89 fa 48 c7 c6 b8 2a 27 82 31 ff 31 c0 e8 de fb ff ff <0f> 0b 66 66 66 

I'll follow this up with a set of patches that fix all the asserts
I trigger with this check.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: ensure buffer types are set correctly.

From: Dave Chinner <dchinner@redhat.com>

Jan Kara reported that log recovery was finding buffers with invalid
types in them. This should not happen, and indicates a bug in the
logging of buffers. To catch this, add asserts to the buffer
formatting code to ensure that the buffer type is in range when the
transaction is committed.

Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 925ead2..46144e2 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -319,6 +319,9 @@ xfs_buf_item_format(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
+	ASSERT(xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF);
+	ASSERT(xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF);
+
 
 	/*
 	 * If it is an inode buffer, transfer the in-memory state to the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
