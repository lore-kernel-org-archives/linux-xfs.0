Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 21:09:04 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9R48sKW007373
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 21:08:54 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id 4B2448F8125
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 21:08:48 -0700 (PDT)
Message-ID: <490527E2.5000600@sgi.com>
Date: Mon, 27 Oct 2008 13:30:58 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: deadlock with latest xfs
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org> <49013C47.4090601@sgi.com> <20081026223940.GN18495@disturbed>
In-Reply-To: <20081026223940.GN18495@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> Ok, I think I've found the regression - it's introduced by the AIL
> cursor modifications. The patch below has been running for 15
> minutes now on my UML box that would have hung in a couple of
> minutes otherwise.
> 
> FYI, the way I found this was:
> 
> 	- put a breakpoint on xfs_create() once the fs hung
> 	- `touch /mnt/xfs2/fred` to trigger the break point.
> 	- look at:
> 		- mp->m_ail->xa_target
> 		- mp->m_ail->xa_ail.next->li_lsn
> 		- mp->m_log->l_tail_lsn
> 	  which indicated the push target was way ahead the
> 	  tail of the log, so AIL pushing was obviously not
> 	  happening otherwise we'd be making progress.
> 	- added breakpoint on xfsaild_push() and continued
> 	- xfsaild_push() bp triggered, looked at *last_lsn
> 	  and found it way behind the tail of the log (like
> 	  3 cycle behind), which meant that would return
> 	  NULL instead of the first object and AIL pushing
> 	  would abort. Confirmed with single stepping.
> 
> Cheers,
> 
> Dave.
> XFS: correctly select first log item to push
> 
> Under heavy metadata load we are seeing log hangs. The
> AIL has items in it ready to be pushed, and they are within
> the push target window. However, we are not pushing them
> when the last pushed LSN is less than the LSN of the
> first log item on the AIL. This is a regression introduced
> by the AIL push cursor modifications.
> ---
>  fs/xfs/xfs_trans_ail.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 67ee466..2d47f10 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -228,7 +228,7 @@ xfs_trans_ail_cursor_first(
>  
>  	list_for_each_entry(lip, &ailp->xa_ail, li_ail) {
>  		if (XFS_LSN_CMP(lip->li_lsn, lsn) >= 0)
> -			break;
> +			goto out;
>  	}
>  	lip = NULL;
>  out:

Yeah, the fix looks good. The previous code is pretty
obviously broken - a search which always returns NULL.

Which begs the question on the best way of testing this ail code.
I dunno - it would be nice for independent testing of data structures
but perhaps that is too ambitious.

OOC, so the call path for this code....
xfsaild -> xfsaild_push(ailp, &last_pushed_lsn)
           -> lip = xfs_trans_ail_cursor_first(ailp, cur, *last_lsn)
Initially, last_lsn = 0 in xfsaild
but it will be updated via last_pushed_lsn.
So it looks like things will work initially when lsn==0, because
xfs_trans_ail_cursor_first special cases that and uses the min.
But as soon as the lsn is set to non-zero,
xfs_trans_ail_cursor_first will return NULL,
and xfsaild_push will return early.

--Tim
