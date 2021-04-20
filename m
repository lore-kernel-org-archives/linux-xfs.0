Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F156C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 23:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1406B613E1
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 23:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbhDTXjY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 19:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233992AbhDTXjX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 19:39:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6307461414;
        Tue, 20 Apr 2021 23:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618961931;
        bh=W7L1/bZaTLGO5GXGzlMtm9cgHRNv+a/zER7d28P6ouo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DYGqU0TSP8rxZQwFKlrZ3t0m8ROWkAllFLCPnFm4mDFaMNklenRDL9f0lU273m6hI
         PD6szoAIAmGgHGr0qyHnEhHGKjB2TWmRkUXVfdoswPaHT/aFCeUSjAguAVg1z6mf1D
         fSwsVbUoJ/q02yjFKcI+hOm8zrwcqRLfH7FB6u/iPs0zKYRYuXBJS8YcVGl//5H3u5
         Z3CrHBzquXW36vMvG+ILXTuKqKLssUonYuySDeyrNSY5qysydPWncQS4C5RNofMTcT
         Jwe8UQ3YCECGvAUaKwSeiWvFdFRiGGMC52yxe8ffl0HqWZV1L+gS9esNxcJpdQ91Tb
         liRZ+TU251zBw==
Date:   Tue, 20 Apr 2021 16:38:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] xfs: Fix fall-through warnings for Clang
Message-ID: <20210420233850.GQ3122264@magnolia>
References: <20210420230652.GA70650@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420230652.GA70650@embeddedor>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 06:06:52PM -0500, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix
> the following warnings by replacing /* fall through */ comments,
> and its variants, with the new pseudo-keyword macro fallthrough:
> 
> fs/xfs/libxfs/xfs_alloc.c:3167:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/libxfs/xfs_da_btree.c:286:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/libxfs/xfs_ag_resv.c:346:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/libxfs/xfs_ag_resv.c:388:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/xfs_bmap_util.c:246:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/xfs_export.c:88:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/xfs_export.c:96:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/xfs_file.c:867:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/xfs_ioctl.c:562:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/xfs_ioctl.c:1548:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/xfs_iomap.c:1040:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/xfs_inode.c:852:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/xfs_log.c:2627:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/xfs_trans_buf.c:298:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/scrub/bmap.c:275:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/scrub/btree.c:48:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/scrub/common.c:85:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/scrub/common.c:138:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/scrub/common.c:698:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/scrub/dabtree.c:51:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> fs/xfs/scrub/repair.c:951:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> 
> Notice that Clang doesn't recognize /* fall through */ comments as
> implicit fall-through markings, so in order to globally enable
> -Wimplicit-fallthrough for Clang, these comments need to be
> replaced with fallthrough; in the whole codebase.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

I've already NAKd this twice, so I guess I'll NAK it a third time.

--D

> ---
>  fs/xfs/libxfs/xfs_ag_resv.c  | 4 ++--
>  fs/xfs/libxfs/xfs_alloc.c    | 2 +-
>  fs/xfs/libxfs/xfs_da_btree.c | 2 +-
>  fs/xfs/scrub/bmap.c          | 2 +-
>  fs/xfs/scrub/btree.c         | 2 +-
>  fs/xfs/scrub/common.c        | 6 +++---
>  fs/xfs/scrub/dabtree.c       | 2 +-
>  fs/xfs/scrub/repair.c        | 2 +-
>  fs/xfs/xfs_bmap_util.c       | 2 +-
>  fs/xfs/xfs_export.c          | 4 ++--
>  fs/xfs/xfs_file.c            | 2 +-
>  fs/xfs/xfs_inode.c           | 2 +-
>  fs/xfs/xfs_ioctl.c           | 4 ++--
>  fs/xfs/xfs_iomap.c           | 2 +-
>  fs/xfs/xfs_trans_buf.c       | 2 +-
>  15 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 6c5f8d10589c..8c3c99a9bf83 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -342,7 +342,7 @@ xfs_ag_resv_alloc_extent(
>  		break;
>  	default:
>  		ASSERT(0);
> -		/* fall through */
> +		fallthrough;
>  	case XFS_AG_RESV_NONE:
>  		field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS :
>  				       XFS_TRANS_SB_FDBLOCKS;
> @@ -384,7 +384,7 @@ xfs_ag_resv_free_extent(
>  		break;
>  	default:
>  		ASSERT(0);
> -		/* fall through */
> +		fallthrough;
>  	case XFS_AG_RESV_NONE:
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
>  		return;
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index aaa19101bb2a..9eabdeeec492 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3163,7 +3163,7 @@ xfs_alloc_vextent(
>  		}
>  		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
>  		args->type = XFS_ALLOCTYPE_NEAR_BNO;
> -		/* FALLTHROUGH */
> +		fallthrough;
>  	case XFS_ALLOCTYPE_FIRST_AG:
>  		/*
>  		 * Rotate through the allocation groups looking for a winner.
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 83ac9771bfb5..747ec77912c3 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -282,7 +282,7 @@ xfs_da3_node_read_verify(
>  						__this_address);
>  				break;
>  			}
> -			/* fall through */
> +			fallthrough;
>  		case XFS_DA_NODE_MAGIC:
>  			fa = xfs_da3_node_verify(bp);
>  			if (fa)
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index b5ebf1d1b4db..77d5c4a0f09f 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -271,7 +271,7 @@ xchk_bmap_iextent_xref(
>  	case XFS_DATA_FORK:
>  		if (xfs_is_reflink_inode(info->sc->ip))
>  			break;
> -		/* fall through */
> +		fallthrough;
>  	case XFS_ATTR_FORK:
>  		xchk_xref_is_not_shared(info->sc, agbno,
>  				irec->br_blockcount);
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index a94bd8122c60..bd1172358964 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -44,7 +44,7 @@ __xchk_btree_process_error(
>  		/* Note the badness but don't abort. */
>  		sc->sm->sm_flags |= errflag;
>  		*error = 0;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
>  			trace_xchk_ifork_btree_op_error(sc, cur, level,
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index aa874607618a..ce9a44ea6948 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -81,7 +81,7 @@ __xchk_process_error(
>  		/* Note the badness but don't abort. */
>  		sc->sm->sm_flags |= errflag;
>  		*error = 0;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		trace_xchk_op_error(sc, agno, bno, *error,
>  				ret_ip);
> @@ -134,7 +134,7 @@ __xchk_fblock_process_error(
>  		/* Note the badness but don't abort. */
>  		sc->sm->sm_flags |= errflag;
>  		*error = 0;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		trace_xchk_file_op_error(sc, whichfork, offset, *error,
>  				ret_ip);
> @@ -694,7 +694,7 @@ xchk_get_inode(
>  		if (error)
>  			return -ENOENT;
>  		error = -EFSCORRUPTED;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		trace_xchk_op_error(sc,
>  				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 653f3280e1c1..9f0dbb47c82c 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -47,7 +47,7 @@ xchk_da_process_error(
>  		/* Note the badness but don't abort. */
>  		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
>  		*error = 0;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
>  				xfs_dir2_da_to_db(ds->dargs.geo,
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index c2857d854c83..b8202dd08939 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -947,7 +947,7 @@ xrep_ino_dqattach(
>  			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
>  		if (XFS_IS_PQUOTA_ON(sc->mp) && !sc->ip->i_pdquot)
>  			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
> -		/* fall through */
> +		fallthrough;
>  	case -ESRCH:
>  		error = 0;
>  		break;
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index a5e9d7d34023..cc628475f9b6 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -242,7 +242,7 @@ xfs_bmap_count_blocks(
>  		 */
>  		*count += btblocks - 1;
>  
> -		/* fall through */
> +		fallthrough;
>  	case XFS_DINODE_FMT_EXTENTS:
>  		*nextents = xfs_bmap_count_leaves(ifp, count);
>  		break;
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index 465fd9e048d4..1da59bdff245 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -84,7 +84,7 @@ xfs_fs_encode_fh(
>  	case FILEID_INO32_GEN_PARENT:
>  		fid->i32.parent_ino = XFS_I(parent)->i_ino;
>  		fid->i32.parent_gen = parent->i_generation;
> -		/*FALLTHRU*/
> +		fallthrough;
>  	case FILEID_INO32_GEN:
>  		fid->i32.ino = XFS_I(inode)->i_ino;
>  		fid->i32.gen = inode->i_generation;
> @@ -92,7 +92,7 @@ xfs_fs_encode_fh(
>  	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
>  		fid64->parent_ino = XFS_I(parent)->i_ino;
>  		fid64->parent_gen = parent->i_generation;
> -		/*FALLTHRU*/
> +		fallthrough;
>  	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
>  		fid64->ino = XFS_I(inode)->i_ino;
>  		fid64->gen = inode->i_generation;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 396ef36dcd0a..3c0749ab9e40 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -863,7 +863,7 @@ xfs_break_layouts(
>  			error = xfs_break_dax_layouts(inode, &retry);
>  			if (error || retry)
>  				break;
> -			/* fall through */
> +			fallthrough;
>  		case BREAK_WRITE:
>  			error = xfs_break_leased_layouts(inode, iolock, &retry);
>  			break;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 0369eb22c1bb..f2846997c3a8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -848,7 +848,7 @@ xfs_init_new_inode(
>  			xfs_inode_inherit_flags(ip, pip);
>  		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
>  			xfs_inode_inherit_flags2(ip, pip);
> -		/* FALLTHROUGH */
> +		fallthrough;
>  	case S_IFLNK:
>  		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
>  		ip->i_df.if_bytes = 0;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 3925bfcb2365..c4dc6c72ac37 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -558,7 +558,7 @@ xfs_ioc_attrmulti_one(
>  	case ATTR_OP_REMOVE:
>  		value = NULL;
>  		*len = 0;
> -		/* fall through */
> +		fallthrough;
>  	case ATTR_OP_SET:
>  		error = mnt_want_write_file(parfilp);
>  		if (error)
> @@ -1544,7 +1544,7 @@ xfs_ioc_getbmap(
>  	switch (cmd) {
>  	case XFS_IOC_GETBMAPA:
>  		bmx.bmv_iflags = BMV_IF_ATTRFORK;
> -		/*FALLTHRU*/
> +		fallthrough;
>  	case XFS_IOC_GETBMAP:
>  		/* struct getbmap is a strict subset of struct getbmapx. */
>  		recsize = sizeof(struct getbmap);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index d154f42e2dc6..d8cd2583dedb 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1036,7 +1036,7 @@ xfs_buffered_write_iomap_begin(
>  			prealloc_blocks = 0;
>  			goto retry;
>  		}
> -		/*FALLTHRU*/
> +		fallthrough;
>  	default:
>  		goto out_unlock;
>  	}
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 9aced0a00003..d11d032da0b4 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -294,7 +294,7 @@ xfs_trans_read_buf_map(
>  	default:
>  		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
>  			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
> -		/* fall through */
> +		fallthrough;
>  	case -ENOMEM:
>  	case -EAGAIN:
>  		return error;
> -- 
> 2.27.0
> 
