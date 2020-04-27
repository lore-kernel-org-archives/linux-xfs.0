Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6B4C54FD0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 07:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B60182051A
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 07:39:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ohSMGrs8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgD0Hju (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 03:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgD0Hjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 03:39:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C05C061A0F
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 00:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nH3+VOuQT16MzCiNEBUPUCxQg5WmSlvjuEj2R1RS3fo=; b=ohSMGrs8pcoMvAtq+KbJ/zXcEf
        ypEJCjlJbO+GDmwPZpvPEWjy9SBVh+MpROdLhj6TE1VXwRu2vBWg07qqVazkm3Y3MzR46ZcB7xoC2
        ZNzCHZvgJrt7VnMOAN6y1aACBVDcKSyW+MzdKFpVWjnGsbggeeRTgdnkWQMKmbtj4oTYvrFgJqj57
        +m0bVuVvgURVShwc9suLzxYmGashBXFP0gtZTEnA6HutRNSYBf1AkRgbq28K+vSVF0pDfN8RcO5R8
        MTp6j6ZGk6cnXk+3/qmui5R2XjDwuBr1ilXhvuiL7E1jKFVzEX6xyTg4Rxc5cVD8Sr/vsV5HUQ/JY
        1GBkJ0aA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSyMm-0004Zt-TC; Mon, 27 Apr 2020 07:39:48 +0000
Date:   Mon, 27 Apr 2020 00:39:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Message-ID: <20200427073948.GA15777@infradead.org>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <20200404085203.1908-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404085203.1908-3-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

FYI, I have had a series in the works for a while but not quite 
finished yet that moves the in-memory nextents and format fields
into the ifork structure.  I feared this might conflict badly, but
so far this seems relatively harmless.  Note that your patch creates
some not so nice layout in struct xfs_icdinode, so maybe I need to
rush and finish that series ASAP.

> +static inline int32_t XFS_DFORK_NEXTENTS(struct xfs_sb *sbp,
> +					struct xfs_dinode *dip, int whichfork)
> +{
> +	int32_t anextents;
> +
> +	if (whichfork == XFS_DATA_FORK)
> +		return be32_to_cpu((dip)->di_nextents);
> +
> +	anextents = be16_to_cpu((dip)->di_anextents_lo);
> +	if (xfs_sb_version_has_v3inode(sbp))
> +		anextents |= ((u32)(be16_to_cpu((dip)->di_anextents_hi)) << 16);
> +
> +	return anextents;

No need for any of the braces around dip.  Also this funcion really
deserves a proper lower case name now, and probably should be moved out
of line.

>  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
>  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
>  typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
> -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> +typedef int32_t		xfs_aextnum_t;	/* # extents in an attribute fork */

We can just retire xfs_aextnum_t.  It only has 4 uses anyway.

> @@ -327,7 +327,7 @@ xfs_inode_to_log_dinode(
>  	to->di_nblocks = from->di_nblocks;
>  	to->di_extsize = from->di_extsize;
>  	to->di_nextents = from->di_nextents;
> -	to->di_anextents = from->di_anextents;
> +	to->di_anextents_lo = ((u32)(from->di_anextents)) & 0xffff;

No need for any of the casting here.

> @@ -3044,7 +3045,14 @@ xlog_recover_inode_pass2(
>  			goto out_release;
>  		}
>  	}
> -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
> +
> +	nextents = ldip->di_anextents_lo;
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb))
> +		nextents |= ((u32)(ldip->di_anextents_hi) << 16);
> +
> +	nextents += ldip->di_nextents;

Little helpers to get/set the attr extents in the log inode would be nice.


Last but not least:  This seems like a feature flag we could just lazily
set once needed, similar to attr2.
