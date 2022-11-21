Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4543DC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 17:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiKURGF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 12:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiKURF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 12:05:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04993C8454
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 09:05:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F2F0B8122D
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 17:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A088C433C1;
        Mon, 21 Nov 2022 17:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669050352;
        bh=ZelmyPh/Smf5UeeG5+QUv4jU1KPIu7koayOr3Nuyhn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g3221mcE7mL2O8MkbFdtPbqn+gJ7piPHsUaCxPUJ56LkqYtf8eKXhrQwdKR5/QO1V
         f1P0Ep8MG1MebHfuhZKuGPHbFnoyJ7JU0axHtlyYUmvUPQEZa+hOV2Db7MWIHOUZgG
         3Ys2ubbaueLfbAG9l/eRskcz0AAwsvD89MCskQYD55WB2QAMhz7yf8VNx2uTHoRYVT
         qYe1lHo78vB4OmNL080bz8YkLmCy8fZC075tf+zhD9cb4aOalMTH8gleLgwsEuKboc
         3vpjw42+KzfFPeS45g6DTp8C8pOuFZ9kc+U07eR1aNq8DMr17SRBdAwFoG3+nkmqXQ
         K4PmRcBhVfMSg==
Date:   Mon, 21 Nov 2022 09:05:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_repair: retain superblock buffer to avoid write
 hook deadlock
Message-ID: <Y3uv78Hd7kwNTxId@magnolia>
References: <166795950005.3761353.14062544433865007925.stgit@magnolia>
 <Uf0fdI34dlM1ORE_68v6AZXXEZeCfwlkYDSXOweV8I1q6ixw-VRtZm7sf4t61T12RvBPHXWC7Gykw-Cus9pvNA==@protonmail.internalid>
 <166795953926.3761353.16847285987138337778.stgit@magnolia>
 <20221118144503.2nutef64wgf7z7wd@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118144503.2nutef64wgf7z7wd@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 18, 2022 at 03:45:03PM +0100, Carlos Maiolino wrote:
> > Fix this by retaining a reference to the superblock buffer when possible
> > so that the writeback hook doesn't have to access the buffer cache to
> > set NEEDSREPAIR.
> 
> This is the same one you sent for 5.19 that opened a discussion between
> retaining it at specific points, or at 'mount' time, wasn't it? Anyway, I think
> this is ok, we can try to do it at mount time in the future.

Correct, it hasn't changed since then.

--D

> 
> > 
> > Fixes: 3b7667cb ("xfs_repair: set NEEDSREPAIR the first time we write to a filesystem")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  libxfs/libxfs_api_defs.h |    2 +
> >  libxfs/libxfs_io.h       |    1 +
> >  libxfs/rdwr.c            |    8 +++++
> >  repair/phase2.c          |    8 +++++
> >  repair/protos.h          |    1 +
> >  repair/xfs_repair.c      |   75 ++++++++++++++++++++++++++++++++++++++++------
> >  6 files changed, 86 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> > index 2716a731bf..f8efcce777 100644
> > --- a/libxfs/libxfs_api_defs.h
> > +++ b/libxfs/libxfs_api_defs.h
> > @@ -53,9 +53,11 @@
> >  #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
> >  #define xfs_buf_get			libxfs_buf_get
> >  #define xfs_buf_get_uncached		libxfs_buf_get_uncached
> > +#define xfs_buf_lock			libxfs_buf_lock
> >  #define xfs_buf_read			libxfs_buf_read
> >  #define xfs_buf_read_uncached		libxfs_buf_read_uncached
> >  #define xfs_buf_relse			libxfs_buf_relse
> > +#define xfs_buf_unlock			libxfs_buf_unlock
> >  #define xfs_bunmapi			libxfs_bunmapi
> >  #define xfs_bwrite			libxfs_bwrite
> >  #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
> > diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> > index 9c0e2704d1..fae8642720 100644
> > --- a/libxfs/libxfs_io.h
> > +++ b/libxfs/libxfs_io.h
> > @@ -226,6 +226,7 @@ xfs_buf_hold(struct xfs_buf *bp)
> >  }
> > 
> >  void xfs_buf_lock(struct xfs_buf *bp);
> > +void xfs_buf_unlock(struct xfs_buf *bp);
> > 
> >  int libxfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags,
> >  		struct xfs_buf **bpp);
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index 20e0793c2f..d5aad3ea21 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -384,6 +384,14 @@ xfs_buf_lock(
> >  		pthread_mutex_lock(&bp->b_lock);
> >  }
> > 
> > +void
> > +xfs_buf_unlock(
> > +	struct xfs_buf	*bp)
> > +{
> > +	if (use_xfs_buf_lock)
> > +		pthread_mutex_unlock(&bp->b_lock);
> > +}
> > +
> >  static int
> >  __cache_lookup(
> >  	struct xfs_bufkey	*key,
> > diff --git a/repair/phase2.c b/repair/phase2.c
> > index 56a39bb456..2ada95aefd 100644
> > --- a/repair/phase2.c
> > +++ b/repair/phase2.c
> > @@ -370,6 +370,14 @@ phase2(
> >  	} else
> >  		do_log(_("Phase 2 - using internal log\n"));
> > 
> > +	/*
> > +	 * Now that we've set up the buffer cache the way we want it, try to
> > +	 * grab our own reference to the primary sb so that the hooks will not
> > +	 * have to call out to the buffer cache.
> > +	 */
> > +	if (mp->m_buf_writeback_fn)
> > +		retain_primary_sb(mp);
> > +
> >  	/* Zero log if applicable */
> >  	do_log(_("        - zero log...\n"));
> > 
> > diff --git a/repair/protos.h b/repair/protos.h
> > index 03ebae1413..83e471ff2a 100644
> > --- a/repair/protos.h
> > +++ b/repair/protos.h
> > @@ -16,6 +16,7 @@ int	get_sb(xfs_sb_t			*sbp,
> >  		xfs_off_t			off,
> >  		int			size,
> >  		xfs_agnumber_t		agno);
> > +int retain_primary_sb(struct xfs_mount *mp);
> >  void	write_primary_sb(xfs_sb_t	*sbp,
> >  			int		size);
> > 
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index 871b428d7d..ff29bea974 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -749,6 +749,63 @@ check_fs_vs_host_sectsize(
> >  	}
> >  }
> > 
> > +/*
> > + * If we set up a writeback function to set NEEDSREPAIR while the filesystem is
> > + * dirty, there's a chance that calling libxfs_getsb could deadlock the buffer
> > + * cache while trying to get the primary sb buffer if the first non-sb write to
> > + * the filesystem is the result of a cache shake.  Retain a reference to the
> > + * primary sb buffer to avoid all that.
> > + */
> > +static struct xfs_buf *primary_sb_bp;	/* buffer for superblock */
> > +
> > +int
> > +retain_primary_sb(
> > +	struct xfs_mount	*mp)
> > +{
> > +	int			error;
> > +
> > +	error = -libxfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR,
> > +			XFS_FSS_TO_BB(mp, 1), 0, &primary_sb_bp,
> > +			&xfs_sb_buf_ops);
> > +	if (error)
> > +		return error;
> > +
> > +	libxfs_buf_unlock(primary_sb_bp);
> > +	return 0;
> > +}
> > +
> > +static void
> > +drop_primary_sb(void)
> > +{
> > +	if (!primary_sb_bp)
> > +		return;
> > +
> > +	libxfs_buf_lock(primary_sb_bp);
> > +	libxfs_buf_relse(primary_sb_bp);
> > +	primary_sb_bp = NULL;
> > +}
> > +
> > +static int
> > +get_primary_sb(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_buf		**bpp)
> > +{
> > +	int			error;
> > +
> > +	*bpp = NULL;
> > +
> > +	if (!primary_sb_bp) {
> > +		error = retain_primary_sb(mp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	libxfs_buf_lock(primary_sb_bp);
> > +	xfs_buf_hold(primary_sb_bp);
> > +	*bpp = primary_sb_bp;
> > +	return 0;
> > +}
> > +
> >  /* Clear needsrepair after a successful repair run. */
> >  static void
> >  clear_needsrepair(
> > @@ -769,15 +826,14 @@ clear_needsrepair(
> >  		do_warn(
> >  	_("Cannot clear needsrepair due to flush failure, err=%d.\n"),
> >  			error);
> > -		return;
> > +		goto drop;
> >  	}
> > 
> >  	/* Clear needsrepair from the superblock. */
> > -	bp = libxfs_getsb(mp);
> > -	if (!bp || bp->b_error) {
> > +	error = get_primary_sb(mp, &bp);
> > +	if (error) {
> >  		do_warn(
> > -	_("Cannot clear needsrepair from primary super, err=%d.\n"),
> > -			bp ? bp->b_error : ENOMEM);
> > +	_("Cannot clear needsrepair from primary super, err=%d.\n"), error);
> >  	} else {
> >  		mp->m_sb.sb_features_incompat &=
> >  				~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > @@ -786,6 +842,8 @@ clear_needsrepair(
> >  	}
> >  	if (bp)
> >  		libxfs_buf_relse(bp);
> > +drop:
> > +	drop_primary_sb();
> >  }
> > 
> >  static void
> > @@ -808,11 +866,10 @@ force_needsrepair(
> >  	    xfs_sb_version_needsrepair(&mp->m_sb))
> >  		return;
> > 
> > -	bp = libxfs_getsb(mp);
> > -	if (!bp || bp->b_error) {
> > +	error = get_primary_sb(mp, &bp);
> > +	if (error) {
> >  		do_log(
> > -	_("couldn't get superblock to set needsrepair, err=%d\n"),
> > -				bp ? bp->b_error : ENOMEM);
> > +	_("couldn't get superblock to set needsrepair, err=%d\n"), error);
> >  	} else {
> >  		/*
> >  		 * It's possible that we need to set NEEDSREPAIR before we've
> > 
> 
> -- 
> Carlos Maiolino
