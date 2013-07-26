Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 349F87F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 21:03:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B736EAC004
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 19:03:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KcloodOCOBHFP5Z0 for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 19:03:49 -0700 (PDT)
Date: Fri, 26 Jul 2013 12:03:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix an assertion failure
Message-ID: <20130726020318.GD21982@dastard>
References: <1374759524-10061-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374759524-10061-1-git-send-email-zwu.kernel@gmail.com>
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
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 25, 2013 at 09:38:44PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   When running the compilebench, one assertion failure was found.
> This related line of code was introduced by commit 5f6bed76c0.
> 
> commit 5f6bed76c0c85cb4d04885a5de00b629deee550b
> Author: Dave Chinner <david@fromorbit.com>
> Date:   Thu Jun 27 16:04:52 2013 +1000
> 
>     xfs: Introduce an ordered buffer item

Ok, so the assert was introduced there, and for good reason: if we
are about to free the xfs_buf_log_item, then it better not still be
referenced by the AIL.

> XFS: Assertion failed: !(bip->bli_item.li_flags & XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 942
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/xfs_message.c:108!
> invalid opcode: 0000 [#1] SMP
> Modules linked in:
> CPU: 0 PID: 40 Comm: kworker/u2:1 Not tainted 3.11.0-rc2+ #955
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Workqueue: writeback bdi_writeback_workfn (flush-8:0)
....
>  [<ffffffff813428df>] xfs_buf_item_relse+0x4f/0xd0
>  [<ffffffff81342aeb>] xfs_buf_item_unlock+0x18b/0x1e0
>  [<ffffffff8133ac3d>] xfs_trans_free_items+0x7d/0xb0
>  [<ffffffff8133b35c>] xfs_trans_cancel+0x13c/0x1b0
>  [<ffffffff812d8d89>] xfs_iomap_write_allocate+0x249/0x350
>  [<ffffffff812c6af2>] xfs_map_blocks+0x2e2/0x350
>  [<ffffffff812c7a76>] xfs_vm_writepage+0x236/0x5e0

And what we see here is a buffer item being released and freed after
a cancelled allocation transaction while it is in the AIL. That's
indicative of a bug in the buffer item code, and will cause
user-after-free issues. Hence:

> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index bfc4e0c..b4d42ae 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -939,7 +939,6 @@ xfs_buf_item_relse(
>  	xfs_buf_log_item_t	*bip = bp->b_fspriv;
>  
>  	trace_xfs_buf_item_relse(bp, _RET_IP_);
> -	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));

Removing the assert is not going to fix the bug that it is telling
us is ocurring.

Indeed, it points out that the calling code - xfs_buf_item_unlock()
- is probably doing the wrong this. i.e. that it assumes that a
clean buffer item is only referenced in this transaction and so it
can unconditionally free it. That's an invalid assumption, and
exactly the situation that the above assert was designed to catch.

Can you try the patch below? It should fix the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: use reference counts to free clean buffer items

From: Dave Chinner <dchinner@redhat.com>

When a transaction is cancelled and the buffer log item is clean in
the transaction, the buffer log item is unconditionally freed. If
the log item is in the AIL, however, this leads to a use after free
condition as the item still has other users.

In this case, xfs_buf_item_relse() should only be called on clean
buffer items if the reference count has dropped to zero. This
ensures only the last user frees the item.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9358504..3a944b1 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -613,11 +613,9 @@ xfs_buf_item_unlock(
 			}
 		}
 	}
-	if (clean)
-		xfs_buf_item_relse(bp);
-	else if (aborted) {
+	if (clean || aborted) {
 		if (atomic_dec_and_test(&bip->bli_refcount)) {
-			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
+			ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
 			xfs_buf_item_relse(bp);
 		}
 	} else

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
