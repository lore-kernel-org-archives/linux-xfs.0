Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0D2C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 08:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B56C206CB
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 08:38:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EcIAhi9S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfLXIiq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 03:38:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36164 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfLXIip (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 03:38:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uhVTY2INrWOSp+8HAoOIDeYbzpTUDJamRCXDJF18xJg=; b=EcIAhi9SDucjfLJUHaaiK8zfA
        zOnb6OI6G5k4yCwc6aoBI449bw598cXFrVGsnzGLUxW4Ecyc+OoX+u0PlxmHXtsJEoMvh+HTlrgUI
        MmhkPfiiPWacY7z5Sysno4NvbkOfIoHnKpj5Khw+KeoLmZ2HQbfK7RNKZvOIJP1kK0cU2J8JqFcom
        8Tjn8Jy1rRRkjTwfAU59G0SjA22R2U6puMGm1XvKBDdwLrrpXFzVi1Iso8A5L7D7XH1p0aZoIfVsz
        uPPvOER7JiagXpa95lfOF4fF2w1VFaLUumGXGJutnkLT7dKrlJHrY5CC4YvacUqU6A95ivKFRa9yD
        CNLblFCkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijfiF-0000tG-P2; Tue, 24 Dec 2019 08:38:43 +0000
Date:   Tue, 24 Dec 2019 00:38:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: fix totally broken unit conversion in
 directory invalidation
Message-ID: <20191224083843.GA1739@infradead.org>
References: <20191218042402.GL12765@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218042402.GL12765@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 08:24:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Your humble author forgot that xfs_dablk_t has the same units as
> xfs_fileoff_t, and totally screwed up the directory buffer invalidation
> loop in dir_binval.  Not only is there an off-by-one error in the loop
> conditional, but the unit conversions are wrong.

Can we kill off xfs_dablk_t?  I found the concept very, very confusing
when touching the dir code.

> --- a/libxfs/xfs_dir2.h
> +++ b/libxfs/xfs_dir2.h
> @@ -308,6 +308,16 @@ xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
>  		  sizeof(struct xfs_dir2_leaf_tail));
>  }
>  
> +/*
> + * For a given dir/attr geometry and extent mapping record, walk every file
> + * offset block (xfs_dablk_t) in the mapping that corresponds to the start
> + * of a logical directory block (xfs_dir2_db_t).
> + */
> +#define for_each_xfs_bmap_dabno(geo, irec, dabno) \
> +	for ((dabno) = round_up((irec)->br_startoff, (geo)->fsbcount); \
> +	     (dabno) < (irec)->br_startoff + (irec)->br_blockcount; \
> +	     (dabno) += (geo)->fsbcount)

I think not having the magic for macro would be cleaner..

> +	xfs_dablk_t		dabno;
>  	int			error = 0;
>  
>  	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> @@ -1286,11 +1286,7 @@ dir_binval(
>  	geo = tp->t_mountp->m_dir_geo;
>  	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  	for_each_xfs_iext(ifp, &icur, &rec) {
> -		dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
> -				geo->fsbcount - 1);
> -		end_dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
> -				rec.br_blockcount);
> -		for (; dabno <= end_dabno; dabno += geo->fsbcount) {
> +		for_each_xfs_bmap_dabno(geo, &rec, dabno) {
>  			bp = NULL;
>  			error = -libxfs_da_get_buf(tp, ip, dabno, -2, &bp,
>  					whichfork);

But either way, the fix looks good.
