Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823ABC388F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 03:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3222220878
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 03:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ov15loRb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418685AbgJZDX0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Oct 2020 23:23:26 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50381 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1418058AbgJZDX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Oct 2020 23:23:26 -0400
Received: by mail-pj1-f66.google.com with SMTP id p21so2424461pju.0
        for <linux-xfs@vger.kernel.org>; Sun, 25 Oct 2020 20:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4IM5WQPMmjRs/RLJidSlXp2yoXqUgayxvOL56ZoOe1A=;
        b=ov15loRbtjKZyy9d1DyCf9HK8t6NHhGe5auoaPK/vEjSMv/Z7mGafMsqkt4tq4hPE/
         Yd+QUq9sfNKzmhaTrWWH+QbJJbTmztFh9V91xJGJc3zMEsrGwD//04kYP7NXDpLmg0Zo
         pTVoyW/26ChTQCIm4lS5ZaxnMd07MjjaUyBfNT7garWb/5K0v6Ynms7OHn0zxLYF8Yyg
         Z+6UURmVnavqxavL9/xpIKmsKb2He6TIM0g2e/LPaz7RRjQRPcQpxa7PvGLmLOY4/QUp
         lkNUR4vnj2JJIn9Z68aNRSAydxjd40lsLuVBtZT+89LEcwExRAEvV9dpq3cp2GLUuZmx
         f8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4IM5WQPMmjRs/RLJidSlXp2yoXqUgayxvOL56ZoOe1A=;
        b=C9c7JknA59iIt6Wt6NiKbXRXdsE0xiv+aYpmPUMgvGn4D9byyPnumoZQvffZZ4+AmX
         7+r7keHsXwzeq/Adcwu1tyOwxTKgdqCYR8OWsve1M24LF2n6F/2MM8MJlvv96ufbcFpo
         HrkH3PCktXiPMaK56fSyzXPsy7vrk5WE1UFFOTsfVa6R2SiXneEM02wFTrPeU55x8e1/
         2MfrbTOPjGTzi7STfX8tgQFgOWn+BSn0Vk1xTQzgm55Rh8t37J6PREXaWx9oaIT83DTs
         JwvrzRDsy+zQtpMJMnG7yyc1b7uex7iJg96sdzwUWZWPBRWA6cEYX9YHqhpKNXoC4uOl
         fXyg==
X-Gm-Message-State: AOAM531ly3l3sohMZMCMbUGCv77wGY1hkzfbBkWjVQJRQHx8X/rtAWT7
        PZYm54MEH/b8rtQWQ9PAW6A=
X-Google-Smtp-Source: ABdhPJxw2txz9lDRv5742c8tn0YVvFuifsJph/L+7Yxu4WQYrcupBA0LdL9tcCYT0bczoOreLlATHQ==
X-Received: by 2002:a17:90a:c1:: with SMTP id v1mr14284260pjd.89.1603682605140;
        Sun, 25 Oct 2020 20:23:25 -0700 (PDT)
Received: from garuda.localnet ([122.167.144.110])
        by smtp.gmail.com with ESMTPSA id j11sm10030636pfh.143.2020.10.25.20.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 20:23:24 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V7 14/14] xfs: Introduce error injection to allocate only minlen size extents for files
Date:   Mon, 26 Oct 2020 08:53:21 +0530
Message-ID: <2166998.mU4Sq72Tuv@garuda>
In-Reply-To: <8878dee5-c3d4-0bf5-ead9-d4682fafdf6f@oracle.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com> <20201019064048.6591-15-chandanrlinux@gmail.com> <8878dee5-c3d4-0bf5-ead9-d4682fafdf6f@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday 25 October 2020 6:52:53 AM IST Allison Henderson wrote:
> 
> On 10/18/20 11:40 PM, Chandan Babu R wrote:
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
> >     sufficient number of one block sized extent records.
> > 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> > After step 3, xfs_bmap_btalloc() will issue space allocation
> > requests for minlen sized extents only.
> > 
> > ENOSPC error code is returned to userspace when there aren't any "one
> > block sized" extents left in any of the AGs.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >   fs/xfs/libxfs/xfs_alloc.c    |  50 ++++++++++++++++++
> >   fs/xfs/libxfs/xfs_alloc.h    |   3 ++
> >   fs/xfs/libxfs/xfs_bmap.c     | 100 +++++++++++++++++++++++++++++++----
> >   fs/xfs/libxfs/xfs_errortag.h |   4 +-
> >   fs/xfs/xfs_error.c           |   3 ++
> >   5 files changed, 150 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 852b536551b5..8e132f8b9cc4 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2473,6 +2473,47 @@ xfs_defer_agfl_block(
> >   	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
> >   }
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
> >   /*
> >    * Decide whether to use this allocation group for this allocation.
> >    * If so, fix up the btree freelist's size.
> > @@ -2544,6 +2585,15 @@ xfs_alloc_fix_freelist(
> >   	if (!xfs_alloc_space_available(args, need, flags))
> >   		goto out_agbp_relse;
> >   
> > +#ifdef DEBUG
> > +	if (args->alloc_minlen_only) {
> > +		int i;
> Just a nit: I think "i" seems like a bit of an odd name here.  I think I 
> might have called it stat to match its parameter name.  Other than that, 
> I think the rest looks ok.

Ok, I will rename "i" with "stat" as you have suggested.

Thank you for reviewing the patchset.

> 
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Allison
> > +
> > +		error = xfs_exact_minlen_extent_available(args, agbp, &i);
> > +		if (error || !i)
> > +			goto out_agbp_relse;
> > +	}
> > +#endif
> >   	/*
> >   	 * Make the freelist shorter if it's too long.
> >   	 *
> > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > index 6c22b12176b8..a4427c5775c2 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.h
> > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > @@ -75,6 +75,9 @@ typedef struct xfs_alloc_arg {
> >   	char		wasfromfl;	/* set if allocation is from freelist */
> >   	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
> >   	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> > +#ifdef DEBUG
> > +	bool		alloc_minlen_only; /* allocate exact minlen extent */
> > +#endif
> >   } xfs_alloc_arg_t;
> >   
> >   /*
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 88db23afc51c..74e148cc41b2 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3474,11 +3474,13 @@ xfs_bmap_compute_alignments(
> >   	int			error;
> >   
> >   	/* stripe alignment for allocation is determined by mount parameters */
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
> >   	if (ap->flags & XFS_BMAPI_COWFORK)
> >   		align = xfs_get_cowextsz_hint(ap->ip);
> > @@ -3551,6 +3553,71 @@ xfs_bmap_process_allocated_extent(
> >   	xfs_bmap_btalloc_accounting(ap, args);
> >   }
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
> > +
> >   STATIC int
> >   xfs_bmap_btalloc(
> >   	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> > @@ -4112,7 +4179,13 @@ xfs_bmap_alloc_userdata(
> >   			return xfs_bmap_rtalloc(bma);
> >   	}
> >   
> > -	return xfs_bmap_btalloc(bma);
> > +#ifdef DEBUG
> > +	if (unlikely(XFS_TEST_ERROR(false, mp,
> > +			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> > +		return xfs_bmap_exact_minlen_extent_alloc(bma);
> > +	else
> > +#endif
> > +		return xfs_bmap_btalloc(bma);
> >   }
> >   
> >   static int
> > @@ -4148,10 +4221,19 @@ xfs_bmapi_allocate(
> >   	else
> >   		bma->minlen = 1;
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
> >   		error = xfs_bmap_alloc_userdata(bma);
> > +	}
> >   	if (error || bma->blkno == NULLFSBLOCK)
> >   		return error;
> >   
> > diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> > index 1c56fcceeea6..6ca9084b6934 100644
> > --- a/fs/xfs/libxfs/xfs_errortag.h
> > +++ b/fs/xfs/libxfs/xfs_errortag.h
> > @@ -57,7 +57,8 @@
> >   #define XFS_ERRTAG_IUNLINK_FALLBACK			34
> >   #define XFS_ERRTAG_BUF_IOERROR				35
> >   #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> > -#define XFS_ERRTAG_MAX					37
> > +#define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
> > +#define XFS_ERRTAG_MAX					38
> >   
> >   /*
> >    * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> > @@ -99,5 +100,6 @@
> >   #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
> >   #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
> >   #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
> > +#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
> >   
> >   #endif /* __XFS_ERRORTAG_H_ */
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index 3780b118cc47..185b4915b7bf 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -55,6 +55,7 @@ static unsigned int xfs_errortag_random_default[] = {
> >   	XFS_RANDOM_IUNLINK_FALLBACK,
> >   	XFS_RANDOM_BUF_IOERROR,
> >   	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
> > +	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
> >   };
> >   
> >   struct xfs_errortag_attr {
> > @@ -166,6 +167,7 @@ XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
> >   XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
> >   XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> >   XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
> > +XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
> >   
> >   static struct attribute *xfs_errortag_attrs[] = {
> >   	XFS_ERRORTAG_ATTR_LIST(noerror),
> > @@ -205,6 +207,7 @@ static struct attribute *xfs_errortag_attrs[] = {
> >   	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
> >   	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
> >   	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
> > +	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
> >   	NULL,
> >   };
> >   
> > 
> 


-- 
chandan



