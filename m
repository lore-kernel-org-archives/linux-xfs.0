Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9DFC388F7
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 03:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C1B2224E
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 03:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m3buFyRG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgKCD4x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 22:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbgKCD4v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 22:56:51 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F3FC0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 19:56:51 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id w4so2401406pgg.13
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 19:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=84Af5G3Pj3zy69dzY9/nUNVDAEq+wUzWJqSneNocsBQ=;
        b=m3buFyRGI7AbE1de5gx5gH3zhi/teVKvDPesWJqogN7b9gtX7R3dJ3ZvH4pVAXVFyJ
         ljqareVcBBN0nmh4MSyMqLAV/PV1ss1XVHn8h9Qi0frJYOdF/OJASAizv8e4S9Egr3Qn
         w1Dj83FelTgeN0Ss/NsgKIZLH98man57NhsuGK6YSricL4K1l35TDfivfo9of3ll6zg8
         q0sMHcLgjd//xj1Y7ThdT5Mp7DToyYgBdqDhC49mGErEaNFOCsvFSj9BXBGbD+Qwm1M3
         6YKotNAqIhqeAH3vfcPw3tysfRxB1xSi+bNnA+kTMmGzvznSxzGCs1HnwbtViEXgYpQU
         ajmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=84Af5G3Pj3zy69dzY9/nUNVDAEq+wUzWJqSneNocsBQ=;
        b=qpwXzryWlOBJCZT+0fi0XqlhqmkmkzemxvYwrDMZ+rgw6r5DVvBaAO+zj2zE8vX7zM
         pzFC124T2izUmU1upLFLtHFtKqC1kzgfUYiSp3vUi25kaTIYCkOTN4KaP9v8yLKdeYU7
         p3xWK8350D6szCvEXcouTTlYoCpBu5kmtO9QYSVPgYBTew2DTRKCmhjOfTZwe1n3CXlH
         U5HC+G6K2rbUc2AqChXR7lvL/vAj5X9yhW/0f9wSlCWruNPUzxm+FbfLqqNa0uKUzkvg
         34+9H7hb5Hryfaj7+pIayNYLSLEbfhXotZhNqrSSFyP65ftFZaQPAN2swc3kW/0nwOEs
         SrGA==
X-Gm-Message-State: AOAM533RzVkHzVr/YDcfdcPOjDptiInhEwjrj8Ng6xL/lTccKz94S4fJ
        Es7DtGQg2RfWbsE7eLJM4XI=
X-Google-Smtp-Source: ABdhPJx7ealnQ9eCQ2xvn98ZQKllVAQUDzbppBFv8IRrLwpsxRPJXisCt9Jod9s1bcl5gmdjIkLFTA==
X-Received: by 2002:a63:3116:: with SMTP id x22mr3307125pgx.278.1604375810655;
        Mon, 02 Nov 2020 19:56:50 -0800 (PST)
Received: from garuda.localnet ([122.179.104.221])
        by smtp.gmail.com with ESMTPSA id f7sm15010894pfd.111.2020.11.02.19.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 19:56:50 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V9 12/14] xfs: Compute bmap extent alignments in a separate function
Date:   Tue, 03 Nov 2020 09:26:46 +0530
Message-ID: <24311653.7XKyyEHPVO@garuda>
In-Reply-To: <20201102170528.GC7123@magnolia>
References: <20201102095048.100956-1-chandanrlinux@gmail.com> <20201102095048.100956-13-chandanrlinux@gmail.com> <20201102170528.GC7123@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 2 November 2020 10:35:28 PM IST Darrick J. Wong wrote:
> On Mon, Nov 02, 2020 at 03:20:46PM +0530, Chandan Babu R wrote:
> > This commit moves over the code which computes stripe alignment and
> > extent size hint alignment into a separate function. Apart from
> > xfs_bmap_btalloc(), the new function will be used by another function
> > introduced in a future commit.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 88 +++++++++++++++++++++++-----------------
> >  1 file changed, 51 insertions(+), 37 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 64c4d0e384a5..935f2d506748 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3463,13 +3463,58 @@ xfs_bmap_btalloc_accounting(
> >  		args->len);
> >  }
> >  
> > +static void
> > +xfs_bmap_compute_alignments(
> > +	struct xfs_bmalloca	*ap,
> > +	struct xfs_alloc_arg	*args,
> > +	int			*stripe_align)
> 
> Uh were you going to change this to return stripe_align?
>

I am sorry. I did that change on top of the final commit, tested the changes
and merged it with the topmost commit (i.e. 14th patch in this series) along
with the other changes. I will pull back the "stripe_align" changes to this
patch and repost the patchset.

> --D
> 
> > +{
> > +	struct xfs_mount	*mp = args->mp;
> > +	xfs_extlen_t		align = 0; /* minimum allocation alignment */
> > +	int			error;
> > +
> > +	/* stripe alignment for allocation is determined by mount parameters */
> > +	*stripe_align = 0;
> > +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > +		*stripe_align = mp->m_swidth;
> > +	else if (mp->m_dalign)
> > +		*stripe_align = mp->m_dalign;
> > +
> > +	if (ap->flags & XFS_BMAPI_COWFORK)
> > +		align = xfs_get_cowextsz_hint(ap->ip);
> > +	else if (ap->datatype & XFS_ALLOC_USERDATA)
> > +		align = xfs_get_extsz_hint(ap->ip);
> > +	if (align) {
> > +		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> > +						align, 0, ap->eof, 0, ap->conv,
> > +						&ap->offset, &ap->length);
> > +		ASSERT(!error);
> > +		ASSERT(ap->length);
> > +	}
> > +
> > +	/* apply extent size hints if obtained earlier */
> > +	if (align) {
> > +		args->prod = align;
> > +		div_u64_rem(ap->offset, args->prod, &args->mod);
> > +		if (args->mod)
> > +			args->mod = args->prod - args->mod;
> > +	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
> > +		args->prod = 1;
> > +		args->mod = 0;
> > +	} else {
> > +		args->prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
> > +		div_u64_rem(ap->offset, args->prod, &args->mod);
> > +		if (args->mod)
> > +			args->mod = args->prod - args->mod;
> > +	}
> > +}
> > +
> >  STATIC int
> >  xfs_bmap_btalloc(
> >  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> >  {
> >  	xfs_mount_t	*mp;		/* mount point structure */
> >  	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
> > -	xfs_extlen_t	align = 0;	/* minimum allocation alignment */
> >  	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
> >  	xfs_agnumber_t	ag;
> >  	xfs_alloc_arg_t	args;
> > @@ -3489,25 +3534,11 @@ xfs_bmap_btalloc(
> >  
> >  	mp = ap->ip->i_mount;
> >  
> > -	/* stripe alignment for allocation is determined by mount parameters */
> > -	stripe_align = 0;
> > -	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > -		stripe_align = mp->m_swidth;
> > -	else if (mp->m_dalign)
> > -		stripe_align = mp->m_dalign;
> > -
> > -	if (ap->flags & XFS_BMAPI_COWFORK)
> > -		align = xfs_get_cowextsz_hint(ap->ip);
> > -	else if (ap->datatype & XFS_ALLOC_USERDATA)
> > -		align = xfs_get_extsz_hint(ap->ip);
> > -	if (align) {
> > -		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> > -						align, 0, ap->eof, 0, ap->conv,
> > -						&ap->offset, &ap->length);
> > -		ASSERT(!error);
> > -		ASSERT(ap->length);
> > -	}
> > +	memset(&args, 0, sizeof(args));
> > +	args.tp = ap->tp;
> > +	args.mp = mp;
> >  
> > +	xfs_bmap_compute_alignments(ap, &args, &stripe_align);
> >  
> >  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
> >  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> > @@ -3538,9 +3569,6 @@ xfs_bmap_btalloc(
> >  	 * Normal allocation, done through xfs_alloc_vextent.
> >  	 */
> >  	tryagain = isaligned = 0;
> > -	memset(&args, 0, sizeof(args));
> > -	args.tp = ap->tp;
> > -	args.mp = mp;
> >  	args.fsbno = ap->blkno;
> >  	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> >  
> > @@ -3571,21 +3599,7 @@ xfs_bmap_btalloc(
> >  		args.total = ap->total;
> >  		args.minlen = ap->minlen;
> >  	}
> > -	/* apply extent size hints if obtained earlier */
> > -	if (align) {
> > -		args.prod = align;
> > -		div_u64_rem(ap->offset, args.prod, &args.mod);
> > -		if (args.mod)
> > -			args.mod = args.prod - args.mod;
> > -	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
> > -		args.prod = 1;
> > -		args.mod = 0;
> > -	} else {
> > -		args.prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
> > -		div_u64_rem(ap->offset, args.prod, &args.mod);
> > -		if (args.mod)
> > -			args.mod = args.prod - args.mod;
> > -	}
> > +
> >  	/*
> >  	 * If we are not low on available data blocks, and the underlying
> >  	 * logical volume manager is a stripe, and the file offset is zero then
> 


-- 
chandan



