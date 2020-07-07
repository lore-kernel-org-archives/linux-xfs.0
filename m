Return-Path: <SRS0=C5JC=AS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E54C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 20:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 542A7206F6
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 20:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vuShPWmm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgGGUwl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 16:52:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55324 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgGGUwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jul 2020 16:52:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 067KbhpE169080;
        Tue, 7 Jul 2020 20:52:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dwHEJe85PG4/FCf2uocrJs2JtOg4eRJoRkbKk4DRaDI=;
 b=vuShPWmm4yizUEi9DtOe8rSrrS+psnt7sc1hvMCaRHoS9b7oc7qcranyGVITVnr0rLxW
 J2rYd995keYPp1b9LpyIqWvv3OrmcVbia1B9bB0Gxm4XjoJctQSrTgcBEKcfZT66FO+d
 aTkd6mwac06saWxQMj+cIC2IddNL3mxT20kBDVQZUNJ5f0ioG4nHbQOupDrtwjGcZbZZ
 VIpI0rFPL7MGhbD+zkW1PelpIbSlCFbETmGny9C6FnyFsUP8Gqaw+J/P0XdTwD2O1onQ
 TQmQO1jaR8pxb0PdsLCRBHgmmlQXA6pOV2W7dICruwr7aq9NR4FRCXzBsDzcznGhhiPE hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 323wacjqc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 07 Jul 2020 20:52:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 067KcFh3033205;
        Tue, 7 Jul 2020 20:50:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3233pxsmqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jul 2020 20:50:39 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 067KocnL010327;
        Tue, 7 Jul 2020 20:50:38 GMT
Received: from localhost (/10.159.242.215)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 13:50:37 -0700
Date:   Tue, 7 Jul 2020 13:50:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use fallthrough pseudo-keyword
Message-ID: <20200707205036.GL7606@magnolia>
References: <20200707200504.GA4796@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707200504.GA4796@embeddedor>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007070136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0 cotscore=-2147483648
 suspectscore=0 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007070136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 07, 2020 at 03:05:04PM -0500, Gustavo A. R. Silva wrote:
> Replace the existing /* fall through */ comments and its variants with
> the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> fall-through markings when it is the case.

I don't see any removals, only line changes?

> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

C18??

The kernel hasn't even moved off of C89 onto C99 yet.

> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c   |    4 ++--
>  fs/xfs/libxfs/xfs_alloc.c     |    2 +-
>  fs/xfs/libxfs/xfs_da_btree.c  |    2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c |    4 ++--

This is going to cause more churn in xfsprogs...

>  fs/xfs/scrub/bmap.c           |    2 +-
>  fs/xfs/scrub/btree.c          |    2 +-
>  fs/xfs/scrub/common.c         |    6 +++---
>  fs/xfs/scrub/dabtree.c        |    2 +-
>  fs/xfs/scrub/repair.c         |    2 +-
>  fs/xfs/xfs_bmap_util.c        |    2 +-
>  fs/xfs/xfs_export.c           |    4 ++--
>  fs/xfs/xfs_file.c             |    2 +-
>  fs/xfs/xfs_fsmap.c            |    2 +-
>  fs/xfs/xfs_inode.c            |    2 +-
>  fs/xfs/xfs_ioctl.c            |    4 ++--
>  fs/xfs/xfs_iomap.c            |    2 +-
>  fs/xfs/xfs_trans_buf.c        |    2 +-
>  17 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index fdfe6dc0d307..0b061a027e4e 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -338,7 +338,7 @@ xfs_ag_resv_alloc_extent(
>  		break;
>  	default:
>  		ASSERT(0);
> -		/* fall through */
> +		fallthrough;

...all so we can increase the number of bloody macros that we have to
obscure things.  I don't get it, what's the point?  Are gcc/clang
refusing to support -Wimplicit-fallthrough=[1-4] past a certain date?

--D

>  	case XFS_AG_RESV_NONE:
>  		field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS :
>  				       XFS_TRANS_SB_FDBLOCKS;
> @@ -380,7 +380,7 @@ xfs_ag_resv_free_extent(
>  		break;
>  	default:
>  		ASSERT(0);
> -		/* fall through */
> +		fallthrough;
>  	case XFS_AG_RESV_NONE:
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
>  		return;
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 203e74fa64aa..6b153e6ee342 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3119,7 +3119,7 @@ xfs_alloc_vextent(
>  		}
>  		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
>  		args->type = XFS_ALLOCTYPE_NEAR_BNO;
> -		/* FALLTHROUGH */
> +		fallthrough;
>  	case XFS_ALLOCTYPE_FIRST_AG:
>  		/*
>  		 * Rotate through the allocation groups looking for a winner.
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 897749c41f36..c48beec0c0df 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -276,7 +276,7 @@ xfs_da3_node_read_verify(
>  						__this_address);
>  				break;
>  			}
> -			/* fall through */
> +			fallthrough;
>  		case XFS_DA_NODE_MAGIC:
>  			fa = xfs_da3_node_verify(bp);
>  			if (fa)
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 6f84ea85fdd8..63b0d86ff985 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -439,8 +439,8 @@ xfs_dinode_verify_forkoff(
>  		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
>  			return __this_address;
>  		break;
> -	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
> -	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
> +	case XFS_DINODE_FMT_LOCAL:
> +	case XFS_DINODE_FMT_EXTENTS:
>  	case XFS_DINODE_FMT_BTREE:
>  		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
>  			return __this_address;
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 7badd6dfe544..10e8599b34f6 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -252,7 +252,7 @@ xchk_bmap_iextent_xref(
>  	case XFS_DATA_FORK:
>  		if (xfs_is_reflink_inode(info->sc->ip))
>  			break;
> -		/* fall through */
> +		fallthrough;
>  	case XFS_ATTR_FORK:
>  		xchk_xref_is_not_shared(info->sc, agbno,
>  				irec->br_blockcount);
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index f52a7b8256f9..990a379fc322 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -43,7 +43,7 @@ __xchk_btree_process_error(
>  		/* Note the badness but don't abort. */
>  		sc->sm->sm_flags |= errflag;
>  		*error = 0;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
>  			trace_xchk_ifork_btree_op_error(sc, cur, level,
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 18876056e5e0..63f13c8ed8c7 100644
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
> @@ -713,7 +713,7 @@ xchk_get_inode(
>  		if (error)
>  			return -ENOENT;
>  		error = -EFSCORRUPTED;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		trace_xchk_op_error(sc,
>  				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 44b15015021f..238a0cab792c 100644
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
> index db3cfd12803d..90948ca758a7 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -944,7 +944,7 @@ xrep_ino_dqattach(
>  			xrep_force_quotacheck(sc, XFS_DQ_GROUP);
>  		if (XFS_IS_PQUOTA_ON(sc->mp) && !sc->ip->i_pdquot)
>  			xrep_force_quotacheck(sc, XFS_DQ_PROJ);
> -		/* fall through */
> +		fallthrough;
>  	case -ESRCH:
>  		error = 0;
>  		break;
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f37f5cc4b19f..035896e81104 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -244,7 +244,7 @@ xfs_bmap_count_blocks(
>  		 */
>  		*count += btblocks - 1;
>  
> -		/* fall through */
> +		fallthrough;
>  	case XFS_DINODE_FMT_EXTENTS:
>  		*nextents = xfs_bmap_count_leaves(ifp, count);
>  		break;
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index 5a4b0119143a..bc5fcb631c51 100644
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
> index 00db81eac80d..b85d1da85b82 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -769,7 +769,7 @@ xfs_break_layouts(
>  			error = xfs_break_dax_layouts(inode, &retry);
>  			if (error || retry)
>  				break;
> -			/* fall through */
> +			fallthrough;
>  		case BREAK_WRITE:
>  			error = xfs_break_leased_layouts(inode, iolock, &retry);
>  			break;
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 4eebcec4aae6..c334550aeea7 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -100,7 +100,7 @@ xfs_fsmap_owner_to_rmap(
>  		dest->rm_owner = XFS_RMAP_OWN_COW;
>  		break;
>  	case XFS_FMR_OWN_DEFECTIVE:	/* not implemented */
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9aea7d68d8ab..52ce37ed14de 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -906,7 +906,7 @@ xfs_ialloc(
>  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
>  				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
>  		}
> -		/* FALLTHROUGH */
> +		fallthrough;
>  	case S_IFLNK:
>  		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
>  		ip->i_df.if_flags = XFS_IFEXTENTS;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a190212ca85d..ea366a645c8e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -557,7 +557,7 @@ xfs_ioc_attrmulti_one(
>  	case ATTR_OP_REMOVE:
>  		value = NULL;
>  		*len = 0;
> -		/* fall through */
> +		fallthrough;
>  	case ATTR_OP_SET:
>  		error = mnt_want_write_file(parfilp);
>  		if (error)
> @@ -1660,7 +1660,7 @@ xfs_ioc_getbmap(
>  	switch (cmd) {
>  	case XFS_IOC_GETBMAPA:
>  		bmx.bmv_iflags = BMV_IF_ATTRFORK;
> -		/*FALLTHRU*/
> +		fallthrough;
>  	case XFS_IOC_GETBMAP:
>  		if (file->f_mode & FMODE_NOCMTIME)
>  			bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index b9a8c3798e08..fc4b65b24fdf 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1002,7 +1002,7 @@ xfs_buffered_write_iomap_begin(
>  			prealloc_blocks = 0;
>  			goto retry;
>  		}
> -		/*FALLTHRU*/
> +		fallthrough;
>  	default:
>  		goto out_unlock;
>  	}
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 08174ffa2118..ad79065607cc 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -310,7 +310,7 @@ xfs_trans_read_buf_map(
>  	default:
>  		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
>  			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
> -		/* fall through */
> +		fallthrough;
>  	case -ENOMEM:
>  	case -EAGAIN:
>  		return error;
> 
