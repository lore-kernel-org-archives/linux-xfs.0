Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6ED6CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D6522089C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bi18BXMC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfKDUuh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:50:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59532 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbfKDUug (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:50:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4Kmv9k138009;
        Mon, 4 Nov 2019 20:50:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8IjPpZKXXTtBbUvAa+jwcBI7TngsxGnpkWjI+X/LiXc=;
 b=bi18BXMCmxgVf2P1cxve9ejcbv+/EEZT9XeT/lC1HHTbBGnx38nZFgZ9nds8ogVfmqQv
 R7dHIt73Zq43F6ZcB/+DCJBCsliBKtpTq7Oqke4Ea51OeVQ3P+8DPnc9CFwxFx5l/2Hh
 w05vZW/NlQTXqP6Lu9Kii3ZEVkOH70/9KJMqBtov8Hrmc/hguDDtySvsxncqXk9Ky55k
 53WYyAED1c97vOZRzefCBqvdRte1g0dNdtpEvaWIIz7sN7MeQTteCGdKUYVn0hB38aFY
 KHirw0OcZs9pZhhLU+sRAN3wsEcX8Id5ktoy71Mk9iwKq4L1Q0H+6XbaRJfkXZOgr4Zy Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w11rpt14x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:50:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KmQqq189704;
        Mon, 4 Nov 2019 20:50:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w1kxdxt7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:50:32 +0000
Received: from abhmp0023.oracle.com (abhmp0023.oracle.com [141.146.116.29])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4KoUu6014833;
        Mon, 4 Nov 2019 20:50:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 20:50:30 +0000
Date:   Mon, 4 Nov 2019 12:50:29 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/34] xfs: remove the now unused dir ops infrastructure
Message-ID: <20191104205029.GH4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-33-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-33-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040201
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:17PM -0700, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

YAY!
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/Makefile               |  1 -
>  fs/xfs/libxfs/xfs_da_btree.h  |  1 -
>  fs/xfs/libxfs/xfs_da_format.c | 46 -----------------------------------
>  fs/xfs/libxfs/xfs_dir2.c      |  2 --
>  fs/xfs/libxfs/xfs_dir2.h      |  9 -------
>  fs/xfs/xfs_inode.h            |  3 ---
>  fs/xfs/xfs_iops.c             |  1 -
>  fs/xfs/xfs_mount.h            |  2 --
>  8 files changed, 65 deletions(-)
>  delete mode 100644 fs/xfs/libxfs/xfs_da_format.c
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 06b68b6115bc..aceca2f9a3db 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -27,7 +27,6 @@ xfs-y				+= $(addprefix libxfs/, \
>  				   xfs_bmap_btree.o \
>  				   xfs_btree.o \
>  				   xfs_da_btree.o \
> -				   xfs_da_format.o \
>  				   xfs_defer.o \
>  				   xfs_dir2.o \
>  				   xfs_dir2_block.o \
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index a3333e7a084d..7362e706cda7 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -10,7 +10,6 @@
>  struct xfs_inode;
>  struct xfs_trans;
>  struct zone;
> -struct xfs_dir_ops;
>  
>  /*
>   * Directory/attribute geometry information. There will be one of these for each
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> deleted file mode 100644
> index 498363ac193d..000000000000
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ /dev/null
> @@ -1,46 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
> - * Copyright (c) 2013 Red Hat, Inc.
> - * All Rights Reserved.
> - */
> -#include "xfs.h"
> -#include "xfs_fs.h"
> -#include "xfs_shared.h"
> -#include "xfs_format.h"
> -#include "xfs_log_format.h"
> -#include "xfs_trans_resv.h"
> -#include "xfs_mount.h"
> -#include "xfs_inode.h"
> -#include "xfs_dir2.h"
> -#include "xfs_dir2_priv.h"
> -
> -static const struct xfs_dir_ops xfs_dir2_ops = {
> -};
> -
> -static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> -};
> -
> -static const struct xfs_dir_ops xfs_dir3_ops = {
> -};
> -
> -/*
> - * Return the ops structure according to the current config.  If we are passed
> - * an inode, then that overrides the default config we use which is based on
> - * feature bits.
> - */
> -const struct xfs_dir_ops *
> -xfs_dir_get_ops(
> -	struct xfs_mount	*mp,
> -	struct xfs_inode	*dp)
> -{
> -	if (dp)
> -		return dp->d_ops;
> -	if (mp->m_dir_inode_ops)
> -		return mp->m_dir_inode_ops;
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		return &xfs_dir3_ops;
> -	if (xfs_sb_version_hasftype(&mp->m_sb))
> -		return &xfs_dir2_ftype_ops;
> -	return &xfs_dir2_ops;
> -}
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 33a6e8aacdba..b1fc89173ea6 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -104,8 +104,6 @@ xfs_da_mount(
>  	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
>  	ASSERT(xfs_dir2_dirblock_bytes(&mp->m_sb) <= XFS_MAX_BLOCKSIZE);
>  
> -	mp->m_dir_inode_ops = xfs_dir_get_ops(mp, NULL);
> -
>  	mp->m_dir_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
>  				    KM_MAYFAIL);
>  	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index f869ee01a381..ccdbc612fb76 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -28,15 +28,6 @@ extern struct xfs_name	xfs_name_dotdot;
>   */
>  extern unsigned char xfs_mode_to_ftype(int mode);
>  
> -/*
> - * directory operations vector for encode/decode routines
> - */
> -struct xfs_dir_ops {
> -};
> -
> -extern const struct xfs_dir_ops *
> -	xfs_dir_get_ops(struct xfs_mount *mp, struct xfs_inode *dp);
> -
>  /*
>   * Generic directory interface routines
>   */
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index bcfb35a9c5ca..6516dd1fc86a 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -37,9 +37,6 @@ typedef struct xfs_inode {
>  	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
>  	struct xfs_ifork	i_df;		/* data fork */
>  
> -	/* operations vectors */
> -	const struct xfs_dir_ops *d_ops;		/* directory ops vector */
> -
>  	/* Transaction and locking information. */
>  	struct xfs_inode_log_item *i_itemp;	/* logging information */
>  	mrlock_t		i_lock;		/* inode lock */
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 40d4495e013c..155c9269b7bb 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1317,7 +1317,6 @@ xfs_setup_inode(
>  		lockdep_set_class(&inode->i_rwsem,
>  				  &inode->i_sb->s_type->i_mutex_dir_key);
>  		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
> -		ip->d_ops = ip->i_mount->m_dir_inode_ops;
>  	} else {
>  		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
>  	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 3ddc5f4d1053..6dc1ff761572 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -12,7 +12,6 @@ struct xfs_mru_cache;
>  struct xfs_nameops;
>  struct xfs_ail;
>  struct xfs_quotainfo;
> -struct xfs_dir_ops;
>  struct xfs_da_geometry;
>  
>  /* dynamic preallocation free space thresholds, 5% down to 1% */
> @@ -158,7 +157,6 @@ typedef struct xfs_mount {
>  	int			m_swidth;	/* stripe width */
>  	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
>  	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
> -	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
>  	uint			m_chsize;	/* size of next field */
>  	atomic_t		m_active_trans;	/* number trans frozen */
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
> -- 
> 2.20.1
> 
