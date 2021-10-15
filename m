Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ABB4C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 00:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F3B861151
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 00:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbhJOAqz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 20:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234622AbhJOAqz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 20:46:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCE0E6108B;
        Fri, 15 Oct 2021 00:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634258689;
        bh=iIdSJF1ZAlDZ3I2DRN546+3Zfknvy2sxGXSvHrmq3RI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=At3Jhzd6/7NEBYC86h7lEHhc+71uepjkcR4HrQf1ABKHhR4jnHI/Bk+vA4Xeci8m4
         iGz1mrEtXIm2ZtG2RErpneruamyS6JvwzsjEQa225PJyBUODmJi2GGNWzGfunmqNrR
         MxYa9TrhWjiI1aTcAWM/uncECbF2JOQeLf4X6xGhO0Eb5ngj0jJnZNIaJ5L01u06s0
         4u3jbB8tFH4Grq5GoTwhrEs0j0QDhLUv8pDahdPyk19+vLjNMY643f4cffFbtEkxCp
         4RGb9P3Juqfv7AWCedhAimA2tCDJTDJYHwaCzBzeI6E6o0lcl5PIgRDKeC1tHLupug
         +Ww/hsTe1LDAA==
Date:   Thu, 14 Oct 2021 17:44:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 12/17] xfs: compute maximum AG btree height for critical
 reservation calculation
Message-ID: <20211015004449.GQ24307@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424268093.756780.1167437160420772989.stgit@magnolia>
 <20211014225447.GR2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014225447.GR2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 15, 2021 at 09:54:47AM +1100, Dave Chinner wrote:
> On Thu, Oct 14, 2021 at 01:18:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Compute the actual maximum AG btree height for deciding if a per-AG
> > block reservation is critically low.  This only affects the sanity check
> > condition, since we /generally/ will trigger on the 10% threshold.  This
> > is a long-winded way of saying that we're removing one more usage of
> > XFS_BTREE_MAXLEVELS.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_ag_resv.c |    3 ++-
> >  fs/xfs/xfs_mount.c          |   14 ++++++++++++++
> >  fs/xfs/xfs_mount.h          |    1 +
> >  3 files changed, 17 insertions(+), 1 deletion(-)
> 
> One minor nit below, otherwise it looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> > index 2aa2b3484c28..fe94058d4e9e 100644
> > --- a/fs/xfs/libxfs/xfs_ag_resv.c
> > +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> > @@ -91,7 +91,8 @@ xfs_ag_resv_critical(
> >  	trace_xfs_ag_resv_critical(pag, type, avail);
> >  
> >  	/* Critically low if less than 10% or max btree height remains. */
> > -	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
> > +	return XFS_TEST_ERROR(avail < orig / 10 ||
> > +			      avail < pag->pag_mount->m_agbtree_maxlevels,
> >  			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
> >  }
> >  
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 06dac09eddbd..5be1dd63fac5 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -567,6 +567,18 @@ xfs_mount_setup_inode_geom(
> >  	xfs_ialloc_setup_geometry(mp);
> >  }
> >  
> > +/* Compute maximum possible height for per-AG btree types for this fs. */
> > +static inline void
> > +xfs_agbtree_compute_maxlevels(
> > +	struct xfs_mount	*mp)
> > +{
> > +	unsigned int		ret;
> > +
> > +	ret = max(mp->m_alloc_maxlevels, M_IGEO(mp)->inobt_maxlevels);
> > +	ret = max(ret, mp->m_rmap_maxlevels);
> > +	mp->m_agbtree_maxlevels = max(ret, mp->m_refc_maxlevels);
> > +}
> 
> "ret" should really be named "levels" here because it's not a return
> value anymore...

Fixed.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
