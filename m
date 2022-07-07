Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB5EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 02:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiGGCeY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jul 2022 22:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiGGCeU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jul 2022 22:34:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABE61C93C
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jul 2022 19:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56DC06209E
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 02:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7608C341CA;
        Thu,  7 Jul 2022 02:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657161257;
        bh=meQy1QQfHmrX9KDSM12dOh4ACGoeodWl+VmGnw/eOQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gBpvSA80q5VNOpOReUCRapUDLX7OWoeY9ClxiN4sIqAZFnWbKoZ+tKPQ4YsJQQh19
         +4m4jdVeqjhTsp7LPy2cOM24g8TGuLIhNHOKelpXiGxk4elF8U6ijtp0wSXmnGmGp7
         c437MUvkDxwuY0EO80fwMWnS2YWLBgDWUQkVOCDUYUY/H3k8af04cazg2nSpKxOv/4
         yyZtK7wPcObYahFe5EBveCWY1dRyfUAfxWE02RnmTjXOUG/IloMTpLHj4qM9+cubP7
         oT4BZoIVVuMESJBy5cijhWpSjEVSqex6oVRmMl84fqPa48JR2WB7Bjb+DIPcLkorDB
         E1iTi1bVvWscw==
Date:   Wed, 6 Jul 2022 19:34:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: add log item precommit operation
Message-ID: <YsZGKWM6KuNH2Z+v@magnolia>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-9-david@fromorbit.com>
 <YrzBEwKCEwa+aFie@magnolia>
 <20220629213437.GX227878@dread.disaster.area>
 <YrzHU53bLN/4komZ@magnolia>
 <20220629214821.GA227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629214821.GA227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 07:48:21AM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2022 at 02:42:43PM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 30, 2022 at 07:34:37AM +1000, Dave Chinner wrote:
> > > On Wed, Jun 29, 2022 at 02:16:03PM -0700, Darrick J. Wong wrote:
> > > > On Mon, Jun 27, 2022 at 10:43:35AM +1000, Dave Chinner wrote:
> > > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > > index 82cf0189c0db..0acb31093d9f 100644
> > > > > --- a/fs/xfs/xfs_trans.c
> > > > > +++ b/fs/xfs/xfs_trans.c
> > > > > @@ -844,6 +844,90 @@ xfs_trans_committed_bulk(
> > > > >  	spin_unlock(&ailp->ail_lock);
> > > > >  }
> > > > >  
> > > > > +/*
> > > > > + * Sort transaction items prior to running precommit operations. This will
> > > > > + * attempt to order the items such that they will always be locked in the same
> > > > > + * order. Items that have no sort function are moved to the end of the list
> > > > > + * and so are locked last (XXX: need to check the logic matches the comment).
> > > > > + *
> > > > > + * This may need refinement as different types of objects add sort functions.
> > > > > + *
> > > > > + * Function is more complex than it needs to be because we are comparing 64 bit
> > > > > + * values and the function only returns 32 bit values.
> > > > > + */
> > > > > +static int
> > > > > +xfs_trans_precommit_sort(
> > > > > +	void			*unused_arg,
> > > > > +	const struct list_head	*a,
> > > > > +	const struct list_head	*b)
> > > > > +{
> > > > > +	struct xfs_log_item	*lia = container_of(a,
> > > > > +					struct xfs_log_item, li_trans);
> > > > > +	struct xfs_log_item	*lib = container_of(b,
> > > > > +					struct xfs_log_item, li_trans);
> > > > > +	int64_t			diff;
> > > > > +
> > > > > +	/*
> > > > > +	 * If both items are non-sortable, leave them alone. If only one is
> > > > > +	 * sortable, move the non-sortable item towards the end of the list.
> > > > > +	 */
> > > > > +	if (!lia->li_ops->iop_sort && !lib->li_ops->iop_sort)
> > > > > +		return 0;
> > > > > +	if (!lia->li_ops->iop_sort)
> > > > > +		return 1;
> > > > > +	if (!lib->li_ops->iop_sort)
> > > > > +		return -1;
> > > > > +
> > > > > +	diff = lia->li_ops->iop_sort(lia) - lib->li_ops->iop_sort(lib);
> > > > 
> > > > I'm kinda surprised the iop_sort method doesn't take both log item
> > > > pointers, like most sorting-comparator functions?  But I'll see, maybe
> > > > you're doing something clever wrt ordering of log items of differing
> > > > types, and hence the ->iop_sort implementations are required to return
> > > > some absolute priority or something.
> > > 
> > > Nope, we have to order item locking based on an unchanging
> > > characteristic of the object. log items can come and go, we want to
> > > lock items in consistent ascending order, so it has to be based on
> > > some kind of physical characteristic, like inode number, block
> > > address, etc.
> > > 
> > > e.g. If all objects are ordered by the physical location, we naturally
> > > get a lock order that can be applied sanely across differing object
> > > types e.g. AG headers will naturally sort and lock before buffers
> > > in the AG itself. e.g. inode cluster buffers for unlinked list
> > > manipulations will always get locked after the AGI....
> > 
> > <nod> So if (say) we were going to add dquots to this scheme, we'd
> > probably want to shift all the iop_sort functions to return (say) the
> > xfs_daddr_t of the associated item?
> 
> No, I don't want to tie it specifically to physical address.
> ip->i_ino is not a daddr, but it would order just fine against one.
> 
> > (Practically speaking, I don't know that I'd want to tie things down to
> > the disk address quite this soon, and since it's all incore code anyway
> > I don't think the precise type of the return values matter.)
> 
> Indeed, I don't even want to tie this specifically to a 64 bit
> value; it's intended that objects will return a sort key, and as
> we add more object types we'll have to think harder about the
> specific key values we use.

Ok.  As there currently are no other ->iop_sort implementations and the
return values aren't encoded on disk, I'll go along with this:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

That just leaves the hch's comments scattered throughout, and my own
comments about patch 3 and 4.  Any chance this series will get a new rev
in time for 5.20?

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
