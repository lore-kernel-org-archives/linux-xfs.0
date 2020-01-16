Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56DDC33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 712E0206D9
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vi++J1Rl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgAPQd4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:33:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAPQdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:33:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RemCcsIL5MEt6YKHMv08Wjo6ykQcd8mMJxqIj8VqBOw=; b=Vi++J1RlBT13ZktpyzywJcxhJ
        4QZN28uRh1vyU5p1l08E/nioU077s+gEhuzTPRQxa0juP6uCj1MHHqq8JkJUaQg6re1JEwQAW+59Y
        L+rtOJiaEkbYFuIZtdBNgb024d+8KxXAz+p5I3//3AFt6z4KyYT/oKFbE8/or6wLWQQqJiQIEsadi
        WK+tgKIJ7j3h/L1BMqDm5wMZZorU42Phr85bwEpCFUqTbbHMf7yqPpSLl7RtPCctjEaB+2Sj6X/oy
        GyyMJtOxIEYzypu8hNdRYdpDDmbg1wyFr24dv9NmQ0uQlI5RgRcWpOU+MGDxio+GgaL+3pItcRkL5
        EHvNU6ABQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is85j-0002By-Ev; Thu, 16 Jan 2020 16:33:55 +0000
Date:   Thu, 16 Jan 2020 08:33:55 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 9/9] xfs: make xfs_btree_get_buf functions return an
 error code
Message-ID: <20200116163355.GI3802@infradead.org>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910787821.2028217.9307411154179566922.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910787821.2028217.9307411154179566922.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -		if (XFS_IS_CORRUPT(args->mp, !bp)) {
> -			error = -EFSCORRUPTED;
> +		error = xfs_btree_get_bufs(args->mp, args->tp, args->agno,
> +				fbno, &bp);
> +		if (error)

Should we keep the XFS_IS_CORRUPT checks in some form?   Not sure they
matter all that much, though.

>  	ASSERT(fsbno != NULLFSBLOCK);
>  	d = XFS_FSB_TO_DADDR(mp, fsbno);
> -	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
> -	if (error)
> -		return NULL;
> -	return bp;
> +	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, bpp);

Maybe kill the local variable while you're at it?

>  	ASSERT(agno != NULLAGNUMBER);
>  	ASSERT(agbno != NULLAGBLOCK);
>  	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
> -	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
> -	if (error)
> -		return NULL;
> -	return bp;
> +	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, bpp);

Same here.
