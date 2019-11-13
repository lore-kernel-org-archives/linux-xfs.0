Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D2FC432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E729206EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WQQIqyQf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKMRt2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 12:49:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbfKMRt1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 12:49:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADHnHUL093125;
        Wed, 13 Nov 2019 17:49:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Icf9I231s9ani8AzTihscrpnBXq9NT9+zW3hmI+p/ic=;
 b=WQQIqyQfxnh0C8aN4ef+hechCigfFhVmrXGLt0oq1cUkWlk8xwRHtAEmR7eZsyPokw/2
 nJD3XQ5POJT9mYrKQq1Ak1xDYRjmnYIs45o6Po3Khh11qyiTL74lszcok4MoDQT5/4c2
 ppErsoxristC+w8wdq58FodecR3wfH0MNAIbbAPDTtCWpffPvJoUwcXP2NCf+VE3C3Sb
 PqTj9wSgxx+6R5a3fkB0j+idaY6V/yLWQnntjWO9BR2aXK+SCpDtClKENBoGah4aaJ6L
 oQuEXe/NawH4xTuoQyVmybCoIzCeBBDqv+kBykeaFby8x/loHiVcLYd5KNkgysGWT/EK 1w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w5mvtx76u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:49:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADHn96S131266;
        Wed, 13 Nov 2019 17:49:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w7vbd980n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:49:22 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xADHn3q3011761;
        Wed, 13 Nov 2019 17:49:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 09:49:02 -0800
Date:   Wed, 13 Nov 2019 09:49:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: Convert kmem_alloc() users
Message-ID: <20191113174901.GE6219@magnolia>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-9-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113142335.1045631-9-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 03:23:32PM +0100, Carlos Maiolino wrote:
> Use kmalloc() directly.
> 
> kmem_alloc_io() and kmem_alloc_large() still have use for kmem_alloc(), due
> their fallback to vmalloc() and also the alignment check. But for that, there is
> no need to export kmem_alloc() to the whole XFS driver, so, also convert
> kmem_alloc() into a static, local function __kmem_alloc().
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/kmem.c                  |  8 ++++----
>  fs/xfs/kmem.h                  |  1 -
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  6 +++---
>  fs/xfs/libxfs/xfs_bmap.c       |  2 +-
>  fs/xfs/libxfs/xfs_da_btree.c   |  4 +++-
>  fs/xfs/libxfs/xfs_defer.c      |  4 ++--
>  fs/xfs/libxfs/xfs_dir2.c       |  2 +-
>  fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  8 ++++----
>  fs/xfs/libxfs/xfs_inode_fork.c | 10 ++++++----
>  fs/xfs/libxfs/xfs_refcount.c   |  9 +++++----
>  fs/xfs/libxfs/xfs_rmap.c       |  2 +-
>  fs/xfs/scrub/bitmap.c          |  7 ++++---
>  fs/xfs/scrub/btree.c           |  4 ++--
>  fs/xfs/scrub/refcount.c        |  4 ++--
>  fs/xfs/xfs_attr_inactive.c     |  2 +-
>  fs/xfs/xfs_attr_list.c         |  2 +-
>  fs/xfs/xfs_buf.c               |  5 +++--
>  fs/xfs/xfs_filestream.c        |  2 +-
>  fs/xfs/xfs_inode.c             |  2 +-
>  fs/xfs/xfs_iwalk.c             |  2 +-
>  fs/xfs/xfs_log_recover.c       |  7 ++++---
>  fs/xfs/xfs_qm.c                |  3 ++-
>  fs/xfs/xfs_rtalloc.c           |  2 +-
>  fs/xfs/xfs_super.c             |  2 +-
>  25 files changed, 55 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 6e10e565632c..79467813d810 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -8,8 +8,8 @@
>  #include "xfs_message.h"
>  #include "xfs_trace.h"
>  
> -void *
> -kmem_alloc(size_t size, xfs_km_flags_t flags)
> +static void *
> +__kmem_alloc(size_t size, xfs_km_flags_t flags)

Was about to get grumpy about the __ prefix but then saw that the next
patch removes this anyway so meh.

Though, it's probably worth mentioning in the commit message that
__kmem_alloc is minimally touched because it's just scaffolding for more
refactoring in the next patch.

The rest loosk ok though, so with the commit message fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  {
>  	int	retries = 0;
>  	gfp_t	lflags = kmem_flags_convert(flags);
> @@ -72,7 +72,7 @@ kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags)
>  	if (WARN_ON_ONCE(align_mask >= PAGE_SIZE))
>  		align_mask = PAGE_SIZE - 1;
>  
> -	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> +	ptr = __kmem_alloc(size, flags | KM_MAYFAIL);
>  	if (ptr) {
>  		if (!((uintptr_t)ptr & align_mask))
>  			return ptr;
> @@ -88,7 +88,7 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
>  
>  	trace_kmem_alloc_large(size, flags, _RET_IP_);
>  
> -	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> +	ptr = __kmem_alloc(size, flags | KM_MAYFAIL);
>  	if (ptr)
>  		return ptr;
>  	return __kmem_vmalloc(size, flags);
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 18b62eee3177..29d02c71fb22 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -52,7 +52,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  	return lflags;
>  }
>  
> -extern void *kmem_alloc(size_t, xfs_km_flags_t);
>  extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
>  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
>  static inline void  kmem_free(const void *ptr)
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 9f54e59f4004..e78cba993eae 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -885,7 +885,7 @@ xfs_attr_shortform_to_leaf(
>  	ifp = dp->i_afp;
>  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>  	size = be16_to_cpu(sf->hdr.totsize);
> -	tmpbuffer = kmem_alloc(size, 0);
> +	tmpbuffer = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
>  	ASSERT(tmpbuffer != NULL);
>  	memcpy(tmpbuffer, ifp->if_u1.if_data, size);
>  	sf = (xfs_attr_shortform_t *)tmpbuffer;
> @@ -1073,7 +1073,7 @@ xfs_attr3_leaf_to_shortform(
>  
>  	trace_xfs_attr_leaf_to_sf(args);
>  
> -	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
> +	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
>  	if (!tmpbuffer)
>  		return -ENOMEM;
>  
> @@ -1534,7 +1534,7 @@ xfs_attr3_leaf_compact(
>  
>  	trace_xfs_attr_leaf_compact(args);
>  
> -	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
> +	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
>  	memset(bp->b_addr, 0, args->geo->blksize);
>  	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 37596e49b92e..fc5bed95bd44 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6045,7 +6045,7 @@ __xfs_bmap_add(
>  			bmap->br_blockcount,
>  			bmap->br_state);
>  
> -	bi = kmem_alloc(sizeof(struct xfs_bmap_intent), KM_NOFS);
> +	bi = kmalloc(sizeof(struct xfs_bmap_intent), GFP_NOFS | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&bi->bi_list);
>  	bi->bi_type = type;
>  	bi->bi_owner = ip;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index dbd2434e68b5..d1211153e7d9 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2152,7 +2152,9 @@ xfs_da_grow_inode_int(
>  		 * If we didn't get it and the block might work if fragmented,
>  		 * try without the CONTIG flag.  Loop until we get it all.
>  		 */
> -		mapp = kmem_alloc(sizeof(*mapp) * count, 0);
> +		mapp = kmalloc(sizeof(*mapp) * count,
> +			       GFP_KERNEL | __GFP_NOFAIL);
> +
>  		for (b = *bno, mapi = 0; b < *bno + count; ) {
>  			nmap = min(XFS_BMAP_MAX_NMAP, count);
>  			c = (int)(*bno + count - b);
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 22557527cfdb..24f71a59462f 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -516,8 +516,8 @@ xfs_defer_add(
>  			dfp = NULL;
>  	}
>  	if (!dfp) {
> -		dfp = kmem_alloc(sizeof(struct xfs_defer_pending),
> -				KM_NOFS);
> +		dfp = kmalloc(sizeof(struct xfs_defer_pending),
> +			      GFP_NOFS | __GFP_NOFAIL);
>  		dfp->dfp_type = type;
>  		dfp->dfp_intent = NULL;
>  		dfp->dfp_done = NULL;
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 67172e376e1d..2606d3070cba 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -331,7 +331,7 @@ xfs_dir_cilookup_result(
>  					!(args->op_flags & XFS_DA_OP_CILOOKUP))
>  		return -EEXIST;
>  
> -	args->value = kmem_alloc(len, KM_NOFS | KM_MAYFAIL);
> +	args->value = kmalloc(len, GFP_NOFS | __GFP_RETRY_MAYFAIL);
>  	if (!args->value)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 358151ddfa75..c90d2d001815 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1083,7 +1083,7 @@ xfs_dir2_sf_to_block(
>  	 * Copy the directory into a temporary buffer.
>  	 * Then pitch the incore inode data so we can make extents.
>  	 */
> -	sfp = kmem_alloc(ifp->if_bytes, 0);
> +	sfp = kmalloc(ifp->if_bytes, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(sfp, oldsfp, ifp->if_bytes);
>  
>  	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index db1a82972d9e..bf38294ba785 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -276,7 +276,7 @@ xfs_dir2_block_to_sf(
>  	 * format the data into.  Once we have formatted the data, we can free
>  	 * the block and copy the formatted data into the inode literal area.
>  	 */
> -	sfp = kmem_alloc(mp->m_sb.sb_inodesize, 0);
> +	sfp = kmalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
>  
>  	/*
> @@ -530,7 +530,7 @@ xfs_dir2_sf_addname_hard(
>  	 */
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>  	old_isize = (int)dp->i_d.di_size;
> -	buf = kmem_alloc(old_isize, 0);
> +	buf = kmalloc(old_isize, GFP_KERNEL | __GFP_NOFAIL);
>  	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
>  	memcpy(oldsfp, sfp, old_isize);
>  	/*
> @@ -1162,7 +1162,7 @@ xfs_dir2_sf_toino4(
>  	 * Don't want xfs_idata_realloc copying the data here.
>  	 */
>  	oldsize = dp->i_df.if_bytes;
> -	buf = kmem_alloc(oldsize, 0);
> +	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
>  	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>  	ASSERT(oldsfp->i8count == 1);
>  	memcpy(buf, oldsfp, oldsize);
> @@ -1235,7 +1235,7 @@ xfs_dir2_sf_toino8(
>  	 * Don't want xfs_idata_realloc copying the data here.
>  	 */
>  	oldsize = dp->i_df.if_bytes;
> -	buf = kmem_alloc(oldsize, 0);
> +	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
>  	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>  	ASSERT(oldsfp->i8count == 0);
>  	memcpy(buf, oldsfp, oldsize);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 34c336f45796..1e4c93cde07e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -153,7 +153,8 @@ xfs_init_local_fork(
>  
>  	if (size) {
>  		real_size = roundup(mem_size, 4);
> -		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
> +		ifp->if_u1.if_data = kmalloc(real_size,
> +					     GFP_NOFS | __GFP_NOFAIL);
>  		memcpy(ifp->if_u1.if_data, data, size);
>  		if (zero_terminate)
>  			ifp->if_u1.if_data[size] = '\0';
> @@ -308,7 +309,7 @@ xfs_iformat_btree(
>  	}
>  
>  	ifp->if_broot_bytes = size;
> -	ifp->if_broot = kmem_alloc(size, KM_NOFS);
> +	ifp->if_broot = kmalloc(size, GFP_NOFS | __GFP_NOFAIL);
>  	ASSERT(ifp->if_broot != NULL);
>  	/*
>  	 * Copy and convert from the on-disk structure
> @@ -373,7 +374,8 @@ xfs_iroot_realloc(
>  		 */
>  		if (ifp->if_broot_bytes == 0) {
>  			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
> -			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
> +			ifp->if_broot = kmalloc(new_size,
> +						GFP_NOFS | __GFP_NOFAIL);
>  			ifp->if_broot_bytes = (int)new_size;
>  			return;
>  		}
> @@ -414,7 +416,7 @@ xfs_iroot_realloc(
>  	else
>  		new_size = 0;
>  	if (new_size > 0) {
> -		new_broot = kmem_alloc(new_size, KM_NOFS);
> +		new_broot = kmalloc(new_size, GFP_NOFS | __GFP_NOFAIL);
>  		/*
>  		 * First copy over the btree block header.
>  		 */
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 78236bd6c64f..5b76d6bbfa58 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1188,8 +1188,8 @@ __xfs_refcount_add(
>  			type, XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
>  			blockcount);
>  
> -	ri = kmem_alloc(sizeof(struct xfs_refcount_intent),
> -			KM_NOFS);
> +	ri = kmalloc(sizeof(struct xfs_refcount_intent),
> +		     GFP_NOFS | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&ri->ri_list);
>  	ri->ri_type = type;
>  	ri->ri_startblock = startblock;
> @@ -1584,7 +1584,7 @@ struct xfs_refcount_recovery {
>  /* Stuff an extent on the recovery list. */
>  STATIC int
>  xfs_refcount_recover_extent(
> -	struct xfs_btree_cur 		*cur,
> +	struct xfs_btree_cur		*cur,
>  	union xfs_btree_rec		*rec,
>  	void				*priv)
>  {
> @@ -1596,7 +1596,8 @@ xfs_refcount_recover_extent(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
> +	rr = kmalloc(sizeof(struct xfs_refcount_recovery),
> +		     GFP_KERNEL | __GFP_NOFAIL);
>  	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
>  	list_add_tail(&rr->rr_list, debris);
>  
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 38e9414878b3..0e1e8cbb8862 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2286,7 +2286,7 @@ __xfs_rmap_add(
>  			bmap->br_blockcount,
>  			bmap->br_state);
>  
> -	ri = kmem_alloc(sizeof(struct xfs_rmap_intent), KM_NOFS);
> +	ri = kmalloc(sizeof(struct xfs_rmap_intent), GFP_NOFS | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&ri->ri_list);
>  	ri->ri_type = type;
>  	ri->ri_owner = owner;
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index 18a684e18a69..37aaab8cca7f 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -25,7 +25,8 @@ xfs_bitmap_set(
>  {
>  	struct xfs_bitmap_range	*bmr;
>  
> -	bmr = kmem_alloc(sizeof(struct xfs_bitmap_range), KM_MAYFAIL);
> +	bmr = kmalloc(sizeof(struct xfs_bitmap_range),
> +		      GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!bmr)
>  		return -ENOMEM;
>  
> @@ -181,8 +182,8 @@ xfs_bitmap_disunion(
>  			 * Deleting from the middle: add the new right extent
>  			 * and then shrink the left extent.
>  			 */
> -			new_br = kmem_alloc(sizeof(struct xfs_bitmap_range),
> -					KM_MAYFAIL);
> +			new_br = kmalloc(sizeof(struct xfs_bitmap_range),
> +					 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  			if (!new_br) {
>  				error = -ENOMEM;
>  				goto out;
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index f52a7b8256f9..93c2371d128b 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -429,8 +429,8 @@ xchk_btree_check_owner(
>  	 * later scanning.
>  	 */
>  	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
> -		co = kmem_alloc(sizeof(struct check_owner),
> -				KM_MAYFAIL);
> +		co = kmalloc(sizeof(struct check_owner),
> +			     GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!co)
>  			return -ENOMEM;
>  		co->level = level;
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 0cab11a5d390..468b739b90b5 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -125,8 +125,8 @@ xchk_refcountbt_rmap_check(
>  		 * is healthy each rmap_irec we see will be in agbno order
>  		 * so we don't need insertion sort here.
>  		 */
> -		frag = kmem_alloc(sizeof(struct xchk_refcnt_frag),
> -				KM_MAYFAIL);
> +		frag = kmalloc(sizeof(struct xchk_refcnt_frag),
> +			       GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!frag)
>  			return -ENOMEM;
>  		memcpy(&frag->rm, rec, sizeof(frag->rm));
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index a78c501f6fb1..ac0931919999 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -148,7 +148,7 @@ xfs_attr3_leaf_inactive(
>  	 * Allocate storage for a list of all the "remote" value extents.
>  	 */
>  	size = count * sizeof(xfs_attr_inactive_list_t);
> -	list = kmem_alloc(size, 0);
> +	list = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	/*
>  	 * Identify each of the "remote" value extents.
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 0ec6606149a2..1b39bbff113e 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -116,7 +116,7 @@ xfs_attr_shortform_list(
>  	 * It didn't all fit, so we have to sort everything on hashval.
>  	 */
>  	sbsize = sf->hdr.count * sizeof(*sbuf);
> -	sbp = sbuf = kmem_alloc(sbsize, KM_NOFS);
> +	sbp = sbuf = kmalloc(sbsize, GFP_NOFS | __GFP_NOFAIL);
>  
>  	/*
>  	 * Scan the attribute list for the rest of the entries, storing
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e2a7eac03d04..8a0cc7593212 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -274,8 +274,9 @@ _xfs_buf_get_pages(
>  		if (page_count <= XB_PAGES) {
>  			bp->b_pages = bp->b_page_array;
>  		} else {
> -			bp->b_pages = kmem_alloc(sizeof(struct page *) *
> -						 page_count, KM_NOFS);
> +			bp->b_pages = kmalloc(sizeof(struct page *) *
> +					      page_count,
> +					      GFP_NOFS | __GFP_NOFAIL);
>  			if (bp->b_pages == NULL)
>  				return -ENOMEM;
>  		}
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 2ae356775f63..0a4bd510e631 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -247,7 +247,7 @@ xfs_filestream_pick_ag(
>  		return 0;
>  
>  	err = -ENOMEM;
> -	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
> +	item = kmalloc(sizeof(*item), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!item)
>  		goto out_put_ag;
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8a67e97ecbfc..48d162b0c254 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3493,7 +3493,7 @@ xfs_iflush_cluster(
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  
>  	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
> -	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
> +	cilist = kmalloc(cilist_size, GFP_NOFS | __GFP_RETRY_MAYFAIL);
>  	if (!cilist)
>  		goto out_put;
>  
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index c812b14af3bb..d6b93a8ee1dc 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -152,7 +152,7 @@ xfs_iwalk_alloc(
>  
>  	/* Allocate a prefetch buffer for inobt records. */
>  	size = iwag->sz_recs * sizeof(struct xfs_inobt_rec_incore);
> -	iwag->recs = kmem_alloc(size, KM_MAYFAIL);
> +	iwag->recs = kmalloc(size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (iwag->recs == NULL)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a7f1dcecc640..d46240152518 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1962,7 +1962,7 @@ xlog_recover_buffer_pass1(
>  		}
>  	}
>  
> -	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
> +	bcp = kmalloc(sizeof(struct xfs_buf_cancel), GFP_KERNEL | __GFP_NOFAIL);
>  	bcp->bc_blkno = buf_f->blf_blkno;
>  	bcp->bc_len = buf_f->blf_len;
>  	bcp->bc_refcount = 1;
> @@ -2932,7 +2932,8 @@ xlog_recover_inode_pass2(
>  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
>  		in_f = item->ri_buf[0].i_addr;
>  	} else {
> -		in_f = kmem_alloc(sizeof(struct xfs_inode_log_format), 0);
> +		in_f = kmalloc(sizeof(struct xfs_inode_log_format),
> +			       GFP_KERNEL | __GFP_NOFAIL);
>  		need_free = 1;
>  		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
>  		if (error)
> @@ -4271,7 +4272,7 @@ xlog_recover_add_to_trans(
>  		return 0;
>  	}
>  
> -	ptr = kmem_alloc(len, 0);
> +	ptr = kmalloc(len, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(ptr, dp, len);
>  	in_f = (struct xfs_inode_log_format *)ptr;
>  
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 771f695d8092..ce0c1dddb784 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -988,7 +988,8 @@ xfs_qm_reset_dqcounts_buf(
>  	if (qip->i_d.di_nblocks == 0)
>  		return 0;
>  
> -	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
> +	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
> +		      GFP_KERNEL | __GFP_NOFAIL);
>  
>  	lblkno = 0;
>  	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index d42b5a2047e0..1875484123d7 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -962,7 +962,7 @@ xfs_growfs_rt(
>  	/*
>  	 * Allocate a new (fake) mount/sb.
>  	 */
> -	nmp = kmem_alloc(sizeof(*nmp), 0);
> +	nmp = kmalloc(sizeof(*nmp), GFP_KERNEL | __GFP_NOFAIL);
>  	/*
>  	 * Loop over the bitmap blocks.
>  	 * We will do everything one bitmap block at a time.
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d9ae27ddf253..c6c423f76447 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1739,7 +1739,7 @@ static int xfs_init_fs_context(
>  {
>  	struct xfs_mount	*mp;
>  
> -	mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
> +	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
>  	if (!mp)
>  		return -ENOMEM;
>  
> -- 
> 2.23.0
> 
