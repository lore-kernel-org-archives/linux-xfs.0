Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C1AC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 989E061A1E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbhCXSc0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237608AbhCXScO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D43E619B4;
        Wed, 24 Mar 2021 18:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616610734;
        bh=V8/mj4YEv5w1sOkupp6KjEbCfPLyw8ZT8Veul9ovYsg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mm4/wehpI1uDPeQBF2ect2M16T3qp2P0DdkNJHEW5ZiDDsIKgtVQ7JXcJj6hRY5Te
         zTfHSSsuUgFptl+jzNAKTX5Ysq1MPJjmsJ+dAloaq1eu8hLFqF+Pe4tl9vWkierrqg
         KRCpX4HKQauREu9tTP179gtIk7IJ5UWopHb3RnhGrUxaa1x/Xa5BR39DwLFtIjuRAs
         NYAU5wE7QeYGqvjCnfeQQj6iE7ALI2bCT7j9Oj3q/kujm28KLK66But8buYUXXl7dX
         rVgPvMnvtyykUgSJGPBQbb8WAksF2MQCJ6arx4m3Dg90KQNF19UqguhpWz3VpU+yq6
         8xlDUHmRe8Zjg==
Date:   Wed, 24 Mar 2021 11:32:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/18] xfs: move the di_flushiter field to struct
 xfs_inode
Message-ID: <20210324183213.GK22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-13-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:23PM +0100, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the
> flushiter field into the containing xfs_inode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems pretty straightforward,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h |  1 -
>  fs/xfs/xfs_icache.c           |  2 +-
>  fs/xfs/xfs_inode.c            | 19 +++++++++----------
>  fs/xfs/xfs_inode.h            |  1 +
>  fs/xfs/xfs_inode_item.c       |  2 +-
>  6 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 9f208d2c8ddb4d..d090274fb8a152 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -193,7 +193,7 @@ xfs_inode_from_disk(
>  	 * inode. If the inode is unused, mode is zero and we shouldn't mess
>  	 * with the uninitialized part of it.
>  	 */
> -	to->di_flushiter = be16_to_cpu(from->di_flushiter);
> +	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
>  	inode->i_generation = be32_to_cpu(from->di_gen);
>  	inode->i_mode = be16_to_cpu(from->di_mode);
>  	if (!inode->i_mode)
> @@ -327,7 +327,7 @@ xfs_inode_to_disk(
>  		to->di_flushiter = 0;
>  	} else {
>  		to->di_version = 2;
> -		to->di_flushiter = cpu_to_be16(from->di_flushiter);
> +		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
>  	}
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 77d250dbe96848..e41a11bef04436 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -16,7 +16,6 @@ struct xfs_dinode;
>   * format specific structures at the appropriate time.
>   */
>  struct xfs_icdinode {
> -	uint16_t	di_flushiter;	/* incremented on flush */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
>  
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index d7952d5955ede5..5c68e3069a8783 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -499,7 +499,7 @@ xfs_iget_cache_miss(
>  	 * simply build the new inode core with a random generation number.
>  	 *
>  	 * For version 4 (and older) superblocks, log recovery is dependent on
> -	 * the di_flushiter field being initialised from the current on-disk
> +	 * the i_flushiter field being initialised from the current on-disk
>  	 * value and hence we must also read the inode off disk even when
>  	 * initializing new inodes.
>  	 */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b8f38423f8c451..e951ea48b3a276 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3430,16 +3430,15 @@ xfs_iflush(
>  	}
>  
>  	/*
> -	 * Inode item log recovery for v2 inodes are dependent on the
> -	 * di_flushiter count for correct sequencing. We bump the flush
> -	 * iteration count so we can detect flushes which postdate a log record
> -	 * during recovery. This is redundant as we now log every change and
> -	 * hence this can't happen but we need to still do it to ensure
> -	 * backwards compatibility with old kernels that predate logging all
> -	 * inode changes.
> +	 * Inode item log recovery for v2 inodes are dependent on the flushiter
> +	 * count for correct sequencing.  We bump the flush iteration count so
> +	 * we can detect flushes which postdate a log record during recovery.
> +	 * This is redundant as we now log every change and hence this can't
> +	 * happen but we need to still do it to ensure backwards compatibility
> +	 * with old kernels that predate logging all inode changes.
>  	 */
>  	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
> -		ip->i_d.di_flushiter++;
> +		ip->i_flushiter++;
>  
>  	/*
>  	 * If there are inline format data / attr forks attached to this inode,
> @@ -3460,8 +3459,8 @@ xfs_iflush(
>  	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
>  
>  	/* Wrap, we never let the log put out DI_MAX_FLUSH */
> -	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
> -		ip->i_d.di_flushiter = 0;
> +	if (ip->i_flushiter == DI_MAX_FLUSH)
> +		ip->i_flushiter = 0;
>  
>  	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
>  	if (XFS_IFORK_Q(ip))
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 36eb33d9bcbdcc..6246ee8a4359ab 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -59,6 +59,7 @@ typedef struct xfs_inode {
>  	uint32_t		i_projid;	/* owner's project id */
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
>  	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
> +	uint16_t		i_flushiter;	/* incremented on flush */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 44902fd513eb0b..091436857ee74b 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -396,7 +396,7 @@ xfs_inode_to_log_dinode(
>  		to->di_flushiter = 0;
>  	} else {
>  		to->di_version = 2;
> -		to->di_flushiter = from->di_flushiter;
> +		to->di_flushiter = ip->i_flushiter;
>  	}
>  }
>  
> -- 
> 2.30.1
> 
