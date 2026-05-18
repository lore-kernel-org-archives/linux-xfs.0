Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C950E350A18
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 11:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779104616; cv=none; b=SZ6TUCN7u7m0cJlf6k/vPZLxV7ar/Js1h/aQkViYj8K9BR9supACYTMQaZRBzNo0ZwKg2T906ATSgaRLoLoUvcjMdQkNBnLWprxKWrYheAA3uqKRmlK5y6xBboDn8YJKG84yaU5hgJCE+4i0hz60TABucXwpEEObwX85tDYaikw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779104616; c=relaxed/simple;
	bh=T6YdimN0xbrMwJr49d2ztIt8MwuCeDVuBDAZ83Fuip4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IFTOZE7hLl8OMY9SEC7r8fdELwtvH1kxtumEyR/hQmaLXxj0HdzJqnA7FJbhln/UbXKr4V82tvK6c4fPU4YRSpi00DgnSVMf4QbOVL9eqS8HYyeDuXxaffn58u4VMBB38N5bvKvwdnj0LzsGQdh7WohL5yxY2u4mHzLJA+m/7j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQP1vbi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQP1vbi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B90C2BCC6;
	Mon, 18 May 2026 11:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779104616;
	bh=T6YdimN0xbrMwJr49d2ztIt8MwuCeDVuBDAZ83Fuip4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uQP1vbi4XHXc9kS4q58PmYQwhKyihk/4f8GxEUi+tZKU+mguse9dyQZL2cRyjRv/R
	 ZZ1bV0NfN7ihxPhbGyDyeC6y50MdUtAwba9AF0pHjT7dGe1qwUgWnKeM0BjjwhFOXn
	 4NLocY67+K8xBXPdfpo3RZWR9my2uSV+dnQBMxwMFiSwmoybqSJLm7UjrDzJUFFTNZ
	 okiBiJwMfqwfA+IjOVSOi4Fx2b+Kiq+6u/NXS97evhg6r3+DBUsm3T8OZ9HuExfnlz
	 uJX6/4RJg8sD5PACGLOVP7pQ+gWibk8n81oAHeLL0ScZO5Soaih2FcA+9YU6heqz4t
	 ghkf0UnjZ6Gig==
Date: Mon, 18 May 2026 13:43:31 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: remove the i_ino field in struct xfs_inode
Message-ID: <agr4VE7rjTlK0Qk1@nidhogg.toxiclabs.cc>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515135103.4042407-10-hch@lst.de>

On Fri, May 15, 2026 at 03:50:30PM +0200, Christoph Hellwig wrote:
> Now that the VFS inode has a u64 i_ino field, there is no need to store
> a copy of the inode number in the xfs_inode structure.
> 
> Introduce an I_INO() wrapper as a shortcut to the inode number so that
> we don't have to propagate the VFS inode everywhere.
> 
> The only non-obvious part is the clearing of i_ino to 0 for RCU freeing
> the inode.  None of this calls into VFS paths, which makes clearing the
> VFS inode field here just as safe as clearing the old field in the
> xfs_inode.
> 

This looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c             |   2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c        |   2 +-
>  fs/xfs/libxfs/xfs_bmap.c             |   6 +-
>  fs/xfs/libxfs/xfs_bmap_btree.c       |   4 +-
>  fs/xfs/libxfs/xfs_btree.c            |   8 +-
>  fs/xfs/libxfs/xfs_btree_staging.c    |   2 +-
>  fs/xfs/libxfs/xfs_da_btree.c         |   2 +-
>  fs/xfs/libxfs/xfs_dir2.c             |  40 +++++-----
>  fs/xfs/libxfs/xfs_dir2_node.c        |   2 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c          |   4 +-
>  fs/xfs/libxfs/xfs_exchmaps.c         |   8 +-
>  fs/xfs/libxfs/xfs_format.h           |   6 +-
>  fs/xfs/libxfs/xfs_ialloc.c           |   2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c        |   4 +-
>  fs/xfs/libxfs/xfs_inode_fork.c       |   6 +-
>  fs/xfs/libxfs/xfs_inode_util.c       |   6 +-
>  fs/xfs/libxfs/xfs_metadir.c          |   2 +-
>  fs/xfs/libxfs/xfs_parent.c           |   8 +-
>  fs/xfs/libxfs/xfs_parent.h           |   2 +-
>  fs/xfs/libxfs/xfs_rmap.c             |   6 +-
>  fs/xfs/libxfs/xfs_rmap.h             |   4 +-
>  fs/xfs/libxfs/xfs_rtbitmap.c         |   4 +-
>  fs/xfs/libxfs/xfs_rtrefcount_btree.c |   4 +-
>  fs/xfs/libxfs/xfs_rtrmap_btree.c     |   4 +-
>  fs/xfs/libxfs/xfs_symlink_remote.c   |   6 +-
>  fs/xfs/scrub/agheader_repair.c       |   2 +-
>  fs/xfs/scrub/attr.c                  |   4 +-
>  fs/xfs/scrub/attr_repair.c           |  16 ++--
>  fs/xfs/scrub/bmap.c                  |   8 +-
>  fs/xfs/scrub/bmap_repair.c           |   4 +-
>  fs/xfs/scrub/common.c                |  12 +--
>  fs/xfs/scrub/common.h                |   2 +-
>  fs/xfs/scrub/dabtree.c               |   4 +-
>  fs/xfs/scrub/dir.c                   |  22 +++---
>  fs/xfs/scrub/dir_repair.c            |  40 +++++-----
>  fs/xfs/scrub/dirtree.c               |  16 ++--
>  fs/xfs/scrub/dirtree_repair.c        |   4 +-
>  fs/xfs/scrub/findparent.c            |  33 ++++----
>  fs/xfs/scrub/inode.c                 |  12 +--
>  fs/xfs/scrub/inode_repair.c          |   2 +-
>  fs/xfs/scrub/iscan.c                 |   2 +-
>  fs/xfs/scrub/listxattr.c             |  10 +--
>  fs/xfs/scrub/metapath.c              |  10 +--
>  fs/xfs/scrub/nlinks.c                |  20 ++---
>  fs/xfs/scrub/nlinks_repair.c         |   4 +-
>  fs/xfs/scrub/orphanage.c             |  10 +--
>  fs/xfs/scrub/parent.c                |  25 +++----
>  fs/xfs/scrub/parent_repair.c         |  16 ++--
>  fs/xfs/scrub/quotacheck.c            |   2 +-
>  fs/xfs/scrub/readdir.c               |  12 +--
>  fs/xfs/scrub/repair.c                |   2 +-
>  fs/xfs/scrub/rmap_repair.c           |   2 +-
>  fs/xfs/scrub/rtbitmap_repair.c       |   2 +-
>  fs/xfs/scrub/rtrefcount_repair.c     |   2 +-
>  fs/xfs/scrub/rtrmap_repair.c         |   4 +-
>  fs/xfs/scrub/rtsummary_repair.c      |   2 +-
>  fs/xfs/scrub/scrub.c                 |   2 +-
>  fs/xfs/scrub/symlink_repair.c        |   8 +-
>  fs/xfs/scrub/tempfile.c              |   2 +-
>  fs/xfs/scrub/trace.h                 |  98 ++++++++++++------------
>  fs/xfs/xfs_aops.c                    |   2 +-
>  fs/xfs/xfs_attr_item.c               |   4 +-
>  fs/xfs/xfs_attr_list.c               |  12 +--
>  fs/xfs/xfs_bmap_item.c               |   4 +-
>  fs/xfs/xfs_bmap_util.c               |   4 +-
>  fs/xfs/xfs_dir2_readdir.c            |   4 +-
>  fs/xfs/xfs_error.c                   |   2 +-
>  fs/xfs/xfs_exchmaps_item.c           |   4 +-
>  fs/xfs/xfs_exchrange.c               |   4 +-
>  fs/xfs/xfs_export.c                  |   8 +-
>  fs/xfs/xfs_filestream.c              |   6 +-
>  fs/xfs/xfs_handle.c                  |   4 +-
>  fs/xfs/xfs_healthmon.c               |   6 +-
>  fs/xfs/xfs_icache.c                  |  25 ++++---
>  fs/xfs/xfs_inode.c                   |  26 +++----
>  fs/xfs/xfs_inode.h                   |  12 ++-
>  fs/xfs/xfs_inode_item.c              |   8 +-
>  fs/xfs/xfs_inode_item_recover.c      |   4 +-
>  fs/xfs/xfs_ioctl.c                   |   2 +-
>  fs/xfs/xfs_iomap.c                   |   4 +-
>  fs/xfs/xfs_iops.c                    |   3 +-
>  fs/xfs/xfs_iunlink_item.c            |   2 +-
>  fs/xfs/xfs_mount.c                   |   2 +-
>  fs/xfs/xfs_qm.c                      |  10 +--
>  fs/xfs/xfs_quotaops.c                |   2 +-
>  fs/xfs/xfs_reflink.c                 |   4 +-
>  fs/xfs/xfs_symlink.c                 |   6 +-
>  fs/xfs/xfs_trace.h                   | 108 +++++++++++++--------------
>  fs/xfs/xfs_trans.c                   |   2 +-
>  fs/xfs/xfs_trans_dquot.c             |   6 +-
>  fs/xfs/xfs_xattr.c                   |   2 +-
>  91 files changed, 427 insertions(+), 425 deletions(-)
> @@ -382,7 +382,7 @@ xrep_rtbitmap_prep_buf(
>  		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
>  
>  		hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
> -		hdr->rt_owner = cpu_to_be64(sc->ip->i_ino);
> +		hdr->rt_owner = cpu_to_be64(I_INO(sc->ip));
>  		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
>  		hdr->rt_lsn = 0;
>  		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
> diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
> index f165fb397647..2b939960c7dd 100644
> --- a/fs/xfs/scrub/rtrefcount_repair.c
> +++ b/fs/xfs/scrub/rtrefcount_repair.c
> @@ -360,7 +360,7 @@ xrep_rtrefc_walk_rmap(
>  		return error;
>  
>  	/* Skip extents which are not owned by this inode and fork. */
> -	if (rec->rm_owner != rr->sc->ip->i_ino)
> +	if (rec->rm_owner != I_INO(rr->sc->ip))
>  		return 0;
>  
>  	error = xrep_check_ino_btree_mapping(rr->sc, rec);
> diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
> index f2d16ca8d251..a2b72e61edf5 100644
> --- a/fs/xfs/scrub/rtrmap_repair.c
> +++ b/fs/xfs/scrub/rtrmap_repair.c
> @@ -324,7 +324,7 @@ xrep_rtrmap_scan_dfork(
>  	struct xfs_inode	*ip)
>  {
>  	struct xrep_rtrmap_ifork rf = {
> -		.accum		= { .rm_owner = ip->i_ino, },
> +		.accum		= { .rm_owner = I_INO(ip), },
>  		.rr		= rr,
>  	};
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
> @@ -392,7 +392,7 @@ xrep_rtrmap_walk_rmap(
>  		return error;
>  
>  	/* Skip extents which are not owned by this inode and fork. */
> -	if (rec->rm_owner != rr->sc->ip->i_ino)
> +	if (rec->rm_owner != I_INO(rr->sc->ip))
>  		return 0;
>  
>  	error = xrep_check_ino_btree_mapping(rr->sc, rec);
> diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
> index afffbd6e0ad1..f065c3e51ce2 100644
> --- a/fs/xfs/scrub/rtsummary_repair.c
> +++ b/fs/xfs/scrub/rtsummary_repair.c
> @@ -91,7 +91,7 @@ xrep_rtsummary_prep_buf(
>  		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
>  
>  		hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
> -		hdr->rt_owner = cpu_to_be64(sc->ip->i_ino);
> +		hdr->rt_owner = cpu_to_be64(I_INO(sc->ip));
>  		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
>  		hdr->rt_lsn = 0;
>  		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 27511a125b39..8742445c86f4 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -955,7 +955,7 @@ xfs_ioc_scrubv_metadata(
>  	 * because each scrubber gets to decide its own strategy and return
>  	 * values for getting an inode.
>  	 */
> -	if (head.svh_ino && head.svh_ino != ip_in->i_ino)
> +	if (head.svh_ino && head.svh_ino != I_INO(ip_in))
>  		handle_ip = xchk_scrubv_open_by_handle(mp, &head);
>  
>  	/* Run all the scrubbers. */
> diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
> index 25416dfb5189..91c86ea0e0f1 100644
> --- a/fs/xfs/scrub/symlink_repair.c
> +++ b/fs/xfs/scrub/symlink_repair.c
> @@ -144,7 +144,7 @@ xrep_symlink_salvage_remote(
>  		fa = bp->b_ops->verify_struct(bp);
>  		dsl = bp->b_addr;
>  		magic_ok = dsl->sl_magic == cpu_to_be32(XFS_SYMLINK_MAGIC);
> -		hdr_ok = xfs_symlink_hdr_ok(ip->i_ino, offset, byte_cnt, bp);
> +		hdr_ok = xfs_symlink_hdr_ok(I_INO(ip), offset, byte_cnt, bp);
>  		if (!hdr_ok || (fa != NULL && !magic_ok))
>  			break;
>  
> @@ -259,7 +259,7 @@ xrep_symlink_local_to_remote(
>  	if (!xfs_has_crc(sc->mp))
>  		return;
>  
> -	dsl->sl_owner = cpu_to_be64(sc->ip->i_ino);
> +	dsl->sl_owner = cpu_to_be64(I_INO(sc->ip));
>  	xfs_trans_log_buf(tp, bp, 0,
>  			  sizeof(struct xfs_dsymlink_hdr) + ifp->if_bytes - 1);
>  }
> @@ -375,7 +375,7 @@ xrep_symlink_reset_fork(
>  
>  	/* Reset the temp symlink target to dummy content. */
>  	xfs_idestroy_fork(ifp);
> -	return xfs_symlink_write_target(sc->tp, sc->tempip, sc->tempip->i_ino,
> +	return xfs_symlink_write_target(sc->tp, sc->tempip, I_INO(sc->tempip),
>  			"?", 1, 0, 0);
>  }
>  
> @@ -434,7 +434,7 @@ xrep_symlink_rebuild(
>  	sc->tempip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
>  
>  	/* Write the salvaged target to the temporary link. */
> -	error = xfs_symlink_write_target(sc->tp, sc->tempip, sc->ip->i_ino,
> +	error = xfs_symlink_write_target(sc->tp, sc->tempip, I_INO(sc->ip),
>  			target_buf, target_len, fs_blocks, resblks);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
> index 8d754df72aa5..e0c630f888cf 100644
> --- a/fs/xfs/scrub/tempfile.c
> +++ b/fs/xfs/scrub/tempfile.c
> @@ -121,7 +121,7 @@ xrep_tempfile_create(
>  		 * remote target block, so the owner is irrelevant.
>  		 */
>  		error = xfs_symlink_write_target(tp, sc->tempip,
> -				sc->tempip->i_ino, ".", 1, 0, 0);
> +				I_INO(sc->tempip), ".", 1, 0, 0);
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index f607ac5fb953..d27c99beee13 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -162,7 +162,7 @@ DECLARE_EVENT_CLASS(xchk_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->type = sm->sm_type;
>  		__entry->agno = sm->sm_agno;
>  		__entry->inum = sm->sm_ino;
> @@ -236,7 +236,7 @@ DECLARE_EVENT_CLASS(xchk_vector_head_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->agno = vhead->svh_agno;
>  		__entry->inum = vhead->svh_ino;
>  		__entry->gen = vhead->svh_gen;
> @@ -340,7 +340,7 @@ TRACE_EVENT(xchk_file_op_error,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = sc->ip->i_mount->m_super->s_dev;
> -		__entry->ino = sc->ip->i_ino;
> +		__entry->ino = I_INO(sc->ip);
>  		__entry->whichfork = whichfork;
>  		__entry->type = sc->sm->sm_type;
>  		__entry->offset = offset;
> @@ -438,7 +438,7 @@ DECLARE_EVENT_CLASS(xchk_fblock_error_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = sc->ip->i_mount->m_super->s_dev;
> -		__entry->ino = sc->ip->i_ino;
> +		__entry->ino = I_INO(sc->ip);
>  		__entry->whichfork = whichfork;
>  		__entry->type = sc->sm->sm_type;
>  		__entry->offset = offset;
> @@ -481,7 +481,7 @@ DECLARE_EVENT_CLASS(xchk_dqiter_class,
>  	TP_fast_assign(
>  		__entry->dev = cursor->sc->mp->m_super->s_dev;
>  		__entry->dqtype = cursor->dqtype;
> -		__entry->ino = cursor->quota_ip->i_ino;
> +		__entry->ino = I_INO(cursor->quota_ip);
>  		__entry->cur_id = cursor->id;
>  		__entry->startoff = cursor->bmap.br_startoff;
>  		__entry->startblock = cursor->bmap.br_startblock;
> @@ -613,7 +613,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
>  	TP_fast_assign(
>  		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
>  		__entry->dev = sc->mp->m_super->s_dev;
> -		__entry->ino = cur->bc_ino.ip->i_ino;
> +		__entry->ino = I_INO(cur->bc_ino.ip);
>  		__entry->whichfork = cur->bc_ino.whichfork;
>  		__entry->type = sc->sm->sm_type;
>  		__assign_str(name);
> @@ -693,7 +693,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
>  	TP_fast_assign(
>  		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
>  		__entry->dev = sc->mp->m_super->s_dev;
> -		__entry->ino = sc->ip->i_ino;
> +		__entry->ino = I_INO(sc->ip);
>  		__entry->whichfork = cur->bc_ino.whichfork;
>  		__entry->type = sc->sm->sm_type;
>  		__assign_str(name);
> @@ -839,7 +839,7 @@ TRACE_EVENT(xchk_inode_is_allocated,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->iflags = ip->i_flags;
>  		__entry->mode = VFS_I(ip)->i_mode;
>  	),
> @@ -1437,7 +1437,7 @@ TRACE_EVENT(xchk_nlinks_collect_dirent,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp->m_super->s_dev;
> -		__entry->dir = dp->i_ino;
> +		__entry->dir = I_INO(dp);
>  		__entry->ino = ino;
>  		__entry->namelen = name->len;
>  		memcpy(__get_str(name), name->name, name->len);
> @@ -1464,7 +1464,7 @@ TRACE_EVENT(xchk_nlinks_collect_pptr,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp->m_super->s_dev;
> -		__entry->dir = dp->i_ino;
> +		__entry->dir = I_INO(dp);
>  		__entry->ino = be64_to_cpu(pptr->p_ino);
>  		__entry->namelen = name->len;
>  		memcpy(__get_str(name), name->name, name->len);
> @@ -1509,7 +1509,7 @@ TRACE_EVENT(xchk_nlinks_live_update,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp->m_super->s_dev;
> -		__entry->dir = dp ? dp->i_ino : NULLFSINO;
> +		__entry->dir = dp ? I_INO(dp) : NULLFSINO;
>  		__entry->action = action;
>  		__entry->ino = ino;
>  		__entry->delta = delta;
> @@ -1602,7 +1602,7 @@ DECLARE_EVENT_CLASS(xchk_nlinks_diff_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->ftype = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
>  		__entry->nlink = VFS_I(ip)->i_nlink;
>  		__entry->parents = live->parents;
> @@ -1638,7 +1638,7 @@ DECLARE_EVENT_CLASS(xchk_pptr_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->namelen = name->len;
>  		memcpy(__get_str(name), name, name->len);
>  		__entry->far_ino = far_ino;
> @@ -1680,7 +1680,7 @@ DECLARE_EVENT_CLASS(xchk_dirtree_class,
>  	TP_fast_assign(
>  		__entry->dev = sc->mp->m_super->s_dev;
>  		__entry->path_nr = path_nr;
> -		__entry->child_ino = ip->i_ino;
> +		__entry->child_ino = I_INO(ip);
>  		__entry->child_gen = VFS_I(ip)->i_generation;
>  		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
>  		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
> @@ -1727,7 +1727,7 @@ DECLARE_EVENT_CLASS(xchk_dirpath_class,
>  		__entry->dev = sc->mp->m_super->s_dev;
>  		__entry->path_nr = path_nr;
>  		__entry->step_nr = step_nr;
> -		__entry->child_ino = ip->i_ino;
> +		__entry->child_ino = I_INO(ip);
>  		__entry->child_gen = VFS_I(ip)->i_generation;
>  		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
>  		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
> @@ -1830,7 +1830,7 @@ DECLARE_EVENT_CLASS(xchk_dirtree_evaluate_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = dl->sc->mp->m_super->s_dev;
> -		__entry->ino = dl->sc->ip->i_ino;
> +		__entry->ino = I_INO(dl->sc->ip);
>  		__entry->rootino = dl->root_ino;
>  		__entry->nr_paths = dl->nr_paths;
>  		__entry->bad = oc->bad;
> @@ -1873,8 +1873,8 @@ TRACE_EVENT(xchk_dirpath_changed,
>  		__entry->dev = sc->mp->m_super->s_dev;
>  		__entry->path_nr = path_nr;
>  		__entry->step_nr = step_nr;
> -		__entry->child_ino = ip->i_ino;
> -		__entry->parent_ino = dp->i_ino;
> +		__entry->child_ino = I_INO(ip);
> +		__entry->parent_ino = I_INO(dp);
>  		__entry->namelen = xname->len;
>  		memcpy(__get_str(name), xname->name, xname->len);
>  	),
> @@ -1904,9 +1904,9 @@ TRACE_EVENT(xchk_dirtree_live_update,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = sc->mp->m_super->s_dev;
> -		__entry->parent_ino = dp->i_ino;
> +		__entry->parent_ino = I_INO(dp);
>  		__entry->action = action;
> -		__entry->child_ino = ip->i_ino;
> +		__entry->child_ino = I_INO(ip);
>  		__entry->delta = delta;
>  		__entry->namelen = xname->len;
>  		memcpy(__get_str(name), xname->name, xname->len);
> @@ -1933,8 +1933,8 @@ DECLARE_EVENT_CLASS(xchk_metapath_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = sc->mp->m_super->s_dev;
> -		__entry->scrub_ino = sc->ip ? sc->ip->i_ino : NULLFSINO;
> -		__entry->parent_ino = dp ? dp->i_ino : NULLFSINO;
> +		__entry->scrub_ino = sc->ip ? I_INO(sc->ip) : NULLFSINO;
> +		__entry->parent_ino = dp ? I_INO(dp) : NULLFSINO;
>  		__entry->ino = ino;
>  		__assign_str(name);
>  	),
> @@ -2208,7 +2208,7 @@ TRACE_EVENT(xrep_bmap_found,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->whichfork = whichfork;
>  		__entry->lblk = irec->br_startoff;
>  		__entry->len = irec->br_blockcount;
> @@ -2609,7 +2609,7 @@ TRACE_EVENT(xrep_dinode_findmode_dirent,
>  	TP_fast_assign(
>  		__entry->dev = sc->mp->m_super->s_dev;
>  		__entry->ino = sc->sm->sm_ino;
> -		__entry->parent_ino = dp->i_ino;
> +		__entry->parent_ino = I_INO(dp);
>  		__entry->ftype = ftype;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx ftype '%s'",
> @@ -2633,7 +2633,7 @@ TRACE_EVENT(xrep_dinode_findmode_dirent_inval,
>  	TP_fast_assign(
>  		__entry->dev = sc->mp->m_super->s_dev;
>  		__entry->ino = sc->sm->sm_ino;
> -		__entry->parent_ino = dp->i_ino;
> +		__entry->parent_ino = I_INO(dp);
>  		__entry->ftype = ftype;
>  		__entry->found_ftype = found_ftype;
>  	),
> @@ -2658,7 +2658,7 @@ TRACE_EVENT(xrep_cow_mark_file_range,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->startoff = startoff;
>  		__entry->startblock = startblock;
>  		__entry->blockcount = blockcount;
> @@ -2687,7 +2687,7 @@ TRACE_EVENT(xrep_cow_replace_mapping,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->startoff = irec->br_startoff;
>  		__entry->startblock = irec->br_startblock;
>  		__entry->blockcount = irec->br_blockcount;
> @@ -2817,13 +2817,13 @@ TRACE_EVENT(xrep_tempfile_create,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = sc->mp->m_super->s_dev;
> -		__entry->ino = sc->file ? XFS_I(file_inode(sc->file))->i_ino : 0;
> +		__entry->ino = sc->file ? file_inode(sc->file)->i_ino : 0;
>  		__entry->type = sc->sm->sm_type;
>  		__entry->agno = sc->sm->sm_agno;
>  		__entry->inum = sc->sm->sm_ino;
>  		__entry->gen = sc->sm->sm_gen;
>  		__entry->flags = sc->sm->sm_flags;
> -		__entry->temp_inum = sc->tempip->i_ino;
> +		__entry->temp_inum = I_INO(sc->tempip);
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx type %s inum 0x%llx gen 0x%x flags 0x%x temp_inum 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> @@ -2850,7 +2850,7 @@ DECLARE_EVENT_CLASS(xrep_tempfile_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = sc->mp->m_super->s_dev;
> -		__entry->ino = sc->tempip->i_ino;
> +		__entry->ino = I_INO(sc->tempip);
>  		__entry->whichfork = whichfork;
>  		__entry->lblk = irec->br_startoff;
>  		__entry->len = irec->br_blockcount;
> @@ -2890,7 +2890,7 @@ TRACE_EVENT(xreap_ifork_extent,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = sc->mp->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->whichfork = whichfork;
>  		__entry->fileoff = irec->br_startoff;
>  		__entry->len = irec->br_blockcount;
> @@ -2946,7 +2946,7 @@ TRACE_EVENT(xrep_xattr_recover_leafblock,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->dabno = dabno;
>  		__entry->magic = magic;
>  	),
> @@ -2971,7 +2971,7 @@ DECLARE_EVENT_CLASS(xrep_xattr_salvage_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->flags = flags;
>  		__entry->namelen = namelen;
>  		memcpy(__get_str(name), name, namelen);
> @@ -3011,7 +3011,7 @@ DECLARE_EVENT_CLASS(xrep_pptr_salvage_class,
>  		const struct xfs_parent_rec	*rec = value;
>  
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->parent_ino = be64_to_cpu(rec->p_ino);
>  		__entry->parent_gen = be32_to_cpu(rec->p_gen);
>  		__entry->namelen = namelen;
> @@ -3043,8 +3043,8 @@ DECLARE_EVENT_CLASS(xrep_xattr_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> -		__entry->src_ino = arg_ip->i_ino;
> +		__entry->ino = I_INO(ip);
> +		__entry->src_ino = I_INO(arg_ip);
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx src 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> @@ -3073,8 +3073,8 @@ DECLARE_EVENT_CLASS(xrep_xattr_pptr_scan_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> -		__entry->parent_ino = dp->i_ino;
> +		__entry->ino = I_INO(ip);
> +		__entry->parent_ino = I_INO(dp);
>  		__entry->parent_gen = VFS_IC(dp)->i_generation;
>  		__entry->namelen = name->len;
>  		memcpy(__get_str(name), name->name, name->len);
> @@ -3108,7 +3108,7 @@ TRACE_EVENT(xrep_dir_recover_dirblock,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = dp->i_mount->m_super->s_dev;
> -		__entry->dir_ino = dp->i_ino;
> +		__entry->dir_ino = I_INO(dp);
>  		__entry->dabno = dabno;
>  		__entry->magic = magic;
>  		__entry->magic_guess = magic_guess;
> @@ -3131,7 +3131,7 @@ DECLARE_EVENT_CLASS(xrep_dir_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = dp->i_mount->m_super->s_dev;
> -		__entry->dir_ino = dp->i_ino;
> +		__entry->dir_ino = I_INO(dp);
>  		__entry->parent_ino = parent_ino;
>  	),
>  	TP_printk("dev %d:%d dir 0x%llx parent 0x%llx",
> @@ -3161,7 +3161,7 @@ DECLARE_EVENT_CLASS(xrep_dirent_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = dp->i_mount->m_super->s_dev;
> -		__entry->dir_ino = dp->i_ino;
> +		__entry->dir_ino = I_INO(dp);
>  		__entry->namelen = name->len;
>  		memcpy(__get_str(name), name->name, name->len);
>  		__entry->ino = ino;
> @@ -3198,8 +3198,8 @@ DECLARE_EVENT_CLASS(xrep_adoption_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = dp->i_mount->m_super->s_dev;
> -		__entry->dir_ino = dp->i_ino;
> -		__entry->child_ino = ip->i_ino;
> +		__entry->dir_ino = I_INO(dp);
> +		__entry->child_ino = I_INO(ip);
>  		__entry->moved = moved;
>  	),
>  	TP_printk("dev %d:%d dir 0x%llx child 0x%llx moved? %d",
> @@ -3224,7 +3224,7 @@ DECLARE_EVENT_CLASS(xrep_parent_salvage_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = dp->i_mount->m_super->s_dev;
> -		__entry->dir_ino = dp->i_ino;
> +		__entry->dir_ino = I_INO(dp);
>  		__entry->ino = ino;
>  	),
>  	TP_printk("dev %d:%d dir 0x%llx parent 0x%llx",
> @@ -3254,7 +3254,7 @@ DECLARE_EVENT_CLASS(xrep_pptr_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
>  		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
>  		__entry->namelen = name->len;
> @@ -3292,8 +3292,8 @@ DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> -		__entry->parent_ino = dp->i_ino;
> +		__entry->ino = I_INO(ip);
> +		__entry->parent_ino = I_INO(dp);
>  		__entry->parent_gen = VFS_IC(dp)->i_generation;
>  		__entry->namelen = name->len;
>  		memcpy(__get_str(name), name->name, name->len);
> @@ -3392,7 +3392,7 @@ TRACE_EVENT(xrep_symlink_salvage_target,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->targetlen = targetlen;
>  		memcpy(__get_str(target), target, targetlen);
>  		__get_str(target)[targetlen] = 0;
> @@ -3413,7 +3413,7 @@ DECLARE_EVENT_CLASS(xrep_symlink_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  	),
>  	TP_printk("dev %d:%d ip 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f279055fcea0..1a82cf625a08 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -268,7 +268,7 @@ xfs_discard_folio(
>  
>  	xfs_alert_ratelimited(mp,
>  		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
> -			folio, ip->i_ino, pos);
> +			folio, I_INO(ip), pos);
>  
>  	/*
>  	 * The end of the punch range is always the offset of the first
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index deab14f31b38..a53ee2b0c54a 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -378,7 +378,7 @@ xfs_attr_log_item(
>  	 * structure with fields from this xfs_attr_intent
>  	 */
>  	attrp = &attrip->attri_format;
> -	attrp->alfi_ino = args->dp->i_ino;
> +	attrp->alfi_ino = I_INO(args->dp);
>  	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
>  	attrp->alfi_op_flags = attr->xattri_op_flags;
>  	attrp->alfi_value_len = nv->value.iov_len;
> @@ -695,7 +695,7 @@ xfs_attri_recover_work(
>  	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
>  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
>  			 XFS_DA_OP_LOGGED;
> -	args->owner = args->dp->i_ino;
> +	args->owner = I_INO(args->dp);
>  	xfs_attr_sethash(args);
>  
>  	switch (xfs_attr_intent_op(attr)) {
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 114566b1ae5c..f751edb930b6 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -248,7 +248,7 @@ xfs_attr_node_list_lookup(
>  			goto out_corruptbuf;
>  		}
>  
> -		fa = xfs_da3_node_header_check(bp, dp->i_ino);
> +		fa = xfs_da3_node_header_check(bp, I_INO(dp));
>  		if (fa)
>  			goto out_corruptbuf;
>  
> @@ -287,7 +287,7 @@ xfs_attr_node_list_lookup(
>  		}
>  	}
>  
> -	fa = xfs_attr3_leaf_header_check(bp, dp->i_ino);
> +	fa = xfs_attr3_leaf_header_check(bp, I_INO(dp));
>  	if (fa) {
>  		__xfs_buf_mark_corrupt(bp, fa);
>  		goto out_releasebuf;
> @@ -348,7 +348,7 @@ xfs_attr_node_list(
>  		case XFS_DA_NODE_MAGIC:
>  		case XFS_DA3_NODE_MAGIC:
>  			trace_xfs_attr_list_wrong_blk(context);
> -			fa = xfs_da3_node_header_check(bp, dp->i_ino);
> +			fa = xfs_da3_node_header_check(bp, I_INO(dp));
>  			if (fa) {
>  				__xfs_buf_mark_corrupt(bp, fa);
>  				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
> @@ -359,7 +359,7 @@ xfs_attr_node_list(
>  		case XFS_ATTR_LEAF_MAGIC:
>  		case XFS_ATTR3_LEAF_MAGIC:
>  			leaf = bp->b_addr;
> -			fa = xfs_attr3_leaf_header_check(bp, dp->i_ino);
> +			fa = xfs_attr3_leaf_header_check(bp, I_INO(dp));
>  			if (fa) {
>  				__xfs_buf_mark_corrupt(bp, fa);
>  				xfs_trans_brelse(context->tp, bp);
> @@ -417,7 +417,7 @@ xfs_attr_node_list(
>  			break;
>  		cursor->blkno = leafhdr.forw;
>  		xfs_trans_brelse(context->tp, bp);
> -		error = xfs_attr3_leaf_read(context->tp, dp, dp->i_ino,
> +		error = xfs_attr3_leaf_read(context->tp, dp, I_INO(dp),
>  				cursor->blkno, &bp);
>  		if (error)
>  			return error;
> @@ -543,7 +543,7 @@ xfs_attr_leaf_list(
>  
>  	context->cursor.blkno = 0;
>  	error = xfs_attr3_leaf_read(context->tp, context->dp,
> -			context->dp->i_ino, 0, &bp);
> +			I_INO(context->dp), 0, &bp);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index b237a25d6045..89f6e79a955f 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -245,7 +245,7 @@ xfs_bmap_update_diff_items(
>  	struct xfs_bmap_intent		*ba = bi_entry(a);
>  	struct xfs_bmap_intent		*bb = bi_entry(b);
>  
> -	return cmp_int(ba->bi_owner->i_ino, bb->bi_owner->i_ino);
> +	return cmp_int(I_INO(ba->bi_owner), I_INO(bb->bi_owner));
>  }
>  
>  /* Log bmap updates in the intent item. */
> @@ -266,7 +266,7 @@ xfs_bmap_update_log_item(
>  	next_extent = atomic_inc_return(&buip->bui_next_extent) - 1;
>  	ASSERT(next_extent < buip->bui_format.bui_nextents);
>  	map = &buip->bui_format.bui_extents[next_extent];
> -	map->me_owner = bi->bi_owner->i_ino;
> +	map->me_owner = I_INO(bi->bi_owner);
>  	map->me_startblock = bi->bi_bmap.br_startblock;
>  	map->me_startoff = bi->bi_bmap.br_startoff;
>  	map->me_len = bi->bi_bmap.br_blockcount;
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0ab00615f1ad..3b9f262f8e91 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1479,7 +1479,7 @@ xfs_swap_change_owner(
>  	struct xfs_trans	*tp = *tpp;
>  
>  	do {
> -		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK, ip->i_ino,
> +		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK, I_INO(ip),
>  					      NULL);
>  		/* success or fatal error */
>  		if (error != -EAGAIN)
> @@ -1631,7 +1631,7 @@ xfs_swap_extents(
>  	if (error) {
>  		xfs_notice(mp,
>  		    "%s: inode 0x%llx format is incompatible for exchanging.",
> -				__func__, ip->i_ino);
> +				__func__, I_INO(ip));
>  		goto out_trans_cancel;
>  	}
>  
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 60a80d4173f7..577f7a581043 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -84,7 +84,7 @@ xfs_dir2_sf_getdents(
>  	 */
>  	if (ctx->pos <= dot_offset) {
>  		ctx->pos = dot_offset & 0x7fffffff;
> -		if (!dir_emit(ctx, ".", 1, dp->i_ino, DT_DIR))
> +		if (!dir_emit(ctx, ".", 1, I_INO(dp), DT_DIR))
>  			return 0;
>  	}
>  
> @@ -532,7 +532,7 @@ xfs_readdir(
>  	args.dp = dp;
>  	args.geo = dp->i_mount->m_dir_geo;
>  	args.trans = tp;
> -	args.owner = dp->i_ino;
> +	args.owner = I_INO(dp);
>  
>  	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
>  		return xfs_dir2_sf_getdents(&args, ctx);
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index d652240a1dca..9ece70fd94ca 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -369,7 +369,7 @@ xfs_inode_verifier_error(
>  
>  	xfs_alert(mp, "Metadata %s detected at %pS, inode 0x%llx %s",
>  		  error == -EFSBADCRC ? "CRC error" : "corruption",
> -		  fa, ip->i_ino, name);
> +		  fa, I_INO(ip), name);
>  
>  	xfs_alert(mp, "Unmount and run xfs_repair");
>  
> diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
> index 13a42467370f..c3745d33e54e 100644
> --- a/fs/xfs/xfs_exchmaps_item.c
> +++ b/fs/xfs/xfs_exchmaps_item.c
> @@ -227,9 +227,9 @@ xfs_exchmaps_create_intent(
>  	xmi_lip = xfs_xmi_init(tp->t_mountp);
>  	xlf = &xmi_lip->xmi_format;
>  
> -	xlf->xmi_inode1 = xmi->xmi_ip1->i_ino;
> +	xlf->xmi_inode1 = I_INO(xmi->xmi_ip1);
>  	xlf->xmi_igen1 = VFS_I(xmi->xmi_ip1)->i_generation;
> -	xlf->xmi_inode2 = xmi->xmi_ip2->i_ino;
> +	xlf->xmi_inode2 = I_INO(xmi->xmi_ip2);
>  	xlf->xmi_igen2 = VFS_I(xmi->xmi_ip2)->i_generation;
>  	xlf->xmi_startoff1 = xmi->xmi_startoff1;
>  	xlf->xmi_startoff2 = xmi->xmi_startoff2;
> diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
> index 5c083f29ea65..94965a6c2187 100644
> --- a/fs/xfs/xfs_exchrange.c
> +++ b/fs/xfs/xfs_exchrange.c
> @@ -91,7 +91,7 @@ xfs_exchrange_check_freshness(
>  	trace_xfs_exchrange_freshness(fxr, ip2);
>  
>  	/* Check that file2 hasn't otherwise been modified. */
> -	if (fxr->file2_ino != ip2->i_ino ||
> +	if (fxr->file2_ino != inode2->i_ino ||
>  	    fxr->file2_gen != inode2->i_generation ||
>  	    !timespec64_equal(&fxr->file2_ctime, &ctime) ||
>  	    !timespec64_equal(&fxr->file2_mtime, &mtime))
> @@ -863,7 +863,7 @@ xfs_ioc_start_commit(
>  	kern_f->file2_ctime_nsec	= kstat.ctime.tv_nsec;
>  	kern_f->file2_mtime		= kstat.mtime.tv_sec;
>  	kern_f->file2_mtime_nsec	= kstat.mtime.tv_nsec;
> -	kern_f->file2_ino		= ip2->i_ino;
> +	kern_f->file2_ino		= inode2->i_ino;
>  	kern_f->file2_gen		= inode2->i_generation;
>  	kern_f->magic			= XCR_FRESH_MAGIC;
>  	xfs_iunlock(ip2, lockflags);
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index e3e3c3c89840..82b884a81f7b 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -82,19 +82,19 @@ xfs_fs_encode_fh(
>  
>  	switch (fileid_type) {
>  	case FILEID_INO32_GEN_PARENT:
> -		fid->i32.parent_ino = XFS_I(parent)->i_ino;
> +		fid->i32.parent_ino = parent->i_ino;
>  		fid->i32.parent_gen = parent->i_generation;
>  		fallthrough;
>  	case FILEID_INO32_GEN:
> -		fid->i32.ino = XFS_I(inode)->i_ino;
> +		fid->i32.ino = inode->i_ino;
>  		fid->i32.gen = inode->i_generation;
>  		break;
>  	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
> -		fid64->parent_ino = XFS_I(parent)->i_ino;
> +		fid64->parent_ino = parent->i_ino;
>  		fid64->parent_gen = parent->i_generation;
>  		fallthrough;
>  	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
> -		fid64->ino = XFS_I(inode)->i_ino;
> +		fid64->ino = inode->i_ino;
>  		fid64->gen = inode->i_generation;
>  		break;
>  	}
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 32e641d76e92..bb46852075f2 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -225,7 +225,7 @@ xfs_filestream_lookup_association(
>  	atomic_inc(&pag_group(pag)->xg_active_ref);
>  	xfs_mru_cache_done(mp->m_filestream);
>  
> -	trace_xfs_filestream_lookup(pag, ap->ip->i_ino);
> +	trace_xfs_filestream_lookup(pag, I_INO(ap->ip));
>  
>  	ap->blkno = xfs_agbno_to_fsb(pag, 0);
>  	xfs_bmap_adjacent(ap);
> @@ -345,7 +345,7 @@ xfs_filestream_select_ag(
>  	args->total = ap->total;
>  	pip = xfs_filestream_get_parent(ap->ip);
>  	if (pip) {
> -		ino = pip->i_ino;
> +		ino = I_INO(pip);
>  		error = xfs_filestream_lookup_association(ap, args, ino,
>  				longest);
>  		xfs_irele(pip);
> @@ -370,7 +370,7 @@ void
>  xfs_filestream_deassociate(
>  	struct xfs_inode	*ip)
>  {
> -	xfs_mru_cache_delete(ip->i_mount->m_filestream, ip->i_ino);
> +	xfs_mru_cache_delete(ip->i_mount->m_filestream, I_INO(ip));
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
> index 2b8617ae7ec2..0689cade8f74 100644
> --- a/fs/xfs/xfs_handle.c
> +++ b/fs/xfs/xfs_handle.c
> @@ -124,7 +124,7 @@ xfs_find_handle(
>  	if (cmd == XFS_IOC_PATH_TO_FSHANDLE)
>  		hsize = xfs_fshandle_init(ip->i_mount, &handle);
>  	else
> -		hsize = xfs_filehandle_init(ip->i_mount, ip->i_ino,
> +		hsize = xfs_filehandle_init(ip->i_mount, inode->i_ino,
>  				inode->i_generation, &handle);
>  
>  	error = -EFAULT;
> @@ -808,7 +808,7 @@ xfs_getparents(
>  			sizeof(struct xfs_attrlist_cursor));
>  
>  	/* Is this the root directory? */
> -	if (ip->i_ino == mp->m_sb.sb_rootino)
> +	if (I_INO(ip) == mp->m_sb.sb_rootino)
>  		gp->gp_oflags |= XFS_GETPARENTS_OFLAG_ROOT;
>  
>  	if (gpx->context.seen_enough == 0) {
> diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> index 26c325d34bd1..4521ffdab9f1 100644
> --- a/fs/xfs/xfs_healthmon.c
> +++ b/fs/xfs/xfs_healthmon.c
> @@ -533,7 +533,7 @@ xfs_healthmon_report_inode(
>  	struct xfs_healthmon_event	event = {
>  		.type			= type,
>  		.domain			= XFS_HEALTHMON_INODE,
> -		.ino			= ip->i_ino,
> +		.ino			= I_INO(ip),
>  		.gen			= VFS_I(ip)->i_generation,
>  	};
>  	struct xfs_healthmon		*hm = xfs_healthmon_get(ip->i_mount);
> @@ -646,7 +646,7 @@ xfs_healthmon_report_file_ioerror(
>  	struct xfs_healthmon_event	event = {
>  		.type			= file_ioerr_type(p->type),
>  		.domain			= XFS_HEALTHMON_FILERANGE,
> -		.fino			= ip->i_ino,
> +		.fino			= I_INO(ip),
>  		.fgen			= VFS_I(ip)->i_generation,
>  		.fpos			= p->pos,
>  		.flen			= p->len,
> @@ -1182,7 +1182,7 @@ xfs_ioc_health_monitor(
>  	 */
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -	if (ip->i_ino != mp->m_sb.sb_rootino)
> +	if (I_INO(ip) != mp->m_sb.sb_rootino)
>  		return -EPERM;
>  	if (current_user_ns() != &init_user_ns)
>  		return -EPERM;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 37caed10c089..6f19e751bb8a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -101,6 +101,7 @@ xfs_inode_alloc(
>  		return NULL;
>  	}
>  
> +	VFS_I(ip)->i_ino = ino;
>  	/* VFS doesn't initialise i_mode! */
>  	VFS_I(ip)->i_mode = 0;
>  	mapping_set_folio_min_order(VFS_I(ip)->i_mapping,
> @@ -108,10 +109,8 @@ xfs_inode_alloc(
>  
>  	XFS_STATS_INC(mp, xs_inodes_active);
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
> -	ASSERT(ip->i_ino == 0);
>  
>  	/* initialise the xfs inode */
> -	ip->i_ino = ino;
>  	ip->i_mount = mp;
>  	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
>  	ip->i_cowfp = NULL;
> @@ -193,7 +192,7 @@ xfs_inode_free(
>  	 */
>  	spin_lock(&ip->i_flags_lock);
>  	ip->i_flags = XFS_IRECLAIM;
> -	ip->i_ino = 0;
> +	VFS_I(ip)->i_ino = 0;
>  	spin_unlock(&ip->i_flags_lock);
>  

>  	__xfs_inode_free(ip);
> @@ -329,6 +328,7 @@ xfs_reinit_inode(
>  	struct inode		*inode)
>  {
>  	int			error;
> +	u64			ino = inode->i_ino;
>  	uint32_t		nlink = inode->i_nlink;
>  	uint32_t		generation = inode->i_generation;
>  	uint64_t		version = inode_peek_iversion(inode);
> @@ -340,6 +340,7 @@ xfs_reinit_inode(
>  
>  	error = inode_init_always(mp->m_super, inode);
>  
> +	inode->i_ino = ino;
>  	set_nlink(inode, nlink);
>  	inode->i_generation = generation;
>  	inode_set_iversion_queried(inode, version);
> @@ -426,7 +427,7 @@ xfs_iget_check_free_state(
>  		if (VFS_I(ip)->i_mode != 0) {
>  			xfs_warn(ip->i_mount,
>  "Corruption detected! Free inode 0x%llx not marked free! (mode 0x%x)",
> -				ip->i_ino, VFS_I(ip)->i_mode);
> +				I_INO(ip), VFS_I(ip)->i_mode);
>  			xfs_agno_mark_sick(ip->i_mount, XFS_INODE_TO_AGNO(ip),
>  					XFS_SICK_AG_INOBT);
>  			return -EFSCORRUPTED;
> @@ -435,7 +436,7 @@ xfs_iget_check_free_state(
>  		if (ip->i_nblocks != 0) {
>  			xfs_warn(ip->i_mount,
>  "Corruption detected! Free inode 0x%llx has blocks allocated!",
> -				ip->i_ino);
> +				I_INO(ip));
>  			xfs_agno_mark_sick(ip->i_mount, XFS_INODE_TO_AGNO(ip),
>  					XFS_SICK_AG_INOBT);
>  			return -EFSCORRUPTED;
> @@ -514,7 +515,7 @@ xfs_iget_cache_hit(
>  	 * will not match, so check for that, too.
>  	 */
>  	spin_lock(&ip->i_flags_lock);
> -	if (ip->i_ino != ino)
> +	if (I_INO(ip) != ino)
>  		goto out_skip;
>  
>  	/*
> @@ -644,7 +645,7 @@ xfs_iget_cache_miss(
>  	 */
>  	xfs_iflags_set(ip, XFS_INEW);
>  
> -	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, flags);
> +	error = xfs_imap(pag, tp, I_INO(ip), &ip->i_imap, flags);
>  	if (error)
>  		goto out_destroy;
>  
> @@ -963,7 +964,7 @@ xfs_reclaim_inode(
>  	struct xfs_inode	*ip,
>  	struct xfs_perag	*pag)
>  {
> -	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
> +	xfs_ino_t		ino = I_INO(ip); /* for radix_tree_delete */
>  
>  	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>  		goto out;
> @@ -1011,7 +1012,7 @@ xfs_reclaim_inode(
>  	 */
>  	spin_lock(&ip->i_flags_lock);
>  	ip->i_flags = XFS_IRECLAIM;
> -	ip->i_ino = 0;
> +	VFS_I(ip)->i_ino = 0;
>  	ip->i_sick = 0;
>  	ip->i_checked = 0;
>  	spin_unlock(&ip->i_flags_lock);
> @@ -1511,7 +1512,7 @@ xfs_blockgc_igrab(
>  
>  	/* Check for stale RCU freed inode */
>  	spin_lock(&ip->i_flags_lock);
> -	if (!ip->i_ino)
> +	if (!I_INO(ip))
>  		goto out_unlock_noent;
>  
>  	if (ip->i_flags & XFS_BLOCKGC_NOGRAB_IFLAGS)
> @@ -1805,7 +1806,7 @@ xfs_icwalk_ag(
>  			 */
>  			if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
>  				continue;
> -			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> +			first_index = XFS_INO_TO_AGINO(mp, I_INO(ip) + 1);
>  			if (first_index < XFS_INODE_TO_AGINO(ip))
>  				done = true;
>  		}
> @@ -1893,7 +1894,7 @@ xfs_check_delalloc(
>  		if (isnullstartblock(got.br_startblock)) {
>  			xfs_warn(ip->i_mount,
>  	"ino %llx %s fork has delalloc extent at [0x%llx:0x%llx]",
> -				ip->i_ino,
> +				I_INO(ip),
>  				whichfork == XFS_DATA_FORK ? "data" : "cow",
>  				got.br_startoff, got.br_blockcount);
>  		}
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f9015a1c6bd8..8452bc5d28a9 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -495,9 +495,9 @@ xfs_lock_two_inodes(
>  	ASSERT(!(ip1_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)));
>  	ASSERT(!(ip0_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)));
>  	ASSERT(!(ip1_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)));
> -	ASSERT(ip0->i_ino != ip1->i_ino);
> +	ASSERT(I_INO(ip0) != I_INO(ip1));
>  
> -	if (ip0->i_ino > ip1->i_ino) {
> +	if (I_INO(ip0) > I_INO(ip1)) {
>  		swap(ip0, ip1);
>  		swap(ip0_mode, ip1_mode);
>  	}
> @@ -1519,7 +1519,7 @@ xfs_iunlink_lookup(
>  	 * Inode in RCU freeing limbo should not happen.  Warn about this and
>  	 * let the caller handle the failure.
>  	 */
> -	if (WARN_ON_ONCE(!ip->i_ino)) {
> +	if (WARN_ON_ONCE(!I_INO(ip))) {
>  		rcu_read_unlock();
>  		return NULL;
>  	}
> @@ -1620,7 +1620,7 @@ xfs_ifree_mark_inode_stale(
>  	 * valid, the wrong inode or stale.
>  	 */
>  	spin_lock(&ip->i_flags_lock);
> -	if (ip->i_ino != inum || __xfs_iflags_test(ip, XFS_ISTALE))
> +	if (I_INO(ip) != inum || __xfs_iflags_test(ip, XFS_ISTALE))
>  		goto out_iflags_unlock;
>  
>  	/*
> @@ -2061,7 +2061,7 @@ xfs_sort_inodes(
>  	 */
>  	for (i = 0; i < num_inodes; i++) {
>  		for (j = 1; j < num_inodes; j++) {
> -			if (i_tab[j]->i_ino < i_tab[j-1]->i_ino)
> +			if (I_INO(i_tab[j]) < I_INO(i_tab[j-1]))
>  				swap(i_tab[j], i_tab[j - 1]);
>  		}
>  	}
> @@ -2392,7 +2392,7 @@ xfs_iflush(
>  	    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_1)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: Bad inode %llu magic number 0x%x, ptr "PTR_FMT,
> -			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
> +			__func__, I_INO(ip), be16_to_cpu(dip->di_magic), dip);
>  		goto flush_out;
>  	}
>  	if (ip->i_df.if_format == XFS_DINODE_FMT_META_BTREE) {
> @@ -2401,7 +2401,7 @@ xfs_iflush(
>  			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  				"%s: Bad %s meta btree inode %Lu, ptr "PTR_FMT,
>  				__func__, xfs_metafile_type_str(ip->i_metatype),
> -				ip->i_ino, ip);
> +				I_INO(ip), ip);
>  			goto flush_out;
>  		}
>  	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
> @@ -2410,7 +2410,7 @@ xfs_iflush(
>  		    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_3)) {
>  			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  				"%s: Bad regular inode %llu, ptr "PTR_FMT,
> -				__func__, ip->i_ino, ip);
> +				__func__, I_INO(ip), ip);
>  			goto flush_out;
>  		}
>  	} else if (S_ISDIR(VFS_I(ip)->i_mode)) {
> @@ -2420,7 +2420,7 @@ xfs_iflush(
>  		    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_4)) {
>  			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  				"%s: Bad directory inode %llu, ptr "PTR_FMT,
> -				__func__, ip->i_ino, ip);
> +				__func__, I_INO(ip), ip);
>  			goto flush_out;
>  		}
>  	}
> @@ -2429,7 +2429,7 @@ xfs_iflush(
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: detected corrupt incore inode %llu, "
>  			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
> -			__func__, ip->i_ino,
> +			__func__, I_INO(ip),
>  			ip->i_df.if_nextents + xfs_ifork_nextents(&ip->i_af),
>  			ip->i_nblocks, ip);
>  		goto flush_out;
> @@ -2438,7 +2438,7 @@ xfs_iflush(
>  	    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_6)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: bad inode %llu, forkoff 0x%x, ptr "PTR_FMT,
> -			__func__, ip->i_ino, ip->i_forkoff, ip);
> +			__func__, I_INO(ip), ip->i_forkoff, ip);
>  		goto flush_out;
>  	}
>  
> @@ -2446,7 +2446,7 @@ xfs_iflush(
>  	    ip->i_af.if_format == XFS_DINODE_FMT_META_BTREE) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: meta btree in inode %Lu attr fork, ptr "PTR_FMT,
> -			__func__, ip->i_ino, ip);
> +			__func__, I_INO(ip), ip);
>  		goto flush_out;
>  	}
>  
> @@ -2746,7 +2746,7 @@ xfs_mmaplock_two_inodes_and_break_dax_layout(
>  {
>  	int			error;
>  
> -	if (ip1->i_ino > ip2->i_ino)
> +	if (I_INO(ip1) > I_INO(ip2))
>  		swap(ip1, ip2);
>  
>  again:
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 724baea02c8d..34c1038ebfcd 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -30,7 +30,6 @@ typedef struct xfs_inode {
>  	struct xfs_dquot	*i_pdquot;	/* project dquot */
>  
>  	/* Inode location stuff */
> -	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
>  	struct xfs_imap		i_imap;		/* location for xfs_imap() */
>  
>  	/* Extent information. */
> @@ -184,6 +183,11 @@ static inline const struct inode *VFS_IC(const struct xfs_inode *ip)
>  	return &ip->i_vnode;
>  }
>  
> +static inline xfs_ino_t I_INO(const struct xfs_inode *ip)
> +{
> +	return VFS_IC(ip)->i_ino;
> +}
> +
>  /*
>   * For regular files we only update the on-disk filesize when actually
>   * writing data back to disk.  Until then only the copy in the VFS inode
> @@ -299,9 +303,9 @@ static inline bool xfs_is_internal_inode(const struct xfs_inode *ip)
>  	 * Before metadata directories, the only metadata inodes were the
>  	 * three quota files, the realtime bitmap, and the realtime summary.
>  	 */
> -	return ip->i_ino == mp->m_sb.sb_rbmino ||
> -	       ip->i_ino == mp->m_sb.sb_rsumino ||
> -	       xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
> +	return I_INO(ip) == mp->m_sb.sb_rbmino ||
> +	       I_INO(ip) == mp->m_sb.sb_rsumino ||
> +	       xfs_is_quota_inode(&mp->m_sb, I_INO(ip));
>  }
>  
>  static inline bool xfs_is_zoned_inode(const struct xfs_inode *ip)
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 4ae81eed0442..2307ce96f753 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -34,7 +34,7 @@ static uint64_t
>  xfs_inode_item_sort(
>  	struct xfs_log_item	*lip)
>  {
> -	return INODE_ITEM(lip)->ili_inode->i_ino;
> +	return I_INO(INODE_ITEM(lip)->ili_inode);
>  }
>  
>  #ifdef DEBUG_EXPENSIVE
> @@ -54,7 +54,7 @@ xfs_inode_item_precommit_check(
>  
>  	xfs_inode_to_disk(ip, dip, 0);
>  	xfs_dinode_calc_crc(mp, dip);
> -	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
> +	fa = xfs_dinode_verify(mp, I_INO(ip), dip);
>  	if (fa) {
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
>  				sizeof(*dip), fa);
> @@ -588,7 +588,7 @@ xfs_inode_to_log_dinode(
>  		to->di_flags2 = ip->i_diflags2;
>  		/* also covers the di_used_blocks union arm: */
>  		to->di_cowextsize = ip->i_cowextsize;
> -		to->di_ino = ip->i_ino;
> +		to->di_ino = I_INO(ip);
>  		to->di_lsn = lsn;
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
>  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
> @@ -651,7 +651,7 @@ xfs_inode_item_format(
>  
>  	ilf = xlog_format_start(lfb, XLOG_REG_TYPE_IFORMAT);
>  	ilf->ilf_type = XFS_LI_INODE;
> -	ilf->ilf_ino = ip->i_ino;
> +	ilf->ilf_ino = I_INO(ip);
>  	ilf->ilf_blkno = ip->i_imap.im_blkno;
>  	ilf->ilf_len = ip->i_imap.im_len;
>  	ilf->ilf_boffset = ip->i_imap.im_boffset;
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index b42106c4a9ef..169a8fe3bf0a 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -99,7 +99,7 @@ xfs_recover_inode_owner_change(
>  	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
>  		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
>  		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
> -					      ip->i_ino, buffer_list);
> +					      I_INO(ip), buffer_list);
>  		if (error)
>  			goto out_free_ip;
>  	}
> @@ -107,7 +107,7 @@ xfs_recover_inode_owner_change(
>  	if (in_f->ilf_fields & XFS_ILOG_AOWNER) {
>  		ASSERT(in_f->ilf_fields & XFS_ILOG_ABROOT);
>  		error = xfs_bmbt_change_owner(NULL, ip, XFS_ATTR_FORK,
> -					      ip->i_ino, buffer_list);
> +					      I_INO(ip), buffer_list);
>  		if (error)
>  			goto out_free_ip;
>  	}
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 46e234863644..fccd39d8157c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -984,7 +984,7 @@ xfs_ioc_swapext(
>  	if (ip->i_mount != tip->i_mount)
>  		return -EINVAL;
>  
> -	if (ip->i_ino == tip->i_ino)
> +	if (I_INO(ip) == I_INO(tip))
>  		return -EINVAL;
>  
>  	if (xfs_is_shutdown(ip->i_mount))
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index f20a02f49ed9..6ff722f04f5d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -45,7 +45,7 @@ xfs_alert_fsblock_zero(
>  			"Access to block zero in inode %llu "
>  			"start_block: %llx start_off: %llx "
>  			"blkcnt: %llx extent-state: %x",
> -		(unsigned long long)ip->i_ino,
> +		(unsigned long long)I_INO(ip),
>  		(unsigned long long)imap->br_startblock,
>  		(unsigned long long)imap->br_startoff,
>  		(unsigned long long)imap->br_blockcount,
> @@ -1736,7 +1736,7 @@ xfs_zoned_buffered_write_iomap_begin(
>  	if (count_fsb > ac->reserved_blocks) {
>  		xfs_warn_ratelimited(mp,
>  "Short write on ino 0x%llx comm %.20s due to three-way race with write fault and direct I/O",
> -			ip->i_ino, current->comm);
> +			I_INO(ip), current->comm);
>  		count_fsb = ac->reserved_blocks;
>  		if (!count_fsb) {
>  			error = -EIO;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 325c2200c501..6339f4956ecb 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -703,7 +703,7 @@ xfs_vn_getattr(
>  	stat->nlink = inode->i_nlink;
>  	stat->uid = vfsuid_into_kuid(vfsuid);
>  	stat->gid = vfsgid_into_kgid(vfsgid);
> -	stat->ino = ip->i_ino;
> +	stat->ino = inode->i_ino;
>  	stat->atime = inode_get_atime(inode);
>  
>  	fill_mg_cmtime(stat, request_mask, inode);
> @@ -1423,7 +1423,6 @@ xfs_setup_inode(
>  	gfp_t			gfp_mask;
>  	bool			is_meta = xfs_is_internal_inode(ip);
>  
> -	inode->i_ino = ip->i_ino;
>  	inode_state_set_raw(inode, I_NEW);
>  
>  	inode_sb_list_add(inode);
> diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> index a03a48eeb9a8..c8817112d49d 100644
> --- a/fs/xfs/xfs_iunlink_item.c
> +++ b/fs/xfs/xfs_iunlink_item.c
> @@ -40,7 +40,7 @@ static uint64_t
>  xfs_iunlink_item_sort(
>  	struct xfs_log_item	*lip)
>  {
> -	return IUL_ITEM(lip)->ip->i_ino;
> +	return I_INO(IUL_ITEM(lip)->ip);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index b24195f570cd..f0188eb47d1e 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1080,7 +1080,7 @@ xfs_mountfs(
>  
>  	if (XFS_IS_CORRUPT(mp, !S_ISDIR(VFS_I(rip)->i_mode))) {
>  		xfs_warn(mp, "corrupted root inode %llu: not a directory",
> -			(unsigned long long)rip->i_ino);
> +			(unsigned long long)I_INO(rip));
>  		xfs_iunlock(rip, XFS_ILOCK_EXCL);
>  		error = -EFSCORRUPTED;
>  		goto out_rele_rip;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 7bd15d9e7fba..aa0d2976f1c3 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -297,7 +297,7 @@ xfs_qm_need_dqattach(
>  		return false;
>  	if (!XFS_NOT_DQATTACHED(mp, ip))
>  		return false;
> -	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
> +	if (xfs_is_quota_inode(&mp->m_sb, I_INO(ip)))
>  		return false;
>  	if (xfs_is_metadir_inode(ip))
>  		return false;
> @@ -390,7 +390,7 @@ xfs_qm_dqdetach(
>  
>  	trace_xfs_dquot_dqdetach(ip);
>  
> -	ASSERT(!xfs_is_quota_inode(&ip->i_mount->m_sb, ip->i_ino));
> +	ASSERT(!xfs_is_quota_inode(&ip->i_mount->m_sb, I_INO(ip)));
>  	if (ip->i_udquot) {
>  		xfs_qm_dqrele(ip->i_udquot);
>  		ip->i_udquot = NULL;
> @@ -986,11 +986,11 @@ xfs_qm_qino_alloc(
>  		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
>  	}
>  	if (flags & XFS_QMOPT_UQUOTA)
> -		mp->m_sb.sb_uquotino = (*ipp)->i_ino;
> +		mp->m_sb.sb_uquotino = I_INO(*ipp);
>  	else if (flags & XFS_QMOPT_GQUOTA)
> -		mp->m_sb.sb_gquotino = (*ipp)->i_ino;
> +		mp->m_sb.sb_gquotino = I_INO(*ipp);
>  	else
> -		mp->m_sb.sb_pquotino = (*ipp)->i_ino;
> +		mp->m_sb.sb_pquotino = I_INO(*ipp);
>  	spin_unlock(&mp->m_sb_lock);
>  	xfs_log_sb(tp);
>  
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 8804508cc2b8..81f739e3aa0c 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -34,7 +34,7 @@ xfs_qm_fill_state(
>  
>  	defq = xfs_get_defquota(mp->m_quotainfo, type);
>  
> -	tstate->ino = ip->i_ino;
> +	tstate->ino = I_INO(ip);
>  	tstate->flags |= QCI_SYSFILE;
>  	tstate->blocks = ip->i_nblocks;
>  	tstate->nextents = ip->i_df.if_nextents;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index db23a0f231d6..ba96d322c950 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1188,7 +1188,7 @@ xfs_reflink_set_inode_flag(
>  		goto out_error;
>  
>  	/* Lock both files against IO */
> -	if (src->i_ino == dest->i_ino)
> +	if (I_INO(src) == I_INO(dest))
>  		xfs_ilock(src, XFS_ILOCK_EXCL);
>  	else
>  		xfs_lock_two_inodes(src, XFS_ILOCK_EXCL, dest, XFS_ILOCK_EXCL);
> @@ -1202,7 +1202,7 @@ xfs_reflink_set_inode_flag(
>  	} else
>  		xfs_iunlock(src, XFS_ILOCK_EXCL);
>  
> -	if (src->i_ino == dest->i_ino)
> +	if (I_INO(src) == I_INO(dest))
>  		goto commit_flags;
>  
>  	if (!xfs_is_reflink_inode(dest)) {
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index c4da624fb296..5585ac7f4d16 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -52,7 +52,7 @@ xfs_readlink(
>  
>  	if (pathlen < 0 || pathlen > XFS_SYMLINK_MAXLEN) {
>  		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
> -			 __func__, (unsigned long long) ip->i_ino,
> +			 __func__, (unsigned long long)I_INO(ip),
>  			 (long long) pathlen);
>  		ASSERT(0);
>  		goto out_corrupt;
> @@ -186,7 +186,7 @@ xfs_symlink(
>  	xfs_qm_vop_create_dqattach(tp, du.ip, udqp, gdqp, pdqp);
>  
>  	resblks -= XFS_IALLOC_SPACE_RES(mp);
> -	error = xfs_symlink_write_target(tp, du.ip, du.ip->i_ino, target_path,
> +	error = xfs_symlink_write_target(tp, du.ip, I_INO(du.ip), target_path,
>  			pathlen, fs_blocks, resblks);
>  	if (error)
>  		goto out_trans_cancel;
> @@ -339,7 +339,7 @@ xfs_inactive_symlink(
>  
>  	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN) {
>  		xfs_alert(mp, "%s: inode (0x%llx) bad symlink length (%d)",
> -			 __func__, (unsigned long long)ip->i_ino, pathlen);
> +			 __func__, (unsigned long long)I_INO(ip), pathlen);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		ASSERT(0);
>  		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 6767e50b643d..ae5faa787830 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -132,7 +132,7 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
> -		__entry->ino = ctx->dp->i_ino;
> +		__entry->ino = I_INO(ctx->dp);
>  		__entry->hashval = ctx->cursor.hashval;
>  		__entry->blkno = ctx->cursor.blkno;
>  		__entry->offset = ctx->cursor.offset;
> @@ -634,7 +634,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
> -		__entry->ino = ctx->dp->i_ino;
> +		__entry->ino = I_INO(ctx->dp);
>  		__entry->hashval = ctx->cursor.hashval;
>  		__entry->blkno = ctx->cursor.blkno;
>  		__entry->offset = ctx->cursor.offset;
> @@ -688,7 +688,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
>  		ifp = xfs_iext_state_to_fork(ip, state);
>  		xfs_iext_get_extent(ifp, cur, &r);
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->leaf = cur->leaf;
>  		__entry->pos = cur->pos;
>  		__entry->startoff = r.br_startoff;
> @@ -1021,7 +1021,7 @@ DECLARE_EVENT_CLASS(xfs_lock_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->lock_flags = lock_flags;
>  		__entry->caller_ip = caller_ip;
>  	),
> @@ -1052,7 +1052,7 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->iflags = ip->i_flags;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx iflags 0x%lx",
> @@ -1128,7 +1128,7 @@ DECLARE_EVENT_CLASS(xfs_fault_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->order = order;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx order %u",
> @@ -1157,7 +1157,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->count = icount_read(VFS_I(ip));
>  		__entry->pincount = atomic_read(&ip->i_pincount);
>  		__entry->iflags = ip->i_flags;
> @@ -1185,7 +1185,7 @@ TRACE_EVENT(xfs_iomap_prealloc_size,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->blocks = blocks;
>  		__entry->shift = shift;
>  		__entry->writeio_blocks = writeio_blocks;
> @@ -1272,7 +1272,7 @@ DECLARE_EVENT_CLASS(xfs_namespace_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(dp)->i_sb->s_dev;
> -		__entry->dp_ino = dp->i_ino;
> +		__entry->dp_ino = I_INO(dp);
>  		__entry->namelen = name->len;
>  		memcpy(__get_str(name), name->name, name->len);
>  	),
> @@ -1308,8 +1308,8 @@ TRACE_EVENT(xfs_rename,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(src_dp)->i_sb->s_dev;
> -		__entry->src_dp_ino = src_dp->i_ino;
> -		__entry->target_dp_ino = target_dp->i_ino;
> +		__entry->src_dp_ino = I_INO(src_dp);
> +		__entry->target_dp_ino = I_INO(target_dp);
>  		__entry->src_namelen = src_name->len;
>  		__entry->target_namelen = target_name->len;
>  		memcpy(__get_str(src_name), src_name->name, src_name->len);
> @@ -1760,7 +1760,7 @@ DECLARE_EVENT_CLASS(xfs_file_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = file_inode(iocb->ki_filp)->i_sb->s_dev;
> -		__entry->ino = XFS_I(file_inode(iocb->ki_filp))->i_ino;
> +		__entry->ino = file_inode(iocb->ki_filp)->i_ino;
>  		__entry->size = XFS_I(file_inode(iocb->ki_filp))->i_disk_size;
>  		__entry->offset = iocb->ki_pos;
>  		__entry->count = iov_iter_count(iter);
> @@ -1796,7 +1796,7 @@ TRACE_EVENT(xfs_iomap_atomic_write_cow,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->offset = offset;
>  		__entry->count = count;
>  	),
> @@ -1824,7 +1824,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->size = ip->i_disk_size;
>  		__entry->offset = offset;
>  		__entry->count = count;
> @@ -1869,7 +1869,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->isize = VFS_I(ip)->i_size;
>  		__entry->disize = ip->i_disk_size;
>  		__entry->offset = offset;
> @@ -1908,7 +1908,7 @@ DECLARE_EVENT_CLASS(xfs_itrunc_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->size = ip->i_disk_size;
>  		__entry->new_size = new_size;
>  	),
> @@ -1941,7 +1941,7 @@ TRACE_EVENT(xfs_bunmap,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->size = ip->i_disk_size;
>  		__entry->fileoff = fileoff;
>  		__entry->len = len;
> @@ -2344,7 +2344,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
> -		__entry->ino = args->dp->i_ino;
> +		__entry->ino = I_INO(args->dp);
>  		if (args->namelen)
>  			memcpy(__get_str(name), args->name, args->namelen);
>  		__entry->namelen = args->namelen;
> @@ -2411,7 +2411,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
> -		__entry->ino = args->dp->i_ino;
> +		__entry->ino = I_INO(args->dp);
>  		if (args->namelen)
>  			memcpy(__get_str(name), args->name, args->namelen);
>  		__entry->namelen = args->namelen;
> @@ -2511,7 +2511,7 @@ DECLARE_EVENT_CLASS(xfs_dir2_space_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
> -		__entry->ino = args->dp->i_ino;
> +		__entry->ino = I_INO(args->dp);
>  		__entry->op_flags = args->op_flags;
>  		__entry->idx = idx;
>  	),
> @@ -2544,7 +2544,7 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
> -		__entry->ino = args->dp->i_ino;
> +		__entry->ino = I_INO(args->dp);
>  		__entry->op_flags = args->op_flags;
>  		__entry->src_idx = src_idx;
>  		__entry->dst_idx = dst_idx;
> @@ -2586,7 +2586,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->which = which;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->format = ip->i_df.if_format;
>  		__entry->nex = ip->i_df.if_nextents;
>  		__entry->broot_size = ip->i_df.if_broot_bytes;
> @@ -2944,7 +2944,7 @@ TRACE_EVENT(xfs_btree_alloc_block,
>  		switch (cur->bc_ops->type) {
>  		case XFS_BTREE_TYPE_INODE:
>  			__entry->agno = 0;
> -			__entry->ino = cur->bc_ino.ip->i_ino;
> +			__entry->ino = I_INO(cur->bc_ino.ip);
>  			break;
>  		case XFS_BTREE_TYPE_AG:
>  			__entry->agno = cur->bc_group->xg_gno;
> @@ -2996,7 +2996,7 @@ TRACE_EVENT(xfs_btree_free_block,
>  		__entry->agno = xfs_daddr_to_agno(cur->bc_mp,
>  							xfs_buf_daddr(bp));
>  		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
> -			__entry->ino = cur->bc_ino.ip->i_ino;
> +			__entry->ino = I_INO(cur->bc_ino.ip);
>  		else
>  			__entry->ino = 0;
>  		__assign_str(name);
> @@ -3251,7 +3251,7 @@ DECLARE_EVENT_CLASS(xfs_btree_error_class,
>  		switch (cur->bc_ops->type) {
>  		case XFS_BTREE_TYPE_INODE:
>  			__entry->agno = 0;
> -			__entry->ino = cur->bc_ino.ip->i_ino;
> +			__entry->ino = I_INO(cur->bc_ino.ip);
>  			break;
>  		case XFS_BTREE_TYPE_AG:
>  			__entry->agno = cur->bc_group->xg_gno;
> @@ -3470,7 +3470,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
>  						bi->bi_bmap.br_startblock,
>  						bi->bi_group->xg_type);
>  		}
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->whichfork = bi->bi_whichfork;
>  		__entry->l_loff = bi->bi_bmap.br_startoff;
>  		__entry->l_len = bi->bi_bmap.br_blockcount;
> @@ -3974,7 +3974,7 @@ DECLARE_EVENT_CLASS(xfs_inode_error_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->error = error;
>  		__entry->caller_ip = caller_ip;
>  	),
> @@ -4012,12 +4012,12 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(src)->i_sb->s_dev;
> -		__entry->src_ino = src->i_ino;
> +		__entry->src_ino = I_INO(src);
>  		__entry->src_isize = VFS_I(src)->i_size;
>  		__entry->src_disize = src->i_disk_size;
>  		__entry->src_offset = soffset;
>  		__entry->len = len;
> -		__entry->dest_ino = dest->i_ino;
> +		__entry->dest_ino = I_INO(dest);
>  		__entry->dest_isize = VFS_I(dest)->i_size;
>  		__entry->dest_disize = dest->i_disk_size;
>  		__entry->dest_offset = doffset;
> @@ -4057,7 +4057,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->lblk = irec->br_startoff;
>  		__entry->len = irec->br_blockcount;
>  		__entry->pblk = irec->br_startblock;
> @@ -4093,7 +4093,7 @@ DECLARE_EVENT_CLASS(xfs_wb_invalid_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->addr = iomap->addr;
>  		__entry->pos = iomap->offset;
>  		__entry->len = iomap->length;
> @@ -4136,7 +4136,7 @@ DECLARE_EVENT_CLASS(xfs_iomap_invalid_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->addr = iomap->addr;
>  		__entry->pos = iomap->offset;
>  		__entry->len = iomap->length;
> @@ -4183,10 +4183,10 @@ TRACE_EVENT(xfs_reflink_remap_blocks,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(src)->i_sb->s_dev;
> -		__entry->src_ino = src->i_ino;
> +		__entry->src_ino = I_INO(src);
>  		__entry->src_lblk = soffset;
>  		__entry->len = len;
> -		__entry->dest_ino = dest->i_ino;
> +		__entry->dest_ino = I_INO(dest);
>  		__entry->dest_lblk = doffset;
>  	),
>  	TP_printk("dev %d:%d fsbcount 0x%llx "
> @@ -4649,7 +4649,7 @@ DECLARE_EVENT_CLASS(xfs_inode_corrupt_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->flags = flags;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx flags 0x%x",
> @@ -5028,7 +5028,7 @@ DECLARE_EVENT_CLASS(xfs_das_state_class,
>  	),
>  	TP_fast_assign(
>  		__entry->das = das;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  	),
>  	TP_printk("state change %s ino 0x%llx",
>  		  __print_symbolic(__entry->das, XFS_DAS_STRINGS),
> @@ -5293,7 +5293,7 @@ DECLARE_EVENT_CLASS(xfs_exchrange_inode_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->whichfile = whichfile;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->format = ip->i_df.if_format;
>  		__entry->nex = ip->i_df.if_nextents;
>  		__entry->fork_off = xfs_inode_fork_boff(ip);
> @@ -5346,10 +5346,10 @@ DECLARE_EVENT_CLASS(xfs_exchrange_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip1)->i_sb->s_dev;
> -		__entry->ip1_ino = ip1->i_ino;
> +		__entry->ip1_ino = I_INO(ip1);
>  		__entry->ip1_isize = VFS_I(ip1)->i_size;
>  		__entry->ip1_disize = ip1->i_disk_size;
> -		__entry->ip2_ino = ip2->i_ino;
> +		__entry->ip2_ino = I_INO(ip2);
>  		__entry->ip2_isize = VFS_I(ip2)->i_size;
>  		__entry->ip2_disize = ip2->i_disk_size;
>  
> @@ -5405,7 +5405,7 @@ TRACE_EVENT(xfs_exchrange_freshness,
>  		struct inode		*inode2 = VFS_I(ip2);
>  
>  		__entry->dev = inode2->i_sb->s_dev;
> -		__entry->ip2_ino = ip2->i_ino;
> +		__entry->ip2_ino = I_INO(ip2);
>  
>  		ts64 = inode_get_ctime(inode2);
>  		__entry->ip2_ctime = ts64.tv_sec;
> @@ -5477,8 +5477,8 @@ DECLARE_EVENT_CLASS(xfs_exchmaps_estimate_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = req->ip1->i_mount->m_super->s_dev;
> -		__entry->ino1 = req->ip1->i_ino;
> -		__entry->ino2 = req->ip2->i_ino;
> +		__entry->ino1 = I_INO(req->ip1);
> +		__entry->ino2 = I_INO(req->ip2);
>  		__entry->startoff1 = req->startoff1;
>  		__entry->startoff2 = req->startoff2;
>  		__entry->blockcount = req->blockcount;
> @@ -5529,8 +5529,8 @@ DECLARE_EVENT_CLASS(xfs_exchmaps_intent_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp->m_super->s_dev;
> -		__entry->ino1 = xmi->xmi_ip1->i_ino;
> -		__entry->ino2 = xmi->xmi_ip2->i_ino;
> +		__entry->ino1 = I_INO(xmi->xmi_ip1);
> +		__entry->ino2 = I_INO(xmi->xmi_ip2);
>  		__entry->flags = xmi->xmi_flags;
>  		__entry->startoff1 = xmi->xmi_startoff1;
>  		__entry->startoff2 = xmi->xmi_startoff2;
> @@ -5625,8 +5625,8 @@ TRACE_EVENT(xfs_exchmaps_delta_nextents,
>  		int whichfork = xfs_exchmaps_reqfork(req);
>  
>  		__entry->dev = req->ip1->i_mount->m_super->s_dev;
> -		__entry->ino1 = req->ip1->i_ino;
> -		__entry->ino2 = req->ip2->i_ino;
> +		__entry->ino1 = I_INO(req->ip1);
> +		__entry->ino2 = I_INO(req->ip2);
>  		__entry->nexts1 = xfs_ifork_ptr(req->ip1, whichfork)->if_nextents;
>  		__entry->nexts2 = xfs_ifork_ptr(req->ip2, whichfork)->if_nextents;
>  		__entry->d_nexts1 = d_nexts1;
> @@ -5656,7 +5656,7 @@ DECLARE_EVENT_CLASS(xfs_getparents_rec_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->firstu = context->firstu;
>  		__entry->reclen = pptr->gpr_reclen;
>  		__entry->bufsize = ppi->gp_bufsize;
> @@ -5700,7 +5700,7 @@ DECLARE_EVENT_CLASS(xfs_getparents_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = ip->i_mount->m_super->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->ino = I_INO(ip);
>  		__entry->iflags = ppi->gp_iflags;
>  		__entry->oflags = ppi->gp_oflags;
>  		__entry->bufsize = ppi->gp_bufsize;
> @@ -5739,8 +5739,8 @@ DECLARE_EVENT_CLASS(xfs_metadir_update_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = upd->dp->i_mount->m_super->s_dev;
> -		__entry->dp_ino = upd->dp->i_ino;
> -		__entry->ino = upd->ip ? upd->ip->i_ino : NULLFSINO;
> +		__entry->dp_ino = I_INO(upd->dp);
> +		__entry->ino = upd->ip ? I_INO(upd->ip) : NULLFSINO;
>  		__assign_str(fname);
>  	),
>  	TP_printk("dev %d:%d dp 0x%llx fname '%s' ino 0x%llx",
> @@ -5774,8 +5774,8 @@ DECLARE_EVENT_CLASS(xfs_metadir_update_error_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = upd->dp->i_mount->m_super->s_dev;
> -		__entry->dp_ino = upd->dp->i_ino;
> -		__entry->ino = upd->ip ? upd->ip->i_ino : NULLFSINO;
> +		__entry->dp_ino = I_INO(upd->dp);
> +		__entry->ino = upd->ip ? I_INO(upd->ip) : NULLFSINO;
>  		__entry->error = error;
>  		__assign_str(fname);
>  	),
> @@ -5807,7 +5807,7 @@ DECLARE_EVENT_CLASS(xfs_metadir_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(dp)->i_sb->s_dev;
> -		__entry->dp_ino = dp->i_ino;
> +		__entry->dp_ino = I_INO(dp);
>  		__entry->ino = ino,
>  		__entry->ftype = name->type;
>  		__entry->namelen = name->len;
> @@ -6325,7 +6325,7 @@ TRACE_EVENT(xfs_healthmon_report_file_ioerror,
>  	TP_fast_assign(
>  		__entry->dev = hm->dev;
>  		__entry->type = p->type;
> -		__entry->ino = XFS_I(p->inode)->i_ino;
> +		__entry->ino = p->inode->i_ino;
>  		__entry->gen = p->inode->i_generation;
>  		__entry->pos = p->pos;
>  		__entry->len = p->len;
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index bcc470f56e46..b375b51831fc 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1164,7 +1164,7 @@ xfs_trans_reserve_more_inode(
>  	if (error)
>  		return error;
>  
> -	if (!XFS_IS_QUOTA_ON(mp) || xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
> +	if (!XFS_IS_QUOTA_ON(mp) || xfs_is_quota_inode(&mp->m_sb, I_INO(ip)))
>  		return 0;
>  
>  	if (tp->t_flags & XFS_TRANS_RESERVE)
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index eaf9de6e07fd..1606c614f205 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -164,7 +164,7 @@ xfs_trans_mod_ino_dquot(
>  	if (xfs_hooks_switched_on(&xfs_dqtrx_hooks_switch)) {
>  		struct xfs_mod_ino_dqtrx_params	p = {
>  			.tx_id		= (uintptr_t)tp,
> -			.ino		= ip->i_ino,
> +			.ino		= I_INO(ip),
>  			.q_type		= xfs_dquot_type(dqp),
>  			.q_id		= dqp->q_id,
>  			.delta		= delta
> @@ -247,7 +247,7 @@ xfs_trans_mod_dquot_byino(
>  	xfs_mount_t	*mp = tp->t_mountp;
>  
>  	if (!XFS_IS_QUOTA_ON(mp) ||
> -	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino) ||
> +	    xfs_is_quota_inode(&mp->m_sb, I_INO(ip)) ||
>  	    xfs_is_metadir_inode(ip))
>  		return;
>  
> @@ -990,7 +990,7 @@ xfs_trans_reserve_quota_nblks(
>  	if (xfs_is_metadir_inode(ip))
>  		return 0;
>  
> -	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
> +	ASSERT(!xfs_is_quota_inode(&mp->m_sb, I_INO(ip)));
>  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
>  
>  	if (force)
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 544213067d59..1efe6c8139b2 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -104,7 +104,7 @@ xfs_attr_change(
>  		args->op_flags |= XFS_DA_OP_LOGGED;
>  	}
>  
> -	args->owner = args->dp->i_ino;
> +	args->owner = I_INO(args->dp);
>  	args->geo = mp->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
>  	xfs_attr_sethash(args);
> -- 
> 2.53.0
> 
