Return-Path: <SRS0=YpFG=EF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2FCC00A89
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 08:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE30C2223F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 08:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eRWV8eyH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgJ3IRG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 04:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3IRF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Oct 2020 04:17:05 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E126AC0613D2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2020 01:17:05 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w11so2595499pll.8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2020 01:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nCaISzCNq+7VZ2H2RS+zbPymI3P07gEeY2wnFLrEziE=;
        b=eRWV8eyHa7+S46ZWfesa2fJzeY9tQTCNWI9aQe0sDbIdiKplYAsW+ySmcL7rrtWgOi
         ubSHXVZf610jsCwnvoAT0czMl2+A3U9l9O1qRbeO0Oute/zyxwwb0BVhLtzOvNKFRH1i
         4TnnWFEIg+4p53KYvquQVNDSxkavcERXZQ/a+Hba3aznOr936FfwwwKvauzrFB2Hts0X
         VMWFX5VlnwC2nskqg5DDS0gmTdMGP8Ri056YooAn6z49boZbITX99GEBpfGech8xdWOR
         90c66QkHyaTXedDpU9HfbZ4VCAPh2WpyzzRzakJu3XSBiO0/iqae4KCtB0iir+YPCcDh
         UmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nCaISzCNq+7VZ2H2RS+zbPymI3P07gEeY2wnFLrEziE=;
        b=rdXnqh5/UnrTT74XEWpOLIzYRzgZRh6/mMFVip2uzJhy4oQBVQPnltbg5Gtjqz9Drx
         PVvv/wl7qoxut1Tp5VrqIt0OqUZ9KOiq51otxxPNClswG7xo2PmOk9rQzdhLpUqGlPwv
         C+7YwjNSVEFgg/EyXwnqCu9omUlooL33Lz8R4jguKuwIGgEbLNDtE2XMEjAb4Bs1Xcbl
         pFuCAJc/XrLmvnWtL7Svq7RBT7RWi/dsfYZ2Y3wVTj4mLKOfPAc9ZRf4gW3VrBdwiqfI
         0hki9OaBh9DRmjlMP4+QMYywPUdVcj0bQ9HPIeMWqfDvxdVgqj107jdJ62swZKprrDbb
         /U5A==
X-Gm-Message-State: AOAM5334NdmWB1Nq2kGscmDHhmM5BchYnDA5gahEmxexq9ZDveJmzsfE
        o92P2ARhTQytW6BrIXtxD+0=
X-Google-Smtp-Source: ABdhPJxQnkVqmQLlyoAt2ZHuwNEflcRWT3vZvVngx2ymx2o5NOdO3ywq5Z7B2MqU2xWFAP1NWBb8Ig==
X-Received: by 2002:a17:902:c286:b029:d6:6cbd:eabf with SMTP id i6-20020a170902c286b02900d66cbdeabfmr7483964pld.41.1604045825369;
        Fri, 30 Oct 2020 01:17:05 -0700 (PDT)
Received: from garuda.localnet ([122.182.226.101])
        by smtp.gmail.com with ESMTPSA id s23sm4570904pgl.47.2020.10.30.01.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 01:17:04 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V8 14/14] xfs: Introduce error injection to allocate only minlen size extents for files
Date:   Fri, 30 Oct 2020 13:47:01 +0530
Message-ID: <2138688.a7ZTlQ0SA2@garuda>
In-Reply-To: <20201029223348.GO1061252@magnolia>
References: <20201029101348.4442-1-chandanrlinux@gmail.com> <20201029101348.4442-15-chandanrlinux@gmail.com> <20201029223348.GO1061252@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 30 October 2020 4:03:48 AM IST Darrick J. Wong wrote:
> On Thu, Oct 29, 2020 at 03:43:48PM +0530, Chandan Babu R wrote:
> > This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
> > helps userspace test programs to get xfs_bmap_btalloc() to always
> > allocate minlen sized extents.
> > 
> > This is required for test programs which need a guarantee that minlen
> > extents allocated for a file do not get merged with their existing
> > neighbours in the inode's BMBT. "Inode fork extent overflow check" for
> > Directories, Xattrs and extension of realtime inodes need this since the
> > file offset at which the extents are being allocated cannot be
> > explicitly controlled from userspace.
> > 
> > One way to use this error tag is to,
> > 1. Consume all of the free space by sequentially writing to a file.
> > 2. Punch alternate blocks of the file. This causes CNTBT to contain
> >    sufficient number of one block sized extent records.
> > 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> > After step 3, xfs_bmap_btalloc() will issue space allocation
> > requests for minlen sized extents only.
> > 
> > ENOSPC error code is returned to userspace when there aren't any "one
> > block sized" extents left in any of the AGs.
> 
> I don't see any new ENOSPC returns in this patch.  Does this comment
> merely confirm that we'll return ENOSPC when we run out of space, like
> all the other allocators?
> 
> Or is there another subtlety to this statement?  Such as ... we'll
> return ENOSPC when there are no more single-block free space extents,
> even if there are still larger chunks of free space?

We will return ENOSPC when there are no minlen sized extents left even though
larger sized free extents might still be present. However, ENOSPC error code
itself is returned by higher layer functions (e.g. xfs_iomap_write_direct())
when they find that xfs_bmapi_write() returned with zero mappings.

> 
> Also, I thought this patch made it so that we always allocate minlen,
> which doesn't necessarily mean single blocks?

Apart from directories, none of the other users of xfs_bmapi_write() function
pass XFS_BMAPI_CONTIG flag. Hence for these cases, xfs_bmapi_allocate() would
set xfs_bmalloca->minlen to 1.

The purpose of the error tag introduced in this patchset was to enable
userspace to be able to deterministic-ally count the number of extents that
get allocated for data/attr fork of an inode. Hence I think this patch should
limit allocation requests to one-block sized extents.

The following can be added at the beginning of
xfs_bmap_exact_minlen_extent_alloc() forcing allocations of single filesystem
blocks.

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 74e148cc41b2..af8259ad6c71 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3565,6 +3565,13 @@ xfs_bmap_exact_minlen_extent_alloc(
        int                     error;

        ASSERT(ap->length);
+
+       if (ap->minlen != 1) {
+               ap->blkno = NULLFSBLOCK;
+               ap->length = 0;
+               return 0;
+       }
+
        orig_offset = ap->offset;
        orig_length = ap->length;

> 
> > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c    |  50 ++++++++++++++++++
> >  fs/xfs/libxfs/xfs_alloc.h    |   3 ++
> >  fs/xfs/libxfs/xfs_bmap.c     | 100 +++++++++++++++++++++++++++++++----
> >  fs/xfs/libxfs/xfs_errortag.h |   4 +-
> >  fs/xfs/xfs_error.c           |   3 ++
> >  5 files changed, 150 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 852b536551b5..a7c4eb1d71d5 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2473,6 +2473,47 @@ xfs_defer_agfl_block(
> >  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
> >  }
> >  
> > +#ifdef DEBUG
> > +/*
> > + * Check if an AGF has a free extent record whose length is equal to
> > + * args->minlen.
> > + */
> > +STATIC int
> > +xfs_exact_minlen_extent_available(
> > +	struct xfs_alloc_arg	*args,
> > +	struct xfs_buf		*agbp,
> > +	int			*stat)
> > +{
> > +	struct xfs_btree_cur	*cnt_cur;
> > +	xfs_agblock_t		fbno;
> > +	xfs_extlen_t		flen;
> > +	int			error = 0;
> > +
> > +	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
> > +			args->agno, XFS_BTNUM_CNT);
> > +	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
> > +	if (error)
> > +		goto out;
> > +
> > +	if (*stat == 0) {
> > +		error = -EFSCORRUPTED;
> > +		goto out;
> > +	}
> > +
> > +	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
> > +	if (error)
> > +		goto out;
> > +
> > +	if (*stat == 1 && flen != args->minlen)
> > +		*stat = 0;
> > +
> > +out:
> > +	xfs_btree_del_cursor(cnt_cur, error);
> > +
> > +	return error;
> > +}
> > +#endif
> > +
> >  /*
> >   * Decide whether to use this allocation group for this allocation.
> >   * If so, fix up the btree freelist's size.
> > @@ -2544,6 +2585,15 @@ xfs_alloc_fix_freelist(
> >  	if (!xfs_alloc_space_available(args, need, flags))
> >  		goto out_agbp_relse;
> >  
> > +#ifdef DEBUG
> > +	if (args->alloc_minlen_only) {
> > +		int stat;
> > +
> > +		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
> > +		if (error || !stat)
> > +			goto out_agbp_relse;
> > +	}
> > +#endif
> >  	/*
> >  	 * Make the freelist shorter if it's too long.
> >  	 *
> > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > index 6c22b12176b8..a4427c5775c2 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.h
> > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > @@ -75,6 +75,9 @@ typedef struct xfs_alloc_arg {
> >  	char		wasfromfl;	/* set if allocation is from freelist */
> >  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
> >  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> > +#ifdef DEBUG
> > +	bool		alloc_minlen_only; /* allocate exact minlen extent */
> > +#endif
> >  } xfs_alloc_arg_t;
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 88db23afc51c..74e148cc41b2 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3474,11 +3474,13 @@ xfs_bmap_compute_alignments(
> >  	int			error;
> >  
> >  	/* stripe alignment for allocation is determined by mount parameters */
> > -	*stripe_align = 0;
> > -	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > -		*stripe_align = mp->m_swidth;
> > -	else if (mp->m_dalign)
> > -		*stripe_align = mp->m_dalign;
> > +	if (stripe_align) {
> > +		*stripe_align = 0;
> > +		if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > +			*stripe_align = mp->m_swidth;
> > +		else if (mp->m_dalign)
> > +			*stripe_align = mp->m_dalign;
> > +	}
> >  
> >  	if (ap->flags & XFS_BMAPI_COWFORK)
> >  		align = xfs_get_cowextsz_hint(ap->ip);
> > @@ -3551,6 +3553,71 @@ xfs_bmap_process_allocated_extent(
> >  	xfs_bmap_btalloc_accounting(ap, args);
> >  }
> >  
> > +#ifdef DEBUG
> > +static int
> > +xfs_bmap_exact_minlen_extent_alloc(
> > +	struct xfs_bmalloca	*ap)
> > +{
> > +	struct xfs_alloc_arg	args;
> > +	struct xfs_mount	*mp = ap->ip->i_mount;
> > +	xfs_fileoff_t		orig_offset;
> > +	xfs_extlen_t		orig_length;
> > +	int			error;
> > +
> > +	ASSERT(ap->length);
> > +	orig_offset = ap->offset;
> > +	orig_length = ap->length;
> > +
> > +	memset(&args, 0, sizeof(args));
> > +	args.alloc_minlen_only = 1;
> > +	args.tp = ap->tp;
> > +	args.mp = mp;
> > +
> > +	xfs_bmap_compute_alignments(ap, &args, NULL);
> > +
> > +	if (ap->tp->t_firstblock == NULLFSBLOCK) {
> > +		/*
> > +		 * Unlike the longest extent available in an AG, we don't track
> > +		 * the length of an AG's shortest extent.
> > +		 * XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is a debug only knob and
> > +		 * hence we can afford to start traversing from the 0th AG since
> > +		 * we need not be concerned about a drop in performance in
> > +		 * "debug only" code paths.
> > +		 */
> > +		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
> > +	} else {
> > +		ap->blkno = ap->tp->t_firstblock;
> > +	}
> > +
> > +	args.fsbno = ap->blkno;
> > +	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> > +	args.type = XFS_ALLOCTYPE_FIRST_AG;
> > +	args.total = args.minlen = args.maxlen = ap->minlen;
> > +
> > +	args.alignment = 1;
> > +	args.minalignslop = 0;
> > +
> > +	args.minleft = ap->minleft;
> > +	args.wasdel = ap->wasdel;
> > +	args.resv = XFS_AG_RESV_NONE;
> > +	args.datatype = ap->datatype;
> > +
> > +	error = xfs_alloc_vextent(&args);
> > +	if (error)
> > +		return error;
> > +
> > +	if (args.fsbno != NULLFSBLOCK) {
> > +		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
> > +			orig_length);
> > +	} else {
> > +		ap->blkno = NULLFSBLOCK;
> > +		ap->length = 0;
> > +	}
> > +
> > +	return 0;
> > +}
> > +#endif
> 
> Urgh, I don't like how the else bodies below are split by the
> prepreprocessor directives.  Could you add an #else clause here to
> 
> #define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
> 
> so that we don't need to do that splitting below?

Sure, That would make the code a lot more readable. Thanks for the
suggestion.

> 
> The rest looks ok though.
> 
> --D
> 
> > +
> >  STATIC int
> >  xfs_bmap_btalloc(
> >  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> > @@ -4112,7 +4179,13 @@ xfs_bmap_alloc_userdata(
> >  			return xfs_bmap_rtalloc(bma);
> >  	}
> >  
> > -	return xfs_bmap_btalloc(bma);
> > +#ifdef DEBUG
> > +	if (unlikely(XFS_TEST_ERROR(false, mp,
> > +			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> > +		return xfs_bmap_exact_minlen_extent_alloc(bma);
> > +	else
> > +#endif
> > +		return xfs_bmap_btalloc(bma);
> >  }
> >  
> >  static int
> > @@ -4148,10 +4221,19 @@ xfs_bmapi_allocate(
> >  	else
> >  		bma->minlen = 1;
> >  
> > -	if (bma->flags & XFS_BMAPI_METADATA)
> > -		error = xfs_bmap_btalloc(bma);
> > -	else
> > +	if (bma->flags & XFS_BMAPI_METADATA) {
> > +#ifdef DEBUG
> > +		if (unlikely(XFS_TEST_ERROR(false, mp,
> > +				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> > +			error = xfs_bmap_exact_minlen_extent_alloc(bma);
> > +		else
> > +#endif
> > +			error = xfs_bmap_btalloc(bma);
> > +
> > +
> > +	} else {
> >  		error = xfs_bmap_alloc_userdata(bma);
> > +	}
> >  	if (error || bma->blkno == NULLFSBLOCK)
> >  		return error;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> > index 1c56fcceeea6..6ca9084b6934 100644
> > --- a/fs/xfs/libxfs/xfs_errortag.h
> > +++ b/fs/xfs/libxfs/xfs_errortag.h
> > @@ -57,7 +57,8 @@
> >  #define XFS_ERRTAG_IUNLINK_FALLBACK			34
> >  #define XFS_ERRTAG_BUF_IOERROR				35
> >  #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> > -#define XFS_ERRTAG_MAX					37
> > +#define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
> > +#define XFS_ERRTAG_MAX					38
> >  
> >  /*
> >   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> > @@ -99,5 +100,6 @@
> >  #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
> >  #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
> >  #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
> > +#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
> >  
> >  #endif /* __XFS_ERRORTAG_H_ */
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index 3780b118cc47..185b4915b7bf 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -55,6 +55,7 @@ static unsigned int xfs_errortag_random_default[] = {
> >  	XFS_RANDOM_IUNLINK_FALLBACK,
> >  	XFS_RANDOM_BUF_IOERROR,
> >  	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
> > +	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
> >  };
> >  
> >  struct xfs_errortag_attr {
> > @@ -166,6 +167,7 @@ XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
> >  XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
> >  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> >  XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
> > +XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
> >  
> >  static struct attribute *xfs_errortag_attrs[] = {
> >  	XFS_ERRORTAG_ATTR_LIST(noerror),
> > @@ -205,6 +207,7 @@ static struct attribute *xfs_errortag_attrs[] = {
> >  	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
> >  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
> >  	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
> > +	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
> >  	NULL,
> >  };
> >  
> 


-- 
chandan



