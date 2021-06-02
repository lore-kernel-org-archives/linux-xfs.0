Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B2AC4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 03:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F48D613CC
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 03:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhFBD34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 23:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231258AbhFBD34 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 23:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53B1D613B8;
        Wed,  2 Jun 2021 03:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622604494;
        bh=Ny2c5hUI6rdJ08FO3ViDUl/3WjVL5+WG17+j7QHzJII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OeKOIj6xHbkI4eDnboiF6go/VP8G1jX9LN6WJ82VP2qq0BWG2VJNw418HJXNxeWPx
         t7CHDMQqq00Oev+Hw/ZZTvxeQPyORckEzuf2BaJUhFZr0hYPCSBGVpiIeijtXRCpj9
         1iQksJPOOVTL68iFEGLkLQUQ+WBW1pZ4fHBB6iDNLjIkD9qqD9u/2z1hgRnmi1aG8+
         UP9dagfkrenWe3+zO5LFZGe0YGFGScrQ3Ju+LWVsWFPzE/+yJzzR46HV1//Tt3MJ7l
         /0KAB/f90giCVplpZ8V0TDFqquFuP8lxT+jr175pwWZCo+604cLlDyjQolCIyN4ETe
         fIAO9/FUSlKOg==
Date:   Tue, 1 Jun 2021 20:28:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 05/14] xfs: separate the dqrele_all inode grab logic from
 xfs_inode_walk_ag_grab
Message-ID: <20210602032813.GG26380@locust>
References: <162259515220.662681.6750744293005850812.stgit@locust>
 <162259518016.662681.13322964506776234493.stgit@locust>
 <20210602015147.GM664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602015147.GM664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 11:51:47AM +1000, Dave Chinner wrote:
> On Tue, Jun 01, 2021 at 05:53:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Disentangle the dqrele_all inode grab code from the "generic" inode walk
> > grabbing code, and and use the opportunity to document why the dqrele
> > grab function does what it does.  Since xfs_inode_walk_ag_grab is now
> > only used for blockgc, rename it to reflect that.
> > 
> > Ultimately, there will be four reasons to perform a walk of incore
> > inodes: quotaoff dquote releasing (dqrele), garbage collection of
> > speculative preallocations (blockgc), reclamation of incore inodes
> > (reclaim), and deferred inactivation (inodegc).  Each of these four have
> > their own slightly different criteria for deciding if they want to
> > handle an inode, so it makes more sense to have four cohesive igrab
> > functions than one confusing parameteric grab function like we do now.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 61 insertions(+), 5 deletions(-)
> 
> Looks ok - one minor nit:
> 
> > @@ -1642,6 +1682,22 @@ xfs_blockgc_free_quota(
> >  
> >  /* XFS Incore Inode Walking Code */
> >  
> > +static inline bool
> > +xfs_grabbed_for_walk(
> > +	enum xfs_icwalk_goal	goal,
> > +	struct xfs_inode	*ip,
> > +	int			iter_flags)
> > +{
> > +	switch (goal) {
> > +	case XFS_ICWALK_BLOCKGC:
> > +		return xfs_blockgc_igrab(ip, iter_flags);
> > +	case XFS_ICWALK_DQRELE:
> > +		return xfs_dqrele_igrab(ip);
> > +	default:
> > +		return false;
> > +	}
> > +}
> 
> xfs_icwalk_grab() seems to make more sense here.

Ok, changed.

> /me is wondering if all this should eventually end up under a
> xfs_icwalk namespace?

Yeah, I'll throw a renamer patch on the end of this series.  Or possibly
just do it after I move the xfs_inode_walk functions to the bottom.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
