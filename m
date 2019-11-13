Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE67DC432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22A95206EE
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pYQS4aRr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfKMRSk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 12:18:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45250 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfKMRSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 12:18:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADGxQCN018229;
        Wed, 13 Nov 2019 17:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=nDbOAFafUK5f2g/fyf19YaGjPQc0P82nEJ0vE0Cn2QQ=;
 b=pYQS4aRrEhEge8qawAm1IRNzst4tr1JFIS6IkXsGBSS4rUfRZVKeucQmILrffEAI5phU
 M0GgBAE0gNk5iNl6sCsmj2QnLtTQTRCp/ut9GFDDhA7RdBGThJmCwNj6yIRCOj8FA0pQ
 T/JIDIX0z0jGQtagtF/4xuOpnCBeSVZK0tetbf7d9i6VZortZODUsv/D3UjKRSPHk/4B
 QYm7c6RArKUx5uQeYRWkt2pxkxmJq5EOzyzTAIYLtruflkaC4B1F2uetpc4VndRiXwWG
 XRXDOMtXf7LE/QiRRjnbZW6daH50/cCEYOlclbiNB40WKnz6d1YhaK2LyD0Yam5AcC55 bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w5p3qww4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:18:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADGxU5g103832;
        Wed, 13 Nov 2019 17:18:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w7vppmcvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:18:33 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xADHIVWU022307;
        Wed, 13 Nov 2019 17:18:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 09:18:31 -0800
Date:   Wed, 13 Nov 2019 09:18:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: remove kmem_zone_zalloc()
Message-ID: <20191113171830.GA6219@magnolia>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113142335.1045631-5-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 03:23:28PM +0100, Carlos Maiolino wrote:
> Use kmem_cache_zalloc() directly.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/kmem.h                      | 6 ------
>  fs/xfs/libxfs/xfs_alloc_btree.c    | 2 +-
>  fs/xfs/libxfs/xfs_bmap.c           | 3 ++-
>  fs/xfs/libxfs/xfs_bmap_btree.c     | 2 +-
>  fs/xfs/libxfs/xfs_da_btree.c       | 2 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c     | 6 +++---
>  fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
>  fs/xfs/libxfs/xfs_rmap_btree.c     | 2 +-
>  fs/xfs/xfs_bmap_item.c             | 4 ++--
>  fs/xfs/xfs_buf.c                   | 2 +-
>  fs/xfs/xfs_buf_item.c              | 2 +-
>  fs/xfs/xfs_dquot.c                 | 2 +-
>  fs/xfs/xfs_extfree_item.c          | 6 ++++--
>  fs/xfs/xfs_icreate_item.c          | 2 +-
>  fs/xfs/xfs_inode_item.c            | 3 ++-
>  fs/xfs/xfs_log.c                   | 7 ++++---
>  fs/xfs/xfs_log_cil.c               | 2 +-
>  fs/xfs/xfs_log_priv.h              | 2 +-
>  fs/xfs/xfs_refcount_item.c         | 4 ++--
>  fs/xfs/xfs_rmap_item.c             | 5 +++--
>  fs/xfs/xfs_trans.c                 | 4 ++--
>  fs/xfs/xfs_trans_dquot.c           | 3 ++-
>  23 files changed, 38 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 6143117770e9..c12ab170c396 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -83,12 +83,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
>  
>  extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
>  
> -static inline void *
> -kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
> -{
> -	return kmem_zone_alloc(zone, flags | KM_ZERO);
> -}
> -
>  static inline struct page *
>  kmem_to_page(void *addr)
>  {
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 279694d73e4e..0867c1fad11b 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -487,7 +487,7 @@ xfs_allocbt_init_cursor(
>  
>  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
>  
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b7cc2f9eae7b..9fbdca183465 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1104,7 +1104,8 @@ xfs_bmap_add_attrfork(
>  	if (error)
>  		goto trans_cancel;
>  	ASSERT(ip->i_afp == NULL);
> -	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
> +	ip->i_afp = kmem_cache_zalloc(xfs_ifork_zone,
> +				      GFP_KERNEL | __GFP_NOFAIL);
>  	ip->i_afp->if_flags = XFS_IFEXTENTS;
>  	logflags = 0;
>  	switch (ip->i_d.di_format) {
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index ffe608d2a2d9..77fe4ae671e5 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -552,7 +552,7 @@ xfs_bmbt_init_cursor(
>  	struct xfs_btree_cur	*cur;
>  	ASSERT(whichfork != XFS_COW_FORK);
>  
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index c5c0b73febae..4e0ec46aec78 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -81,7 +81,7 @@ kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
>  xfs_da_state_t *
>  xfs_da_state_alloc(void)
>  {
> -	return kmem_zone_zalloc(xfs_da_state_zone, KM_NOFS);
> +	return kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index b82992f795aa..5366a874b076 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -413,7 +413,7 @@ xfs_inobt_init_cursor(
>  	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index ad2b9c313fd2..2bffaa31d62a 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -98,7 +98,7 @@ xfs_iformat_fork(
>  		return 0;
>  
>  	ASSERT(ip->i_afp == NULL);
> -	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
> +	ip->i_afp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	switch (dip->di_aformat) {
>  	case XFS_DINODE_FMT_LOCAL:
> @@ -688,8 +688,8 @@ xfs_ifork_init_cow(
>  	if (ip->i_cowfp)
>  		return;
>  
> -	ip->i_cowfp = kmem_zone_zalloc(xfs_ifork_zone,
> -				       KM_NOFS);
> +	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_zone,
> +				       GFP_NOFS | __GFP_NOFAIL);
>  	ip->i_cowfp->if_flags = XFS_IFEXTENTS;
>  	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
>  	ip->i_cnextents = 0;
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 38529dbacd55..bb86988780ea 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -325,7 +325,7 @@ xfs_refcountbt_init_cursor(
>  
>  	ASSERT(agno != NULLAGNUMBER);
>  	ASSERT(agno < mp->m_sb.sb_agcount);
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index fc78efa52c94..8d84dd98e8d3 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -461,7 +461,7 @@ xfs_rmapbt_init_cursor(
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	/* Overlapping btree; 2 keys per pointer. */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ee6f4229cebc..451d6b925930 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -141,7 +141,7 @@ xfs_bui_init(
>  {
>  	struct xfs_bui_log_item		*buip;
>  
> -	buip = kmem_zone_zalloc(xfs_bui_zone, 0);
> +	buip = kmem_cache_zalloc(xfs_bui_zone, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
>  	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
> @@ -218,7 +218,7 @@ xfs_trans_get_bud(
>  {
>  	struct xfs_bud_log_item		*budp;
>  
> -	budp = kmem_zone_zalloc(xfs_bud_zone, 0);
> +	budp = kmem_cache_zalloc(xfs_bud_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
>  			  &xfs_bud_item_ops);
>  	budp->bud_buip = buip;
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a0229c368e78..85f9ef4f504e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -209,7 +209,7 @@ _xfs_buf_alloc(
>  	int			error;
>  	int			i;
>  
> -	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
> +	bp = kmem_cache_zalloc(xfs_buf_zone, GFP_NOFS | __GFP_NOFAIL);
>  	if (unlikely(!bp))
>  		return NULL;
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 3458a1264a3f..676149ac09a3 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -747,7 +747,7 @@ xfs_buf_item_init(
>  		return 0;
>  	}
>  
> -	bip = kmem_zone_zalloc(xfs_buf_item_zone, 0);
> +	bip = kmem_cache_zalloc(xfs_buf_item_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
>  	bip->bli_buf = bp;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 153815bf18fc..79f0de378123 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -440,7 +440,7 @@ xfs_dquot_alloc(
>  {
>  	struct xfs_dquot	*dqp;
>  
> -	dqp = kmem_zone_zalloc(xfs_qm_dqzone, 0);
> +	dqp = kmem_cache_zalloc(xfs_qm_dqzone, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	dqp->dq_flags = type;
>  	dqp->q_core.d_id = cpu_to_be32(id);
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6ea847f6e298..49ce6d6c4bb9 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -165,7 +165,8 @@ xfs_efi_init(
>  			((nextents - 1) * sizeof(xfs_extent_t)));
>  		efip = kmem_zalloc(size, 0);
>  	} else {
> -		efip = kmem_zone_zalloc(xfs_efi_zone, 0);
> +		efip = kmem_cache_zalloc(xfs_efi_zone,
> +					 GFP_KERNEL | __GFP_NOFAIL);
>  	}
>  
>  	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
> @@ -336,7 +337,8 @@ xfs_trans_get_efd(
>  				(nextents - 1) * sizeof(struct xfs_extent),
>  				0);
>  	} else {
> -		efdp = kmem_zone_zalloc(xfs_efd_zone, 0);
> +		efdp = kmem_cache_zalloc(xfs_efd_zone,
> +					 GFP_KERNEL | __GFP_NOFAIL);
>  	}
>  
>  	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 490fee22b878..85bbf9dbe095 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -89,7 +89,7 @@ xfs_icreate_log(
>  {
>  	struct xfs_icreate_item	*icp;
>  
> -	icp = kmem_zone_zalloc(xfs_icreate_zone, 0);
> +	icp = kmem_cache_zalloc(xfs_icreate_zone, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	xfs_log_item_init(tp->t_mountp, &icp->ic_item, XFS_LI_ICREATE,
>  			  &xfs_icreate_item_ops);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 3a62976291a1..2097e6932a48 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -652,7 +652,8 @@ xfs_inode_item_init(
>  	struct xfs_inode_log_item *iip;
>  
>  	ASSERT(ip->i_itemp == NULL);
> -	iip = ip->i_itemp = kmem_zone_zalloc(xfs_ili_zone, 0);
> +	iip = ip->i_itemp = kmem_cache_zalloc(xfs_ili_zone,
> +					      GFP_KERNEL | __GFP_NOFAIL);
>  
>  	iip->ili_inode = ip;
>  	xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE,
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6a147c63a8a6..30447bd477d2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -454,7 +454,8 @@ xfs_log_reserve(
>  	XFS_STATS_INC(mp, xs_try_logspace);
>  
>  	ASSERT(*ticp == NULL);
> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
> +				GFP_KERNEL | __GFP_NOFAIL);
>  	*ticp = tic;
>  
>  	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> @@ -3587,12 +3588,12 @@ xlog_ticket_alloc(
>  	int			cnt,
>  	char			client,
>  	bool			permanent,
> -	xfs_km_flags_t		alloc_flags)
> +	gfp_t			alloc_flags)
>  {
>  	struct xlog_ticket	*tic;
>  	int			unit_res;
>  
> -	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
> +	tic = kmem_cache_zalloc(xfs_log_ticket_zone, alloc_flags);
>  	if (!tic)
>  		return NULL;
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 48435cf2aa16..630c2482c8f1 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -38,7 +38,7 @@ xlog_cil_ticket_alloc(
>  	struct xlog_ticket *tic;
>  
>  	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
> -				KM_NOFS);
> +				GFP_NOFS | __GFP_NOFAIL);
>  
>  	/*
>  	 * set the current reservation to zero so we know to steal the basic
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index c47aa2ca6dc7..54c95fee9dc4 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -427,7 +427,7 @@ xlog_ticket_alloc(
>  	int		count,
>  	char		client,
>  	bool		permanent,
> -	xfs_km_flags_t	alloc_flags);
> +	gfp_t		alloc_flags);
>  
>  
>  static inline void
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 8eeed73928cd..a242bc9874a6 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -146,7 +146,7 @@ xfs_cui_init(
>  		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
>  				0);
>  	else
> -		cuip = kmem_zone_zalloc(xfs_cui_zone, 0);
> +		cuip = kmem_cache_zalloc(xfs_cui_zone, GFP_KERNEL | __GFP_NOFAIL);

Long line.  I'll just fix it if nobody else posts any objections...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
>  	cuip->cui_format.cui_nextents = nextents;
> @@ -223,7 +223,7 @@ xfs_trans_get_cud(
>  {
>  	struct xfs_cud_log_item		*cudp;
>  
> -	cudp = kmem_zone_zalloc(xfs_cud_zone, 0);
> +	cudp = kmem_cache_zalloc(xfs_cud_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
>  			  &xfs_cud_item_ops);
>  	cudp->cud_cuip = cuip;
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 4911b68f95dd..857cc78dc440 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -144,7 +144,8 @@ xfs_rui_init(
>  	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
>  		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
>  	else
> -		ruip = kmem_zone_zalloc(xfs_rui_zone, 0);
> +		ruip = kmem_cache_zalloc(xfs_rui_zone,
> +					 GFP_KERNEL | __GFP_NOFAIL);
>  
>  	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
>  	ruip->rui_format.rui_nextents = nextents;
> @@ -246,7 +247,7 @@ xfs_trans_get_rud(
>  {
>  	struct xfs_rud_log_item		*rudp;
>  
> -	rudp = kmem_zone_zalloc(xfs_rud_zone, 0);
> +	rudp = kmem_cache_zalloc(xfs_rud_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
>  			  &xfs_rud_item_ops);
>  	rudp->rud_ruip = ruip;
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3b208f9a865c..29f34492d5f4 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -90,7 +90,7 @@ xfs_trans_dup(
>  
>  	trace_xfs_trans_dup(tp, _RET_IP_);
>  
> -	ntp = kmem_zone_zalloc(xfs_trans_zone, 0);
> +	ntp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	/*
>  	 * Initialize the new transaction structure.
> @@ -263,7 +263,7 @@ xfs_trans_alloc(
>  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
>  	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
>  	 */
> -	tp = kmem_zone_zalloc(xfs_trans_zone, 0);
> +	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_start_intwrite(mp->m_super);
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index ff1c326826d3..69e8f6d049aa 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -863,7 +863,8 @@ STATIC void
>  xfs_trans_alloc_dqinfo(
>  	xfs_trans_t	*tp)
>  {
> -	tp->t_dqinfo = kmem_zone_zalloc(xfs_qm_dqtrxzone, 0);
> +	tp->t_dqinfo = kmem_cache_zalloc(xfs_qm_dqtrxzone,
> +					 GFP_KERNEL | __GFP_NOFAIL);
>  }
>  
>  void
> -- 
> 2.23.0
> 
