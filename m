Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B73C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B764520663
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:17:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJ9ilraI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbgCPNRN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:17:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22835 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731033AbgCPNRN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 09:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584364631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ARArX7X5GXX7KCoFSS/eaMO0yNA2/1ewz2EOlPGFppo=;
        b=aJ9ilraIdxLoaZurBkuL0X5dctOrqUSPQOfTYyz/pbyvD1Uhfg4WsnbVd4JFMT6LZ+fqbz
        ELQ7pRzLPJm15ulpV68Yx7wpqcwOAt/QrrH17KRcNr6vwn+EmIIhlhVKjw5hy4wmVTD/Bk
        BuoI8YIn1QShn1P13dTLIiViy0VQ3I4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-v-u3_MG5PUmg6LNucQ91uA-1; Mon, 16 Mar 2020 09:17:10 -0400
X-MC-Unique: v-u3_MG5PUmg6LNucQ91uA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28C7A149C3;
        Mon, 16 Mar 2020 13:17:09 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D44FE5DA7B;
        Mon, 16 Mar 2020 13:17:08 +0000 (UTC)
Date:   Mon, 16 Mar 2020 09:17:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: only check the superblock version for dinode
 size calculation
Message-ID: <20200316131707.GF12313@bfoster>
References: <20200312142235.550766-1-hch@lst.de>
 <20200312142235.550766-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312142235.550766-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:22:32PM +0100, Christoph Hellwig wrote:
> The size of the dinode structure is only dependent on the file system
> version, so instead of checking the individual inode version just use
> the newly added xfs_sb_version_has_large_dinode helper, and simplify
> various calling conventions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  5 ++---
>  fs/xfs/libxfs/xfs_bmap.c       | 10 ++++------
>  fs/xfs/libxfs/xfs_format.h     | 15 +++++++--------
>  fs/xfs/libxfs/xfs_ialloc.c     |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h |  9 ++-------
>  fs/xfs/libxfs/xfs_log_format.h | 10 ++++------
>  fs/xfs/xfs_inode_item.c        |  4 ++--
>  fs/xfs/xfs_log_recover.c       |  2 +-
>  fs/xfs/xfs_symlink.c           |  2 +-
>  11 files changed, 26 insertions(+), 37 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index ad2b9c313fd2..518c6f0ec3a6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -183,7 +183,7 @@ xfs_iformat_local(
>  	 */
>  	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
>  		xfs_warn(ip->i_mount,
> -	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
> +	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",

Is this here intentionally? Otherwise seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  			(unsigned long long) ip->i_ino, size,
>  			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 500333d0101e..668ee942be22 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -46,14 +46,9 @@ struct xfs_ifork {
>  			(ip)->i_afp : \
>  			(ip)->i_cowfp))
>  #define XFS_IFORK_DSIZE(ip) \
> -	(XFS_IFORK_Q(ip) ? \
> -		XFS_IFORK_BOFF(ip) : \
> -		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version))
> +	(XFS_IFORK_Q(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
>  #define XFS_IFORK_ASIZE(ip) \
> -	(XFS_IFORK_Q(ip) ? \
> -		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version) - \
> -			XFS_IFORK_BOFF(ip) : \
> -		0)
> +	(XFS_IFORK_Q(ip) ? XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : 0)
>  #define XFS_IFORK_SIZE(ip,w) \
>  	((w) == XFS_DATA_FORK ? \
>  		XFS_IFORK_DSIZE(ip) : \
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 9bac0d2e56dc..76defbea8000 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -424,12 +424,10 @@ struct xfs_log_dinode {
>  	/* structure must be padded to 64 bit alignment */
>  };
>  
> -static inline uint xfs_log_dinode_size(int version)
> -{
> -	if (version == 3)
> -		return sizeof(struct xfs_log_dinode);
> -	return offsetof(struct xfs_log_dinode, di_next_unlinked);
> -}
> +#define xfs_log_dinode_size(mp)						\
> +	(xfs_sb_version_has_large_dinode(&(mp)->m_sb) ?				\
> +		sizeof(struct xfs_log_dinode) :				\
> +		offsetof(struct xfs_log_dinode, di_next_unlinked))
>  
>  /*
>   * Buffer Log Format definitions
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index f021b55a0301..451f9b6b2806 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -125,7 +125,7 @@ xfs_inode_item_size(
>  
>  	*nvecs += 2;
>  	*nbytes += sizeof(struct xfs_inode_log_format) +
> -		   xfs_log_dinode_size(ip->i_d.di_version);
> +		   xfs_log_dinode_size(ip->i_mount);
>  
>  	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
>  	if (XFS_IFORK_Q(ip))
> @@ -370,7 +370,7 @@ xfs_inode_item_format_core(
>  
>  	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
>  	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
> -	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
> +	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_mount));
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e5e976b5cc11..79fc85a4ff08 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3068,7 +3068,7 @@ xlog_recover_inode_pass2(
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
> -	isize = xfs_log_dinode_size(ldip->di_version);
> +	isize = xfs_log_dinode_size(mp);
>  	if (unlikely(item->ri_buf[1].i_len > isize)) {
>  		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index ea42e25ec1bf..fa0fa3c70f1a 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -192,7 +192,7 @@ xfs_symlink(
>  	 * The symlink will fit into the inode data fork?
>  	 * There can't be any attributes so we get the whole variable part.
>  	 */
> -	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
> +	if (pathlen <= XFS_LITINO(mp))
>  		fs_blocks = 0;
>  	else
>  		fs_blocks = xfs_symlink_blocks(mp, pathlen);
> -- 
> 2.24.1
> 

