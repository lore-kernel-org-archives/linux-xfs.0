Return-Path: <SRS0=bjGU=EK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149C0C2D0A3
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Nov 2020 03:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C940E206FB
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Nov 2020 03:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="efUOoLX0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgKDDVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730099AbgKDDVo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 22:21:44 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70D5C061A4D
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 19:21:43 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id z24so15361851pgk.3
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 19:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dHNltDR4LhUnY5yK/KfaVTBSWa9qrd34oGIvdsAbgrQ=;
        b=efUOoLX0LFcLkTU7EI13F206l5HOJjDro9mP/h7rI2qjlXLOl3OlZ8lllHNYRTaZ6D
         JAL/1DExdQr5axBYpNo/hRWKngwCzql/rRtmcra21ifSxwYiJKxM1VP7dNSBZJnGEfYN
         V2XzXWq58gj9xhmDbliP6dN5LMwhQXtFuaqKvdDEAuKxuO8Vo267tqbXqcxXLH3uiZbW
         NvVEyoylfT2I0IO0+OnsOU/BkEgYXD4e0rgIdb1qt51Sne7w+sWNXpvSnNaqeQ8SQvtn
         XXaxlEUs80e/nW2q26tSrkyc8Vu/R8XGGspEglA662Ha5UyzcgND7WtxxtHyvUGvPB73
         XABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dHNltDR4LhUnY5yK/KfaVTBSWa9qrd34oGIvdsAbgrQ=;
        b=soQr2MEbJVVEvJS72Zbc1fdsLA3bs5r3UuHVb6a4aTt87PMTsmjiZpsR2Rhjs5bUv2
         wkGaN8o7bjjcNBt0uE4KGTw5BN0WISNeYFh+0nDYdiZBNwvAjwlrWJw/Sxib9Xwd6FJz
         k/sSeQJBPLqWTiGY0dFFhV4roLJ8VgiVZs2Nwn06fN77qYwRc+WiHtGha1yBmQcS5iUw
         w6kUD4QW07YxNjp823N9nX1gKHqj9rDLxSfthcOcGl+jCv6KT8q79Szb5bpOhyIVzCS0
         5+fc1MBca8r1HfPZJtrm9XzWaAiu7oPeo0Emuar6zCxsz8HVQY0dGZgZgcX+gHGO7oAA
         CZbg==
X-Gm-Message-State: AOAM533Y5CMs3+ysDfJrq1ehnkIgSS1u+FNHaigyaVbed/nKc4zUeGRv
        2E/aOPaAY1FeZvOgCpF7ebw9xFLcXMA=
X-Google-Smtp-Source: ABdhPJxOdDFHBuLssI7xq+U5NIxyxtJyioa4x8CAqgJNzVaQh1xshuB/RC9BH4bDQChqb4JcMaIgUg==
X-Received: by 2002:a17:90a:4282:: with SMTP id p2mr2247522pjg.165.1604460103443;
        Tue, 03 Nov 2020 19:21:43 -0800 (PST)
Received: from garuda.localnet ([122.171.54.58])
        by smtp.gmail.com with ESMTPSA id q84sm572184pfq.144.2020.11.03.19.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 19:21:42 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V10 12/14] xfs: Compute bmap extent alignments in a separate function
Date:   Wed, 04 Nov 2020 08:51:39 +0530
Message-ID: <1653060.Rga6FrLBiV@garuda>
In-Reply-To: <20201103195114.GA7115@magnolia>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com> <20201103150642.2032284-13-chandanrlinux@gmail.com> <20201103195114.GA7115@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 4 November 2020 1:21:14 AM IST Darrick J. Wong wrote:
> On Tue, Nov 03, 2020 at 08:36:40PM +0530, Chandan Babu R wrote:
> > This commit moves over the code which computes stripe alignment and
> > extent size hint alignment into a separate function. Apart from
> > xfs_bmap_btalloc(), the new function will be used by another function
> > introduced in a future commit.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
> Looks fine at last :)

Thanks for the review comments.

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Could you please add a fsstress style test that sets the errortag to see
> what kinds of, uh, testing artifacts fall out of that mode?

Sure. I will work on that.

> 
> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 89 +++++++++++++++++++++++-----------------
> >  1 file changed, 52 insertions(+), 37 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 64c4d0e384a5..5032539d5e85 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3463,13 +3463,59 @@ xfs_bmap_btalloc_accounting(
> >  		args->len);
> >  }
> >  
> > +static int
> > +xfs_bmap_compute_alignments(
> > +	struct xfs_bmalloca	*ap,
> > +	struct xfs_alloc_arg	*args)
> > +{
> > +	struct xfs_mount	*mp = args->mp;
> > +	xfs_extlen_t		align = 0; /* minimum allocation alignment */
> > +	int			stripe_align = 0;
> > +	int			error;
> > +
> > +	/* stripe alignment for allocation is determined by mount parameters */
> > +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > +		stripe_align = mp->m_swidth;
> > +	else if (mp->m_dalign)
> > +		stripe_align = mp->m_dalign;
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
> > +
> > +	return stripe_align;
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
> > @@ -3489,25 +3535,11 @@ xfs_bmap_btalloc(
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
> > +	stripe_align = xfs_bmap_compute_alignments(ap, &args);
> >  
> >  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
> >  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> > @@ -3538,9 +3570,6 @@ xfs_bmap_btalloc(
> >  	 * Normal allocation, done through xfs_alloc_vextent.
> >  	 */
> >  	tryagain = isaligned = 0;
> > -	memset(&args, 0, sizeof(args));
> > -	args.tp = ap->tp;
> > -	args.mp = mp;
> >  	args.fsbno = ap->blkno;
> >  	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> >  
> > @@ -3571,21 +3600,7 @@ xfs_bmap_btalloc(
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



