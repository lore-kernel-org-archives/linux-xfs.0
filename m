Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07784C41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 09:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980D32078E
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 09:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="koG6EKur"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgJFJVe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFJVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 05:21:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02017C061755
        for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2020 02:21:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id o8so922780pll.4
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2020 02:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IHB01l4yW8d3vUIQXeIjmsawkAdqIkd6biUp7w8w7xY=;
        b=koG6EKurvtHGQGlJqK1vjT+0pN9Ou/EZVdkIUgd8M5S2h93OMQM1PKHumMXSQaqCT2
         rCHO6pnzU1bROrNu07EMBfDaQWTJBaS56P1qZ/2PRC2uoxk8n4NLfi4yR4PvbBQUs+1c
         XrBaVgL3Zr1fo7R+b0Ro+mnmHkR4agjTJkbz/ZZlI0lk5htBbXE18X/HguoUKKDz6uNS
         vSJjRXBN9M8faGgLJ3lUrACm7KnQIkRytwwkybK0PcRw+864+n/sYdwHuhm2FrMTB4nH
         WRX7j7aM4zWTookYJ1tC6iQM7g7CjMjnQ7fpNP/LoOrl17hIKyqbU9xvkubmqRE10I3Y
         hXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IHB01l4yW8d3vUIQXeIjmsawkAdqIkd6biUp7w8w7xY=;
        b=BRr2wkgzFjmqMQsQXmmnG3FzxkUq1VfgmgdGMQVab4nTt7sUvKURwzMCeAVVUdzktl
         9PapvkZYYJagKfVxM6H0NIvxTXKxIlS8RtLQy+zyqvUxxh3W2mZORD+DYP2YqLyITFpj
         11x9LlmrFWs5SEgfz/RBLYorrKqfRj/DlHG6qjhoZmbJPMrzYTf3HjLreh0zFPOCTJaz
         pOoOXb58qGZWYohHBQlsXlCElbIe4T+Wy2j7YTHpQRYcKkVy0GiSclVLWLkBNmUPWO9o
         HWZN4j8M3+PJLEdWFqsS8ylnMHoNQbDKG0UI6xf8ucKnl7xRYKfmNauGXFbhxcTI1ZCZ
         S7wQ==
X-Gm-Message-State: AOAM533hNh5LaxvhtEY0CH7BILpnZScunz129Zng+M5lykSTmcc+4BoH
        wPe6btseJwjcck0ZxNETwDk=
X-Google-Smtp-Source: ABdhPJxVX2+H5+/58q2kkzLf9AXLjnXYC0zwYpvv85J/lQnQuv4Svp7fi59FRzslPm2ae47y14DwQg==
X-Received: by 2002:a17:902:a5c5:b029:d3:5fd4:be2f with SMTP id t5-20020a170902a5c5b02900d35fd4be2fmr2389467plq.5.1601976093333;
        Tue, 06 Oct 2020 02:21:33 -0700 (PDT)
Received: from garuda.localnet ([122.167.153.52])
        by smtp.gmail.com with ESMTPSA id q14sm2390630pgl.38.2020.10.06.02.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 02:21:32 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 12/12] xfs: Introduce error injection to allocate only minlen size extents for files
Date:   Tue, 06 Oct 2020 14:47:02 +0530
Message-ID: <1977666.2q3HRY3AOK@garuda>
In-Reply-To: <20201006043424.GS49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com> <20201003055633.9379-13-chandanrlinux@gmail.com> <20201006043424.GS49547@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 6 October 2020 10:04:24 AM IST Darrick J. Wong wrote:
> On Sat, Oct 03, 2020 at 11:26:33AM +0530, Chandan Babu R wrote:
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
> 
> Is step #2 required?  What happens if I only turn the knob?

If there are no minlen sized free space extents in the CNTBT, we would return
-ENOSPC to the userspace process. The reason behind forcing allocation of
minlen sized CNTBT records is to make sure that these newly allocated extents
do not get merged with their neighbouring extents in the inode's BMBT. On the
other hand, if we did allow slicing off minlen sized chunks of a larger free
space extent record in the CNTBT, the newly allocated extent records could be
contiguous (w.r.t both disk offset and file offset) with its neighbours in the
BMBT and hence merged, therby reducing inode fork extent count. This will
prevent us from writing deterministic "Inode extent count overflow" tests for
Directories, xattrs and realtime inodes.

> > ENOSPC error code is returned to userspace when there aren't any "one
> > block sized" extents left in any of the AGs.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c    | 46 ++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_alloc.h    |  1 +
> >  fs/xfs/libxfs/xfs_bmap.c     | 26 ++++++++++++++------
> >  fs/xfs/libxfs/xfs_errortag.h |  4 +++-
> >  fs/xfs/xfs_error.c           |  3 +++
> >  5 files changed, 72 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 852b536551b5..d8d8ab1478db 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2473,6 +2473,45 @@ xfs_defer_agfl_block(
> >  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
> >  }
> >  
> > +STATIC int
> > +minlen_freespace_available(
> 
> This ought to have an 'xfs_' prefix.

Ok. I will fix this up.
> 
> Also, what does this function do?  Does it decide if there's even enough
> space to go ahead with a minlen allocation?

I will come up with a better name for this function. This function checks if
there is a freespace extent record whose length is exactly equal to
args->minlen.

> 
> > +	struct xfs_alloc_arg	*args,
> > +	struct xfs_buf		*agbp,
> > +	int			*stat)
> > +{
> > +	xfs_btree_cur_t		*cnt_cur;
> 
> struct xfs_btree_cur	*cnt_cur;

Sorry, I will fix that up.

> 
> > +	xfs_agblock_t		fbno;
> > +	xfs_extlen_t		flen;
> > +	int			btree_error = XFS_BTREE_NOERROR;
> > +	int			error = 0;
> > +
> > +	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
> > +			args->agno, XFS_BTNUM_CNT);
> > +	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
> > +	if (error) {
> > +		btree_error = XFS_BTREE_ERROR;
> > +		goto out;
> > +	}
> > +
> > +	ASSERT(*stat == 1);
> 
> Is it ok to keep going with stat==0?  Or should we just ... I don't
> know?  Bail out with -EFSCORRUPTED?

I think returning with -EFSCORRUPTED is a better option since before
executing the code here, we would have already executed
xfs_alloc_space_available() to make sure that atleast minlen free space is
available in the AG whose CNTBT is being traversed. Thanks for the
suggestion.

> 
> > +
> > +	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
> > +	if (error) {
> > +		btree_error = XFS_BTREE_ERROR;
> > +		goto out;
> > +	}
> > +
> > +	if (flen == args->minlen)
> > +		*stat = 1;
> > +	else
> > +		*stat = 0;
> > +
> > +out:
> > +	xfs_btree_del_cursor(cnt_cur, btree_error);
> 
> Note that due to a sloppy quirk of error handling, you can pass @error
> to this function, no need for a separate btree_error.

Ok. Thanks for pointing that out. I will fix this.

> 
> > +
> > +	return error;
> > +}
> > +
> >  /*
> >   * Decide whether to use this allocation group for this allocation.
> >   * If so, fix up the btree freelist's size.
> > @@ -2490,6 +2529,7 @@ xfs_alloc_fix_freelist(
> >  	struct xfs_alloc_arg	targs;	/* local allocation arguments */
> >  	xfs_agblock_t		bno;	/* freelist block */
> >  	xfs_extlen_t		need;	/* total blocks needed in freelist */
> > +	int			i;
> >  	int			error = 0;
> >  
> >  	/* deferred ops (AGFL block frees) require permanent transactions */
> > @@ -2544,6 +2584,12 @@ xfs_alloc_fix_freelist(
> >  	if (!xfs_alloc_space_available(args, need, flags))
> >  		goto out_agbp_relse;
> >  
> > +	if (args->alloc_minlen_only) {
> > +		error = minlen_freespace_available(args, agbp, &i);
> > +		if (error || !i)
> > +			goto out_agbp_relse;
> > +	}
> > +
> >  	/*
> >  	 * Make the freelist shorter if it's too long.
> >  	 *
> > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > index 6c22b12176b8..1d04089b7fb4 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.h
> > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > @@ -75,6 +75,7 @@ typedef struct xfs_alloc_arg {
> >  	char		wasfromfl;	/* set if allocation is from freelist */
> >  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
> >  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> > +	bool		alloc_minlen_only;
> >  } xfs_alloc_arg_t;
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 5156cbd476f2..fab4097e7492 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3510,12 +3510,19 @@ xfs_bmap_btalloc(
> >  		ASSERT(ap->length);
> >  	}
> >  
> > +	memset(&args, 0, sizeof(args));
> > +
> > +	args.alloc_minlen_only = XFS_TEST_ERROR(false, mp,
> > +					XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
> 
> Can we just set maxlen = minlen here?

I had noticed that xfs_bmap_btalloc() is structured as described below,
1. Compute the appropriate filesystem-wide block number (and hence the AG)
   to start searching for free space extents.
2. Compute xfs_alloc_arg->{type, total, minlen, maxlen}.
3. Compute xfs_alloc_arg->alignment and adjust xfs_alloc_arg->{type, maxlen}
   as required.
4. Invoke xfs_alloc_vextent().

To keep up with the existing code flow, I had set
xfs_alloc_args->{minlen, maxlen, total} to xfs_bmalloca->minlen at function
location corresponding to step 2.

> 
> Also, should this debug knob also be applied to rt file allocations?

I had missed xfs_bmap_alloc_userdata() => xfs_bmap_rtalloc() sequence. I will
add the error tag to rt file allocations as well. Thanks for pointing that
out.

> 
> >  
> >  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
> >  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> >  							ap->tp->t_firstblock);
> >  	if (nullfb) {
> > -		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> > +		if (args.alloc_minlen_only) {
> > +			ag = 0;
> 
> Hm, so setting this magic knob also makes everyone fight for space in AG 0?

For the normal use case, each AGF tracks the longest extent via
xfs_agf->agf_longest. When the transaction is allocating its first
extent, xfs_bmap_btalloc_nullfb() loops over each AG until it finds an AG
whose longest extent can be used for allocating xfs_alloc_arg->maxlen free
space extent. 

However, there is no such existing facility for tracking "minimum length"
extent in an AG. This could be done by adding a new member to the in-memory
data structure and intializing the new member by assigning the "length" value
of the leftmost record from CNTBT during xfs_alloc_read_agf(). However I
refrained from doing this since we will never need this on production
machines.

Also, since xfs_alloc_arg->type is being to XFS_ALLOCTYPE_FIRST_AG later in
the code, AG 0 is just the first AG being scanned for "exact minlen"
extents. We end up looping across remaining AGs if previously searched AGs do
not contain "exact minlen" extents.

> 
> > +			ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
> > +		} else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> >  		    xfs_inode_is_filestream(ap->ip)) {
> >  			ag = xfs_filestream_lookup_ag(ap->ip);
> >  			ag = (ag != NULLAGNUMBER) ? ag : 0;
> > @@ -3523,10 +3530,12 @@ xfs_bmap_btalloc(
> >  		} else {
> >  			ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
> >  		}
> > -	} else
> > +	} else {
> >  		ap->blkno = ap->tp->t_firstblock;
> > +	}
> >  
> > -	xfs_bmap_adjacent(ap);
> > +	if (!args.alloc_minlen_only)
> > +		xfs_bmap_adjacent(ap);
> >  
> >  	/*
> >  	 * If allowed, use ap->blkno; otherwise must use firstblock since
> > @@ -3540,7 +3549,6 @@ xfs_bmap_btalloc(
> >  	 * Normal allocation, done through xfs_alloc_vextent.
> >  	 */
> >  	tryagain = isaligned = 0;
> > -	memset(&args, 0, sizeof(args));
> >  	args.tp = ap->tp;
> >  	args.mp = mp;
> >  	args.fsbno = ap->blkno;
> > @@ -3549,7 +3557,10 @@ xfs_bmap_btalloc(
> >  	/* Trim the allocation back to the maximum an AG can fit. */
> >  	args.maxlen = min(ap->length, mp->m_ag_max_usable);
> >  	blen = 0;
> > -	if (nullfb) {
> > +	if (args.alloc_minlen_only) {
> > +		args.type = XFS_ALLOCTYPE_START_AG;
> > +		args.total = args.minlen = args.maxlen = ap->minlen;
> > +	} else if (nullfb) {
> >  		/*
> >  		 * Search for an allocation group with a single extent large
> >  		 * enough for the request.  If one isn't found, then adjust
> > @@ -3595,7 +3606,8 @@ xfs_bmap_btalloc(
> >  	 * is only set if the allocation length is >= the stripe unit and the
> >  	 * allocation offset is at the end of file.
> >  	 */
> > -	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof) {
> > +	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof &&
> > +		!args.alloc_minlen_only) {
> >  		if (!ap->offset) {
> 
> Yikes, the conditional lines up with the body!

Sorry, I will fix this.

> 
> --D
> 
> >  			args.alignment = stripe_align;
> >  			atype = args.type;
> > @@ -3681,7 +3693,7 @@ xfs_bmap_btalloc(
> >  		if ((error = xfs_alloc_vextent(&args)))
> >  			return error;
> >  	}
> > -	if (args.fsbno == NULLFSBLOCK && nullfb) {
> > +	if (args.fsbno == NULLFSBLOCK && nullfb && !args.alloc_minlen_only) {
> >  		args.fsbno = 0;
> >  		args.type = XFS_ALLOCTYPE_FIRST_AG;
> >  		args.total = ap->minlen;
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
> > index 3780b118cc47..028560bb596a 100644
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
> > +XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent, XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
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



