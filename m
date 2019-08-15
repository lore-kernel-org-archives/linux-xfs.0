Return-Path: <SRS0=AwRW=WL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55514C3A589
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 23:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A87B2064A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 23:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfHOXhm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Aug 2019 19:37:42 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35686 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725440AbfHOXhm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 19:37:42 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3F99643DC0B;
        Fri, 16 Aug 2019 09:37:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hyPIE-0007OW-Vz; Fri, 16 Aug 2019 09:36:30 +1000
Date:   Fri, 16 Aug 2019 09:36:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190815233630.GU6129@dread.disaster.area>
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=HWi-pe_5GEalEUxW92wA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 07:17:33PM +0800, kaixuxia wrote:
> In this patch we make the unlinked list removal a deferred operation,
> i.e. log an iunlink remove intent and then do it after the RENAME_WHITEOUT
> transaction has committed, and the iunlink remove intention and done
> log items are provided.

I really like the idea of doing this, not just for the inode unlink
list removal, but for all the high level complex metadata
modifications such as create, unlink, etc.

The reason I like this is that it moves use closer to being able to
do operations almost completely asynchronously once the first intent
has been logged.

Once we have committed the intent, we can treat the rest of the
operation like recovery - all the information needed to perform the
operation is in the intenti and all the objects that need to be
locked across the entire operation are locked and joined to the
defer structure. If the intent hits the log the we guarantee that it
will be completed atomically and in the correct sequence order.
Hence it doesn't matter once the intent is built and committed what
context actually completes the rest of the transaction.

If we have to do a sync transaction, because XFS_MOUNT_SYNC,
XFS_MOUNT_DIRSYNC, or there's a sync flag on the inode(s), we can
add a waitqueue_head to the struct xfs_defer and have the context
issuing the transaction attach itself and wait for the defer ops to
complete and wake it....


.....

> @@ -3752,6 +3755,96 @@ struct xfs_buf_cancel {
>  }
> 
>  /*
> + * This routine is called to create an in-core iunlink remove intent
> + * item from the iri format structure which was logged on disk.
> + * It allocates an in-core iri, copies the inode from the format
> + * structure into it, and adds the iri to the AIL with the given
> + * LSN.
> + */
> +STATIC int
> +xlog_recover_iri_pass2(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	xfs_mount_t		*mp = log->l_mp;
> +	xfs_iri_log_item_t	*irip;
> +	xfs_iri_log_format_t	*iri_formatp;
> +
> +	iri_formatp = item->ri_buf[0].i_addr;
> +
> +	irip = xfs_iri_init(mp, 1);
> +	irip->iri_format = *iri_formatp;
> +	if (item->ri_buf[0].i_len != sizeof(xfs_iri_log_format_t)) {
> +		xfs_iri_item_free(irip);
> +		return EFSCORRUPTED;
> +	}
> +
> +	spin_lock(&log->l_ailp->ail_lock);
> +	/*
> +	 * The IRI has two references. One for the IRD and one for IRI to ensure
> +	 * it makes it into the AIL. Insert the IRI into the AIL directly and
> +	 * drop the IRI reference. Note that xfs_trans_ail_update() drops the
> +	 * AIL lock.
> +	 */
> +	xfs_trans_ail_update(log->l_ailp, &irip->iri_item, lsn);
> +	xfs_iri_release(irip);
> +	return 0;
> +}

These intent recovery functions all do very, very similar things.
We already have 4 copies of this almost identical code - I think
there needs to be some factoring/abstrcting done here rather than
continuing to copy/paste this code...

> @@ -3981,6 +4074,8 @@ struct xfs_buf_cancel {
>  	case XFS_LI_CUD:
>  	case XFS_LI_BUI:
>  	case XFS_LI_BUD:
> +	case XFS_LI_IRI:
> +	case XFS_LI_IRD:
>  	default:
>  		break;
>  	}
> @@ -4010,6 +4105,8 @@ struct xfs_buf_cancel {
>  	case XFS_LI_CUD:
>  	case XFS_LI_BUI:
>  	case XFS_LI_BUD:
> +	case XFS_LI_IRI:
> +	case XFS_LI_IRD:
>  		/* nothing to do in pass 1 */
>  		return 0;
>  	default:
> @@ -4052,6 +4149,10 @@ struct xfs_buf_cancel {
>  		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
>  	case XFS_LI_BUD:
>  		return xlog_recover_bud_pass2(log, item);
> +	case XFS_LI_IRI:
> +		return xlog_recover_iri_pass2(log, item, trans->r_lsn);
> +	case XFS_LI_IRD:
> +		return xlog_recover_ird_pass2(log, item);
>  	case XFS_LI_DQUOT:
>  		return xlog_recover_dquot_pass2(log, buffer_list, item,
>  						trans->r_lsn);

As can be seen by the increasing size of this table....

> @@ -4721,6 +4822,46 @@ struct xfs_buf_cancel {
>  	spin_lock(&ailp->ail_lock);
>  }
> 
> +/* Recover the IRI if necessary. */
> +STATIC int
> +xlog_recover_process_iri(
> +	struct xfs_trans		*parent_tp,
> +	struct xfs_ail			*ailp,
> +	struct xfs_log_item		*lip)
> +{
> +	struct xfs_iri_log_item		*irip;
> +	int				error;
> +
> +	/*
> +	 * Skip IRIs that we've already processed.
> +	 */
> +	irip = container_of(lip, struct xfs_iri_log_item, iri_item);
> +	if (test_bit(XFS_IRI_RECOVERED, &irip->iri_flags))
> +		return 0;
> +
> +	spin_unlock(&ailp->ail_lock);
> +	error = xfs_iri_recover(parent_tp, irip);
> +	spin_lock(&ailp->ail_lock);
> +
> +	return error;
> +}
> +
> +/* Release the IRI since we're cancelling everything. */
> +STATIC void
> +xlog_recover_cancel_iri(
> +	struct xfs_mount		*mp,
> +	struct xfs_ail			*ailp,
> +	struct xfs_log_item		*lip)
> +{
> +	struct xfs_iri_log_item         *irip;
> +
> +	irip = container_of(lip, struct xfs_iri_log_item, iri_item);
> +
> +	spin_unlock(&ailp->ail_lock);
> +	xfs_iri_release(irip);
> +	spin_lock(&ailp->ail_lock);
> +}

More cookie cutter code.

> @@ -4856,6 +4998,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  		case XFS_LI_BUI:
>  			error = xlog_recover_process_bui(parent_tp, ailp, lip);
>  			break;
> +		case XFS_LI_IRI:
> +			error = xlog_recover_process_iri(parent_tp, ailp, lip);
> +			break;
>  		}
>  		if (error)
>  			goto out;
> @@ -4912,6 +5057,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  		case XFS_LI_BUI:
>  			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
>  			break;
> +		case XFS_LI_IRI:
> +			xlog_recover_cancel_iri(log->l_mp, ailp, lip);
> +			break;
>  		}

And the table that drives it....

I guess what I'm saying is that I'd really like to see an abstract
type specifically for intent log items and generic infrastructure to
manipulate them before we go adding more of them...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
