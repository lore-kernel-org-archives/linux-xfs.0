Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD61C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 15:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7071619AB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 15:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhC3PZr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 11:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232389AbhC3PZk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 11:25:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97275619A7;
        Tue, 30 Mar 2021 15:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617117939;
        bh=sWAi3rtxIofvIv379ZcsDcoGhQ65Lo5vP4iD1zHDnBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tTakyiCZozkXGhTv4mFbHMbBRqt9Zxmz84WBdfONVWKubjgRHaMsoVJ0giXnRyDjL
         K7uZQ/p1EiJetAJHLrJAILDKZa3c2klMvoveepqq1l08tf2EIUWk8ij7h7YBbWjx/p
         vOWdytoOmkkfbA2BkjV4+wY/XwGy8n0Y/s1QVb5ytWIJq5tCxNFHvazeHENgjUyOJt
         vH0y57lqDCwKafG+0hDQYgMFoLB8G4KUO3qyH8aoY6Ziab9w3DXescm4/o6oQo++bG
         xHYUyAht9H9tsAZoqxnT8oW/lUYNde1rRa5aisJic4l+mElf/RAsMir+PoJqACvCTY
         g1YiaO+KELuzA==
Date:   Tue, 30 Mar 2021 08:25:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/20] xfs: merge _xfs_dic2xflags into xfs_ip2xflags
Message-ID: <20210330152538.GP4090233@magnolia>
References: <20210329053829.1851318-1-hch@lst.de>
 <20210329053829.1851318-21-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329053829.1851318-21-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 07:38:29AM +0200, Christoph Hellwig wrote:
> Merge _xfs_dic2xflags into its only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me wonders if/how this will clash with Miklos' fileattr series, but eh,
whatever, I don't think it will, and if it does it's easy enough to fix.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 54 +++++++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3006cfbd072617..9100a9b7aa80cb 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -598,65 +598,55 @@ xfs_lock_two_inodes(
>  	}
>  }
>  
> -STATIC uint
> -_xfs_dic2xflags(
> -	uint16_t		di_flags,
> -	uint64_t		di_flags2,
> -	bool			has_attr)
> +uint
> +xfs_ip2xflags(
> +	struct xfs_inode	*ip)
>  {
>  	uint			flags = 0;
>  
> -	if (di_flags & XFS_DIFLAG_ANY) {
> -		if (di_flags & XFS_DIFLAG_REALTIME)
> +	if (ip->i_diflags & XFS_DIFLAG_ANY) {
> +		if (ip->i_diflags & XFS_DIFLAG_REALTIME)
>  			flags |= FS_XFLAG_REALTIME;
> -		if (di_flags & XFS_DIFLAG_PREALLOC)
> +		if (ip->i_diflags & XFS_DIFLAG_PREALLOC)
>  			flags |= FS_XFLAG_PREALLOC;
> -		if (di_flags & XFS_DIFLAG_IMMUTABLE)
> +		if (ip->i_diflags & XFS_DIFLAG_IMMUTABLE)
>  			flags |= FS_XFLAG_IMMUTABLE;
> -		if (di_flags & XFS_DIFLAG_APPEND)
> +		if (ip->i_diflags & XFS_DIFLAG_APPEND)
>  			flags |= FS_XFLAG_APPEND;
> -		if (di_flags & XFS_DIFLAG_SYNC)
> +		if (ip->i_diflags & XFS_DIFLAG_SYNC)
>  			flags |= FS_XFLAG_SYNC;
> -		if (di_flags & XFS_DIFLAG_NOATIME)
> +		if (ip->i_diflags & XFS_DIFLAG_NOATIME)
>  			flags |= FS_XFLAG_NOATIME;
> -		if (di_flags & XFS_DIFLAG_NODUMP)
> +		if (ip->i_diflags & XFS_DIFLAG_NODUMP)
>  			flags |= FS_XFLAG_NODUMP;
> -		if (di_flags & XFS_DIFLAG_RTINHERIT)
> +		if (ip->i_diflags & XFS_DIFLAG_RTINHERIT)
>  			flags |= FS_XFLAG_RTINHERIT;
> -		if (di_flags & XFS_DIFLAG_PROJINHERIT)
> +		if (ip->i_diflags & XFS_DIFLAG_PROJINHERIT)
>  			flags |= FS_XFLAG_PROJINHERIT;
> -		if (di_flags & XFS_DIFLAG_NOSYMLINKS)
> +		if (ip->i_diflags & XFS_DIFLAG_NOSYMLINKS)
>  			flags |= FS_XFLAG_NOSYMLINKS;
> -		if (di_flags & XFS_DIFLAG_EXTSIZE)
> +		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
>  			flags |= FS_XFLAG_EXTSIZE;
> -		if (di_flags & XFS_DIFLAG_EXTSZINHERIT)
> +		if (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT)
>  			flags |= FS_XFLAG_EXTSZINHERIT;
> -		if (di_flags & XFS_DIFLAG_NODEFRAG)
> +		if (ip->i_diflags & XFS_DIFLAG_NODEFRAG)
>  			flags |= FS_XFLAG_NODEFRAG;
> -		if (di_flags & XFS_DIFLAG_FILESTREAM)
> +		if (ip->i_diflags & XFS_DIFLAG_FILESTREAM)
>  			flags |= FS_XFLAG_FILESTREAM;
>  	}
>  
> -	if (di_flags2 & XFS_DIFLAG2_ANY) {
> -		if (di_flags2 & XFS_DIFLAG2_DAX)
> +	if (ip->i_diflags2 & XFS_DIFLAG2_ANY) {
> +		if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
>  			flags |= FS_XFLAG_DAX;
> -		if (di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> +		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
>  			flags |= FS_XFLAG_COWEXTSIZE;
>  	}
>  
> -	if (has_attr)
> +	if (XFS_IFORK_Q(ip))
>  		flags |= FS_XFLAG_HASATTR;
> -
>  	return flags;
>  }
>  
> -uint
> -xfs_ip2xflags(
> -	struct xfs_inode	*ip)
> -{
> -	return _xfs_dic2xflags(ip->i_diflags, ip->i_diflags2, XFS_IFORK_Q(ip));
> -}
> -
>  /*
>   * Lookups up an inode from "name". If ci_name is not NULL, then a CI match
>   * is allowed, otherwise it has to be an exact match. If a CI match is found,
> -- 
> 2.30.1
> 
