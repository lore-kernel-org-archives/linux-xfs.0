Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F58DCCA483
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jun 2022 07:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbiFZHsK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 03:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbiFZHsJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 03:48:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923F3FD8;
        Sun, 26 Jun 2022 00:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2TZRQN/GrmPBp8ytdnHV7foGFk0sHlg+XtRAmSyt/4I=; b=saNgYaHV4JuyNL5PDWEhbLb461
        cpore3km28Dk5GZXJzcFYSLbRbmOYeocRHbwrEGyr9+S5T47khW89iOLZftVXqi46r1KQ3Cg5/rJ4
        d5PpypmD2NRXHC+gFeJXhcmWjm70i5QkN97/1WLLts9UYXdcFEDCAGU4eW5S1Ui6cA8Z4qFex+kvn
        VFagNAjta53MDywfJ/+qEfOuqrIPoGgTkiyP7GKNNhLhUG7rl4vn26coquzR3oXccLvoN3E5ZsMgG
        YgiQeq0z2NzkqY82PKJUuycAzTBYGIiH1s/PU4O7ZoX/ocF9uuvIniz+sWxs4lmy97l0uBAKfxUQU
        hGEQZDFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o5N04-00AStc-6E; Sun, 26 Jun 2022 07:48:08 +0000
Date:   Sun, 26 Jun 2022 00:48:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-api@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 2/8] vfs: support STATX_DIOALIGN on block devices
Message-ID: <YrgPOHarxLdMt2m2@infradead.org>
References: <20220616201506.124209-1-ebiggers@kernel.org>
 <20220616201506.124209-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616201506.124209-3-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 01:15:00PM -0700, Eric Biggers wrote:
> +/* Handle STATX_DIOALIGN for block devices. */
> +static inline void handle_bdev_dioalign(struct path *path, u32 request_mask,
> +					struct kstat *stat)
> +{
> +#ifdef CONFIG_BLOCK
> +	struct inode *inode;
> +	struct block_device *bdev;
> +	unsigned int lbs;
> +
> +	if (likely(!(request_mask & STATX_DIOALIGN)))
> +		return;
> +
> +	inode = d_backing_inode(path->dentry);
> +	if (!S_ISBLK(inode->i_mode))
> +		return;
> +
> +	bdev = blkdev_get_no_open(inode->i_rdev);
> +	if (!bdev)
> +		return;
> +
> +	lbs = bdev_logical_block_size(bdev);
> +	stat->dio_mem_align = lbs;
> +	stat->dio_offset_align = lbs;
> +	stat->result_mask |= STATX_DIOALIGN;
> +
> +	blkdev_put_no_open(bdev);
> +#endif /* CONFIG_BLOCK */
> +}

This helper should go into block/bdev.c with the STATX_DIOALIGN and
S_ISBLK checks lifted into the caller.  I'd also pass just the inode
here.

Note that this also needs to account for the reduced memory alignment
that landed in the block tree eventually.
