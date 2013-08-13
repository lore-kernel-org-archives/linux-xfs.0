Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D0B37F54
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 10:03:23 -0500 (CDT)
Message-ID: <520A4AB7.1080207@sgi.com>
Date: Tue, 13 Aug 2013 10:03:19 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 50/50] xfs: use reference counts to free clean buffer items
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<1376304611-22994-51-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-51-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/12/13 05:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
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
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_buf_item.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 9358504..3a944b1 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -613,11 +613,9 @@ xfs_buf_item_unlock(
>   			}
>   		}
>   	}
> -	if (clean)
> -		xfs_buf_item_relse(bp);
> -	else if (aborted) {
> +	if (clean || aborted) {
>   		if (atomic_dec_and_test(&bip->bli_refcount)) {
> -			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
> +			ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
>   			xfs_buf_item_relse(bp);
>   		}
>   	} else

why is a clean buffer on the AIL? Racing with a completion handler?

rather than this:

	if (clean || aborted) {
		if (atomic_dec_and_test(&bip->bli_refcount)) {
			ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
			xfs_buf_item_relse(bp);
		}
	} else
		atomic_dec(&bip->bli_refcount);

why not fold it into this:

	if (atomic_dec_and_test(&bip->bli_refcount)) {
		ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
		xfs_buf_item_relse(bp);
	}

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
