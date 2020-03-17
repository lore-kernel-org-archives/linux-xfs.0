Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAB8C1975A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 18:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 583AB20714
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 18:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LJTbMExo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCQScc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 14:32:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43806 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgCQScc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 14:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=POGBCeL7joT41DWMU0Y0FuQbB2RUMjVoaJ4kiR5oVG4=; b=LJTbMExo9DMOUsFRCB6b6jk0fi
        pFA3mUP4pQZu56+hOuSEvNx8MQYCs0OLlkk9ET1IAnUfIQIZ+kFOZ/dVFQcBSBJMEykjat6gQtSgY
        s1Tj6x5n1YBAbygRv1PSJVcsuNLo2VbxGO2xy8t188Zau1f9ubEkaySKNTpzFcv9mqSpOCR1N9USd
        XXvdW0ncvRSS8C7Fb+fmkHiB4dGdF63NRHaPblueJpCTabMW5T2ukPnBiFtg+oyrTjBvjMP5kjWCf
        VdJ/CevhuZxghiqD16/OT9IxGDXYU8x+XjeECYOVjXkRVQptz3QMDQh893+4811z/NmJBnovLUWSY
        S+avprxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEH0p-0007pW-I7; Tue, 17 Mar 2020 18:32:23 +0000
Date:   Tue, 17 Mar 2020 11:32:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     bfoster@redhat.com, dchinner@redhat.com, sandeen@sandeen.net,
        darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com
Subject: Re: [PATCH 2/2] xfs: avoid f_bfree overflow
Message-ID: <20200317183223.GA23580@infradead.org>
References: <1584364028-122886-1-git-send-email-zhengbin13@huawei.com>
 <1584364028-122886-3-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584364028-122886-3-git-send-email-zhengbin13@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	if (sbp->sb_fdblocks < mp->m_alloc_set_aside) {
> +		xfs_alert(mp, "Corruption detected. Please run xfs_repair.");
> +		error = -EFSCORRUPTED;
> +		goto out_log_dealloc;
> +	}
> +
>  	/*
>  	 * Get and sanity-check the root inode.
>  	 * Save the pointer to it in the mount structure.
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2094386..9dcf772 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -755,7 +755,8 @@ xfs_fs_statfs(
>  	statp->f_blocks = sbp->sb_dblocks - lsize;
>  	spin_unlock(&mp->m_sb_lock);
> 
> -	statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
> +	/* make sure statp->f_bfree does not underflow */
> +	statp->f_bfree = max_t(int64_t, fdblocks - mp->m_alloc_set_aside, 0);

How can this happen with the above hunk applies?  And even if we'd
need to do the sanity chck it shold be two separate patches.
