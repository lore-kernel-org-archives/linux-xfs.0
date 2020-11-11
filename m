Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775A3C388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 263F82064B
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgKKA22 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:28:28 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48842 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730894AbgKKA22 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:28:28 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AB08A58C4AC;
        Wed, 11 Nov 2020 11:28:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kcdzm-009qhh-RV; Wed, 11 Nov 2020 11:28:18 +1100
Date:   Wed, 11 Nov 2020 11:28:18 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 02/10] xfs: Add delay ready attr remove routines
Message-ID: <20201111002818.GJ7391@dread.disaster.area>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-3-allison.henderson@oracle.com>
 <20201110234331.GL9695@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110234331.GL9695@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=7-415B0cAAAA:8
        a=O4jiMZvonYGVslo09fcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 03:43:31PM -0800, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 11:34:27PM -0700, Allison Henderson wrote:
> > +/*
> > + * Remove the attribute specified in @args.
> > + *
> > + * This function may return -EAGAIN to signal that the transaction needs to be
> > + * rolled.  Callers should continue calling this function until they receive a
> > + * return value other than -EAGAIN.
> > + */
> > +int
> > +xfs_attr_remove_iter(
> > +	struct xfs_delattr_context	*dac)
> > +{
> > +	struct xfs_da_args		*args = dac->da_args;
> > +	struct xfs_inode		*dp = args->dp;
> > +
> > +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
> > +		goto node;
> >  
> 
> Might as well just make this part of the if statement dispatch:
> 
> 	if (dac->dela_state == XFS_DAS_RM_SHRINK)
> 		return xfs_attr_node_removename_iter(dac);
> 	else if (!xfs_inode_hasattr(dp))
> 		return -ENOATTR;
> 
> >  	if (!xfs_inode_hasattr(dp)) {
> > -		error = -ENOATTR;
> > +		return -ENOATTR;
> >  	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> >  		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> > -		error = xfs_attr_shortform_remove(args);
> > +		return xfs_attr_shortform_remove(args);
> >  	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > -		error = xfs_attr_leaf_removename(args);
> > -	} else {
> > -		error = xfs_attr_node_removename(args);
> > +		return xfs_attr_leaf_removename(args);
> >  	}
> > -
> > -	return error;
> > +node:
> > +	return  xfs_attr_node_removename_iter(dac);

Just a nitpick on this anti-pattern: else is not necessary
when the branch returns.

	if (!xfs_inode_hasattr(dp))
		return -ENOATTR;

	if (dac->dela_state == XFS_DAS_RM_SHRINK)
		return xfs_attr_node_removename_iter(dac);

	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
		return xfs_attr_shortform_remove(args);
	}

	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
		return xfs_attr_leaf_removename(args);

	return xfs_attr_node_removename_iter(dac);

-Dave.
-- 
Dave Chinner
david@fromorbit.com
