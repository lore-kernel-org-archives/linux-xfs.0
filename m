Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E52C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 00:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiEKA5p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 20:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236761AbiEKA5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 20:57:44 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13D86532CF
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 17:57:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3669253458A;
        Wed, 11 May 2022 10:57:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1noafd-00AV6G-FJ; Wed, 11 May 2022 10:57:41 +1000
Date:   Wed, 11 May 2022 10:57:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] xfs: rework deferred attribute operation setup
Message-ID: <20220511005741.GY1098723@dread.disaster.area>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-5-david@fromorbit.com>
 <20220510230451.GH27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510230451.GH27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=627b0a06
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=ol1Rakwd5XOFDp043FwA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 04:04:51PM -0700, Darrick J. Wong wrote:
> On Mon, May 09, 2022 at 10:41:24AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Logged attribute intents only have set and remove types - there is
> > no type of the replace operation. We should ahve a separate type for
> 
> "..no separate intent type for a replace operation."?
> 
> Also, "ahve" -> "have".
> 
> > a replace operation, as it needs to perform operations that neither
> > SET or REMOVE can perform.
> > 
> > Add this type to the intent items and rearrange the deferred
> > operation setup to reflect the different operations we are
> > performing.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       | 165 +++++++++++++++++++--------------
> >  fs/xfs/libxfs/xfs_attr.h       |   2 -
> >  fs/xfs/libxfs/xfs_log_format.h |   1 +
> >  fs/xfs/xfs_attr_item.c         |   9 +-
> >  fs/xfs/xfs_trace.h             |   4 +
> >  5 files changed, 110 insertions(+), 71 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index a4b0b20a3bab..817e15740f9c 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -671,6 +671,81 @@ xfs_attr_lookup(
> >  	return xfs_attr_node_hasname(args, NULL);
> >  }
> >  
> > +static int
> > +xfs_attr_item_init(
> > +	struct xfs_da_args	*args,
> > +	unsigned int		op_flags,	/* op flag (set or remove) */
> > +	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
> > +{
> > +
> > +	struct xfs_attr_item	*new;
> > +
> > +	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
> 
> Can this fail?
> 
> > +	new->xattri_op_flags = op_flags;
> > +	new->xattri_da_args = args;
> > +
> > +	*attr = new;
> > +	return 0;
> 
> And if it can't, then there's no need for a return value, AFAICT.  I
> looked at the end of xfs-5.19-compose and there's no other return
> statements in this function.
> 
> And then you don't need any of the error handling in this patch at all,
> right?
> 
> *OH*, this is just a hoist of the stuff at the end.  Could someone add a
> patch on the end of ... whatever patchset there is to clean that up?
> 
> In the meantime, with the commit message typos cleaned up,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks.

I'm making notes of all the things that need cleaning up. there's a
few things already, that probably won't happen until the next cycle
at this point...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
