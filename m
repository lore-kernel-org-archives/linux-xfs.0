Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA08C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 01:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiEKBGz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 21:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiEKBGy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 21:06:54 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50350BC14
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 18:06:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6D36C534468;
        Wed, 11 May 2022 11:06:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1noaoV-00AVEl-8T; Wed, 11 May 2022 11:06:51 +1000
Date:   Wed, 11 May 2022 11:06:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] xfs: separate out initial attr_set states
Message-ID: <20220511010651.GZ1098723@dread.disaster.area>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-6-david@fromorbit.com>
 <20220510231234.GI27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510231234.GI27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627b0c2c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=2GxwkD63JcoF1FxzpF8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 04:12:34PM -0700, Darrick J. Wong wrote:
> On Mon, May 09, 2022 at 10:41:25AM +1000, Dave Chinner wrote:
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index c9c867e3406c..ad52b5dc59e4 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -530,4 +553,35 @@ void xfs_attri_destroy_cache(void);
> >  int __init xfs_attrd_init_cache(void);
> >  void xfs_attrd_destroy_cache(void);
> >  
> > +/*
> > + * Check to see if the attr should be upgraded from non-existent or shortform to
> > + * single-leaf-block attribute list.
> > + */
> > +static inline bool
> > +xfs_attr_is_shortform(
> > +	struct xfs_inode    *ip)
> > +{
> > +	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
> > +	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> > +		ip->i_afp->if_nextents == 0);
> > +}
> > +
> > +static inline enum xfs_delattr_state
> > +xfs_attr_init_add_state(struct xfs_da_args *args)
> > +{
> > +	if (!args->dp->i_afp)
> > +		return XFS_DAS_DONE;
> 
> If we're in add/replace attr call without an attr fork, why do we go
> straight to finished?

I suspect I've fixed all the issues that triggered crashes here
because args->dp->i_afp was null. THere were transient states in a
replace operaiton when the remove takes away the last attr, removes
the attr fork, then calls the ADD operation. The add operation
assumes that the attr fork has already been set up, and so bad
things happened here.

This also occurred when setting up recovery operations - recovery of
an add/replace could start from that same "there's no attr fork"
condition, and so calling xfs_inode_has_attr() or
xfs_attr_is_shortform() direct from the reocovery setup code would
go splat because ip->i_afp was null.

I'm going to leave this for the moment (cleanup note made) because I
don't want to have to find out that I missed a corner case somewhere
they hard way right now. It's basically there to stop log recovery
crashing hard, which only occurs when the experimental larp code is
running, so I think this is safe to leave for a later cleanup.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
