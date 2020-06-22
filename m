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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA8CC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 09:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B222B20708
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 09:24:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kAztAlKh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgFVJYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 05:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgFVJYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 05:24:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66277C061794
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 02:24:04 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 35so7347440ple.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 02:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SSRHJAId7ZuSuvqr4RQasMw+aSTmyJdcEt8Mgri6Hs8=;
        b=kAztAlKhcWr8V5vwBIFoiI4/PUKC034rFt1UAfj8jtG8r8V81564rlWSYDXij3dTFZ
         yvjFajRLAyo1dFIJQIp1SGnc2DjOEJ5EPwUcJPIEeg1VFLBjp3fHsaMVlcZaJ+sKfOY1
         BnyeCei8A4HiXztKMF/cRKPNKKjSTIsqPzHatf6A3utojq8iiYqdascP3CYZ6Mbcb8xs
         fW0IxrclQFw0FRFzLr1573SFrQXhnAljOzb2diVygIGywdYBbr1zRmPuCm++kujIm5c/
         NoMkPPDVJAncWIH72Btn0feEzclHl1NC57kmgcnjPrbK/Zkd02oLLwbhJN6xKBtY/uZw
         mVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SSRHJAId7ZuSuvqr4RQasMw+aSTmyJdcEt8Mgri6Hs8=;
        b=hieZNpeJSuGw1ksEPeGCJhfYjd4pF5GmpUmZLK0T3fwaJ8vX07m0pJHyJMwF9uAWxo
         aQSmN3sXXXqQ/EUfXG8bnR4ozmqueeaC5QFZAYODanuGgfK4wbn9q8RP7JKUtG8WMkAZ
         FmQ6F1Xd/HSu+kesxB/Czlap8nG3cqI2mDIPHfAh7WL0YAU9wNDGtETbElzSjtaJqeYx
         4+UzGQrNqHpGJzD99vetml3fvJxm0iFykn91vP2GuFBOlzRP1llPQkX2x5dIF05HJ6YI
         VB1hQzH5hyfO1QOTpJnn4985T5mQ6DcGG5TD1ZMPve6odsmXNDrEMZewOF8shFGgLyFp
         /ZPA==
X-Gm-Message-State: AOAM531UTkQUskL4IgLFLplIji4FXC2khwYyHQ73CPxchStRMsKDErDP
        8FFkck6TMXCa0yuKE75YM29RhtJo
X-Google-Smtp-Source: ABdhPJx154xZXw0IOrcKNtGeCdXu4+r/Tocue/5xIFE7Q/IoLBd+hDvXLyLF/uOauPYDArNahAYqDA==
X-Received: by 2002:a17:90a:ab88:: with SMTP id n8mr8839883pjq.34.1592817843530;
        Mon, 22 Jun 2020 02:24:03 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id q9sm14840160pfu.45.2020.06.22.02.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:24:03 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/15] xfs: move the di_size field to struct xfs_inode
Date:   Mon, 22 Jun 2020 14:54:00 +0530
Message-ID: <3239403.q4Xj0k9eOE@garuda>
In-Reply-To: <20200620071102.462554-4-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-4-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:40:50 PM IST Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the on-disk
> size field into the containing xfs_inode structure.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       |  2 +-
>  fs/xfs/libxfs/xfs_dir2.c       | 14 +++++------
>  fs/xfs/libxfs/xfs_dir2_block.c | 10 ++++----
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |  2 +-
>  fs/xfs/libxfs/xfs_dir2_node.c  |  2 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c    | 46 +++++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_inode_buf.c  |  4 +--
>  fs/xfs/libxfs/xfs_inode_buf.h  |  1 -
>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>  fs/xfs/scrub/dir.c             |  6 ++---
>  fs/xfs/scrub/parent.c          |  2 +-
>  fs/xfs/scrub/symlink.c         |  2 +-
>  fs/xfs/xfs_aops.c              |  4 +--
>  fs/xfs/xfs_bmap_util.c         |  6 ++---
>  fs/xfs/xfs_dir2_readdir.c      |  2 +-
>  fs/xfs/xfs_file.c              |  2 +-
>  fs/xfs/xfs_inode.c             |  8 +++---
>  fs/xfs/xfs_inode.h             |  5 ++--
>  fs/xfs/xfs_inode_item.c        |  4 +--
>  fs/xfs/xfs_iomap.c             |  2 +-
>  fs/xfs/xfs_iops.c              | 12 ++++-----
>  fs/xfs/xfs_itable.c            |  2 +-
>  fs/xfs/xfs_pnfs.c              |  2 +-
>  fs/xfs/xfs_qm_syscalls.c       |  2 +-
>  fs/xfs/xfs_reflink.c           |  4 +--
>  fs/xfs/xfs_rtalloc.c           |  8 +++---
>  fs/xfs/xfs_symlink.c           | 16 ++++++------
>  fs/xfs/xfs_trace.h             | 16 ++++++------
>  28 files changed, 94 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 667cdd0dfdf4a3..56d78f8ba55eb6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1445,7 +1445,7 @@ xfs_bmap_last_offset(
>  
>  /*
>   * Returns whether the selected fork of the inode has exactly one
> - * block or not.  For the data fork we check this matches di_size,
> + * block or not.  For the data fork we check this matches i_disk_size,
>   * implying the file's range is 0..bsize-1.
>   */
>  int					/* 1=>1 block, 0=>otherwise */
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 612a9c5e41b1c6..050bdcc4fe7376 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -179,9 +179,9 @@ xfs_dir_isempty(
>  	xfs_dir2_sf_hdr_t	*sfp;
>  
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
> -	if (dp->i_d.di_size == 0)	/* might happen during shutdown. */
> +	if (dp->i_disk_size == 0)	/* might happen during shutdown. */
>  		return 1;
> -	if (dp->i_d.di_size > XFS_IFORK_DSIZE(dp))
> +	if (dp->i_disk_size > XFS_IFORK_DSIZE(dp))
>  		return 0;
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>  	return !sfp->count;
> @@ -584,8 +584,8 @@ xfs_dir2_grow_inode(
>  		xfs_fsize_t	size;		/* directory file (data) size */
>  
>  		size = XFS_FSB_TO_B(mp, bno + count);
> -		if (size > dp->i_d.di_size) {
> -			dp->i_d.di_size = size;
> +		if (size > dp->i_disk_size) {
> +			dp->i_disk_size = size;
>  			xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
>  		}
>  	}
> @@ -608,7 +608,7 @@ xfs_dir2_isblock(
>  	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
>  	if (XFS_IS_CORRUPT(args->dp->i_mount,
>  			   rval != 0 &&
> -			   args->dp->i_d.di_size != args->geo->blksize))
> +			   args->dp->i_disk_size != args->geo->blksize))
>  		return -EFSCORRUPTED;
>  	*vp = rval;
>  	return 0;
> @@ -687,7 +687,7 @@ xfs_dir2_shrink_inode(
>  	/*
>  	 * If the block isn't the last one in the directory, we're done.
>  	 */
> -	if (dp->i_d.di_size > xfs_dir2_db_off_to_byte(args->geo, db + 1, 0))
> +	if (dp->i_disk_size > xfs_dir2_db_off_to_byte(args->geo, db + 1, 0))
>  		return 0;
>  	bno = da;
>  	if ((error = xfs_bmap_last_before(tp, dp, &bno, XFS_DATA_FORK))) {
> @@ -703,7 +703,7 @@ xfs_dir2_shrink_inode(
>  	/*
>  	 * Set the size to the new last block.
>  	 */
> -	dp->i_d.di_size = XFS_FSB_TO_B(mp, bno);
> +	dp->i_disk_size = XFS_FSB_TO_B(mp, bno);
>  	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 5b59d3f7746b34..7824af54637513 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -961,7 +961,7 @@ xfs_dir2_leaf_to_block(
>  	 * been left behind during no-space-reservation operations.
>  	 * These will show up in the leaf bests table.
>  	 */
> -	while (dp->i_d.di_size > args->geo->blksize) {
> +	while (dp->i_disk_size > args->geo->blksize) {
>  		int hdrsz;
>  
>  		hdrsz = args->geo->data_entry_offset;
> @@ -1097,13 +1097,13 @@ xfs_dir2_sf_to_block(
>  	trace_xfs_dir2_sf_to_block(args);
>  
>  	ASSERT(ifp->if_flags & XFS_IFINLINE);
> -	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
> +	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  
>  	oldsfp = (xfs_dir2_sf_hdr_t *)ifp->if_u1.if_data;
>  
> -	ASSERT(ifp->if_bytes == dp->i_d.di_size);
> +	ASSERT(ifp->if_bytes == dp->i_disk_size);
>  	ASSERT(ifp->if_u1.if_data != NULL);
> -	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
> +	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
>  	ASSERT(dp->i_df.if_nextents == 0);
>  
>  	/*
> @@ -1115,7 +1115,7 @@ xfs_dir2_sf_to_block(
>  
>  	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
>  	xfs_bmap_local_to_extents_empty(tp, dp, XFS_DATA_FORK);
> -	dp->i_d.di_size = 0;
> +	dp->i_disk_size = 0;
>  
>  	/*
>  	 * Add block 0 to the inode.
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 95d2a3f92d75de..73fb3e1152e6d7 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -151,7 +151,7 @@ xfs_dir3_leaf_check_int(
>  	/*
>  	 * XXX (dgc): This value is not restrictive enough.
>  	 * Should factor in the size of the bests table as well.
> -	 * We can deduce a value for that from di_size.
> +	 * We can deduce a value for that from i_disk_size.
>  	 */
>  	if (hdr->count > geo->leaf_max_ents)
>  		return __this_address;
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 6ac4aad98cd76c..3698030ca5e2f7 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -441,7 +441,7 @@ xfs_dir2_leaf_to_node(
>  	leaf = lbp->b_addr;
>  	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
>  	if (be32_to_cpu(ltp->bestcount) >
> -				(uint)dp->i_d.di_size / args->geo->blksize) {
> +				(uint)dp->i_disk_size / args->geo->blksize) {
>  		xfs_buf_mark_corrupt(lbp);
>  		return -EFSCORRUPTED;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 2463b5d7344724..00fee3943a09dc 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -344,7 +344,7 @@ xfs_dir2_block_to_sf(
>  	ASSERT(dp->i_df.if_bytes == 0);
>  	xfs_init_local_fork(dp, XFS_DATA_FORK, sfp, size);
>  	dp->i_df.if_format = XFS_DINODE_FMT_LOCAL;
> -	dp->i_d.di_size = size;
> +	dp->i_disk_size = size;
>  
>  	logflags |= XFS_ILOG_DDATA;
>  	xfs_dir2_sf_check(args);
> @@ -367,7 +367,7 @@ xfs_dir2_sf_addname(
>  	xfs_inode_t		*dp;		/* incore directory inode */
>  	int			error;		/* error return value */
>  	int			incr_isize;	/* total change in size */
> -	int			new_isize;	/* di_size after adding name */
> +	int			new_isize;	/* size after adding name */
>  	int			objchange;	/* changing to 8-byte inodes */
>  	xfs_dir2_data_aoff_t	offset = 0;	/* offset for new entry */
>  	int			pick;		/* which algorithm to use */
> @@ -379,11 +379,11 @@ xfs_dir2_sf_addname(
>  	ASSERT(xfs_dir2_sf_lookup(args) == -ENOENT);
>  	dp = args->dp;
>  	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> -	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
> -	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
> +	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
> +	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> -	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
> +	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
>  	/*
>  	 * Compute entry (and change in) size.
>  	 */
> @@ -401,7 +401,7 @@ xfs_dir2_sf_addname(
>  		objchange = 1;
>  	}
>  
> -	new_isize = (int)dp->i_d.di_size + incr_isize;
> +	new_isize = (int)dp->i_disk_size + incr_isize;
>  	/*
>  	 * Won't fit as shortform any more (due to size),
>  	 * or the pick routine says it won't (due to offset values).
> @@ -492,7 +492,7 @@ xfs_dir2_sf_addname_easy(
>  	sfp->count++;
>  	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM)
>  		sfp->i8count++;
> -	dp->i_d.di_size = new_isize;
> +	dp->i_disk_size = new_isize;
>  	xfs_dir2_sf_check(args);
>  }
>  
> @@ -519,7 +519,7 @@ xfs_dir2_sf_addname_hard(
>  	int			nbytes;		/* temp for byte copies */
>  	xfs_dir2_data_aoff_t	new_offset;	/* next offset value */
>  	xfs_dir2_data_aoff_t	offset;		/* current offset value */
> -	int			old_isize;	/* previous di_size */
> +	int			old_isize;	/* previous size */
>  	xfs_dir2_sf_entry_t	*oldsfep;	/* entry in original dir */
>  	xfs_dir2_sf_hdr_t	*oldsfp;	/* original shortform dir */
>  	xfs_dir2_sf_entry_t	*sfep;		/* entry in new dir */
> @@ -529,7 +529,7 @@ xfs_dir2_sf_addname_hard(
>  	 * Copy the old directory to the stack buffer.
>  	 */
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> -	old_isize = (int)dp->i_d.di_size;
> +	old_isize = (int)dp->i_disk_size;
>  	buf = kmem_alloc(old_isize, 0);
>  	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
>  	memcpy(oldsfp, sfp, old_isize);
> @@ -586,7 +586,7 @@ xfs_dir2_sf_addname_hard(
>  		memcpy(sfep, oldsfep, old_isize - nbytes);
>  	}
>  	kmem_free(buf);
> -	dp->i_d.di_size = new_isize;
> +	dp->i_disk_size = new_isize;
>  	xfs_dir2_sf_check(args);
>  }
>  
> @@ -697,7 +697,7 @@ xfs_dir2_sf_check(
>  		ASSERT(xfs_dir2_sf_get_ftype(mp, sfep) < XFS_DIR3_FT_MAX);
>  	}
>  	ASSERT(i8count == sfp->i8count);
> -	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);
> +	ASSERT((char *)sfep - (char *)sfp == dp->i_disk_size);
>  	ASSERT(offset +
>  	       (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
>  	       (uint)sizeof(xfs_dir2_block_tail_t) <= args->geo->blksize);
> @@ -821,7 +821,7 @@ xfs_dir2_sf_create(
>  	dp = args->dp;
>  
>  	ASSERT(dp != NULL);
> -	ASSERT(dp->i_d.di_size == 0);
> +	ASSERT(dp->i_disk_size == 0);
>  	/*
>  	 * If it's currently a zero-length extent file,
>  	 * convert it to local format.
> @@ -850,7 +850,7 @@ xfs_dir2_sf_create(
>  	 */
>  	xfs_dir2_sf_put_parent_ino(sfp, pino);
>  	sfp->count = 0;
> -	dp->i_d.di_size = size;
> +	dp->i_disk_size = size;
>  	xfs_dir2_sf_check(args);
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  	return 0;
> @@ -878,11 +878,11 @@ xfs_dir2_sf_lookup(
>  	xfs_dir2_sf_check(args);
>  
>  	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> -	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
> -	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
> +	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
> +	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> -	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
> +	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
>  	/*
>  	 * Special case for .
>  	 */
> @@ -955,7 +955,7 @@ xfs_dir2_sf_removename(
>  	trace_xfs_dir2_sf_removename(args);
>  
>  	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> -	oldsize = (int)dp->i_d.di_size;
> +	oldsize = (int)dp->i_disk_size;
>  	ASSERT(oldsize >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  	ASSERT(dp->i_df.if_bytes == oldsize);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
> @@ -995,7 +995,7 @@ xfs_dir2_sf_removename(
>  	 * Fix up the header and file size.
>  	 */
>  	sfp->count--;
> -	dp->i_d.di_size = newsize;
> +	dp->i_disk_size = newsize;
>  	/*
>  	 * Reallocate, making it smaller.
>  	 */
> @@ -1054,11 +1054,11 @@ xfs_dir2_sf_replace(
>  	trace_xfs_dir2_sf_replace(args);
>  
>  	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> -	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
> -	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
> +	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
> +	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> -	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
> +	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
>  
>  	/*
>  	 * New inode number is large, and need to convert to 8-byte inodes.
> @@ -1219,7 +1219,7 @@ xfs_dir2_sf_toino4(
>  	 * Clean up the inode.
>  	 */
>  	kmem_free(buf);
> -	dp->i_d.di_size = newsize;
> +	dp->i_disk_size = newsize;
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  }
>  
> @@ -1292,6 +1292,6 @@ xfs_dir2_sf_toino8(
>  	 * Clean up the inode.
>  	 */
>  	kmem_free(buf);
> -	dp->i_d.di_size = newsize;
> +	dp->i_disk_size = newsize;
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index b064cb8072c84a..c202de8bbdd427 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -241,7 +241,7 @@ xfs_inode_from_disk(
>  	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
>  	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
>  
> -	to->di_size = be64_to_cpu(from->di_size);
> +	ip->i_disk_size = be64_to_cpu(from->di_size);
>  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
>  	to->di_extsize = be32_to_cpu(from->di_extsize);
>  	to->di_forkoff = from->di_forkoff;
> @@ -304,7 +304,7 @@ xfs_inode_to_disk(
>  	to->di_gen = cpu_to_be32(inode->i_generation);
>  	to->di_mode = cpu_to_be16(inode->i_mode);
>  
> -	to->di_size = cpu_to_be64(from->di_size);
> +	to->di_size = cpu_to_be64(ip->i_disk_size);
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
>  	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index b826d81b356956..f187127d50e010 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -17,7 +17,6 @@ struct xfs_dinode;
>   */
>  struct xfs_icdinode {
>  	uint16_t	di_flushiter;	/* incremented on flush */
> -	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 28b366275ae0ed..d2029e12bda4de 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -240,7 +240,7 @@ xfs_iformat_data_fork(
>  	case S_IFCHR:
>  	case S_IFBLK:
>  	case S_IFSOCK:
> -		ip->i_d.di_size = 0;
> +		ip->i_disk_size = 0;
>  		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
>  		return 0;
>  	case S_IFREG:
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 7c432997edade4..d89aa8efb84545 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -523,7 +523,7 @@ xchk_directory_leaf1_bestfree(
>  	 * There should be as many bestfree slots as there are dir data
>  	 * blocks that can fit under i_size.
>  	 */
> -	if (bestcount != xfs_dir2_byte_to_db(geo, sc->ip->i_d.di_size)) {
> +	if (bestcount != xfs_dir2_byte_to_db(geo, sc->ip->i_disk_size)) {
>  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  		goto out;
>  	}
> @@ -789,7 +789,7 @@ xchk_directory(
>  		return -ENOENT;
>  
>  	/* Plausible size? */
> -	if (sc->ip->i_d.di_size < xfs_dir2_sf_hdr_size(0)) {
> +	if (sc->ip->i_disk_size < xfs_dir2_sf_hdr_size(0)) {
>  		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
>  		goto out;
>  	}
> @@ -815,7 +815,7 @@ xchk_directory(
>  	 * Userspace usually asks for a 32k buffer, so we will too.
>  	 */
>  	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE,
> -			sc->ip->i_d.di_size);
> +			sc->ip->i_disk_size);
>  
>  	/*
>  	 * Look up every name in this directory by hash.
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 855aa8bcab64bd..766e870999a9a8 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -102,7 +102,7 @@ xchk_parent_count_parent_dentries(
>  	 * scanned.
>  	 */
>  	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE,
> -			parent->i_d.di_size);
> +			parent->i_disk_size);
>  	oldpos = 0;
>  	while (true) {
>  		error = xfs_readdir(sc->tp, parent, &spc.dc, bufsize);
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> index 5641ae512c9efc..9b751d79adf096 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -43,7 +43,7 @@ xchk_symlink(
>  	if (!S_ISLNK(VFS_I(ip)->i_mode))
>  		return -ENOENT;
>  	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> -	len = ip->i_d.di_size;
> +	len = ip->i_disk_size;
>  
>  	/* Plausible size? */
>  	if (len > XFS_SYMLINK_MAXLEN || len <= 0) {
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 2834cbf1212e5a..18a497cc817c2a 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -36,7 +36,7 @@ XFS_WPC(struct iomap_writepage_ctx *ctx)
>  static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
>  {
>  	return ioend->io_offset + ioend->io_size >
> -		XFS_I(ioend->io_inode)->i_d.di_size;
> +		XFS_I(ioend->io_inode)->i_disk_size;
>  }
>  
>  STATIC int
> @@ -88,7 +88,7 @@ __xfs_setfilesize(
>  
>  	trace_xfs_setfilesize(ip, offset, size);
>  
> -	ip->i_d.di_size = isize;
> +	ip->i_disk_size = isize;
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index e42553884c23cf..d199ecddc1ab19 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -423,7 +423,7 @@ xfs_getbmap(
>  		break;
>  	case XFS_DATA_FORK:
>  		if (!(iflags & BMV_IF_DELALLOC) &&
> -		    (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size)) {
> +		    (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_disk_size)) {
>  			error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
>  			if (error)
>  				goto out_unlock_iolock;
> @@ -1656,8 +1656,8 @@ xfs_swap_extents(
>  
>  	/* Verify all data are being swapped */
>  	if (sxp->sx_offset != 0 ||
> -	    sxp->sx_length != ip->i_d.di_size ||
> -	    sxp->sx_length != tip->i_d.di_size) {
> +	    sxp->sx_length != ip->i_disk_size ||
> +	    sxp->sx_length != tip->i_disk_size) {
>  		error = -EFAULT;
>  		goto out_trans_cancel;
>  	}
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 66deddd5e29698..03e7c39a07807a 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -58,7 +58,7 @@ xfs_dir2_sf_getdents(
>  	struct xfs_da_geometry	*geo = args->geo;
>  
>  	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> -	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
> +	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
>  
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 403c90309a8ffe..14b533a8ce8e6a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1137,7 +1137,7 @@ xfs_file_readdir(
>  	 * point we can change the ->readdir prototype to include the
>  	 * buffer size.  For now we use the current glibc buffer size.
>  	 */
> -	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE, ip->i_d.di_size);
> +	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE, ip->i_disk_size);
>  
>  	return xfs_readdir(NULL, ip, ctx, bufsize);
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 40e4d3ed29a798..723a911c8b6d81 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -825,7 +825,7 @@ xfs_ialloc(
>  	    (inode->i_mode & S_ISGID) && !in_group_p(inode->i_gid))
>  		inode->i_mode &= ~S_ISGID;
>  
> -	ip->i_d.di_size = 0;
> +	ip->i_disk_size = 0;
>  	ip->i_df.if_nextents = 0;
>  	ASSERT(ip->i_d.di_nblocks == 0);
>  
> @@ -1675,7 +1675,7 @@ xfs_inactive_truncate(
>  	 * of a system crash before the truncate completes. See the related
>  	 * comment in xfs_vn_setattr_size() for details.
>  	 */
> -	ip->i_d.di_size = 0;
> +	ip->i_disk_size = 0;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
> @@ -1831,7 +1831,7 @@ xfs_inactive(
>  	}
>  
>  	if (S_ISREG(VFS_I(ip)->i_mode) &&
> -	    (ip->i_d.di_size != 0 || XFS_ISIZE(ip) != 0 ||
> +	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
>  	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
>  		truncate = 1;
>  
> @@ -2729,7 +2729,7 @@ xfs_ifree(
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT(VFS_I(ip)->i_nlink == 0);
>  	ASSERT(ip->i_df.if_nextents == 0);
> -	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
> +	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
>  	ASSERT(ip->i_d.di_nblocks == 0);
>  
>  	/*
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 51ea9d53407863..61c41395536f07 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -54,6 +54,7 @@ typedef struct xfs_inode {
>  	/* Miscellaneous state. */
>  	unsigned long		i_flags;	/* see defined flags below */
>  	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
> +	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
>  	uint32_t		i_projid;	/* owner's project id */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
> @@ -88,7 +89,7 @@ static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
>  {
>  	if (S_ISREG(VFS_I(ip)->i_mode))
>  		return i_size_read(VFS_I(ip));
> -	return ip->i_d.di_size;
> +	return ip->i_disk_size;
>  }
>  
>  /*
> @@ -102,7 +103,7 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
>  
>  	if (new_size > i_size || new_size < 0)
>  		new_size = i_size;
> -	return new_size > ip->i_d.di_size ? new_size : 0;
> +	return new_size > ip->i_disk_size ? new_size : 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index e546b4b58ce2e0..179f1c2de6bd0f 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -196,7 +196,7 @@ xfs_inode_item_format_data_fork(
>  			 */
>  			data_bytes = roundup(ip->i_df.if_bytes, 4);
>  			ASSERT(ip->i_df.if_u1.if_data != NULL);
> -			ASSERT(ip->i_d.di_size > 0);
> +			ASSERT(ip->i_disk_size > 0);
>  			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
>  					ip->i_df.if_u1.if_data, data_bytes);
>  			ilf->ilf_dsize = (unsigned)data_bytes;
> @@ -323,7 +323,7 @@ xfs_inode_to_log_dinode(
>  	to->di_gen = inode->i_generation;
>  	to->di_mode = inode->i_mode;
>  
> -	to->di_size = from->di_size;
> +	to->di_size = ip->i_disk_size;
>  	to->di_nblocks = from->di_nblocks;
>  	to->di_extsize = from->di_extsize;
>  	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index b9a8c3798e08fc..6e03963b6b300e 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -583,7 +583,7 @@ xfs_iomap_write_unwritten(
>  			i_size_write(inode, i_size);
>  		i_size = xfs_new_eof(ip, i_size);
>  		if (i_size) {
> -			ip->i_d.di_size = i_size;
> +			ip->i_disk_size = i_size;
>  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		}
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 5440f555c9cc2c..1abee83d49cff9 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -935,8 +935,8 @@ xfs_setattr_size(
>  	 * operation.
>  	 *
>  	 * And we update in-core i_size and truncate page cache beyond newsize
> -	 * before writeback the [di_size, newsize] range, so we're guaranteed
> -	 * not to write stale data past the new EOF on truncate down.
> +	 * before writeback the [i_disk_size, newsize] range, so we're
> +	 * guaranteed not to write stale data past the new EOF on truncate down.
>  	 */
>  	truncate_setsize(inode, newsize);
>  
> @@ -949,9 +949,9 @@ xfs_setattr_size(
>  	 * otherwise those blocks may not be zeroed after a crash.
>  	 */
>  	if (did_zeroing ||
> -	    (newsize > ip->i_d.di_size && oldsize != ip->i_d.di_size)) {
> +	    (newsize > ip->i_disk_size && oldsize != ip->i_disk_size)) {
>  		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> -						ip->i_d.di_size, newsize - 1);
> +						ip->i_disk_size, newsize - 1);
>  		if (error)
>  			return error;
>  	}
> @@ -993,7 +993,7 @@ xfs_setattr_size(
>  	 * permanent before actually freeing any blocks it doesn't matter if
>  	 * they get written to.
>  	 */
> -	ip->i_d.di_size = newsize;
> +	ip->i_disk_size = newsize;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	if (newsize <= oldsize) {
> @@ -1323,7 +1323,7 @@ xfs_setup_inode(
>  	/* make the inode look hashed for the writeback code */
>  	inode_fake_hash(inode);
>  
> -	i_size_write(inode, ip->i_d.di_size);
> +	i_size_write(inode, ip->i_disk_size);
>  	xfs_diflags_to_iflags(ip, true);
>  
>  	if (S_ISDIR(inode->i_mode)) {
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 97b3b794dd4ada..9f92514301b334 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -88,7 +88,7 @@ xfs_bulkstat_one_int(
>  	buf->bs_ino = ino;
>  	buf->bs_uid = i_uid_read(inode);
>  	buf->bs_gid = i_gid_read(inode);
> -	buf->bs_size = dic->di_size;
> +	buf->bs_size = ip->i_disk_size;
>  
>  	buf->bs_nlink = inode->i_nlink;
>  	buf->bs_atime = inode->i_atime.tv_sec;
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index b101feb2aab452..e6caca783764f9 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -286,7 +286,7 @@ xfs_fs_commit_blocks(
>  	xfs_setattr_time(ip, iattr);
>  	if (update_isize) {
>  		i_size_write(inode, iattr->ia_size);
> -		ip->i_d.di_size = iattr->ia_size;
> +		ip->i_disk_size = iattr->ia_size;
>  	}
>  
>  	xfs_trans_set_sync(tp);
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 7effd7a2813656..08dec36095fae2 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -293,7 +293,7 @@ xfs_qm_scall_trunc_qfile(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	ip->i_d.di_size = 0;
> +	ip->i_disk_size = 0;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 107bf2a2f3448a..8598896156e29a 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -938,7 +938,7 @@ xfs_reflink_update_dest(
>  	if (newlen > i_size_read(VFS_I(dest))) {
>  		trace_xfs_reflink_update_inode_size(dest, newlen);
>  		i_size_write(VFS_I(dest), newlen);
> -		dest->i_d.di_size = newlen;
> +		dest->i_disk_size = newlen;
>  	}
>  
>  	if (cowextsize) {
> @@ -1078,7 +1078,7 @@ xfs_reflink_remap_extent(
>  		if (newlen > i_size_read(VFS_I(ip))) {
>  			trace_xfs_reflink_update_inode_size(ip, newlen);
>  			i_size_write(VFS_I(ip), newlen);
> -			ip->i_d.di_size = newlen;
> +			ip->i_disk_size = newlen;
>  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		}
>  
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6209e7b6b895b8..cc07d7d27dd7e0 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -941,8 +941,8 @@ xfs_growfs_rt(
>  	 * Get the old block counts for bitmap and summary inodes.
>  	 * These can't change since other growfs callers are locked out.
>  	 */
> -	rbmblocks = XFS_B_TO_FSB(mp, mp->m_rbmip->i_d.di_size);
> -	rsumblocks = XFS_B_TO_FSB(mp, mp->m_rsumip->i_d.di_size);
> +	rbmblocks = XFS_B_TO_FSB(mp, mp->m_rbmip->i_disk_size);
> +	rsumblocks = XFS_B_TO_FSB(mp, mp->m_rsumip->i_disk_size);
>  	/*
>  	 * Allocate space to the bitmap and summary files, as necessary.
>  	 */
> @@ -1009,7 +1009,7 @@ xfs_growfs_rt(
>  		/*
>  		 * Update the bitmap inode's size.
>  		 */
> -		mp->m_rbmip->i_d.di_size =
> +		mp->m_rbmip->i_disk_size =
>  			nsbp->sb_rbmblocks * nsbp->sb_blocksize;
>  		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
>  		/*
> @@ -1020,7 +1020,7 @@ xfs_growfs_rt(
>  		/*
>  		 * Update the summary inode's size.
>  		 */
> -		mp->m_rsumip->i_d.di_size = nmp->m_rsumsize;
> +		mp->m_rsumip->i_disk_size = nmp->m_rsumsize;
>  		xfs_trans_log_inode(tp, mp->m_rsumip, XFS_ILOG_CORE);
>  		/*
>  		 * Copy summary data from old to new sizes.
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 8e88a7ca387ea9..6b8980b1497c9a 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -33,7 +33,7 @@ xfs_readlink_bmap_ilocked(
>  	struct xfs_buf		*bp;
>  	xfs_daddr_t		d;
>  	char			*cur_chunk;
> -	int			pathlen = ip->i_d.di_size;
> +	int			pathlen = ip->i_disk_size;
>  	int			nmaps = XFS_SYMLINK_MAPS;
>  	int			byte_cnt;
>  	int			n;
> @@ -86,7 +86,7 @@ xfs_readlink_bmap_ilocked(
>  	}
>  	ASSERT(pathlen == 0);
>  
> -	link[ip->i_d.di_size] = '\0';
> +	link[ip->i_disk_size] = '\0';
>  	error = 0;
>  
>   out:
> @@ -111,7 +111,7 @@ xfs_readlink(
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  
> -	pathlen = ip->i_d.di_size;
> +	pathlen = ip->i_disk_size;
>  	if (!pathlen)
>  		goto out;
>  
> @@ -250,7 +250,7 @@ xfs_symlink(
>  	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
>  		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
>  
> -		ip->i_d.di_size = pathlen;
> +		ip->i_disk_size = pathlen;
>  		ip->i_df.if_format = XFS_DINODE_FMT_LOCAL;
>  		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
>  	} else {
> @@ -265,7 +265,7 @@ xfs_symlink(
>  			goto out_trans_cancel;
>  
>  		resblks -= fs_blocks;
> -		ip->i_d.di_size = pathlen;
> +		ip->i_disk_size = pathlen;
>  		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  		cur_chunk = target_path;
> @@ -399,8 +399,8 @@ xfs_inactive_symlink_rmt(
>  	 * locked for the second transaction.  In the error paths we need it
>  	 * held so the cancel won't rele it, see below.
>  	 */
> -	size = (int)ip->i_d.di_size;
> -	ip->i_d.di_size = 0;
> +	size = (int)ip->i_disk_size;
> +	ip->i_disk_size = 0;
>  	VFS_I(ip)->i_mode = (VFS_I(ip)->i_mode & ~S_IFMT) | S_IFREG;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	/*
> @@ -476,7 +476,7 @@ xfs_inactive_symlink(
>  		return -EIO;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	pathlen = (int)ip->i_d.di_size;
> +	pathlen = (int)ip->i_disk_size;
>  	ASSERT(pathlen);
>  
>  	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN) {
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 460136628a7959..5cc73db80ae0c0 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1140,7 +1140,7 @@ DECLARE_EVENT_CLASS(xfs_file_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
> -		__entry->size = ip->i_d.di_size;
> +		__entry->size = ip->i_disk_size;
>  		__entry->offset = offset;
>  		__entry->count = count;
>  	),
> @@ -1181,7 +1181,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
> -		__entry->size = ip->i_d.di_size;
> +		__entry->size = ip->i_disk_size;
>  		__entry->offset = offset;
>  		__entry->count = count;
>  		__entry->whichfork = whichfork;
> @@ -1227,7 +1227,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
>  		__entry->isize = VFS_I(ip)->i_size;
> -		__entry->disize = ip->i_d.di_size;
> +		__entry->disize = ip->i_disk_size;
>  		__entry->offset = offset;
>  		__entry->count = count;
>  	),
> @@ -1265,7 +1265,7 @@ DECLARE_EVENT_CLASS(xfs_itrunc_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
> -		__entry->size = ip->i_d.di_size;
> +		__entry->size = ip->i_disk_size;
>  		__entry->new_size = new_size;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx",
> @@ -1295,7 +1295,7 @@ TRACE_EVENT(xfs_pagecache_inval,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
> -		__entry->size = ip->i_d.di_size;
> +		__entry->size = ip->i_disk_size;
>  		__entry->start = start;
>  		__entry->finish = finish;
>  	),
> @@ -1323,7 +1323,7 @@ TRACE_EVENT(xfs_bunmap,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
> -		__entry->size = ip->i_d.di_size;
> +		__entry->size = ip->i_disk_size;
>  		__entry->bno = bno;
>  		__entry->len = len;
>  		__entry->caller_ip = caller_ip;
> @@ -2984,12 +2984,12 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
>  		__entry->dev = VFS_I(src)->i_sb->s_dev;
>  		__entry->src_ino = src->i_ino;
>  		__entry->src_isize = VFS_I(src)->i_size;
> -		__entry->src_disize = src->i_d.di_size;
> +		__entry->src_disize = src->i_disk_size;
>  		__entry->src_offset = soffset;
>  		__entry->len = len;
>  		__entry->dest_ino = dest->i_ino;
>  		__entry->dest_isize = VFS_I(dest)->i_size;
> -		__entry->dest_disize = dest->i_d.di_size;
> +		__entry->dest_disize = dest->i_disk_size;
>  		__entry->dest_offset = doffset;
>  	),
>  	TP_printk("dev %d:%d count %zd "
> 


-- 
chandan



