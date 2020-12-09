Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CA7C4361B
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 07:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A46C223BC4
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 07:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgLIHx3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 02:53:29 -0500
Received: from verein.lst.de ([213.95.11.211]:49035 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728436AbgLIHx3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Dec 2020 02:53:29 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6398067373; Wed,  9 Dec 2020 08:52:46 +0100 (CET)
Date:   Wed, 9 Dec 2020 08:52:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201209075246.GA10645@lst.de>
References: <20201208122003.3158922-1-hsiangkao@redhat.com> <20201208122003.3158922-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208122003.3158922-4-hsiangkao@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	/* Initialise the newly allocated inode. */
> +	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid);

IMHO this comment is not overly helpful..

> +	if (IS_ERR(ip)) {
> +		error = PTR_ERR(ip);
> +		ip = NULL;
>  		goto out_trans_cancel;
> +	}

And the calling convention with the ERR_PTR return does not seem to
fit the call chain to well.  But those are minor details, so:

>  STATIC int
>  xfs_qm_qino_alloc(
> -	xfs_mount_t	*mp,
> -	xfs_inode_t	**ip,
> -	uint		flags)
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	**ipp,
> +	unsigned int		flags)
>  {
>  	xfs_trans_t	*tp;
>  	int		error;
>  	bool		need_alloc = true;

Why do you reindent and de-typdefify the arguments, but not the local
variables?

All the stuff below also seems to deal with the fact that the old return
ip by reference calling convention seems to actually work better with
the code base..
