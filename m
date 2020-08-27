Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7559C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A286922BED
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l3GBd0i0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgH0HBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgH0HBA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 03:01:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB52CC061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sTGOR5Dc2WuLXHQ4cF6PI1pidBV5M3v+Dbj0t2SkrtU=; b=l3GBd0i07ZMxMsUiEmb7yvLd5g
        elQItP3XByIjfKjxc5UkVQbPWy4zbz5RUB2hnmEgCFbHuKvo6B/q18wxeOYoarTGruht0MVHyESkY
        pffLlM5p5ZTux0JxvPDnuuz7htaI6yXa7/kdLY/MCxQGJQ8PDG1G/ekuizbBc9DzKhgOzZBbdeYhK
        sTU2K+mAbcfSGboofIXcCrX+ZBsA7niPo8TERFbsmtPImekmwoLKmTmcBpC0InY0rASAzKEueCo1j
        lxvoUm64FpG/ekwPxMSgZqOYutFiGopmhuUnYTDLzm7TAHbNSfJASegsDs/TR0WM10D52UqimgYV3
        Puawgz6w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBty-0005j7-Pc; Thu, 27 Aug 2020 07:00:50 +0000
Date:   Thu, 27 Aug 2020 08:00:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 09/11] xfs: widen ondisk quota expiration timestamps to
 handle y2038+
Message-ID: <20200827070050.GC17534@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847955663.2601708.15732334977032233773.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159847955663.2601708.15732334977032233773.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 972c740aaf7b..9cf84b57e2ce 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1257,13 +1257,15 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>  #define XFS_DQTYPE_USER		0x01		/* user dquot record */
>  #define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
>  #define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
> +#define XFS_DQTYPE_BIGTIME	0x08		/* large expiry timestamps */

Maybe make this the high bit in the field to keep space for adding more
actual quota types if we need them?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
