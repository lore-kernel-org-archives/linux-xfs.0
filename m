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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59EEC00A89
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 16:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 514B820A8B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 16:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iEiQ/PEF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgJ3Q1C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 12:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgJ3Q1C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Oct 2020 12:27:02 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F095BC0613CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2020 09:27:01 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 13so5740193pfy.4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Oct 2020 09:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xlj66WyRDrWrOSRLEak3Gk044UQ7eJ3StZdjM/I813g=;
        b=iEiQ/PEF3JkQ5qFLVhtpBPwaJxvL3Z7mlNe7dAXMIgXEyUSfNJhATspsQpbIg/ESOJ
         tpYEop48VpsSwbp2sWM2rB3V8SzbNpSE7U5a3ntkPFgt4zYYJCGMXTInvNxDLookhAu2
         OaQTClOBKke0JW0jQnVWW0HBl1pYf6RTO1sb1gaU3LPFbUDwECp52nweXWQmYNgjH6gq
         s/YfSgL4WCJFsFANLO+Hi+3tX2QCPLe61AMATW+FEL5QNpInYDTyhP5xQvSbLlQ4OUZ6
         4WCmkfXpMlFIjqifGQeyPatT2EO14JwSRbNUuZdU0gEyt+2M3D6MCGBEdikBEp0k5YCD
         a9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xlj66WyRDrWrOSRLEak3Gk044UQ7eJ3StZdjM/I813g=;
        b=V1Sd4Ry05F0VEMrsrmpYykElgr2Mb/tsHqOIK67+zgLBpM6nrVX+n3mkUlSo1+4oEJ
         eLAzEsY+rUMKoUe4qCrNsboW5De262yFeuttmdwMLs5xJJMKN88ISsVAACtOnqBuZHST
         oqQXehtwKFP159tXjNxt5Bp+7aWKMgzPD8PMOumAGvynOEfby223LeAJWNi0jPb0B28a
         e5Pz/KsisvvNoRFnCFt5PLOXwSVVc6MVzfWHIwr3HMKoLcumzTAHrFeyKkvlOiNM7tQH
         ToSjOLcPd+7hg5mMc4mOCTrgZJroKvtTt7Cav7UHtVtIdpMzBvb9pjGITxqi7jXZHUc0
         WQ3g==
X-Gm-Message-State: AOAM531wo9uTcSFE85Kd2UoArSsx2KrPHQVIOTsB+IXSFCW6iQCM9nE9
        lSZ8CJktsnScVmB/c5M5/eg=
X-Google-Smtp-Source: ABdhPJwP8fK8dgUOIIwJsskuMQMcVyCqKqLu966TmHtEGseRQ1AZzRR2v8Gyhci5HgeVrbU47Qf4rg==
X-Received: by 2002:a17:90a:3:: with SMTP id 3mr3680887pja.184.1604075221509;
        Fri, 30 Oct 2020 09:27:01 -0700 (PDT)
Received: from garuda.localnet ([122.182.226.101])
        by smtp.gmail.com with ESMTPSA id e3sm4047392pjt.33.2020.10.30.09.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 09:27:00 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V8 12/14] xfs: Compute bmap extent alignments in a separate function
Date:   Fri, 30 Oct 2020 21:56:57 +0530
Message-ID: <802040417.dp7cjt2klD@garuda>
In-Reply-To: <20201030155212.GQ1061252@magnolia>
References: <20201029101348.4442-1-chandanrlinux@gmail.com> <2167513.2nQQj6O1E8@garuda> <20201030155212.GQ1061252@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 30 October 2020 9:22:12 PM IST Darrick J. Wong wrote:
> On Fri, Oct 30, 2020 at 01:46:18PM +0530, Chandan Babu R wrote:
> > On Friday 30 October 2020 3:51:30 AM IST Darrick J. Wong wrote:
> > > On Thu, Oct 29, 2020 at 03:43:46PM +0530, Chandan Babu R wrote:
> > > > This commit moves over the code which computes stripe alignment and
> > > > extent size hint alignment into a separate function. Apart from
> > > > xfs_bmap_btalloc(), the new function will be used by another function
> > > > introduced in a future commit.
> > > > 
> > > > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_bmap.c | 88 +++++++++++++++++++++++-----------------
> > > >  1 file changed, 51 insertions(+), 37 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > index 64c4d0e384a5..935f2d506748 100644
> > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > @@ -3463,13 +3463,58 @@ xfs_bmap_btalloc_accounting(
> > > >  		args->len);
> > > >  }
> > > >  
> > > > +static void
> > > 
> > > Why not return stripe_align instead of passing pointers?
> > 
> > xfs_bmap_exact_minlen_extent_alloc() introduced in the last patch would invoke
> > this function passing NULL value as the third argument i.e. it does not need
> > "stripe alignment" to be computed. Hence xfs_bmap_exact_minlen_extent_alloc()
> > would ignore the return value of xfs_bmap_compute_alignments(). This was the
> > reason for deciding on passing a pointer to the stripe_align variable as an
> > argument.
> 
> I would have thought that an out parameter that isn't used by all
> callers would be the perfect use of a return, especially since passing
> by pointer means that the compiler has to spill stripe_align to a memory
> location both here and in the callers and cannot keep the value in
> registers.

You are right. I will implement the change pointed out by you. Thanks once
again for your suggestions.

> 
> --D
> 
> > > 
> > > > +xfs_bmap_compute_alignments(
> > > > +	struct xfs_bmalloca	*ap,
> > > > +	struct xfs_alloc_arg	*args,
> > > > +	int			*stripe_align)
> > > > +{
> > > > +	struct xfs_mount	*mp = args->mp;
> > > > +	xfs_extlen_t		align = 0; /* minimum allocation alignment */
> > > > +	int			error;
> > > > +
> > > > +	/* stripe alignment for allocation is determined by mount parameters */
> > > > +	*stripe_align = 0;
> > > > +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > > > +		*stripe_align = mp->m_swidth;
> > > > +	else if (mp->m_dalign)
> > > > +		*stripe_align = mp->m_dalign;
> > > > +
> > > > +	if (ap->flags & XFS_BMAPI_COWFORK)
> > > > +		align = xfs_get_cowextsz_hint(ap->ip);
> > > > +	else if (ap->datatype & XFS_ALLOC_USERDATA)
> > > > +		align = xfs_get_extsz_hint(ap->ip);
> > > > +	if (align) {
> > > > +		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> > > > +						align, 0, ap->eof, 0, ap->conv,
> > > > +						&ap->offset, &ap->length);
> > > > +		ASSERT(!error);
> > > > +		ASSERT(ap->length);
> > > > +	}
> > > > +
> > > > +	/* apply extent size hints if obtained earlier */
> > > > +	if (align) {
> > > > +		args->prod = align;
> > > > +		div_u64_rem(ap->offset, args->prod, &args->mod);
> > > > +		if (args->mod)
> > > > +			args->mod = args->prod - args->mod;
> > > > +	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
> > > > +		args->prod = 1;
> > > > +		args->mod = 0;
> > > > +	} else {
> > > > +		args->prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
> > > > +		div_u64_rem(ap->offset, args->prod, &args->mod);
> > > > +		if (args->mod)
> > > > +			args->mod = args->prod - args->mod;
> > > > +	}
> > > > +}
> > > > +
> > > >  STATIC int
> > > >  xfs_bmap_btalloc(
> > > >  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> > > >  {
> > > >  	xfs_mount_t	*mp;		/* mount point structure */
> > > >  	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
> > > > -	xfs_extlen_t	align = 0;	/* minimum allocation alignment */
> > > >  	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
> > > >  	xfs_agnumber_t	ag;
> > > >  	xfs_alloc_arg_t	args;
> > > > @@ -3489,25 +3534,11 @@ xfs_bmap_btalloc(
> > > >  
> > > >  	mp = ap->ip->i_mount;
> > > >  
> > > > -	/* stripe alignment for allocation is determined by mount parameters */
> > > > -	stripe_align = 0;
> > > > -	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > > > -		stripe_align = mp->m_swidth;
> > > > -	else if (mp->m_dalign)
> > > > -		stripe_align = mp->m_dalign;
> > > > -
> > > > -	if (ap->flags & XFS_BMAPI_COWFORK)
> > > > -		align = xfs_get_cowextsz_hint(ap->ip);
> > > > -	else if (ap->datatype & XFS_ALLOC_USERDATA)
> > > > -		align = xfs_get_extsz_hint(ap->ip);
> > > > -	if (align) {
> > > > -		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> > > > -						align, 0, ap->eof, 0, ap->conv,
> > > > -						&ap->offset, &ap->length);
> > > > -		ASSERT(!error);
> > > > -		ASSERT(ap->length);
> > > > -	}
> > > > +	memset(&args, 0, sizeof(args));
> > > > +	args.tp = ap->tp;
> > > > +	args.mp = mp;
> > > 
> > > FWIW you might as well clean up the variable declarations while you're
> > > moving this stuff around:
> > > 
> > > STATIC int
> > > xfs_bmap_btalloc(
> > > 	struct xfs_bmalloca	*ap)
> > > {
> > > 	struct xfs_mount	*mp = ap->ip->i_mount;
> > > 	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
> > > 
> > > And then you can get rid of the memset call.
> > 
> > Sure, I will make the changes that have been suggested.
> > 
> > > 
> > > AFAICT there aren't any data dependencies between the parts where we
> > > initialize args.fsbno and where we set args.prod and args.mod, so I
> > > guess this is a reasonable hoist.
> > > 
> > > Other than those cleanups, this looks ok to me.
> > > 
> > > --D
> > > 
> > > >  
> > > > +	xfs_bmap_compute_alignments(ap, &args, &stripe_align);
> > > >  
> > > >  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
> > > >  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> > > > @@ -3538,9 +3569,6 @@ xfs_bmap_btalloc(
> > > >  	 * Normal allocation, done through xfs_alloc_vextent.
> > > >  	 */
> > > >  	tryagain = isaligned = 0;
> > > > -	memset(&args, 0, sizeof(args));
> > > > -	args.tp = ap->tp;
> > > > -	args.mp = mp;
> > > >  	args.fsbno = ap->blkno;
> > > >  	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> > > >  
> > > > @@ -3571,21 +3599,7 @@ xfs_bmap_btalloc(
> > > >  		args.total = ap->total;
> > > >  		args.minlen = ap->minlen;
> > > >  	}
> > > > -	/* apply extent size hints if obtained earlier */
> > > > -	if (align) {
> > > > -		args.prod = align;
> > > > -		div_u64_rem(ap->offset, args.prod, &args.mod);
> > > > -		if (args.mod)
> > > > -			args.mod = args.prod - args.mod;
> > > > -	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
> > > > -		args.prod = 1;
> > > > -		args.mod = 0;
> > > > -	} else {
> > > > -		args.prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
> > > > -		div_u64_rem(ap->offset, args.prod, &args.mod);
> > > > -		if (args.mod)
> > > > -			args.mod = args.prod - args.mod;
> > > > -	}
> > > > +
> > > >  	/*
> > > >  	 * If we are not low on available data blocks, and the underlying
> > > >  	 * logical volume manager is a stripe, and the file offset is zero then
> > > 
> > 
> > 
> 


-- 
chandan



