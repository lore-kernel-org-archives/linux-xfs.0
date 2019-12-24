Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44502C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DDC520722
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:16:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rh9nCHNJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfLXMQB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 07:16:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39682 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfLXMQB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 07:16:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1DS/Iw1/QjO97uwQ8JjPGjfbpnPjScWrnsbrWszlLmQ=; b=rh9nCHNJ3MRMgWVhV/O3a3UPc
        GxdHbrK4S5pDFsP+pn5U9AmFkF02+C/F8xSEFZEN0cPiOCH20rzkoHivJLZs73AaqhsJnXC9kYf2u
        iXZfipodZJxsqPy9KGaVu8hN3QKJXc164n/DVUDempdNbZLo3y/pI7gi3D2bHrDg2NUaJB5h1AUpv
        YuhJyzvQLBsUV5V8EnDZJSQdis6VarhM7zl8jtGsjRNFZY2rAkb+euTPZvmUay76pl3OPQRxFKGrB
        JcW/robgr/mRlZeePs473lzVVh24gjOLyGM4AamDfBZ5cHWCCAaeqTmGd7rfPDKTe5g5HKg2EFOER
        W6ZxPwPQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijj6X-0003gt-8T; Tue, 24 Dec 2019 12:16:01 +0000
Date:   Tue, 24 Dec 2019 04:16:01 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 06/14] xfs: Factor up trans handling in
 xfs_attr3_leaf_flipflags
Message-ID: <20191224121601.GC18379@infradead.org>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-7-allison.henderson@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

What does "factor up" mean?  Basically this moves the
xfs_trans_roll_inode from xfs_attr3_leaf_flipflags to the callers,
so I'd expect the subject to mention that.

> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);

Do we really still need these comments?

> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index ef96971..4fffa84 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2972,10 +2972,5 @@ xfs_attr3_leaf_flipflags(
>  			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -
>  	return error;

This can become a

	return 0;

now.
