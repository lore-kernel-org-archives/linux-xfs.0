Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64701C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 05:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjDKFG7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 01:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjDKFG6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 01:06:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913E42691
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 22:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PJBxrye33zmCbdVVzj/BDmxW4oXsGrmH/9m3ApNdE9E=; b=rfmokPPET7PJ3iEr3EG/RjXjG0
        gf6zz3cGZGPaDPDfKq13bCkXUJcPiCLjS1UCMHrmNh+DDU+uQCWKuTIH8G7IWqpX886gf4EBFOGBL
        daeIpdom+jlPvMq4hSUHmBCtamIM2oZrWcnl4rkdbe0dOoa3r1T7rh65SEO2cjvmRnYUxhBw0zXWJ
        eGYcgPjl3Zjp3TXtGtSIS1KBasD/uafK3oe5RTgghUV2lMNvyvvF0N/nsygLV2CHOVEaEkWKJTwMn
        RE1oUP3okKxQaHm6bFtAkrBW0bQOVGkOunDGZlO6/OOrcXorVyAiZddfi9UHSCuplfSRA8UeBcjsH
        a1YCMvoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm6DO-00GQoP-2d;
        Tue, 11 Apr 2023 05:06:46 +0000
Date:   Mon, 10 Apr 2023 22:06:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: _{attr,data}_map_shared should take ILOCK_EXCL
 until iread_extents is completely done
Message-ID: <ZDTq5mdvNErn+JrE@infradead.org>
References: <20230411010638.GF360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411010638.GF360889@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 10, 2023 at 06:06:38PM -0700, Darrick J. Wong wrote:
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1171,6 +1171,8 @@ xfs_iread_extents(
>  		goto out;
>  	}
>  	ASSERT(ir.loaded == xfs_iext_count(ifp));
> +	smp_mb();
> +	ifp->if_needextents = 0;

Shouldn't this be a WRITE_ONCE?

> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 6b21760184d9..eadae924dc42 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -174,6 +174,8 @@ xfs_iformat_btree(
>  	int			level;
>  
>  	ifp = xfs_ifork_ptr(ip, whichfork);
> +	ifp->if_needextents = 1;

Same here.

>  	dfp = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
>  	size = XFS_BMAP_BROOT_SPACE(mp, dfp);
>  	nrecs = be16_to_cpu(dfp->bb_numrecs);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index d3943d6ad0b9..e69c78c35c96 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -24,6 +24,7 @@ struct xfs_ifork {
>  	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
>  	short			if_broot_bytes;	/* bytes allocated for root */
>  	int8_t			if_format;	/* format of this fork */
> +	int8_t			if_needextents;	/* extents have not been read */
>  };

I don't think this should be signed.

>  static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
>  {
> -	return ifp->if_format == XFS_DINODE_FMT_BTREE && ifp->if_height == 0;
> +	return ifp->if_format == XFS_DINODE_FMT_BTREE && ifp->if_needextents;

.. and this should use READ_ONCE and drop the if_format check given
that if_needextents is only set in xfs_iformat_btree.
