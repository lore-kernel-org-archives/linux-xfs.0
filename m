Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06760C34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 06:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E67208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 06:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgBSGxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 01:53:10 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41410 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgBSGxK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 01:53:10 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A460A3A3748;
        Wed, 19 Feb 2020 17:53:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j4JEG-0006cx-Gk; Wed, 19 Feb 2020 17:53:04 +1100
Date:   Wed, 19 Feb 2020 17:53:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 30/31] xfs: remove XFS_DA_OP_INCOMPLETE
Message-ID: <20200219065304.GM10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-31-hch@lst.de>
 <20200218022334.GD10776@dread.disaster.area>
 <20200218154856.GD21780@lst.de>
 <20200219004729.GD9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219004729.GD9506@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=JLbkrko1uwvrcnX89RoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 04:47:29PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 18, 2020 at 04:48:56PM +0100, Christoph Hellwig wrote:
> > On Tue, Feb 18, 2020 at 01:23:34PM +1100, Dave Chinner wrote:
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > index d5c112b6dcdd..23e0d8ce39f8 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > @@ -898,7 +898,7 @@ xfs_attr_node_addname(
> > > >  		 * The INCOMPLETE flag means that we will find the "old"
> > > >  		 * attr, not the "new" one.
> > > >  		 */
> > > > -		args->op_flags |= XFS_DA_OP_INCOMPLETE;
> > > > +		args->attr_namespace |= XFS_ATTR_INCOMPLETE;
> > > 
> > > So args->attr_namespace is no longer an indication of what attribute
> > > namespace to look up? Unless you are now defining incomplete
> > > attributes to be in a namespace?
> > 
> > It is the same field on disk.

Yes, but the INCOMPLETE flag is not indicating a user specified
attribute namespace type like user.*, system.* or secure.*. We're just using
the flag to store that prefix in as little space as possible.

Indeed, we can have incomplete attributes in all the namespaces, so
what we are really using this field and it's flags for is search
filtering.

> > > If so, I think this needs more explanation than "we can use the
> > > on-disk format directly instead". That's just telling me what the
> > > patch is doing and doesn't explain why we are considering this
> > > specific on disk flag to indicate a new type of "namespace" for
> > > attributes lookups. Hence I think this needs more documentation in
> > > both the commit and the code as the definition of
> > > XFS_ATTR_INCOMPLETE doesn't really make it clear that this is now
> > > considered a namespace signifier...
> > 
> > Ok.  Also if anyone has a better name for the field, suggestions welcome..
> 
> The bureaucrat part of my brain suggests "attr_flags", with a
> XFS_ATTR_NAMESPACE() helper to extract just the namespace part by using
> #define XFS_ATTR_NAMESPACE_MASK (XFS_ATTR_ROOT | XFS_ATTR_SECURE)

If it's filtering, then attr_filter might be appropriate. We only
return attributes that match the filter mask....

> I kind of dislike that idea because it seems like a lot of overkill to
> keep the two namespace bits separate from the actual attr entry flags,
> but maybe we need it...

*nod*

I don't think we need all that jazz (waves jazz hands in the air) if
we look at it from the point of view of it being a filter mask
rather than a namespace specifier....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
