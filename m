Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B94C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 17:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E82FB206BA
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 17:53:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Oo/wZ1uu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKKRxr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:53:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33196 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKKRxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 12:53:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TeFwu2Z/tusS80y3zEUDkBEYvRG+lcAmdyEw2HV1C0c=; b=Oo/wZ1uuJwE4L1E6jxAamlTtn
        A9xxoQPYg0RnYaejITN2m2dMLt0IZInZOMhPxy1/8NOIF37J/1x7hme9K7otl9kIQO7so0RvfoJFM
        bJbqFBsrOrXYKD2aWNO8HPYxyBEu7XhNZnDAx32w7hCf0VuToKylnQ3BC1GPdlw8QHFkWyGwNamur
        YJgoYu4f/TxCaOeCLLAgzGCCG/QZ0wvGCvS2R65z92YUffx7f/kk3hgNtjysyh18YH3rIHR4a4zSK
        KhNrvPeas1kDWAmN9Rl8WruACZvgy05lvrsM5ZNdZLZFKlJcJd3HyN10zJzfvdiP4jXita25K6/1X
        wqD6HGu4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iUDsp-0000oY-0r; Mon, 11 Nov 2019 17:53:47 +0000
Date:   Mon, 11 Nov 2019 09:53:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 05/17] xfs: Add xfs_has_attr and subroutines
Message-ID: <20191111175346.GC28708@infradead.org>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-6-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	if (!xfs_inode_hasattr(dp)) {
> +		error = -ENOATTR;
> +	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +		error = xfs_attr_shortform_hasname(args, NULL, NULL);
> +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +		error = xfs_attr_leaf_hasname(args, &bp);
> +		if (error != -ENOATTR && error != -EEXIST)
> +			goto out;
> +		xfs_trans_brelse(args->trans, bp);
> +	} else {
> +		error = xfs_attr_node_hasname(args, NULL);
> +	}
> +out:
> +	return error;
> +}

I think a lot of this would be much simpler without the goto out, e.g.:

	if (!xfs_inode_hasattr(dp))
		return -ENOATTR;

	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
		return xfs_attr_shortform_hasname(args, NULL, NULL);
	}

	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
		struct xfs_buf	*bp;
		int		error = xfs_attr_leaf_hasname(args, &bp);

		if (error == -ENOATTR || error == -EEXIST)
			xfs_trans_brelse(args->trans, bp);
		return error;
	}

	return xfs_attr_node_hasname(args, NULL);
