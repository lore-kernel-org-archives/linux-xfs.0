Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E1AC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 00:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2890A6128E
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 00:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhDNAJB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 20:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhDNAJB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 20:09:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E929961246;
        Wed, 14 Apr 2021 00:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618358921;
        bh=MqN6tUdq+DwpaT7L8+6UwZrAu2STkjo/7G2caSFtN3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IPZTIkw3s/57SUgi8xUuB1czUDvp6f0KBAgjpAaahoRZp9cNAGLqSmYEClPJ/BSXO
         up7f46Ei1dmp5g+zhRLDZm+HUzSo+viDpg/TOiMVH7htruS6lYPCZVjlDoSBe07ZaG
         dJCvge+dVTlP3X628E4CQBsi2S0x3QCX6BwVN67OGNJZIZC9A2zd/xf/KOrIJ0IW6P
         3ZjtVD9ERrYssS2gqXBDkCs+odRV0An8zQYhDJ9991kdmYC6+FqfftkU/iNxTMyNYI
         16Y5Y6dzH//8emUuFsYo9rj3VAv5Z+kBaYNkKSe6cUb7cjOFLnzuJbOAldzaHQK8La
         KqzuKfzO+WL9w==
Date:   Tue, 13 Apr 2021 17:08:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/7] xfs: only look at the fork format in
 xfs_idestroy_fork
Message-ID: <20210414000839.GR3957620@magnolia>
References: <20210412133819.2618857-1-hch@lst.de>
 <20210412133819.2618857-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412133819.2618857-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 03:38:16PM +0200, Christoph Hellwig wrote:
> Stop using the XFS_IFEXTENTS flag, and instead switch on the fork format
> in xfs_idestroy_fork to decide how to cleanup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index a8800ff03f9432..73eea7939b55e4 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -522,17 +522,16 @@ xfs_idestroy_fork(
>  		ifp->if_broot = NULL;
>  	}
>  
> -	/*
> -	 * If the format is local, then we can't have an extents array so just
> -	 * look for an inline data array.  If we're not local then we may or may
> -	 * not have an extents list, so check and free it up if we do.
> -	 */
> -	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
> +	switch (ifp->if_format) {
> +	case XFS_DINODE_FMT_LOCAL:
>  		kmem_free(ifp->if_u1.if_data);
>  		ifp->if_u1.if_data = NULL;
> -	} else if (ifp->if_flags & XFS_IFEXTENTS) {
> +		break;
> +	case XFS_DINODE_FMT_EXTENTS:
> +	case XFS_DINODE_FMT_BTREE:
>  		if (ifp->if_height)
>  			xfs_iext_destroy(ifp);
> +		break;
>  	}
>  }
>  
> -- 
> 2.30.1
> 
