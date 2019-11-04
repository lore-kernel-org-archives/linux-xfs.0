Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91B1CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 18:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76D1020B7C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 18:21:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YhLIRbcn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfKDSVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 13:21:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbfKDSVi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 13:21:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4IIuZU007468;
        Mon, 4 Nov 2019 18:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3GKuJemnuvs7+XFJd1ynfVfJKDt4C8EfNKKC93lApO4=;
 b=YhLIRbcnPVt8LSgnaOBlyGEyTNCYK5rULaaZYBvlyLk0c5Vr6PgfKZqWqoG7823hBhxf
 TiAI/NE6T3fFSEHZ8zQRloPQT/OvUNTjzPzzcpBKykMkwWrsOhDmg7fctoFJ7TKvYooz
 HEPR2kxGdlBgMHhepgZgqixRMqI98cx79caxftVMKSydN4LNhnEWgwmKfdSz6qU5qLot
 x3zfDPGUdi3rOmKhLgJDkwqtzLFdJEN/37/TRf23v8fa7U31ZbdQ4zb+Wm8VTTtG/5dP
 xKQAYVfWFV3vnUULbN6/eUs4TsDLM5iLProyCMa0HMBzD+acGiaSvmwGsL5hsbA/uftX Ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w11rps71u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 18:21:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4IJXf6183126;
        Mon, 4 Nov 2019 18:21:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w1kxdqmwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 18:21:29 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4ILSaT017025;
        Mon, 4 Nov 2019 18:21:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 10:21:28 -0800
Date:   Mon, 4 Nov 2019 10:21:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/34] xfs: move incore structures out of xfs_da_format.h
Message-ID: <20191104182127.GB4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:06:46PM -0700, Christoph Hellwig wrote:
> Move the abstract in-memory version of various btree block headers
> out of xfs_da_format.h as they aren't on-disk formats.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.h | 23 ++++++++++++++
>  fs/xfs/libxfs/xfs_da_btree.h  | 13 ++++++++
>  fs/xfs/libxfs/xfs_da_format.c |  1 +
>  fs/xfs/libxfs/xfs_da_format.h | 57 -----------------------------------
>  fs/xfs/libxfs/xfs_dir2.h      |  2 ++
>  fs/xfs/libxfs/xfs_dir2_priv.h | 20 ++++++++++++
>  6 files changed, 59 insertions(+), 57 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index bb0880057ee3..16208a7743df 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -16,6 +16,29 @@ struct xfs_da_state_blk;
>  struct xfs_inode;
>  struct xfs_trans;
>  
> +/*
> + * Incore version of the attribute leaf header.
> + */
> +struct xfs_attr3_icleaf_hdr {
> +	uint32_t	forw;
> +	uint32_t	back;
> +	uint16_t	magic;
> +	uint16_t	count;
> +	uint16_t	usedbytes;
> +	/*
> +	 * Firstused is 32-bit here instead of 16-bit like the on-disk variant
> +	 * to support maximum fsb size of 64k without overflow issues throughout
> +	 * the attr code. Instead, the overflow condition is handled on
> +	 * conversion to/from disk.
> +	 */
> +	uint32_t	firstused;
> +	__u8		holes;
> +	struct {
> +		uint16_t	base;
> +		uint16_t	size;
> +	} freemap[XFS_ATTR_LEAF_MAPSIZE];
> +};
> +
>  /*
>   * Used to keep a list of "remote value" extents when unlinking an inode.
>   */
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index ae0bbd20d9ca..02f7a21ab3a5 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -124,6 +124,19 @@ typedef struct xfs_da_state {
>  						/* for dirv2 extrablk is data */
>  } xfs_da_state_t;
>  
> +/*
> + * In-core version of the node header to abstract the differences in the v2 and
> + * v3 disk format of the headers. Callers need to convert to/from disk format as
> + * appropriate.
> + */
> +struct xfs_da3_icnode_hdr {
> +	uint32_t		forw;
> +	uint32_t		back;
> +	uint16_t		magic;
> +	uint16_t		count;
> +	uint16_t		level;
> +};
> +
>  /*
>   * Utility macros to aid in logging changed structure fields.
>   */
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index b1ae572496b6..31bb250c1899 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -13,6 +13,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_dir2.h"
> +#include "xfs_dir2_priv.h"
>  
>  /*
>   * Shortform directory ops
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index ae654e06b2fb..548806060f45 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -93,19 +93,6 @@ struct xfs_da3_intnode {
>  	struct xfs_da_node_entry __btree[];
>  };
>  
> -/*
> - * In-core version of the node header to abstract the differences in the v2 and
> - * v3 disk format of the headers. Callers need to convert to/from disk format as
> - * appropriate.
> - */
> -struct xfs_da3_icnode_hdr {
> -	uint32_t	forw;
> -	uint32_t	back;
> -	uint16_t	magic;
> -	uint16_t	count;
> -	uint16_t	level;
> -};
> -
>  /*
>   * Directory version 2.
>   *
> @@ -434,14 +421,6 @@ struct xfs_dir3_leaf_hdr {
>  	__be32			pad;		/* 64 bit alignment */
>  };
>  
> -struct xfs_dir3_icleaf_hdr {
> -	uint32_t		forw;
> -	uint32_t		back;
> -	uint16_t		magic;
> -	uint16_t		count;
> -	uint16_t		stale;
> -};
> -
>  /*
>   * Leaf block entry.
>   */
> @@ -520,19 +499,6 @@ struct xfs_dir3_free {
>  
>  #define XFS_DIR3_FREE_CRC_OFF  offsetof(struct xfs_dir3_free, hdr.hdr.crc)
>  
> -/*
> - * In core version of the free block header, abstracted away from on-disk format
> - * differences. Use this in the code, and convert to/from the disk version using
> - * xfs_dir3_free_hdr_from_disk/xfs_dir3_free_hdr_to_disk.
> - */
> -struct xfs_dir3_icfree_hdr {
> -	uint32_t	magic;
> -	uint32_t	firstdb;
> -	uint32_t	nvalid;
> -	uint32_t	nused;
> -
> -};
> -
>  /*
>   * Single block format.
>   *
> @@ -709,29 +675,6 @@ struct xfs_attr3_leafblock {
>  	 */
>  };
>  
> -/*
> - * incore, neutral version of the attribute leaf header
> - */
> -struct xfs_attr3_icleaf_hdr {
> -	uint32_t	forw;
> -	uint32_t	back;
> -	uint16_t	magic;
> -	uint16_t	count;
> -	uint16_t	usedbytes;
> -	/*
> -	 * firstused is 32-bit here instead of 16-bit like the on-disk variant
> -	 * to support maximum fsb size of 64k without overflow issues throughout
> -	 * the attr code. Instead, the overflow condition is handled on
> -	 * conversion to/from disk.
> -	 */
> -	uint32_t	firstused;
> -	__u8		holes;
> -	struct {
> -		uint16_t	base;
> -		uint16_t	size;
> -	} freemap[XFS_ATTR_LEAF_MAPSIZE];
> -};
> -
>  /*
>   * Special value to represent fs block size in the leaf header firstused field.
>   * Only used when block size overflows the 2-bytes available on disk.
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index f54244779492..e170792c0acc 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -18,6 +18,8 @@ struct xfs_dir2_sf_entry;
>  struct xfs_dir2_data_hdr;
>  struct xfs_dir2_data_entry;
>  struct xfs_dir2_data_unused;
> +struct xfs_dir3_icfree_hdr;
> +struct xfs_dir3_icleaf_hdr;
>  
>  extern struct xfs_name	xfs_name_dotdot;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 59f9fb2241a5..973b1527b7ba 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -8,6 +8,26 @@
>  
>  struct dir_context;
>  
> +/*
> + * In-core version of the leaf and free block headers to abstract the
> + * differences in the v2 and v3 disk format of the headers.
> + */
> +struct xfs_dir3_icleaf_hdr {
> +	uint32_t		forw;
> +	uint32_t		back;
> +	uint16_t		magic;
> +	uint16_t		count;
> +	uint16_t		stale;
> +};
> +
> +struct xfs_dir3_icfree_hdr {
> +	uint32_t		magic;
> +	uint32_t		firstdb;
> +	uint32_t		nvalid;
> +	uint32_t		nused;
> +
> +};
> +
>  /* xfs_dir2.c */
>  extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
>  				xfs_dir2_db_t *dbp);
> -- 
> 2.20.1
> 
