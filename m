Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6201CC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 05:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 367CB6115C
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 05:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhDOFXC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 01:23:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229560AbhDOFXC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 01:23:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618464159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hXnGfqQLzFfCfj6+jkSwuXDuiSsNWJGwJBTSWVXAwuE=;
        b=M1+NAcFcBkmZ/lPHK7G5AhdrFhQbRrWHj5jAyyoGEAHrT3AXwFiBX25hRMiVuw2fI84Sc2
        Ia6975ILDJ2CVUIbi9c5aS6wswnGbzPdrFVNZgMUs1pH0UPyIwS7pgJBOsPaePWL30Uksh
        4jFs/tjWsZcI6KriE4fwEE6d78SsZHc=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-9vTblEV1PH2ES5D2MbcHCw-1; Thu, 15 Apr 2021 01:22:37 -0400
X-MC-Unique: 9vTblEV1PH2ES5D2MbcHCw-1
Received: by mail-pg1-f200.google.com with SMTP id s20-20020a63af540000b02901fb4a1fe304so819283pgo.13
        for <linux-xfs@vger.kernel.org>; Wed, 14 Apr 2021 22:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hXnGfqQLzFfCfj6+jkSwuXDuiSsNWJGwJBTSWVXAwuE=;
        b=W26UrW7SCqKHI89XxoOb3Zu76cP4EoBs8TJGblDntS1TJqOsASqV9OedErmqTplNVS
         1EXRFlloINOGLYGUpdOudmelEub0pdej3/xx5ZClUHQMYiPqrlv1dhw8lN4O52Ciuvt2
         fZF0Mk8VyHmi95691Gk7bINBJMUIMLhAt2LDaafwSG+A8tVxBOlHs+SbLmXQfumDSGT6
         DkXWDiU0Vwk4ym6CertFL3IOXoqzc9YyaI7t6i9spKTyzULNU7fark4zp1ESEy2vn4Pd
         EaqhNC2lQDCUh3F8i+YMUvcKFmZ0y+iqdgnY6r9iABJzeWwMLdrHPpnaP5hQJvnVkZ48
         N6Hw==
X-Gm-Message-State: AOAM532AmPonFgAmIKHeAXPH99uMsKqLSWwivX3ZxcaoP12jq6R3gKUZ
        lxz39I4g2o1KxPxgAVkGl1Slrxq4fBM02q0H4lEJgv9TYi0/Os3SeWdg65XFhNldkk9TskoCqnq
        i5ZhaigTE2p1JsycxZrxa
X-Received: by 2002:a17:90a:288:: with SMTP id w8mr1904131pja.163.1618464156296;
        Wed, 14 Apr 2021 22:22:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQA07UsYSWKz0AvLM5OjBu4lk9M2SLXaBqvjWk3MVnxE/T3XzipwUVb56/4o5bh8MX2wqXCQ==
X-Received: by 2002:a17:90a:288:: with SMTP id w8mr1904097pja.163.1618464155851;
        Wed, 14 Apr 2021 22:22:35 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y23sm685443pfr.82.2021.04.14.22.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 22:22:35 -0700 (PDT)
Date:   Thu, 15 Apr 2021 13:22:26 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] xfs: support shrinking empty AGs
Message-ID: <20210415052226.GC1864610@xiangao.remote.csb>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-5-hsiangkao@redhat.com>
 <20210415042549.GM63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210415042549.GM63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Thu, Apr 15, 2021 at 02:25:49PM +1000, Dave Chinner wrote:
> On Thu, Apr 15, 2021 at 03:52:40AM +0800, Gao Xiang wrote:
> > Roughly, freespace can be shrinked atomicly with the following steps:
> > 
> >  - make sure the pending-for-discard AGs are all stablized as empty;
> >  - a transaction to
> >      fix up freespace btrees for the target tail AG;
> >      decrease agcount to the target value.
> > 
> > In order to make sure such AGs are empty, first to mark them as
> > inactive, then check if these AGs are all empty one-by-one. Also
> > need to log force, complete all discard operations together.
> > 
> > Even it's needed to drain out all related cached buffers in case of
> > corrupt fs if growfs again, so ail items are all needed to be pushed
> > out as well.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c |   1 -
> >  fs/xfs/libxfs/xfs_ag.h |   2 +-
> >  fs/xfs/xfs_fsops.c     | 148 ++++++++++++++++++++++++++++++++++++++---
> >  fs/xfs/xfs_mount.c     |  87 +++++++++++++++++++-----
> >  fs/xfs/xfs_trans.c     |   1 -
> >  5 files changed, 210 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index ba5702e5c9ad..eb370fbae192 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -512,7 +512,6 @@ xfs_ag_shrink_space(
> >  	struct xfs_agf		*agf;
> >  	int			error, err2;
> >  
> > -	ASSERT(agno == mp->m_sb.sb_agcount - 1);
> >  	error = xfs_ialloc_read_agi(mp, *tpp, agno, &agibp);
> >  	if (error)
> >  		return error;
> > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > index 4535de1d88ea..7031e2c7ef66 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -15,7 +15,7 @@ struct aghdr_init_data {
> >  	xfs_agblock_t		agno;		/* ag to init */
> >  	xfs_extlen_t		agsize;		/* new AG size */
> >  	struct list_head	buffer_list;	/* buffer writeback list */
> > -	xfs_rfsblock_t		nfree;		/* cumulative new free space */
> > +	int64_t			nfree;		/* cumulative new free space */
> >  
> >  	/* per header data */
> >  	xfs_daddr_t		daddr;		/* header location */
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index b33c894b6cf3..659ca1836bba 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -14,11 +14,14 @@
> >  #include "xfs_trans.h"
> >  #include "xfs_error.h"
> >  #include "xfs_alloc.h"
> > +#include "xfs_ialloc.h"
> > +#include "xfs_extent_busy.h"
> >  #include "xfs_fsops.h"
> >  #include "xfs_trans_space.h"
> >  #include "xfs_log.h"
> >  #include "xfs_ag.h"
> >  #include "xfs_ag_resv.h"
> > +#include "xfs_trans_priv.h"
> >  
> >  /*
> >   * Write new AG headers to disk. Non-transactional, but need to be
> > @@ -78,6 +81,112 @@ xfs_resizefs_init_new_ags(
> >  	return error;
> >  }
> >  
> > +static int
> > +xfs_shrinkfs_deactivate_ags(
> > +	struct xfs_mount        *mp,
> > +	xfs_agnumber_t		oagcount,
> > +	xfs_agnumber_t		nagcount)
> > +{
> > +	xfs_agnumber_t		agno;
> > +	int			error;
> > +
> > +	/* confirm AGs pending for shrinking are all inactive */
> > +	for (agno = nagcount; agno < oagcount; ++agno) {
> > +		struct xfs_buf *agfbp, *agibp;
> > +		struct xfs_perag *pag = xfs_perag_get(mp, agno);
> > +
> > +		down_write(&pag->pag_inactive_rwsem);
> > +		/* need to lock agi, agf buffers here to close all races */
> > +		error = xfs_read_agi(mp, NULL, agno, &agibp);
> > +		if (!error) {
> > +			error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agfbp);
> > +			if (!error) {
> > +				pag->pag_inactive = true;
> > +				xfs_buf_relse(agfbp);
> > +			}
> > +			xfs_buf_relse(agibp);
> > +		}
> > +		up_write(&pag->pag_inactive_rwsem);
> > +		xfs_perag_put(pag);
> > +		if (error)
> > +			break;
> > +	}
> > +	return error;
> > +}
> 
> Hmmmm. Ok, that's why the first patch had the specific locking
> pattern it had, because once the AGI is locked under the
> inactive_rwsem. This seems ... fragile. It relies on the code
> looking up the perag to check the pag->pag_inactive flag before it
> takes an AGF or AGI lock, but does not allow a caller than has
> an AGI or AGF locked to take the inactive_sem to check if the per-ag
> is inactive or not. It's a one-way locking mechanism...

It guarantees that when AGF, AGI locked, pag_inactive won't be
switched, and before taking AGF or AGI, pag_inactive_sem should
be taken to confirm AGF, AGI can be read. That is the way that
I can think out with much less invasion than touch more XFS
codebase....

> 
> I'd much prefer active/passive references here, and the order of
> AG inactivation is highest to lowest...
> 
> static void
> xfs_shrinkfs_deactivate_ags(
> 	struct xfs_mount        *mp,
> 	xfs_agnumber_t		oagcount,
> 	xfs_agnumber_t		nagcount)
> {
> 	xfs_agnumber_t		agno;
> 
> 	for (agno = oagcount - 1; agno >= nagcount; agno--) {
> 		struct xfs_perag *pag = xfs_perag_get(mp, agno);
> 
> 		/* drop active reference */
> 		xfs_perag_put_active(pag);
> 
> 		/* wait for pag->pag_active_refs to hit zero */
> 		.....
> 
> 		xfs_perag_put(pag);
> 	}
> }
> 
> At this point, we know there are going to be no new racing accesses
> to the perags...
> 
> 
> > +static void
> > +xfs_shrinkfs_activate_ags(
> > +	struct xfs_mount        *mp,
> > +	xfs_agnumber_t		oagcount,
> > +	xfs_agnumber_t		nagcount)
> > +{
> > +	xfs_agnumber_t		agno;
> > +
> > +	for (agno = nagcount; agno < oagcount; ++agno) {
> > +		struct xfs_perag *pag = xfs_perag_get(mp, agno);
> > +
> > +		down_write(&pag->pag_inactive_rwsem);
> > +		pag->pag_inactive = false;
> > +		up_write(&pag->pag_inactive_rwsem);
> > +	}
> > +}
> 
> static void
> xfs_shrinkfs_reactivate_ags(
> 	struct xfs_mount        *mp,
> 	xfs_agnumber_t		oagcount,
> 	xfs_agnumber_t		nagcount)
> {
> 	xfs_agnumber_t		agno;
> 
> 	for (agno = oagcount - 1; agno >= nagcount; agno--) {
> 		struct xfs_perag *pag = xfs_perag_get(mp, agno);
> 
> 		/* get a new active reference for the mount */
> 		atomic_inc(&pag->pag_active_ref);
> 
> 		xfs_perag_put(pag);
> 	}
> }
> 
> 
> > +
> > +static int
> > +xfs_shrinkfs_prepare_ags(
> > +	struct xfs_mount        *mp,
> > +	struct aghdr_init_data	*id,
> > +	xfs_agnumber_t		oagcount,
> > +	xfs_agnumber_t		nagcount)
> > +{
> > +	xfs_agnumber_t		agno;
> > +	int 			error;
> > +
> > +	error = xfs_shrinkfs_deactivate_ags(mp, oagcount, nagcount);
> > +	if (error)
> > +		goto err_out;
> 
> Waiting for active references to drain means this can't fail.
> 
> > +
> > +	/* confirm AGs pending for shrinking are all empty */
> > +	for (agno = nagcount; agno < oagcount; ++agno) {
> 
> Again, needs to work from last AG back to first.

ok.

> 
> > +		struct xfs_buf		*agfbp;
> > +		struct xfs_perag	*pag;
> > +
> > +		error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agfbp);
> > +		if (error)
> > +			goto err_out;
> > +
> > +		pag = agfbp->b_pag;
> > +		error = xfs_ag_resv_free(pag);
> > +		if (!error) {
> > +			error = xfs_ag_is_empty(agfbp);
> > +			if (!error) {
> > +				ASSERT(!pag->pagf_flcount);
> > +				id->nfree -= pag->pagf_freeblks;
> > +			}
> > +		}
> 
> Please don't nest "if (!error)" statements like this. It results in
> excessive indent in the code, and it makes it harder to determine
> what the actual error handling for failure is.

ok.

> 
> > +		xfs_buf_relse(agfbp);
> > +		if (error)
> > +			goto err_out;
> > +	}
> > +	xfs_log_force(mp, XFS_LOG_SYNC);
> 
> What does this do,

It just makes sure that no ongoing write transactions before tearing
down AGs. The reason it was here about AGFL drain, but since it's a
sync transaction, so I think it should be raised up.

> and why is it not needed before we try to free
> reservations and determine if the AG is empty?

Yeah, but it can only cause false nagative, anyway, I will raise it
up.

> 
> > +	/*
> > +	 * Wait for all busy extents to be freed, including completion of
> > +	 * any discard operation.
> > +	 */
> > +	xfs_extent_busy_wait_all(mp);
> > +	flush_workqueue(xfs_discard_wq);
> 
> Shouldn't this happen before we start trying to tear down the AGs?

May I ask what's your suggestted place? since the AGs are already
inactive here.

> 
> > +
> > +	/*
> > +	 * Also need to drain out all related cached buffers, at least,
> > +	 * in case of growfs back later (which uses uncached buffers.)
> > +	 */
> > +	xfs_ail_push_all_sync(mp->m_ail);
> > +	xfs_buftarg_drain(mp->m_ddev_targp);
> 
> Urk, no, this can livelock on active filesystems.
> 
> What you want to do is drain the per-ag buffer cache, not the global
> filesystem LRU. Given that, at this point, all the buffers still
> cached in the per-ag should have zero references to them, a walk of
> the rbtree taking a reference to each buffer, marking it stale and
> then calling xfs_buf_rele() on it should be sufficient to free all
> the buffers in the AG and release all the remaining passive
> references to the struct perag for the AG.
> 

I understand the issue, yeah, it'd be much better to use
xfs_buftarg_drain() here. Thanks for your suggestion about this.

> At this point, we can remove the perag from the m_perag radix tree,
> do the final teardown on it, and free if via call_rcu()....

I still think active/passive reference approach causes a lot of
random modification all over the whole XFS codebase since it
assumes current perag won't be removed/freed even reference count
reaches zero, adding new active reference counts in principle
sounds better yet a bit far away from the current XFS codebase
status.

Thanks,
Gao Xiang

> 
> > +	return error;
> > +err_out:
> > +	xfs_shrinkfs_activate_ags(mp, oagcount, nagcount);
> > +	return error;
> > +}
> > +
> >  /*
> >   * growfs operations
> >   */
> > @@ -93,7 +202,7 @@ xfs_growfs_data_private(
> >  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> >  	int64_t			delta;
> >  	bool			lastag_extended;
> > -	xfs_agnumber_t		oagcount;
> > +	xfs_agnumber_t		oagcount, agno;
> >  	struct xfs_trans	*tp;
> >  	struct aghdr_init_data	id = {};
> >  
> > @@ -130,14 +239,13 @@ xfs_growfs_data_private(
> >  	oagcount = mp->m_sb.sb_agcount;
> >  
> >  	/* allocate the new per-ag structures */
> > -	if (nagcount > oagcount) {
> > +	if (nagcount > oagcount)
> >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> > -		if (error)
> > -			return error;
> > -	} else if (nagcount < oagcount) {
> > -		/* TODO: shrinking the entire AGs hasn't yet completed */
> > -		return -EINVAL;
> > -	}
> > +	else if (nagcount < oagcount)
> > +		error = xfs_shrinkfs_prepare_ags(mp, &id, oagcount, nagcount);
> > +
> > +	if (error)
> > +		return error;
> >  
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> >  			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> > @@ -151,13 +259,29 @@ xfs_growfs_data_private(
> >  	} else {
> >  		static struct ratelimit_state shrink_warning = \
> >  			RATELIMIT_STATE_INIT("shrink_warning", 86400 * HZ, 1);
> > +		xfs_agblock_t	agdelta;
> > +
> >  		ratelimit_set_flags(&shrink_warning, RATELIMIT_MSG_ON_RELEASE);
> >  
> >  		if (__ratelimit(&shrink_warning))
> >  			xfs_alert(mp,
> >  	"EXPERIMENTAL online shrink feature in use. Use at your own risk!");
> >  
> > -		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
> > +		for (agno = nagcount; agno < oagcount; ++agno) {
> > +			struct xfs_perag *pag = xfs_perag_get(mp, agno);
> > +
> > +			pag->pagf_freeblks = 0;
> > +			pag->pagf_longest = 0;
> > +			xfs_perag_put(pag);
> > +		}
> > +
> > +		xfs_trans_agblocks_delta(tp, id.nfree);
> > +
> > +		if (nagcount != oagcount)
> > +			agdelta = nagcount * mp->m_sb.sb_agblocks - nb;
> > +		else
> > +			agdelta = -delta;
> > +		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, agdelta);
> >  	}
> >  	if (error)
> >  		goto out_trans_cancel;
> > @@ -167,8 +291,10 @@ xfs_growfs_data_private(
> >  	 * seen by the rest of the world until the transaction commit applies
> >  	 * them atomically to the superblock.
> >  	 */
> > -	if (nagcount > oagcount)
> > -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > +	if (nagcount != oagcount)
> > +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT,
> > +				 (int64_t)nagcount - (int64_t)oagcount);
> > +
> >  	if (delta)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
> >  	if (id.nfree)
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 69a60b5f4a32..ca9513fdc09e 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -172,6 +172,47 @@ xfs_sb_validate_fsb_count(
> >  	return 0;
> >  }
> >  
> > +static int
> > +xfs_perag_reset(
> > +	struct xfs_perag	*pag)
> > +{
> > +	int	error;
> > +
> > +	spin_lock_init(&pag->pag_ici_lock);
> > +	INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
> > +	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
> > +
> > +	error = xfs_buf_hash_init(pag);
> > +	if (error)
> > +		return error;
> > +
> > +	init_waitqueue_head(&pag->pagb_wait);
> > +	spin_lock_init(&pag->pagb_lock);
> > +	pag->pagb_count = 0;
> > +	pag->pagb_tree = RB_ROOT;
> > +
> > +	error = xfs_iunlink_init(pag);
> > +	if (error) {
> > +		xfs_buf_hash_destroy(pag);
> > +		return error;
> > +	}
> > +	spin_lock_init(&pag->pag_state_lock);
> > +	return 0;
> > +}
> > +
> > +static int
> > +xfs_perag_inactive_reset(
> > +	struct xfs_perag	*pag)
> > +{
> > +	cancel_delayed_work_sync(&pag->pag_blockgc_work);
> > +	xfs_iunlink_destroy(pag);
> > +	xfs_buf_hash_destroy(pag);
> > +
> > +	memset((char *)pag + offsetof(struct xfs_perag, pag_inactive), 0,
> > +	       sizeof(*pag) - offsetof(struct xfs_perag, pag_inactive));
> > +	return xfs_perag_reset(pag);
> > +}
> > +
> >  int
> >  xfs_initialize_perag(
> >  	xfs_mount_t	*mp,
> > @@ -180,6 +221,8 @@ xfs_initialize_perag(
> >  {
> >  	xfs_agnumber_t	index;
> >  	xfs_agnumber_t	first_initialised = NULLAGNUMBER;
> > +	xfs_agnumber_t	first_inactive = NULLAGNUMBER;
> > +	xfs_agnumber_t	last_inactive = NULLAGNUMBER;
> >  	xfs_perag_t	*pag;
> >  	int		error = -ENOMEM;
> >  
> > @@ -191,6 +234,20 @@ xfs_initialize_perag(
> >  	for (index = 0; index < agcount; index++) {
> >  		pag = xfs_perag_get(mp, index);
> >  		if (pag) {
> > +			down_write(&pag->pag_inactive_rwsem);
> > +			if (pag->pag_inactive) {
> > +				error = xfs_perag_inactive_reset(pag);
> > +				if (error) {
> > +					pag->pag_inactive = true;
> > +					up_write(&pag->pag_inactive_rwsem);
> > +					xfs_perag_put(pag);
> > +					goto out_unwind_new_pags;
> > +				}
> > +				if (first_inactive == NULLAGNUMBER)
> > +					first_inactive = index;
> > +				last_inactive = index;
> > +			}
> > +			up_write(&pag->pag_inactive_rwsem);
> 
> This should all go away if the perags have already been removed from
> the tree. In fact, you shouldn't need to call xfs_initialize_perag()
> at all for the shrink case that removes whole AGs....
> 
> CHeers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

