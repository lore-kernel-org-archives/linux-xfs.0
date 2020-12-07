Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFADC4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 13:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33585233FA
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 13:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgLGNuY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:50:24 -0500
Received: from verein.lst.de ([213.95.11.211]:41927 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgLGNuY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 08:50:24 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 839A867373; Mon,  7 Dec 2020 14:49:41 +0100 (CET)
Date:   Mon, 7 Dec 2020 14:49:41 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201207134941.GD29249@lst.de>
References: <20201207001533.2702719-1-hsiangkao@redhat.com> <20201207001533.2702719-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207001533.2702719-4-hsiangkao@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 08:15:30AM +0800, Gao Xiang wrote:
>  /*
> + * Initialise a newly allocated inode and return the in-core inode to the
> + * caller locked exclusively.
>   */
> -static int
> -xfs_ialloc(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*pip,
> -	umode_t		mode,
> -	xfs_nlink_t	nlink,
> -	dev_t		rdev,
> -	prid_t		prid,
> -	xfs_buf_t	**ialloc_context,
> -	xfs_inode_t	**ipp)
> +static struct xfs_inode *
> +xfs_dir_ialloc_init(

This is boderline bikeshedding, but I would just call this
xfs_init_new_inode.

>  int
>  xfs_dir_ialloc(
> @@ -954,83 +908,59 @@ xfs_dir_ialloc(
>  	xfs_inode_t	**ipp)		/* pointer to inode; it will be
>  					   locked. */
>  {
>  	xfs_inode_t	*ip;
>  	xfs_buf_t	*ialloc_context = NULL;
> +	xfs_ino_t	pino = dp ? dp->i_ino : 0;

Maybe spell out parent_inode?  pino reminds of some of the weird Windows
code that start all variable names for pointers with a "p".

> +	/* Initialise the newly allocated inode. */
> +	ip = xfs_dir_ialloc_init(*tpp, dp, ino, mode, nlink, rdev, prid);
> +	if (IS_ERR(ip))
> +		return PTR_ERR(ip);
> +	*ipp = ip;
>  	return 0;

I wonder if we should just return the inode by reference from
xfs_dir_ialloc_init as well, as that nicely fits the calling convention
in the caller, i.e. this could become

	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid, ipp);

Note with the right naming we don't really need the comment either,
as the function name should explain everything.
