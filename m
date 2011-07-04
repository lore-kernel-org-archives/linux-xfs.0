Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p648G4ie124762 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 03:16:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE94D1EE788B
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 01:16:03 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	TSLseR7EuygtI3Pm for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 01:16:03 -0700 (PDT)
Date: Mon, 4 Jul 2011 04:16:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: remove confusing ail cursor wrapper
Message-ID: <20110704081603.GC22496@infradead.org>
References: <1309757260-5484-1-git-send-email-david@fromorbit.com>
	<1309757260-5484-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309757260-5484-4-git-send-email-david@fromorbit.com>
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

On Mon, Jul 04, 2011 at 03:27:38PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_trans_ail_cursor_set() doesn't set the cursor to the current log
> item, it sets it to the next item. There is already a function for
> doing this - xfs_trans_ail_cursor_next() - and the _set function is
> simply a two line wrapper.  Remove it and open code the setting of
> the cursor in the two locations that call it to remove the
> confusion.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_trans_ail.c |   38 ++++++++++++--------------------------
>  1 files changed, 12 insertions(+), 26 deletions(-)

> @@ -295,14 +283,11 @@ xfs_trans_ail_cursor_first(
>  	}
>  	lip = NULL;
>  out:
> -	xfs_trans_ail_cursor_set(ailp, cur, lip);
> +	if (lip)
> +		cur->item = xfs_ail_next(ailp, lip);
>  	return lip;

The lip = NULL above could nbe turned into a direct return NULL;

Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
