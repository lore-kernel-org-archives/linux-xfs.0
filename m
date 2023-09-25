Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1AACE7A95
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 15:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjIYPNw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjIYPNv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 11:13:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AE7103
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 08:13:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D345C433C7;
        Mon, 25 Sep 2023 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695654824;
        bh=2VSsXhSTf5jJSO+fGHyGvw5zzKz+lSRbxM50UfPLDUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RC7PQrheAc6m9X+G8IRGWCo4Eg1mBE8EdYI1D0k6gZanHbjwt9uD9S+f3WesFEUQM
         24TFUDuJg0eO9bzeqrT4jgkmsI7roZekJyr5OiR3gNUHusJ+tvVR0h+XU6mnqTyzTH
         tvxGdgu8V3XBEzr3TGXcWrc4e394O/s23YktVGsTRABETx0f6FdjxI76QqfWXhvs2+
         2ZgEN6GYvEtKADFownJwrOFN9aOXYh5NWiu31VUW/sfG9d/Yp+csxfF/2ktYBcGrYm
         G8dPwljicX8VioU6C5Lg3dsG1UM+y4fBKyACJuheLwHPh0yDgJVdRKi3rCAhvqPQ90
         b2FRgo+59AyVg==
Date:   Mon, 25 Sep 2023 08:13:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move log discard work to xfs_discard.c
Message-ID: <20230925151344.GC11456@frogsfrogsfrogs>
References: <20230921013945.559634-1-david@fromorbit.com>
 <20230921013945.559634-2-david@fromorbit.com>
 <20230921155243.GC11391@frogsfrogsfrogs>
 <ZQzoJoYVrK7HV8v8@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQzoJoYVrK7HV8v8@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 22, 2023 at 11:04:38AM +1000, Dave Chinner wrote:
> On Thu, Sep 21, 2023 at 08:52:43AM -0700, Darrick J. Wong wrote:
> > On Thu, Sep 21, 2023 at 11:39:43AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Because we are going to use the same list-based discard submission
> > > interface for fstrim-based discards, too.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ....
> > > @@ -31,6 +28,23 @@ struct xfs_extent_busy {
> > >  #define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
> > >  };
> > >  
> > > +/*
> > > + * List used to track groups of related busy extents all the way through
> > > + * to discard completion.
> > > + */
> > > +struct xfs_busy_extents {
> > > +	struct xfs_mount	*mount;
> > > +	struct list_head	extent_list;
> > > +	struct work_struct	endio_work;
> > > +
> > > +	/*
> > > +	 * Owner is the object containing the struct xfs_busy_extents to free
> > > +	 * once the busy extents have been processed. If only the
> > > +	 * xfs_busy_extents object needs freeing, then point this at itself.
> > > +	 */
> > > +	void			*owner;
> > > +};
> > > +
> > >  void
> > >  xfs_extent_busy_insert(struct xfs_trans *tp, struct xfs_perag *pag,
> > >  	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
> > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > index 3aec5589d717..c340987880c8 100644
> > > --- a/fs/xfs/xfs_log_cil.c
> > > +++ b/fs/xfs/xfs_log_cil.c
> > > @@ -16,8 +16,7 @@
> > >  #include "xfs_log.h"
> > >  #include "xfs_log_priv.h"
> > >  #include "xfs_trace.h"
> > > -
> > > -struct workqueue_struct *xfs_discard_wq;
> > > +#include "xfs_discard.h"
> > >  
> > >  /*
> > >   * Allocate a new ticket. Failing to get a new ticket makes it really hard to
> > > @@ -103,7 +102,7 @@ xlog_cil_ctx_alloc(void)
> > >  
> > >  	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
> > >  	INIT_LIST_HEAD(&ctx->committing);
> > > -	INIT_LIST_HEAD(&ctx->busy_extents);
> > > +	INIT_LIST_HEAD(&ctx->busy_extents.extent_list);
> > 
> > I wonder if xfs_busy_extents should have an initializer function to
> > INIT_LIST_HEAD and set mount/owner?  This patch and the next one both
> > have similar initialization sequences.
> > 
> > (Not sure if you want to INIT_WORK at the same time?)
> > 
> > >  	INIT_LIST_HEAD(&ctx->log_items);
> > >  	INIT_LIST_HEAD(&ctx->lv_chain);
> > >  	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
> > > @@ -132,7 +131,7 @@ xlog_cil_push_pcp_aggregate(
> > >  
> > >  		if (!list_empty(&cilpcp->busy_extents)) {
> > >  			list_splice_init(&cilpcp->busy_extents,
> > > -					&ctx->busy_extents);
> > > +					&ctx->busy_extents.extent_list);
> > 
> > Hmm.  Should xfs_trans.t_busy and xlog_cil_pcp.busy_extents also get
> > converted into xfs_busy_extents objects and a helper written to splice
> > two busy_extents lists together?
> > 
> > (This might be architecture astronauting, feel free to ignore this...)
> 
> These two cases are a little bit different - they are just lists of
> busy extents and do not need any of the stuff for discards. It
> doesn't make a whole lot of sense to make them xfs_busy_extents and
> then either have to open code all the places they use to add
> ".extent_list" or add one line wrappers for list add, splice, and
> empty check operations.
> 
> It's likely more code than just open coding the extent list access
> in the couple of places we need to access it directly...
> 
> ....
> 
> > > @@ -980,8 +909,8 @@ xlog_cil_committed(
> > >  
> > >  	xlog_cil_ail_insert(ctx, abort);
> > >  
> > > -	xfs_extent_busy_sort(&ctx->busy_extents);
> > > -	xfs_extent_busy_clear(mp, &ctx->busy_extents,
> > > +	xfs_extent_busy_sort(&ctx->busy_extents.extent_list);
> > > +	xfs_extent_busy_clear(mp, &ctx->busy_extents.extent_list,
> > >  			      xfs_has_discard(mp) && !abort);
> > 
> > Should these two xfs_extent_busy objects take the xfs_busy_extent object
> > as an arg instead of the mount and list_head?  It seems strange (both
> > here and the next patch) to build up this struct and then pass around
> > its individual parts.
> 
> xfs_extent_busy_sort(), no. It's just sorting a list of busy
> extents, and has nothign to do with discard contexts and it gets
> called from transaction freeing context when we abort transactions...
> 
> xfs_extent_busy_clear() also gets called from transaction context and
> does not do discards - it just passes a list of busy extents to be
> cleared.
> 
> So we'd have to wrap tp->t_busy up as a xfs_busy_extents
> object just so we can pass a xfs_busy_extents object to these
> functions, even though we are just using these as list_heads and not
> for any other purpose.
> 
> Ignoring all the helpers we'd need, I'm also not convinced that the
> runtime cost of increasing the struct xfs_trans by 48 bytes with
> stuff it will never use is lower than the benefit of reducing the
> parameters we pass to one function from 3 to 2....

ouch.

> > The straight conversion aspect of this patch looks correct, so (aside
> > from the question above) any larger API cleanups can be their own patch.
> 
> If it was a much more widely used API, it might make sense to make
> the struct xfs_busy_extents a first class citizen. But as it stands
> it's just a wrapper to enable discard operation to be abstracted so
> I've just made it as minimally invasive as I can....

<nod>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
