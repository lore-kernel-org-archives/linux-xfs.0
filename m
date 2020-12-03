Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63209C4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 21:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07B8D221F2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 21:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgLCVpL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:45:11 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:41544 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728715AbgLCVpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 16:45:11 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 87B9A1AC8D2;
        Fri,  4 Dec 2020 08:44:27 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kkwOo-000CAA-P5; Fri, 04 Dec 2020 08:44:26 +1100
Date:   Fri, 4 Dec 2020 08:44:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201203214426.GE3913616@dread.disaster.area>
References: <20201202232724.1730114-1-david@fromorbit.com>
 <20201203084012.GA32480@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203084012.GA32480@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=5oyB3hKR7ax4ijZr7l8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 08:40:12AM +0000, Christoph Hellwig wrote:
> This looks pretty sensible, and pretty simple.  Why the RFC?
> 
> This looks good to me modulo a few tiny nitpicks below:
> 
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 1414ab79eacf..75b44b82ad1f 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -126,6 +126,7 @@ xfs_cleanup_inode(
> >  	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
> >  }
> >  
> > +
> >  STATIC int
> >  xfs_generic_create(
> >  	struct inode	*dir,
> 
> Nit: this adds a spuurious empty line.

Fixed.

> > @@ -161,7 +162,14 @@ xfs_generic_create(
> >  		goto out_free_acl;
> >  
> >  	if (!tmpfile) {
> > -		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
> > +		bool need_xattr = false;
> > +
> > +		if ((IS_ENABLED(CONFIG_SECURITY) && dir->i_sb->s_security) ||
> > +		    default_acl || acl)
> > +			need_xattr = true;
> > +
> > +		error = xfs_create(XFS_I(dir), &name, mode, rdev,
> > +					need_xattr, &ip);
> 
> It might be wort to factor the condition into a little helper.  Also
> I think we also have security labels for O_TMPFILE inodes, so it might
> be worth plugging into that path as well.

Yeah, a helper is a good idea - I just wanted to get some feedback
first on whether it's a good idea to peek directly at
i_sb->s_security or whether there is some other way of knowing ahead
of time that a security xattr is going to be created. I couldn't
find one, but that doesn't mean such an interface doesn't exist in
all the twisty passages of the LSM layers...

You didn't shout and run screaming, so that's a positive :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
