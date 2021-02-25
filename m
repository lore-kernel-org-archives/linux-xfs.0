Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7005EC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3165A64EF1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhBYIKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbhBYIJz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:09:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AD8C061786
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IPtXa99fLwlS3ftiJk3XEEs+Is6D11slIy/E4P2YHug=; b=Qnlr6vzyxu4Ouec7FaO5DnCS7s
        BDNtjwvhKf/E0+SGh74JAN5hhrzzgGYivFBVJARStDPkGMo1E2TWh4BtLD5cY/XrHQmVjN32/PfvT
        QbIAb4WX8MLQq7LrhDafzchtvkEIECdo7E8uOx4Xids7PnhY5M7hZz9i9QF6ybznQNqDo2aIs0S3t
        FWrF2w2IDSosin7eAXNUeJEslcxTWN83rMGEpj4C9WdXLxsbYREF1YmMI3NLT/LoTEKG87hSVcACF
        5Z+jh9Tv2NC93rtCmVUnNc7/wTMp518dyZB3x+qPbl5eI8AtKMdociRCAZlK6pxtpSuov/JXjNH79
        2pmloTDQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBhk-00ARp7-3P; Thu, 25 Feb 2021 08:09:03 +0000
Date:   Thu, 25 Feb 2021 08:09:00 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: initialise attr fork on inode create
Message-ID: <20210225080900.GH2483198@infradead.org>
References: <20210222230556.GR4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222230556.GR4662@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This look really nice to me, but a few comments on the overall
structure:

> +/*
> + * Set an inode attr fork offset based on the format of the data fork.
> + *
> + * If a size of zero is passed in, then caller does not know the size of
> + * the attribute that might be added (i.e. pre-emptive attr fork creation).
> + * Hence in this case just set the fork offset to the default so that we don't
> + * need to modify the supported attr format in the superblock.
> + */
>  int
>  xfs_bmap_set_attrforkoff(
>  	struct xfs_inode	*ip,
> @@ -1041,6 +1048,11 @@ xfs_bmap_set_attrforkoff(
>  	case XFS_DINODE_FMT_LOCAL:
>  	case XFS_DINODE_FMT_EXTENTS:
>  	case XFS_DINODE_FMT_BTREE:
> +		if (size == 0) {
> +			ASSERT(!version);
> +			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> +			break;
> +		}
>  		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
>  		if (!ip->i_d.di_forkoff)
>  			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;

I don't think cramming this special case into xfs_bmap_set_attrforkoff
makes a whole lot of sense.  I'd rather just open code this logic into
the caller like this:

	if (init_xattrs) {
		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
	}

which seems a whole lot simpler and much more obvious than the rather
arcane calling conventions for this magic invocation of 
xfs_bmap_set_attrforkoffxfs_bmap_set_attrforkoff.

> +struct xfs_ifork *
> +xfs_ifork_alloc(
> +	enum xfs_dinode_fmt	format,
> +	xfs_extnum_t		nextents)
> +{
> +	struct xfs_ifork	*ifp;
> +
> +	ifp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
> +	ifp->if_format = format;
> +	ifp->if_nextents = nextents;
> +	return ifp;
> +}

Please split the addition of xfs_ifork_alloc and the conversion of the
existing calles into a prep patch.

> -	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
> -		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;

This check is lost.  I think we're fine as we don't support such old
file systems at all, but we should probably document this change (and
maybe even split it into a separate prep patch).

>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>  
>  int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 636ac13b1df2..95e3a5e6e5e2 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -773,6 +773,7 @@ xfs_init_new_inode(
>  	xfs_nlink_t		nlink,
>  	dev_t			rdev,
>  	prid_t			prid,
> +	bool			init_xattrs,
>  	struct xfs_inode	**ipp)
>  {
>  	struct inode		*dir = pip ? VFS_I(pip) : NULL;

So instead of passing the parameter down a few levels I think we can
just take the decision inside of xfs_init_new_inode with a simple check
like:

	if (pip && nlink > 0 && !S_ISLNK(mode) &&
	    xfs_create_need_xattr(dir, default_acl, acl)) {
	    	...
	}

> +static inline bool
> +xfs_create_need_xattr(
> +	struct inode	*dir,
> +	struct posix_acl *default_acl,
> +	struct posix_acl *acl)
> +{
> +	if (acl)
> +		return true;
> +	if (default_acl)
> +		return true;
> +	if (!IS_ENABLED(CONFIG_SECURITY))
> +		return false;
> +	if (dir->i_sb->s_security)
> +		return true;
> +	return false;
> +}

This isn't XFS-specific.  Please move it to fs.h and split it into another
prep patch.  Also this won't compile as-is as s_security only exists
when CONFIG_SECURITY is defined, so the IS_ENABLED needs to be replaced
with an ifdef.
