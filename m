Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39679C3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 07:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AD77246A1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 07:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgCBHrc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 02:47:32 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55318 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgCBHrc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 02:47:32 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 56A343A20B1;
        Mon,  2 Mar 2020 18:47:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j8fnU-0007aB-7P; Mon, 02 Mar 2020 18:47:28 +1100
Date:   Mon, 2 Mar 2020 18:47:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 7/9] xfs: buffer relogging support prototype
Message-ID: <20200302074728.GM10776@dread.disaster.area>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227134321.7238-8-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=q4cYGwKqrz1c7mKgUL4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 08:43:19AM -0500, Brian Foster wrote:
> Add a quick and dirty implementation of buffer relogging support.
> There is currently no use case for buffer relogging. This is for
> experimental use only and serves as an example to demonstrate the
> ability to relog arbitrary items in the future, if necessary.
> 
> Add a hook to enable relogging a buffer in a transaction, update the
> buffer log item handlers to support relogged BLIs and update the
> relog handler to join the relogged buffer to the relog transaction.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
.....
>  /*
> @@ -187,9 +188,21 @@ xfs_ail_relog(
>  			xfs_log_ticket_put(ailp->ail_relog_tic);
>  		spin_unlock(&ailp->ail_lock);
>  
> -		xfs_trans_add_item(tp, lip);
> -		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> -		tp->t_flags |= XFS_TRANS_DIRTY;
> +		/*
> +		 * TODO: Ideally, relog transaction management would be pushed
> +		 * down into the ->iop_push() callbacks rather than playing
> +		 * games with ->li_trans and looking at log item types here.
> +		 */
> +		if (lip->li_type == XFS_LI_BUF) {
> +			struct xfs_buf_log_item	*bli = (struct xfs_buf_log_item *) lip;
> +			xfs_buf_hold(bli->bli_buf);

What is this for? The bli already has a reference to the buffer.

> +			xfs_trans_bjoin(tp, bli->bli_buf);
> +			xfs_trans_dirty_buf(tp, bli->bli_buf);
> +		} else {
> +			xfs_trans_add_item(tp, lip);
> +			set_bit(XFS_LI_DIRTY, &lip->li_flags);
> +			tp->t_flags |= XFS_TRANS_DIRTY;
> +		}

Really, this should be a xfs_item_ops callout. i.e.

		lip->li_ops->iop_relog(lip);

And then a) it doesn't matter really where we call it from, and b)
it becomes fully generic and we can implement the callout
as future functionality requires.

However, we have to make sure that the current transaction we are
running has the correct space usage accounted to it, so I think this
callout really does need to be done in a tight loop iterating and
accounting all the relog items into the transaction without outside
interference.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
