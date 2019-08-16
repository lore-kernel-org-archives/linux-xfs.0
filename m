Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB35C3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 14:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8A1D2086C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 14:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfHPOxO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:53:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfHPOxO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Aug 2019 10:53:14 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4FBB830860C2;
        Fri, 16 Aug 2019 14:53:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88D9244F8C;
        Fri, 16 Aug 2019 14:53:12 +0000 (UTC)
Date:   Fri, 16 Aug 2019 10:53:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190816145310.GB54929@bfoster>
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
 <20190815233630.GU6129@dread.disaster.area>
 <65790fd5-5915-9318-8737-d81899d73e9e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65790fd5-5915-9318-8737-d81899d73e9e@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 16 Aug 2019 14:53:13 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 04:09:39PM +0800, kaixuxia wrote:
> 
> 
> On 2019/8/16 7:36, Dave Chinner wrote:
> > On Tue, Aug 13, 2019 at 07:17:33PM +0800, kaixuxia wrote:
> > > In this patch we make the unlinked list removal a deferred operation,
> > > i.e. log an iunlink remove intent and then do it after the RENAME_WHITEOUT
> > > transaction has committed, and the iunlink remove intention and done
> > > log items are provided.
> > 
> > I really like the idea of doing this, not just for the inode unlink
> > list removal, but for all the high level complex metadata
> > modifications such as create, unlink, etc.
> > 
> > The reason I like this is that it moves use closer to being able to
> > do operations almost completely asynchronously once the first intent
> > has been logged.
> > 
> 
> Thanks a lot for your comments.
> Yeah, sometimes the complex metadata modifications correspond to the
> long and complex transactions that hold more locks or other common
> resources, so the deferred options may be better choices than just
> changing the order in one transaction.
> 

I can't speak for Dave (who can of course chime in again..) or others,
but I don't think he's saying that this approach is preferred to the
various alternative approaches discussed in the other subthread. Note
that he also replied there with another potential solution that doesn't
involve deferred operations.

Rather, I think he's viewing this in a much longer term context around
changing more of the filesystem to be async in architecture. Personally,
I'd have a ton more questions around the context of what something like
that looks like before I'd support starting to switch over less complex
operations to be deferred operations based on the current dfops
mechanism. The mechanism works and solves real problems, but it also has
tradeoffs that IMO warrant the current model of selective use. Further,
it's nearly impossible to determine what other fundamental
incompatibilities might exist without context on bigger picture design.
IOW, this topic really needs a separate thread that that starts with a
high level architectural description for others to reason about, because
I think it's already caused confusion.

In short, while it might be worth keeping this patch around for future
use, I still think this is overkill (and insufficient as Darrick already
noted) for fixing the originally reported problem... 

Brian

> > Once we have committed the intent, we can treat the rest of the
> > operation like recovery - all the information needed to perform the
> > operation is in the intenti and all the objects that need to be
> > locked across the entire operation are locked and joined to the
> > defer structure. If the intent hits the log the we guarantee that it
> > will be completed atomically and in the correct sequence order.
> > Hence it doesn't matter once the intent is built and committed what
> > context actually completes the rest of the transaction.
> > 
> > If we have to do a sync transaction, because XFS_MOUNT_SYNC,
> > XFS_MOUNT_DIRSYNC, or there's a sync flag on the inode(s), we can
> > add a waitqueue_head to the struct xfs_defer and have the context
> > issuing the transaction attach itself and wait for the defer ops to
> > complete and wake it....
> > 
> > 
> > .....
> > 
> > > @@ -3752,6 +3755,96 @@ struct xfs_buf_cancel {
> > >   }
> > > 
> > >   /*
> > > + * This routine is called to create an in-core iunlink remove intent
> > > + * item from the iri format structure which was logged on disk.
> > > + * It allocates an in-core iri, copies the inode from the format
> > > + * structure into it, and adds the iri to the AIL with the given
> > > + * LSN.
> > > + */
> > > +STATIC int
> > > +xlog_recover_iri_pass2(
> > > +	struct xlog			*log,
> > > +	struct xlog_recover_item	*item,
> > > +	xfs_lsn_t			lsn)
> > > +{
> > > +	xfs_mount_t		*mp = log->l_mp;
> > > +	xfs_iri_log_item_t	*irip;
> > > +	xfs_iri_log_format_t	*iri_formatp;
> > > +
> > > +	iri_formatp = item->ri_buf[0].i_addr;
> > > +
> > > +	irip = xfs_iri_init(mp, 1);
> > > +	irip->iri_format = *iri_formatp;
> > > +	if (item->ri_buf[0].i_len != sizeof(xfs_iri_log_format_t)) {
> > > +		xfs_iri_item_free(irip);
> > > +		return EFSCORRUPTED;
> > > +	}
> > > +
> > > +	spin_lock(&log->l_ailp->ail_lock);
> > > +	/*
> > > +	 * The IRI has two references. One for the IRD and one for IRI to ensure
> > > +	 * it makes it into the AIL. Insert the IRI into the AIL directly and
> > > +	 * drop the IRI reference. Note that xfs_trans_ail_update() drops the
> > > +	 * AIL lock.
> > > +	 */
> > > +	xfs_trans_ail_update(log->l_ailp, &irip->iri_item, lsn);
> > > +	xfs_iri_release(irip);
> > > +	return 0;
> > > +}
> > 
> > These intent recovery functions all do very, very similar things.
> > We already have 4 copies of this almost identical code - I think
> > there needs to be some factoring/abstrcting done here rather than
> > continuing to copy/paste this code...
> 
> Factoring/abstrcting is better than just copy/paste...
> The log incompat feature bit is also needed because adding new
> log item types(IRI&IRD)...
> Any way, I will send the V2 patch for all the review comments.
> 
> > 
> > > @@ -3981,6 +4074,8 @@ struct xfs_buf_cancel {
> > >   	case XFS_LI_CUD:
> > >   	case XFS_LI_BUI:
> > >   	case XFS_LI_BUD:
> > > +	case XFS_LI_IRI:
> > > +	case XFS_LI_IRD:
> > >   	default:
> > >   		break;
> > >   	}
> > > @@ -4010,6 +4105,8 @@ struct xfs_buf_cancel {
> > >   	case XFS_LI_CUD:
> > >   	case XFS_LI_BUI:
> > >   	case XFS_LI_BUD:
> > > +	case XFS_LI_IRI:
> > > +	case XFS_LI_IRD:
> > >   		/* nothing to do in pass 1 */
> > >   		return 0;
> > >   	default:
> > > @@ -4052,6 +4149,10 @@ struct xfs_buf_cancel {
> > >   		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
> > >   	case XFS_LI_BUD:
> > >   		return xlog_recover_bud_pass2(log, item);
> > > +	case XFS_LI_IRI:
> > > +		return xlog_recover_iri_pass2(log, item, trans->r_lsn);
> > > +	case XFS_LI_IRD:
> > > +		return xlog_recover_ird_pass2(log, item);
> > >   	case XFS_LI_DQUOT:
> > >   		return xlog_recover_dquot_pass2(log, buffer_list, item,
> > >   						trans->r_lsn);
> > 
> > As can be seen by the increasing size of this table....
> > 
> > > @@ -4721,6 +4822,46 @@ struct xfs_buf_cancel {
> > >   	spin_lock(&ailp->ail_lock);
> > >   }
> > > 
> > > +/* Recover the IRI if necessary. */
> > > +STATIC int
> > > +xlog_recover_process_iri(
> > > +	struct xfs_trans		*parent_tp,
> > > +	struct xfs_ail			*ailp,
> > > +	struct xfs_log_item		*lip)
> > > +{
> > > +	struct xfs_iri_log_item		*irip;
> > > +	int				error;
> > > +
> > > +	/*
> > > +	 * Skip IRIs that we've already processed.
> > > +	 */
> > > +	irip = container_of(lip, struct xfs_iri_log_item, iri_item);
> > > +	if (test_bit(XFS_IRI_RECOVERED, &irip->iri_flags))
> > > +		return 0;
> > > +
> > > +	spin_unlock(&ailp->ail_lock);
> > > +	error = xfs_iri_recover(parent_tp, irip);
> > > +	spin_lock(&ailp->ail_lock);
> > > +
> > > +	return error;
> > > +}
> > > +
> > > +/* Release the IRI since we're cancelling everything. */
> > > +STATIC void
> > > +xlog_recover_cancel_iri(
> > > +	struct xfs_mount		*mp,
> > > +	struct xfs_ail			*ailp,
> > > +	struct xfs_log_item		*lip)
> > > +{
> > > +	struct xfs_iri_log_item         *irip;
> > > +
> > > +	irip = container_of(lip, struct xfs_iri_log_item, iri_item);
> > > +
> > > +	spin_unlock(&ailp->ail_lock);
> > > +	xfs_iri_release(irip);
> > > +	spin_lock(&ailp->ail_lock);
> > > +}
> > 
> > More cookie cutter code.
> > 
> > > @@ -4856,6 +4998,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
> > >   		case XFS_LI_BUI:
> > >   			error = xlog_recover_process_bui(parent_tp, ailp, lip);
> > >   			break;
> > > +		case XFS_LI_IRI:
> > > +			error = xlog_recover_process_iri(parent_tp, ailp, lip);
> > > +			break;
> > >   		}
> > >   		if (error)
> > >   			goto out;
> > > @@ -4912,6 +5057,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
> > >   		case XFS_LI_BUI:
> > >   			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
> > >   			break;
> > > +		case XFS_LI_IRI:
> > > +			xlog_recover_cancel_iri(log->l_mp, ailp, lip);
> > > +			break;
> > >   		}
> > 
> > And the table that drives it....
> > 
> > I guess what I'm saying is that I'd really like to see an abstract
> > type specifically for intent log items and generic infrastructure to
> > manipulate them before we go adding more of them...
> > 
> > Cheers,
> > 
> > Dave.
> > 
> 
> -- 
> kaixuxia
