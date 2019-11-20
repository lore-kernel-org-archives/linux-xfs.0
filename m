Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452F0C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 19:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 001102068D
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 19:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e6iHKznu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKTTAK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 14:00:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57708 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfKTTAK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 14:00:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIxKFR020162;
        Wed, 20 Nov 2019 19:00:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=P2nhOQBrbmxuX1d3UTDBFbziMGXAdfZGANAq8HAzE/o=;
 b=e6iHKznu27Sp7yDD3xt/c+96OdBWE71niPZidU6mxeWvPXOElCQx7A6HQUWyZm5uQLSM
 cjfTBgpvRVeRy9cqdakF7o8t+aQPAwpUs6AMEzPZl4LC8SgF2gGOTWaYVOmv/q2j6wak
 NIFKQIDj+eQWcmfEbqtJShpIssDPdvImRmUGlHzk/0d52xVLl3eWay4h8M8ezwhCoBoQ
 R+rGUow1vF+5A9ELwVmv8Kszv9H/GUFyDeiUvmEAYgEAbiQiGGG7JAtL6NkjsFPpQu3q
 nRwKxfdAvXWK6sH8hSCWY30IXRhmU9+4vZhD2AIraNYRGLMkWqhfFP6y7LgOSz4YJqts SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92pyhp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 19:00:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIxDeD131223;
        Wed, 20 Nov 2019 19:00:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wcemhav5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 19:00:03 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKJ029o016756;
        Wed, 20 Nov 2019 19:00:02 GMT
Received: from localhost (/10.159.246.236)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 11:00:02 -0800
Date:   Wed, 20 Nov 2019 11:00:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove kmem_zalloc() wrapper
Message-ID: <20191120190001.GP6219@magnolia>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
 <20191120104425.407213-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120104425.407213-4-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 11:44:23AM +0100, Carlos Maiolino wrote:
> Use kzalloc() directly
> 
> Special attention goes to function xfs_buf_map_from_irec(). Giving the
> fact we are not allowed to fail there, I removed the 'if (!map)'
> conditional from there, I'd just like somebody to double check if it's
> fine as I believe it is
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> V2:
> 	- Fix comment on xfs_dir_lookup()
> 
>  fs/xfs/kmem.h                 |  6 ------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
>  fs/xfs/libxfs/xfs_da_btree.c  | 10 ++++------
>  fs/xfs/libxfs/xfs_dir2.c      | 27 +++++++++++++--------------
>  fs/xfs/libxfs/xfs_iext_tree.c | 12 ++++++++----
>  fs/xfs/scrub/agheader.c       |  4 ++--
>  fs/xfs/scrub/fscounters.c     |  3 ++-
>  fs/xfs/xfs_buf.c              |  6 +++---
>  fs/xfs/xfs_buf_item.c         |  4 ++--
>  fs/xfs/xfs_dquot_item.c       |  3 ++-
>  fs/xfs/xfs_error.c            |  4 ++--
>  fs/xfs/xfs_extent_busy.c      |  3 ++-
>  fs/xfs/xfs_extfree_item.c     |  6 +++---
>  fs/xfs/xfs_inode.c            |  2 +-
>  fs/xfs/xfs_itable.c           |  8 ++++----
>  fs/xfs/xfs_iwalk.c            |  3 ++-
>  fs/xfs/xfs_log.c              |  5 +++--
>  fs/xfs/xfs_log_cil.c          |  6 +++---
>  fs/xfs/xfs_log_recover.c      | 12 ++++++------
>  fs/xfs/xfs_mount.c            |  3 ++-
>  fs/xfs/xfs_mru_cache.c        |  5 +++--
>  fs/xfs/xfs_qm.c               |  3 ++-
>  fs/xfs/xfs_refcount_item.c    |  4 ++--
>  fs/xfs/xfs_rmap_item.c        |  3 ++-
>  fs/xfs/xfs_trans_ail.c        |  3 ++-
>  25 files changed, 77 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 7e4ad73771ce..b9ee67fa747b 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -57,12 +57,6 @@ extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
>  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
>  extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
>  
> -static inline void *
> -kmem_zalloc(size_t size, xfs_km_flags_t flags)
> -{
> -	return kmem_alloc(size, flags | KM_ZERO);
> -}
> -
>  static inline void *
>  kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
>  {
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 795b9b21b64d..67de68584224 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2253,7 +2253,8 @@ xfs_attr3_leaf_unbalance(
>  		struct xfs_attr_leafblock *tmp_leaf;
>  		struct xfs_attr3_icleaf_hdr tmphdr;
>  
> -		tmp_leaf = kmem_zalloc(state->args->geo->blksize, 0);
> +		tmp_leaf = kzalloc(state->args->geo->blksize,
> +				   GFP_KERNEL | __GFP_NOFAIL);
>  
>  		/*
>  		 * Copy the header into the temp leaf so that all the stuff
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 10a96e64b2ec..29c25d1b3b76 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2534,10 +2534,8 @@ xfs_buf_map_from_irec(
>  	ASSERT(nirecs >= 1);
>  
>  	if (nirecs > 1) {
> -		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map),
> -				  KM_NOFS);
> -		if (!map)
> -			return -ENOMEM;
> +		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
> +			      GFP_NOFS | __GFP_NOFAIL);
>  		*mapp = map;
>  	}
>  
> @@ -2593,8 +2591,8 @@ xfs_dabuf_map(
>  		 * Optimize the one-block case.
>  		 */
>  		if (nfsb != 1)
> -			irecs = kmem_zalloc(sizeof(irec) * nfsb,
> -					    KM_NOFS);
> +			irecs = kzalloc(sizeof(irec) * nfsb,
> +					GFP_NOFS | __GFP_NOFAIL);
>  
>  		nirecs = nfsb;
>  		error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index efd7cec65259..c2deda036271 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -104,10 +104,10 @@ xfs_da_mount(
>  	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
>  	ASSERT(xfs_dir2_dirblock_bytes(&mp->m_sb) <= XFS_MAX_BLOCKSIZE);
>  
> -	mp->m_dir_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
> -				    KM_MAYFAIL);
> -	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
> -				     KM_MAYFAIL);
> +	mp->m_dir_geo = kzalloc(sizeof(struct xfs_da_geometry),
> +				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	mp->m_attr_geo = kzalloc(sizeof(struct xfs_da_geometry),
> +				 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!mp->m_dir_geo || !mp->m_attr_geo) {
>  		kfree(mp->m_dir_geo);
>  		kfree(mp->m_attr_geo);
> @@ -234,7 +234,7 @@ xfs_dir_init(
>  	if (error)
>  		return error;
>  
> -	args = kmem_zalloc(sizeof(*args), KM_NOFS);
> +	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
>  	if (!args)
>  		return -ENOMEM;
>  
> @@ -271,7 +271,7 @@ xfs_dir_createname(
>  		XFS_STATS_INC(dp->i_mount, xs_dir_create);
>  	}
>  
> -	args = kmem_zalloc(sizeof(*args), KM_NOFS);
> +	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
>  	if (!args)
>  		return -ENOMEM;
>  
> @@ -363,14 +363,13 @@ xfs_dir_lookup(
>  	XFS_STATS_INC(dp->i_mount, xs_dir_lookup);
>  
>  	/*
> -	 * We need to use KM_NOFS here so that lockdep will not throw false
> +	 * We need to use GFP_NOFS here so that lockdep will not throw false
>  	 * positive deadlock warnings on a non-transactional lookup path. It is
> -	 * safe to recurse into inode recalim in that case, but lockdep can't
> -	 * easily be taught about it. Hence KM_NOFS avoids having to add more
> -	 * lockdep Doing this avoids having to add a bunch of lockdep class
> -	 * annotations into the reclaim path for the ilock.
> +	 * safe to recurse into inode reclaim in that case, but lockdep can't
> +	 * easily be taught about it. Hence GFP_NOFS avoids having to add more
> +	 * lockdep class annotations into the reclaim path for the ilock.
>  	 */
> -	args = kmem_zalloc(sizeof(*args), KM_NOFS);
> +	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
>  	args->geo = dp->i_mount->m_dir_geo;
>  	args->name = name->name;
>  	args->namelen = name->len;
> @@ -439,7 +438,7 @@ xfs_dir_removename(
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
>  	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
>  
> -	args = kmem_zalloc(sizeof(*args), KM_NOFS);
> +	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
>  	if (!args)
>  		return -ENOMEM;
>  
> @@ -500,7 +499,7 @@ xfs_dir_replace(
>  	if (rval)
>  		return rval;
>  
> -	args = kmem_zalloc(sizeof(*args), KM_NOFS);
> +	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
>  	if (!args)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index a7ba30cd81da..e75e7c021187 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -398,7 +398,8 @@ static void
>  xfs_iext_grow(
>  	struct xfs_ifork	*ifp)
>  {
> -	struct xfs_iext_node	*node = kmem_zalloc(NODE_SIZE, KM_NOFS);
> +	struct xfs_iext_node	*node = kzalloc(NODE_SIZE,
> +						GFP_NOFS | __GFP_NOFAIL);
>  	int			i;
>  
>  	if (ifp->if_height == 1) {
> @@ -454,7 +455,8 @@ xfs_iext_split_node(
>  	int			*nr_entries)
>  {
>  	struct xfs_iext_node	*node = *nodep;
> -	struct xfs_iext_node	*new = kmem_zalloc(NODE_SIZE, KM_NOFS);
> +	struct xfs_iext_node	*new = kzalloc(NODE_SIZE,
> +					       GFP_NOFS | __GFP_NOFAIL);
>  	const int		nr_move = KEYS_PER_NODE / 2;
>  	int			nr_keep = nr_move + (KEYS_PER_NODE & 1);
>  	int			i = 0;
> @@ -542,7 +544,8 @@ xfs_iext_split_leaf(
>  	int			*nr_entries)
>  {
>  	struct xfs_iext_leaf	*leaf = cur->leaf;
> -	struct xfs_iext_leaf	*new = kmem_zalloc(NODE_SIZE, KM_NOFS);
> +	struct xfs_iext_leaf	*new = kzalloc(NODE_SIZE,
> +					       GFP_NOFS | __GFP_NOFAIL);
>  	const int		nr_move = RECS_PER_LEAF / 2;
>  	int			nr_keep = nr_move + (RECS_PER_LEAF & 1);
>  	int			i;
> @@ -583,7 +586,8 @@ xfs_iext_alloc_root(
>  {
>  	ASSERT(ifp->if_bytes == 0);
>  
> -	ifp->if_u1.if_root = kmem_zalloc(sizeof(struct xfs_iext_rec), KM_NOFS);
> +	ifp->if_u1.if_root = kzalloc(sizeof(struct xfs_iext_rec),
> +				     GFP_NOFS | __GFP_NOFAIL);
>  	ifp->if_height = 1;
>  
>  	/* now that we have a node step into it */
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 6f7126f6d25c..5533c0d38333 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -720,8 +720,8 @@ xchk_agfl(
>  	memset(&sai, 0, sizeof(sai));
>  	sai.sc = sc;
>  	sai.sz_entries = agflcount;
> -	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount,
> -			KM_MAYFAIL);
> +	sai.entries = kzalloc(sizeof(xfs_agblock_t) * agflcount,
> +			      GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!sai.entries) {
>  		error = -ENOMEM;
>  		goto out;
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 7251c66a82c9..bb036c5a6f21 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -125,7 +125,8 @@ xchk_setup_fscounters(
>  	struct xchk_fscounters	*fsc;
>  	int			error;
>  
> -	sc->buf = kmem_zalloc(sizeof(struct xchk_fscounters), 0);
> +	sc->buf = kzalloc(sizeof(struct xchk_fscounters),
> +			  GFP_KERNEL | __GFP_NOFAIL);
>  	if (!sc->buf)
>  		return -ENOMEM;
>  	fsc = sc->buf;
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 0d2c41c6639d..c70122fbc2a8 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -178,8 +178,8 @@ xfs_buf_get_maps(
>  		return 0;
>  	}
>  
> -	bp->b_maps = kmem_zalloc(map_count * sizeof(struct xfs_buf_map),
> -				KM_NOFS);
> +	bp->b_maps = kzalloc(map_count * sizeof(struct xfs_buf_map),
> +			     GFP_NOFS | __GFP_NOFAIL);
>  	if (!bp->b_maps)
>  		return -ENOMEM;
>  	return 0;
> @@ -1749,7 +1749,7 @@ xfs_alloc_buftarg(
>  {
>  	xfs_buftarg_t		*btp;
>  
> -	btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
> +	btp = kzalloc(sizeof(*btp), GFP_NOFS | __GFP_NOFAIL);
>  
>  	btp->bt_mount = mp;
>  	btp->bt_dev =  bdev->bd_dev;
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index dc39b2d1b351..4fea8e5e70fb 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -701,8 +701,8 @@ xfs_buf_item_get_format(
>  		return 0;
>  	}
>  
> -	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
> -				0);
> +	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
> +				   GFP_KERNEL | __GFP_NOFAIL);
>  	if (!bip->bli_formats)
>  		return -ENOMEM;
>  	return 0;
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 1b5e68ccef60..91bd47e8b832 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -347,7 +347,8 @@ xfs_qm_qoff_logitem_init(
>  {
>  	struct xfs_qoff_logitem	*qf;
>  
> -	qf = kmem_zalloc(sizeof(struct xfs_qoff_logitem), 0);
> +	qf = kzalloc(sizeof(struct xfs_qoff_logitem),
> +		     GFP_KERNEL | __GFP_NOFAIL);
>  
>  	xfs_log_item_init(mp, &qf->qql_item, XFS_LI_QUOTAOFF, start ?
>  			&xfs_qm_qoffend_logitem_ops : &xfs_qm_qoff_logitem_ops);
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 4c0883380d7c..0e0ef2e15e2e 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -212,8 +212,8 @@ int
>  xfs_errortag_init(
>  	struct xfs_mount	*mp)
>  {
> -	mp->m_errortag = kmem_zalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
> -			KM_MAYFAIL);
> +	mp->m_errortag = kzalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
> +				 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!mp->m_errortag)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 9f0b99c7b34a..0ce50b47fc28 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -33,7 +33,8 @@ xfs_extent_busy_insert(
>  	struct rb_node		**rbp;
>  	struct rb_node		*parent = NULL;
>  
> -	new = kmem_zalloc(sizeof(struct xfs_extent_busy), 0);
> +	new = kzalloc(sizeof(struct xfs_extent_busy),
> +		      GFP_KERNEL | __GFP_NOFAIL);
>  	new->agno = agno;
>  	new->bno = bno;
>  	new->length = len;
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index c3b8804aa396..872312029957 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -163,7 +163,7 @@ xfs_efi_init(
>  	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
>  		size = (uint)(sizeof(xfs_efi_log_item_t) +
>  			((nextents - 1) * sizeof(xfs_extent_t)));
> -		efip = kmem_zalloc(size, 0);
> +		efip = kzalloc(size, GFP_KERNEL | __GFP_NOFAIL);
>  	} else {
>  		efip = kmem_cache_zalloc(xfs_efi_zone,
>  					 GFP_KERNEL | __GFP_NOFAIL);
> @@ -333,9 +333,9 @@ xfs_trans_get_efd(
>  	ASSERT(nextents > 0);
>  
>  	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> -		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> +		efdp = kzalloc(sizeof(struct xfs_efd_log_item) +
>  				(nextents - 1) * sizeof(struct xfs_extent),
> -				0);
> +				GFP_KERNEL | __GFP_NOFAIL);
>  	} else {
>  		efdp = kmem_cache_zalloc(xfs_efd_zone,
>  					 GFP_KERNEL | __GFP_NOFAIL);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e1121ed7cbb5..297b2a73f285 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2024,7 +2024,7 @@ xfs_iunlink_add_backref(
>  	if (XFS_TEST_ERROR(false, pag->pag_mount, XFS_ERRTAG_IUNLINK_FALLBACK))
>  		return 0;
>  
> -	iu = kmem_zalloc(sizeof(*iu), KM_NOFS);
> +	iu = kzalloc(sizeof(*iu), GFP_NOFS | __GFP_NOFAIL);
>  	iu->iu_agino = prev_agino;
>  	iu->iu_next_unlinked = this_agino;
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 36bf47f11117..ec5d590469fc 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -168,8 +168,8 @@ xfs_bulkstat_one(
>  
>  	ASSERT(breq->icount == 1);
>  
> -	bc.buf = kmem_zalloc(sizeof(struct xfs_bulkstat),
> -			KM_MAYFAIL);
> +	bc.buf = kzalloc(sizeof(struct xfs_bulkstat),
> +			 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!bc.buf)
>  		return -ENOMEM;
>  
> @@ -242,8 +242,8 @@ xfs_bulkstat(
>  	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
>  		return 0;
>  
> -	bc.buf = kmem_zalloc(sizeof(struct xfs_bulkstat),
> -			KM_MAYFAIL);
> +	bc.buf = kzalloc(sizeof(struct xfs_bulkstat),
> +			 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!bc.buf)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 67e98f9023d2..e6006423e140 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -616,7 +616,8 @@ xfs_iwalk_threaded(
>  		if (xfs_pwork_ctl_want_abort(&pctl))
>  			break;
>  
> -		iwag = kmem_zalloc(sizeof(struct xfs_iwalk_ag), 0);
> +		iwag = kzalloc(sizeof(struct xfs_iwalk_ag),
> +			       GFP_KERNEL | __GFP_NOFAIL);
>  		iwag->mp = mp;
>  		iwag->iwalk_fn = iwalk_fn;
>  		iwag->data = data;
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 9ed7869d879f..152c87865241 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1412,7 +1412,7 @@ xlog_alloc_log(
>  	int			error = -ENOMEM;
>  	uint			log2_size = 0;
>  
> -	log = kmem_zalloc(sizeof(struct xlog), KM_MAYFAIL);
> +	log = kzalloc(sizeof(struct xlog), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!log) {
>  		xfs_warn(mp, "Log allocation failed: No memory!");
>  		goto out;
> @@ -1482,7 +1482,8 @@ xlog_alloc_log(
>  		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
>  				sizeof(struct bio_vec);
>  
> -		iclog = kmem_zalloc(sizeof(*iclog) + bvec_size, KM_MAYFAIL);
> +		iclog = kzalloc(sizeof(*iclog) + bvec_size,
> +				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!iclog)
>  			goto out_free_iclog;
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 9953f2f040ab..de5c892c72b0 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -660,7 +660,7 @@ xlog_cil_push(
>  	if (!cil)
>  		return 0;
>  
> -	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
> +	new_ctx = kzalloc(sizeof(*new_ctx), GFP_NOFS | __GFP_NOFAIL);
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
>  
>  	down_write(&cil->xc_ctx_lock);
> @@ -1179,11 +1179,11 @@ xlog_cil_init(
>  	struct xfs_cil	*cil;
>  	struct xfs_cil_ctx *ctx;
>  
> -	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
> +	cil = kzalloc(sizeof(*cil), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!cil)
>  		return -ENOMEM;
>  
> -	ctx = kmem_zalloc(sizeof(*ctx), KM_MAYFAIL);
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!ctx) {
>  		kfree(cil);
>  		return -ENOMEM;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4167e1326f62..cb02deb5dedc 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4171,7 +4171,7 @@ xlog_recover_add_item(
>  {
>  	xlog_recover_item_t	*item;
>  
> -	item = kmem_zalloc(sizeof(xlog_recover_item_t), 0);
> +	item = kzalloc(sizeof(xlog_recover_item_t), GFP_KERNEL | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&item->ri_list);
>  	list_add_tail(&item->ri_list, head);
>  }
> @@ -4298,8 +4298,8 @@ xlog_recover_add_to_trans(
>  
>  		item->ri_total = in_f->ilf_size;
>  		item->ri_buf =
> -			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
> -				    0);
> +			kzalloc(item->ri_total * sizeof(xfs_log_iovec_t),
> +				GFP_KERNEL | __GFP_NOFAIL);
>  	}
>  
>  	if (item->ri_total <= item->ri_cnt) {
> @@ -4442,7 +4442,7 @@ xlog_recover_ophdr_to_trans(
>  	 * This is a new transaction so allocate a new recovery container to
>  	 * hold the recovery ops that will follow.
>  	 */
> -	trans = kmem_zalloc(sizeof(struct xlog_recover), 0);
> +	trans = kzalloc(sizeof(struct xlog_recover), GFP_KERNEL | __GFP_NOFAIL);
>  	trans->r_log_tid = tid;
>  	trans->r_lsn = be64_to_cpu(rhead->h_lsn);
>  	INIT_LIST_HEAD(&trans->r_itemq);
> @@ -5561,9 +5561,9 @@ xlog_do_log_recovery(
>  	 * First do a pass to find all of the cancelled buf log items.
>  	 * Store them in the buf_cancel_table for use in the second pass.
>  	 */
> -	log->l_buf_cancel_table = kmem_zalloc(XLOG_BC_TABLE_SIZE *
> +	log->l_buf_cancel_table = kzalloc(XLOG_BC_TABLE_SIZE *
>  						 sizeof(struct list_head),
> -						 0);
> +						 GFP_KERNEL | __GFP_NOFAIL);
>  	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
>  		INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 53ddb058b11a..c352567c8ef5 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -194,7 +194,8 @@ xfs_initialize_perag(
>  			continue;
>  		}
>  
> -		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
> +		pag = kzalloc(sizeof(*pag),
> +			      GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!pag)
>  			goto out_unwind_new_pags;
>  		pag->pag_agno = index;
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index 6ef0a71d7681..f24014759c57 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -333,12 +333,13 @@ xfs_mru_cache_create(
>  	if (!(grp_time = msecs_to_jiffies(lifetime_ms) / grp_count))
>  		return -EINVAL;
>  
> -	if (!(mru = kmem_zalloc(sizeof(*mru), 0)))
> +	if (!(mru = kzalloc(sizeof(*mru), GFP_KERNEL | __GFP_NOFAIL)))
>  		return -ENOMEM;
>  
>  	/* An extra list is needed to avoid reaping up to a grp_time early. */
>  	mru->grp_count = grp_count + 1;
> -	mru->lists = kmem_zalloc(mru->grp_count * sizeof(*mru->lists), 0);
> +	mru->lists = kzalloc(mru->grp_count * sizeof(*mru->lists),
> +			     GFP_KERNEL | __GFP_NOFAIL);
>  
>  	if (!mru->lists) {
>  		err = -ENOMEM;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 06c92dc61a03..a2664afa10c3 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -643,7 +643,8 @@ xfs_qm_init_quotainfo(
>  
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
> -	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), 0);
> +	qinf = mp->m_quotainfo = kzalloc(sizeof(xfs_quotainfo_t),
> +					 GFP_KERNEL | __GFP_NOFAIL);
>  
>  	error = list_lru_init(&qinf->qi_lru);
>  	if (error)
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 76b39f2a0260..7ec70a5f1cb0 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -143,8 +143,8 @@ xfs_cui_init(
>  
>  	ASSERT(nextents > 0);
>  	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
> -		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
> -				0);
> +		cuip = kzalloc(xfs_cui_log_item_sizeof(nextents),
> +			       GFP_KERNEL | __GFP_NOFAIL);
>  	else
>  		cuip = kmem_cache_zalloc(xfs_cui_zone,
>  					 GFP_KERNEL | __GFP_NOFAIL);
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 6aeb6745d007..82d822885996 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -142,7 +142,8 @@ xfs_rui_init(
>  
>  	ASSERT(nextents > 0);
>  	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
> -		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
> +		ruip = kzalloc(xfs_rui_log_item_sizeof(nextents),
> +			       GFP_KERNEL | __GFP_NOFAIL);
>  	else
>  		ruip = kmem_cache_zalloc(xfs_rui_zone,
>  					 GFP_KERNEL | __GFP_NOFAIL);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 589918d11041..2e3515df1bb5 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -824,7 +824,8 @@ xfs_trans_ail_init(
>  {
>  	struct xfs_ail	*ailp;
>  
> -	ailp = kmem_zalloc(sizeof(struct xfs_ail), KM_MAYFAIL);
> +	ailp = kzalloc(sizeof(struct xfs_ail),
> +		       GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!ailp)
>  		return -ENOMEM;
>  
> -- 
> 2.23.0
> 
