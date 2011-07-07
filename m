Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67KTihJ193912 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 15:29:44 -0500
Subject: Re: [PATCH 2/5] xfs: use a cursor for bulk AIL insertion
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1309757260-5484-3-git-send-email-david@fromorbit.com>
References: <1309757260-5484-1-git-send-email-david@fromorbit.com>
	<1309757260-5484-3-git-send-email-david@fromorbit.com>
Date: Thu, 7 Jul 2011 15:29:40 -0500
Message-ID: <1310070580.1980.64.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-07-04 at 15:27 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Delayed logging can insert tens of thousands of log items into the
> AIL at the same LSN. When the committing of log commit records
> occur, we can get insertions occurring at an LSN that is not at the
> end of the AIL. If there are thousands of items in the AIL on the
> tail LSN, each insertion has to walk the AIL to find the correct
> place to insert the new item into the AIL. This can consume large
> amounts of CPU time and block other operations from occurring while
> the traversals are in progress.
> 
> To avoid this repeated walk, use a AIL cursor to record
> where we should be inserting the new items into the AIL without
> having to repeat the walk. The cursor infrastructure already
> provides this functionality for push walks, so is a simple extension
> of existing code. While this will not avoid the initial walk, it
> will avoid repeating it tens of thousands of times during a single
> checkpoint commit.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I agree with Christoph's comments about both eliminating
the do_init parameter in __xfs_trans_ail_cursor_last(),
and that there's no need for a loop in xfs_ail_splice().

I have some thoughts below, one of which points out what may
be a bug involving the use of list_for_each_entry_reverse().
Someone else should confirm it though.

> ---
>  fs/xfs/xfs_trans.c      |   27 +++++++++--
>  fs/xfs/xfs_trans_ail.c  |  122 +++++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_trans_priv.h |   10 +++-
>  3 files changed, 131 insertions(+), 28 deletions(-)
> 

. . .

> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 5fc2380..272e7fa 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c

. . .

> @@ -300,31 +300,110 @@ out:
>  }
>  
>  /*
> - * splice the log item list into the AIL at the given LSN.
> + * Initialise the cursor to the last item in the AIL with the given @lsn.

I think you should capture here that the cursor points to
the last entry with an lsn lower than the given one if
none with the given lsn is present in the list already.

> + * This searches the list from highest LSN to lowest.
>   */
> -static void
> -xfs_ail_splice(
> -	struct xfs_ail  *ailp,
> -	struct list_head *list,
> -	xfs_lsn_t       lsn)
> +static struct xfs_log_item *
> +__xfs_trans_ail_cursor_last(
> +	struct xfs_ail		*ailp,
> +	struct xfs_ail_cursor	*cur,
> +	xfs_lsn_t		lsn,
> +	bool			do_init)

. . .

> -	list_for_each_entry_reverse(next_lip, &ailp->xa_ail, li_ail) {
> -		if (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0)
> +	list_for_each_entry_reverse(lip, &ailp->xa_ail, li_ail) {
> +		if (XFS_LSN_CMP(lip->li_lsn, lsn) <= 0)
>  			break;
>  	}
> +out:
> +	if (cur)
> +		cur->item = lip;

I don't think it's safe to use the value of "lip" here.
I think if list_for_each_entry_reverse() terminates
because it has visited every entry on the list then
its "pos" parameter (lip in this case) does not have
a meaningful value.  The problem case is if the lsn
you are inserting is lower than any already in the AIL.
Can you guarantee that cannot happen?

If not, there doesn't seem to be a way to indicate
to the caller that the new entry belongs at the
beginning of the AIL--"after nothing."  A null
pointer means the list is empty, and maybe that
is in some sense no different from this case, I
don't know.

I haven't looked closely at the new xfs_ail_splice()
yet (below) so maybe this all "just works" but if
it does it may be fragile.

> +	return lip;
> +}
>  
> -	ASSERT(&next_lip->li_ail == &ailp->xa_ail ||
> -	       XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0);
> +/*

. . .

> +/*
> + * splice the log item list into the AIL at the given LSN. We splice to the
> + * tail of the given LSN to maintain insert order for push traversals. The
> + * cursor is optional, allowing repeated updates to the same LSN to avoid
> + * repeated traversals.

     ...  If supplied, the cursor must have been previously initialized.

> + */
> +static void
> +xfs_ail_splice(
> +	struct xfs_ail		*ailp,
> +	struct xfs_ail_cursor	*cur,
> +	struct list_head	*list,
> +	xfs_lsn_t		lsn)
> +{
> +	struct xfs_log_item	*lip = cur ? cur->item : NULL;
> +	struct xfs_log_item	*next_lip;
> +
> +	do {
> +		/* no placeholder, so get our insert location */
> +		if (!lip)
> +			lip = __xfs_trans_ail_cursor_last(ailp, cur,
> +								lsn, false);
> +
> +		if (!lip) {
> +			/*
> +			 * The list is empty, so just splice and return.  Our
> +			 * cursor is already guaranteed to be up to date, so we
> +			 * don't need to touch it here.
> +			 */
> +			list_splice(list, &ailp->xa_ail);
> +			return;
> +		}
> +
> +		/* The placeholder was invalidated, need to get a new cursor */
> +		if ((__psint_t)lip & 1)
> +			lip = NULL;
> +
> +	} while (lip == NULL);
> +
> +	/*
> +	 * Our cursor points to the item we want to insert _after_, so we have
> +	 * to update the cursor to point to the end of the list we are splicing
> +	 * in so that it points to the correct location for the next splice.
> +	 * i.e. before the splice
> +	 *
> +	 *  lsn -> lsn -> lsn + x -> lsn + x ...
> +	 *          ^
> +	 *          | cursor points here
> +	 *
> +	 * After the splice we have:
> +	 *
> +	 *  lsn -> lsn -> lsn -> lsn -> .... -> lsn -> lsn + x -> lsn + x ...
> +	 *          ^                            ^
> +	 *          | cursor points here         | needs to move here
> +	 *
> +	 * So we set the cursor to the last item in the list to be spliced
> +	 * before we execute the splice, resulting in the cursor pointing to
> +	 * the correct item after the splice occurs.
> +	 */
> +	if (cur) {
> +		next_lip = list_entry(list->prev, struct xfs_log_item, li_ail);
> +		cur->item = next_lip;
> +	}
> +	list_splice_init(list, &lip->li_ail);

I think simply list_splice() is sufficient here (and it was
before as well).  Either that or the empty list case above
should also call list_splice_init().

>  }
>  
>  /*

. . .

> @@ -111,10 +112,13 @@ xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
>  void			xfs_trans_unlocked_item(struct xfs_ail *,
>  					xfs_log_item_t *);
>  
> -struct xfs_log_item	*xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
> +struct xfs_log_item *	xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
>  					struct xfs_ail_cursor *cur,
>  					xfs_lsn_t lsn);
> -struct xfs_log_item	*xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
> +struct xfs_log_item *	xfs_trans_ail_cursor_last(struct xfs_ail *ailp,
> +					struct xfs_ail_cursor *cur,
> +					xfs_lsn_t lsn);
> +struct xfs_log_item *	xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
>  					struct xfs_ail_cursor *cur);
>  void			xfs_trans_ail_cursor_done(struct xfs_ail *ailp,
>  					struct xfs_ail_cursor *cur);

Curious about the formatting convention here.

I actually toyed with doing exactly this years ago in
my own code, but I seemed to be bucking convention too
much so I went back to the K&R way (I think that's
putting the star adjacent to the function/variable
name comes from).




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
