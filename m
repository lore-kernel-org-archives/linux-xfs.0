Return-Path: <SRS0=YpFG=EF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA8DC00A89
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 15:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9EB92067D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 15:52:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="maVF+C/t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgJ3PwY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 11:52:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbgJ3PwY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Oct 2020 11:52:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UFmjk2116455;
        Fri, 30 Oct 2020 15:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gqhBYTamTu+B0SZLibYBdliF1mmUjXatbjWO0Nd101k=;
 b=maVF+C/tE9I2t3rEaPA/hY71aUA2u9wT31s5uNqJn2xF4C1p/qRu2Hc0vcxjfS6vxhBZ
 5CyYyxedgcDvDR7FIxdZ+UU39kICUoCsaJ/6Gtq5zwwY4njvAGjywRvV/6G6Ln8b1kho
 IMVknwZnL4DJNzICxHQ5Mbfwb3WRRN5Hgc6qrdqDnhj05QpbZMYhxeG822M6PD4XOAfn
 M7THViPHwYfnOjYMj3DbDyCKL42p9hBE2MR7pxcHW/ybUJHT7DZBE/UIGKue/MNYvfo0
 Y1ehsiwyhwxH7dAjfnZeAgcqnKmwqP00F8wV0A1L6Zw9nTQiz4z6GZZY/xPOoRVxUehj 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm4g0xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 15:52:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UFoZIS149907;
        Fri, 30 Oct 2020 15:52:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwur3y55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 15:52:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09UFqEoj013752;
        Fri, 30 Oct 2020 15:52:14 GMT
Received: from localhost (/10.159.131.226)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Oct 2020 08:52:14 -0700
Date:   Fri, 30 Oct 2020 08:52:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH V8 12/14] xfs: Compute bmap extent alignments in a
 separate function
Message-ID: <20201030155212.GQ1061252@magnolia>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
 <20201029101348.4442-13-chandanrlinux@gmail.com>
 <20201029222130.GM1061252@magnolia>
 <2167513.2nQQj6O1E8@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2167513.2nQQj6O1E8@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9790 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9790 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300117
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 30, 2020 at 01:46:18PM +0530, Chandan Babu R wrote:
> On Friday 30 October 2020 3:51:30 AM IST Darrick J. Wong wrote:
> > On Thu, Oct 29, 2020 at 03:43:46PM +0530, Chandan Babu R wrote:
> > > This commit moves over the code which computes stripe alignment and
> > > extent size hint alignment into a separate function. Apart from
> > > xfs_bmap_btalloc(), the new function will be used by another function
> > > introduced in a future commit.
> > > 
> > > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_bmap.c | 88 +++++++++++++++++++++++-----------------
> > >  1 file changed, 51 insertions(+), 37 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index 64c4d0e384a5..935f2d506748 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -3463,13 +3463,58 @@ xfs_bmap_btalloc_accounting(
> > >  		args->len);
> > >  }
> > >  
> > > +static void
> > 
> > Why not return stripe_align instead of passing pointers?
> 
> xfs_bmap_exact_minlen_extent_alloc() introduced in the last patch would invoke
> this function passing NULL value as the third argument i.e. it does not need
> "stripe alignment" to be computed. Hence xfs_bmap_exact_minlen_extent_alloc()
> would ignore the return value of xfs_bmap_compute_alignments(). This was the
> reason for deciding on passing a pointer to the stripe_align variable as an
> argument.

I would have thought that an out parameter that isn't used by all
callers would be the perfect use of a return, especially since passing
by pointer means that the compiler has to spill stripe_align to a memory
location both here and in the callers and cannot keep the value in
registers.

--D

> > 
> > > +xfs_bmap_compute_alignments(
> > > +	struct xfs_bmalloca	*ap,
> > > +	struct xfs_alloc_arg	*args,
> > > +	int			*stripe_align)
> > > +{
> > > +	struct xfs_mount	*mp = args->mp;
> > > +	xfs_extlen_t		align = 0; /* minimum allocation alignment */
> > > +	int			error;
> > > +
> > > +	/* stripe alignment for allocation is determined by mount parameters */
> > > +	*stripe_align = 0;
> > > +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > > +		*stripe_align = mp->m_swidth;
> > > +	else if (mp->m_dalign)
> > > +		*stripe_align = mp->m_dalign;
> > > +
> > > +	if (ap->flags & XFS_BMAPI_COWFORK)
> > > +		align = xfs_get_cowextsz_hint(ap->ip);
> > > +	else if (ap->datatype & XFS_ALLOC_USERDATA)
> > > +		align = xfs_get_extsz_hint(ap->ip);
> > > +	if (align) {
> > > +		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> > > +						align, 0, ap->eof, 0, ap->conv,
> > > +						&ap->offset, &ap->length);
> > > +		ASSERT(!error);
> > > +		ASSERT(ap->length);
> > > +	}
> > > +
> > > +	/* apply extent size hints if obtained earlier */
> > > +	if (align) {
> > > +		args->prod = align;
> > > +		div_u64_rem(ap->offset, args->prod, &args->mod);
> > > +		if (args->mod)
> > > +			args->mod = args->prod - args->mod;
> > > +	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
> > > +		args->prod = 1;
> > > +		args->mod = 0;
> > > +	} else {
> > > +		args->prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
> > > +		div_u64_rem(ap->offset, args->prod, &args->mod);
> > > +		if (args->mod)
> > > +			args->mod = args->prod - args->mod;
> > > +	}
> > > +}
> > > +
> > >  STATIC int
> > >  xfs_bmap_btalloc(
> > >  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> > >  {
> > >  	xfs_mount_t	*mp;		/* mount point structure */
> > >  	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
> > > -	xfs_extlen_t	align = 0;	/* minimum allocation alignment */
> > >  	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
> > >  	xfs_agnumber_t	ag;
> > >  	xfs_alloc_arg_t	args;
> > > @@ -3489,25 +3534,11 @@ xfs_bmap_btalloc(
> > >  
> > >  	mp = ap->ip->i_mount;
> > >  
> > > -	/* stripe alignment for allocation is determined by mount parameters */
> > > -	stripe_align = 0;
> > > -	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> > > -		stripe_align = mp->m_swidth;
> > > -	else if (mp->m_dalign)
> > > -		stripe_align = mp->m_dalign;
> > > -
> > > -	if (ap->flags & XFS_BMAPI_COWFORK)
> > > -		align = xfs_get_cowextsz_hint(ap->ip);
> > > -	else if (ap->datatype & XFS_ALLOC_USERDATA)
> > > -		align = xfs_get_extsz_hint(ap->ip);
> > > -	if (align) {
> > > -		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> > > -						align, 0, ap->eof, 0, ap->conv,
> > > -						&ap->offset, &ap->length);
> > > -		ASSERT(!error);
> > > -		ASSERT(ap->length);
> > > -	}
> > > +	memset(&args, 0, sizeof(args));
> > > +	args.tp = ap->tp;
> > > +	args.mp = mp;
> > 
> > FWIW you might as well clean up the variable declarations while you're
> > moving this stuff around:
> > 
> > STATIC int
> > xfs_bmap_btalloc(
> > 	struct xfs_bmalloca	*ap)
> > {
> > 	struct xfs_mount	*mp = ap->ip->i_mount;
> > 	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
> > 
> > And then you can get rid of the memset call.
> 
> Sure, I will make the changes that have been suggested.
> 
> > 
> > AFAICT there aren't any data dependencies between the parts where we
> > initialize args.fsbno and where we set args.prod and args.mod, so I
> > guess this is a reasonable hoist.
> > 
> > Other than those cleanups, this looks ok to me.
> > 
> > --D
> > 
> > >  
> > > +	xfs_bmap_compute_alignments(ap, &args, &stripe_align);
> > >  
> > >  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
> > >  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> > > @@ -3538,9 +3569,6 @@ xfs_bmap_btalloc(
> > >  	 * Normal allocation, done through xfs_alloc_vextent.
> > >  	 */
> > >  	tryagain = isaligned = 0;
> > > -	memset(&args, 0, sizeof(args));
> > > -	args.tp = ap->tp;
> > > -	args.mp = mp;
> > >  	args.fsbno = ap->blkno;
> > >  	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> > >  
> > > @@ -3571,21 +3599,7 @@ xfs_bmap_btalloc(
> > >  		args.total = ap->total;
> > >  		args.minlen = ap->minlen;
> > >  	}
> > > -	/* apply extent size hints if obtained earlier */
> > > -	if (align) {
> > > -		args.prod = align;
> > > -		div_u64_rem(ap->offset, args.prod, &args.mod);
> > > -		if (args.mod)
> > > -			args.mod = args.prod - args.mod;
> > > -	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
> > > -		args.prod = 1;
> > > -		args.mod = 0;
> > > -	} else {
> > > -		args.prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
> > > -		div_u64_rem(ap->offset, args.prod, &args.mod);
> > > -		if (args.mod)
> > > -			args.mod = args.prod - args.mod;
> > > -	}
> > > +
> > >  	/*
> > >  	 * If we are not low on available data blocks, and the underlying
> > >  	 * logical volume manager is a stripe, and the file offset is zero then
> > 
> 
> 
> -- 
> chandan
> 
> 
> 
