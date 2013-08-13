Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6178E7F98
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:46:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EFC0AAC004
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 14:46:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Yq3jafQGGo1G0ak9 for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 14:46:53 -0700 (PDT)
Date: Wed, 14 Aug 2013 07:46:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 50/50] xfs: use reference counts to free clean buffer items
Message-ID: <20130813214648.GC6023@dastard>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<1376304611-22994-51-git-send-email-david@fromorbit.com>
	<520A4AB7.1080207@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520A4AB7.1080207@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 13, 2013 at 10:03:19AM -0500, Mark Tinguely wrote:
> On 08/12/13 05:50, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >When a transaction is cancelled and the buffer log item is clean in
> >the transaction, the buffer log item is unconditionally freed. If
> >the log item is in the AIL, however, this leads to a use after free
> >condition as the item still has other users.
> >
> >In this case, xfs_buf_item_relse() should only be called on clean
> >buffer items if the reference count has dropped to zero. This
> >ensures only the last user frees the item.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> >  fs/xfs/xfs_buf_item.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> >diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> >index 9358504..3a944b1 100644
> >--- a/fs/xfs/xfs_buf_item.c
> >+++ b/fs/xfs/xfs_buf_item.c
> >@@ -613,11 +613,9 @@ xfs_buf_item_unlock(
> >  			}
> >  		}
> >  	}
> >-	if (clean)
> >-		xfs_buf_item_relse(bp);
> >-	else if (aborted) {
> >+	if (clean || aborted) {
> >  		if (atomic_dec_and_test(&bip->bli_refcount)) {
> >-			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
> >+			ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
> >  			xfs_buf_item_relse(bp);
> >  		}
> >  	} else
> 
> why is a clean buffer on the AIL? Racing with a completion handler?

"clean" means that it wasn't dirtied in the transaction - it can be
in the AIL and holding a reference count that way.

> rather than this:
> 
> 	if (clean || aborted) {
> 		if (atomic_dec_and_test(&bip->bli_refcount)) {
> 			ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
> 			xfs_buf_item_relse(bp);
> 		}
> 	} else
> 		atomic_dec(&bip->bli_refcount);
> 
> why not fold it into this:
> 
> 	if (atomic_dec_and_test(&bip->bli_refcount)) {
> 		ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
> 		xfs_buf_item_relse(bp);
> 	}

Basically, the code as it stands documents the different exit
conditions of a transaction commit. If the item was logged, we
expect it to continue existing and something else will free it.  If
we change it, we lose awareness that there are different exit
criteria, and it risks introducing a use after free if there is ever
a race condition w.r.t. unpinning the item in an async CIL commit.

I'm not saying that there is a problem here, just that the code as
it stands will not free the item in this case. The stale buffer
handling has similar requirements (i.e. decrement without freeing so
the unpin on log IO completion will free it) and there's a comment in
xfs_log_commit_cil() related to avoiding such race conditions.

So I'd prefer to leave it as it stands...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
