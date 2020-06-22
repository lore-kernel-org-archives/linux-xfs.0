Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D00C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 09:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D94520708
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 09:33:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGKuUOHB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgFVJdE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 05:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbgFVJdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 05:33:04 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033F0C061794
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 02:33:04 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b16so8134343pfi.13
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 02:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7NM+EIPECho7Du9zirb071w5o8JOCuXD3m5mBdbBkdY=;
        b=hGKuUOHBwOzAA7Nw6sAe7HATZ1rX5/rwNZ/Td+sc5XsQ1AfdkaE655mvHqopG5nWl6
         r71QX5e44bv6iyiOL3UwfAs4P0GiL8JCIrzclHoCAxmQd3of3Z1da8vRQTOk9p5h2FHY
         515tCNdmC6ra7U3RKJGQBBXBibykO+65J7bXc2CgNsh4zNYrsIQoINH6st710DBK8dYg
         ZlyBPerXITxMB9WjAz3BcyU/4DkZcOcM/0iix3oYJmxCqom5LW/anqhXOK44cY1XxmVn
         wJw1LGsaS5PFS1/zd+LSaax3p2j/dFO7oFTGVFJ6OTGclL5gnOEmVp2Ld73SychSuuxO
         rePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7NM+EIPECho7Du9zirb071w5o8JOCuXD3m5mBdbBkdY=;
        b=pKqYEPCOrh25MWzJnG+h9xlO7bMov9EFUM5EHbQmJSy0zYQT20+pUqU+Tx2T+kUiJU
         5qBB9ak+PwkfVIPZwjpZ+m/Y4YSfPmstzjfE2P4Q8buvc1FdR6DOAbo8Nf4OlzXGsfaB
         /dmusVzT5Fv8qyB7ohX1X2Fp9Lp5RwDuBEW9nG1Uipchur9GGdDxL0IzRQNlIy5kpNCT
         g5RNNOySWaAE/TPFtqQcQVytbEuMcQkM4E1vVJlxaVXR4ZKA21vT1wBlNgG/9dqYgoQn
         e/tEaA9OQhlSWSbN4lH69u/mQtKfnEzy/ChmjzH86QYOLNgGr1f5WoM+l/9M+wI2QEiL
         ukjQ==
X-Gm-Message-State: AOAM530cBZMVhSZq4rMVsknjGsGNKWU31IytIMShWcZq5iTtWdZ6aHe+
        Nphbf3rT5u8gEF6lXtnSPVJfGyeG
X-Google-Smtp-Source: ABdhPJy/Q0iM9vINI2gpQuaQeXZG4P0YYc8v3gSxTGSzCvX8M0UxuMCWPQ+YkTMeswkaZ8FV/cVV7Q==
X-Received: by 2002:a62:ee0b:: with SMTP id e11mr18951889pfi.185.1592818383284;
        Mon, 22 Jun 2020 02:33:03 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id 140sm13561283pfv.38.2020.06.22.02.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:33:02 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/15] xfs: move the di_nblocks field to struct xfs_inode
Date:   Mon, 22 Jun 2020 15:03:00 +0530
Message-ID: <6322676.GXjEgjZpzN@garuda>
In-Reply-To: <20200620071102.462554-5-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-5-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:40:51 PM IST Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the nblocks
> field into the containing xfs_inode structure.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 12 ++++++------
>  fs/xfs/libxfs/xfs_bmap_btree.c |  4 ++--
>  fs/xfs/libxfs/xfs_da_btree.c   |  4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.c  |  4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h  |  1 -
>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>  fs/xfs/xfs_bmap_util.c         |  8 ++++----
>  fs/xfs/xfs_icache.c            |  4 ++--
>  fs/xfs/xfs_inode.c             |  8 ++++----
>  fs/xfs/xfs_inode.h             |  1 +
>  fs/xfs/xfs_inode_item.c        |  2 +-
>  fs/xfs/xfs_iops.c              |  3 +--
>  fs/xfs/xfs_itable.c            |  2 +-
>  fs/xfs/xfs_qm.c                | 10 +++++-----
>  fs/xfs/xfs_quotaops.c          |  2 +-
>  15 files changed, 33 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 56d78f8ba55eb6..54f3015f08285a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -623,7 +623,7 @@ xfs_bmap_btree_to_extents(
>  		return error;
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
>  	xfs_bmap_add_free(cur->bc_tp, cbno, 1, &oinfo);
> -	ip->i_d.di_nblocks--;
> +	ip->i_nblocks--;
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
>  	xfs_trans_binval(tp, cbp);
>  	if (cur->bc_bufs[0] == cbp)
> @@ -725,7 +725,7 @@ xfs_bmap_extents_to_btree(
>  	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
>  	tp->t_firstblock = args.fsbno;
>  	cur->bc_ino.allocated++;
> -	ip->i_d.di_nblocks++;
> +	ip->i_nblocks++;
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
>  	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
>  			XFS_FSB_TO_DADDR(mp, args.fsbno),
> @@ -907,7 +907,7 @@ xfs_bmap_local_to_extents(
>  	xfs_iext_insert(ip, &icur, &rec, 0);
>  
>  	ifp->if_nextents = 1;
> -	ip->i_d.di_nblocks = 1;
> +	ip->i_nblocks = 1;
>  	xfs_trans_mod_dquot_byino(tp, ip,
>  		XFS_TRANS_DQ_BCOUNT, 1L);
>  	flags |= xfs_ilog_fext(whichfork);
> @@ -3448,7 +3448,7 @@ xfs_bmap_btalloc_accounting(
>  	}
>  
>  	/* data/attr fork only */
> -	ap->ip->i_d.di_nblocks += args->len;
> +	ap->ip->i_nblocks += args->len;
>  	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
>  	if (ap->wasdel) {
>  		ap->ip->i_delayed_blks -= args->len;
> @@ -4659,7 +4659,7 @@ xfs_bmapi_remap(
>  		ASSERT(got.br_startoff - bno >= len);
>  	}
>  
> -	ip->i_d.di_nblocks += len;
> +	ip->i_nblocks += len;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	if (ifp->if_flags & XFS_IFBROOT) {
> @@ -5225,7 +5225,7 @@ xfs_bmap_del_extent_real(
>  	 * Adjust inode # blocks in the file.
>  	 */
>  	if (nblks)
> -		ip->i_d.di_nblocks -= nblks;
> +		ip->i_nblocks -= nblks;
>  	/*
>  	 * Adjust quota data.
>  	 */
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index d9c63f17d2decd..9ad4c6a1eec518 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -260,7 +260,7 @@ xfs_bmbt_alloc_block(
>  	ASSERT(args.len == 1);
>  	cur->bc_tp->t_firstblock = args.fsbno;
>  	cur->bc_ino.allocated++;
> -	cur->bc_ino.ip->i_d.di_nblocks++;
> +	cur->bc_ino.ip->i_nblocks++;
>  	xfs_trans_log_inode(args.tp, cur->bc_ino.ip, XFS_ILOG_CORE);
>  	xfs_trans_mod_dquot_byino(args.tp, cur->bc_ino.ip,
>  			XFS_TRANS_DQ_BCOUNT, 1L);
> @@ -287,7 +287,7 @@ xfs_bmbt_free_block(
>  
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
>  	xfs_bmap_add_free(cur->bc_tp, fsbno, 1, &oinfo);
> -	ip->i_d.di_nblocks--;
> +	ip->i_nblocks--;
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 897749c41f36eb..55fadffb8752d3 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2139,7 +2139,7 @@ xfs_da_grow_inode_int(
>  	struct xfs_trans	*tp = args->trans;
>  	struct xfs_inode	*dp = args->dp;
>  	int			w = args->whichfork;
> -	xfs_rfsblock_t		nblks = dp->i_d.di_nblocks;
> +	xfs_rfsblock_t		nblks = dp->i_nblocks;
>  	struct xfs_bmbt_irec	map, *mapp;
>  	int			nmap, error, got, i, mapi;
>  
> @@ -2205,7 +2205,7 @@ xfs_da_grow_inode_int(
>  	}
>  
>  	/* account for newly allocated blocks in reserved blocks total */
> -	args->total -= dp->i_d.di_nblocks - nblks;
> +	args->total -= dp->i_nblocks - nblks;
>  
>  out_free_map:
>  	if (mapp != &map)
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index c202de8bbdd427..d1a15778e86a38 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -242,7 +242,7 @@ xfs_inode_from_disk(
>  	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
>  
>  	ip->i_disk_size = be64_to_cpu(from->di_size);
> -	to->di_nblocks = be64_to_cpu(from->di_nblocks);
> +	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
>  	to->di_extsize = be32_to_cpu(from->di_extsize);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
> @@ -305,7 +305,7 @@ xfs_inode_to_disk(
>  	to->di_mode = cpu_to_be16(inode->i_mode);
>  
>  	to->di_size = cpu_to_be64(ip->i_disk_size);
> -	to->di_nblocks = cpu_to_be64(from->di_nblocks);
> +	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
>  	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
>  	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index f187127d50e010..a322e1adf0a348 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -17,7 +17,6 @@ struct xfs_dinode;
>   */
>  struct xfs_icdinode {
>  	uint16_t	di_flushiter;	/* incremented on flush */
> -	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index d2029e12bda4de..391836dd4814e0 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -192,7 +192,7 @@ xfs_iformat_btree(
>  		     nrecs == 0 ||
>  		     XFS_BMDR_SPACE_CALC(nrecs) >
>  					XFS_DFORK_SIZE(dip, mp, whichfork) ||
> -		     ifp->if_nextents > ip->i_d.di_nblocks) ||
> +		     ifp->if_nextents > ip->i_nblocks) ||
>  		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
>  		xfs_warn(mp, "corrupt inode %Lu (btree).",
>  					(unsigned long long) ip->i_ino);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index d199ecddc1ab19..5eba039d72fb83 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -154,7 +154,7 @@ xfs_bmap_rtalloc(
>  		ap->blkno *= mp->m_sb.sb_rextsize;
>  		ralen *= mp->m_sb.sb_rextsize;
>  		ap->length = ralen;
> -		ap->ip->i_d.di_nblocks += ralen;
> +		ap->ip->i_nblocks += ralen;
>  		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
>  		if (ap->wasdel)
>  			ap->ip->i_delayed_blks -= ralen;
> @@ -1469,9 +1469,9 @@ xfs_swap_extent_forks(
>  	/*
>  	 * Fix the on-disk inode values
>  	 */
> -	tmp = (uint64_t)ip->i_d.di_nblocks;
> -	ip->i_d.di_nblocks = tip->i_d.di_nblocks - taforkblks + aforkblks;
> -	tip->i_d.di_nblocks = tmp + taforkblks - aforkblks;
> +	tmp = (uint64_t)ip->i_nblocks;
> +	ip->i_nblocks = tip->i_nblocks - taforkblks + aforkblks;
> +	tip->i_nblocks = tmp + taforkblks - aforkblks;
>  
>  	/*
>  	 * The extents in the source inode could still contain speculative
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a3bbd6e4bb6fc8..ad01e694f3ab9b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -66,7 +66,7 @@ xfs_inode_alloc(
>  	memset(&ip->i_df, 0, sizeof(ip->i_df));
>  	ip->i_flags = 0;
>  	ip->i_delayed_blks = 0;
> -	ip->i_d.di_nblocks = 0;
> +	ip->i_nblocks = 0;
>  	ip->i_d.di_forkoff = 0;
>  	ip->i_sick = 0;
>  	ip->i_checked = 0;
> @@ -331,7 +331,7 @@ xfs_iget_check_free_state(
>  			return -EFSCORRUPTED;
>  		}
>  
> -		if (ip->i_d.di_nblocks != 0) {
> +		if (ip->i_nblocks != 0) {
>  			xfs_warn(ip->i_mount,
>  "Corruption detected! Free inode 0x%llx has blocks allocated!",
>  				ip->i_ino);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 723a911c8b6d81..19d132acc499cb 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -827,7 +827,7 @@ xfs_ialloc(
>  
>  	ip->i_disk_size = 0;
>  	ip->i_df.if_nextents = 0;
> -	ASSERT(ip->i_d.di_nblocks == 0);
> +	ASSERT(ip->i_nblocks == 0);
>  
>  	tv = current_time(inode);
>  	inode->i_mtime = tv;
> @@ -2730,7 +2730,7 @@ xfs_ifree(
>  	ASSERT(VFS_I(ip)->i_nlink == 0);
>  	ASSERT(ip->i_df.if_nextents == 0);
>  	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
> -	ASSERT(ip->i_d.di_nblocks == 0);
> +	ASSERT(ip->i_nblocks == 0);
>  
>  	/*
>  	 * Pull the on-disk inode from the AGI unlinked list.
> @@ -3747,13 +3747,13 @@ xfs_iflush_int(
>  		}
>  	}
>  	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
> -				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
> +				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: detected corrupt incore inode %Lu, "
>  			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
>  			__func__, ip->i_ino,
>  			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
> -			ip->i_d.di_nblocks, ip);
> +			ip->i_nblocks, ip);
>  		goto flush_out;
>  	}
>  	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 61c41395536f07..828f49f109475e 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -55,6 +55,7 @@ typedef struct xfs_inode {
>  	unsigned long		i_flags;	/* see defined flags below */
>  	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
>  	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
> +	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	uint32_t		i_projid;	/* owner's project id */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 179f1c2de6bd0f..0980fa43472cf8 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -324,7 +324,7 @@ xfs_inode_to_log_dinode(
>  	to->di_mode = inode->i_mode;
>  
>  	to->di_size = ip->i_disk_size;
> -	to->di_nblocks = from->di_nblocks;
> +	to->di_nblocks = ip->i_nblocks;
>  	to->di_extsize = from->di_extsize;
>  	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
>  	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 1abee83d49cff9..78159c57d82828 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -554,8 +554,7 @@ xfs_vn_getattr(
>  	stat->atime = inode->i_atime;
>  	stat->mtime = inode->i_mtime;
>  	stat->ctime = inode->i_ctime;
> -	stat->blocks =
> -		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
> +	stat->blocks = XFS_FSB_TO_BB(mp, ip->i_nblocks + ip->i_delayed_blks);
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		if (request_mask & STATX_BTIME) {
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 9f92514301b334..7af144500bbfdb 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -130,7 +130,7 @@ xfs_bulkstat_one_int(
>  	case XFS_DINODE_FMT_BTREE:
>  		buf->bs_rdev = 0;
>  		buf->bs_blksize = mp->m_sb.sb_blocksize;
> -		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks;
> +		buf->bs_blocks = ip->i_nblocks + ip->i_delayed_blks;
>  		break;
>  	}
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index ea22dcf868b474..3af3b5f5d4f2ad 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -989,7 +989,7 @@ xfs_qm_reset_dqcounts_buf(
>  	 * trans_reserve. But, this gets called during quotacheck, and that
>  	 * happens only at mount time which is single threaded.
>  	 */
> -	if (qip->i_d.di_nblocks == 0)
> +	if (qip->i_nblocks == 0)
>  		return 0;
>  
>  	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
> @@ -1171,7 +1171,7 @@ xfs_qm_dqusage_adjust(
>  		xfs_bmap_count_leaves(ifp, &rtblks);
>  	}
>  
> -	nblks = (xfs_qcnt_t)ip->i_d.di_nblocks - rtblks;
> +	nblks = (xfs_qcnt_t)ip->i_nblocks - rtblks;
>  
>  	/*
>  	 * Add the (disk blocks and inode) resources occupied by this
> @@ -1774,11 +1774,11 @@ xfs_qm_vop_chown(
>  	ASSERT(prevdq);
>  	ASSERT(prevdq != newdq);
>  
> -	xfs_trans_mod_dquot(tp, prevdq, bfield, -(ip->i_d.di_nblocks));
> +	xfs_trans_mod_dquot(tp, prevdq, bfield, -(ip->i_nblocks));
>  	xfs_trans_mod_dquot(tp, prevdq, XFS_TRANS_DQ_ICOUNT, -1);
>  
>  	/* the sparkling new dquot */
> -	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_d.di_nblocks);
> +	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_nblocks);
>  	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
>  
>  	/*
> @@ -1854,7 +1854,7 @@ xfs_qm_vop_chown_reserve(
>  
>  	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
>  				udq_delblks, gdq_delblks, pdq_delblks,
> -				ip->i_d.di_nblocks, 1, flags | blkflags);
> +				ip->i_nblocks, 1, flags | blkflags);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index bf809b77a31606..09a5290ad2bd1b 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -35,7 +35,7 @@ xfs_qm_fill_state(
>  		tempqip = true;
>  	}
>  	tstate->flags |= QCI_SYSFILE;
> -	tstate->blocks = ip->i_d.di_nblocks;
> +	tstate->blocks = ip->i_nblocks;
>  	tstate->nextents = ip->i_df.if_nextents;
>  	tstate->spc_timelimit = (u32)defq->btimelimit;
>  	tstate->ino_timelimit = (u32)defq->itimelimit;
> 


-- 
chandan



