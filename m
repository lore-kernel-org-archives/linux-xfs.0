Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1461C43141
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C758920409
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GPZlsNNt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfKMRIZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 12:08:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33376 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfKMRIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 12:08:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADGxHKU018156;
        Wed, 13 Nov 2019 17:08:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HDgJzb5KuS/Yb6QTKQsNnIwxFXBPTHhfuGgmD2iScuw=;
 b=GPZlsNNtD1AxtqKiMoa/j/E7JgxaabF3MDLpsKyE0PCb0cWmOA0v2netIV2X42129cXw
 +ovvU0TDOYrb+B6XfgYNAUg+nye/Kz8S/fjn7f80zFXFW196LSS8cxZvZy9vKtv56tDO
 aJICmt/tLjet/r7vrOIfvJl2zgcZMTLchIpKJFsGCAzKOiwSqXjlLjYpEXyLcr9onJd1
 aYESKkt/RkkLz8jDIh69F8YBn0mCoAVP+ty70jQKYxtmD2dAIWlGudRrO0AXcgZjbEez
 qWbwpvXiPrGL36oyvra/vxCXFasobHP9D63Xnxbsm627g0dc2nMoN0IMBKhNE1IhEnhA FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5p3qwtyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:08:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADGxcTc070379;
        Wed, 13 Nov 2019 17:06:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w8g17ucr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:06:21 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xADH6KCC005127;
        Wed, 13 Nov 2019 17:06:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 09:06:19 -0800
Date:   Wed, 13 Nov 2019 09:06:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: Remove slab init wrappers
Message-ID: <20191113170618.GX6219@magnolia>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113142335.1045631-2-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 03:23:25PM +0100, Carlos Maiolino wrote:
> Remove kmem_zone_init() and kmem_zone_init_flags() together with their
> specific KM_* to SLAB_* flag wrappers.
> 
> Use kmem_cache_create() directly.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/kmem.h      | 18 ---------
>  fs/xfs/xfs_buf.c   |  5 ++-
>  fs/xfs/xfs_dquot.c | 10 +++--
>  fs/xfs/xfs_super.c | 99 +++++++++++++++++++++++++++-------------------
>  4 files changed, 68 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 8170d95cf930..15c5800128b3 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -78,27 +78,9 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
>   * Zone interfaces
>   */
>  
> -#define KM_ZONE_HWALIGN	SLAB_HWCACHE_ALIGN
> -#define KM_ZONE_RECLAIM	SLAB_RECLAIM_ACCOUNT
> -#define KM_ZONE_SPREAD	SLAB_MEM_SPREAD
> -#define KM_ZONE_ACCOUNT	SLAB_ACCOUNT
> -
>  #define kmem_zone	kmem_cache
>  #define kmem_zone_t	struct kmem_cache
>  
> -static inline kmem_zone_t *
> -kmem_zone_init(int size, char *zone_name)
> -{
> -	return kmem_cache_create(zone_name, size, 0, 0, NULL);
> -}
> -
> -static inline kmem_zone_t *
> -kmem_zone_init_flags(int size, char *zone_name, slab_flags_t flags,
> -		     void (*construct)(void *))
> -{
> -	return kmem_cache_create(zone_name, size, 0, flags, construct);
> -}
> -
>  static inline void
>  kmem_zone_free(kmem_zone_t *zone, void *ptr)
>  {
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 2ed3c65c602f..3741f5b369de 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2060,8 +2060,9 @@ xfs_buf_delwri_pushbuf(
>  int __init
>  xfs_buf_init(void)
>  {
> -	xfs_buf_zone = kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
> -						KM_ZONE_HWALIGN, NULL);
> +	xfs_buf_zone = kmem_cache_create("xfs_buf",
> +					 sizeof(struct xfs_buf), 0,
> +					 SLAB_HWCACHE_ALIGN, NULL);
>  	if (!xfs_buf_zone)
>  		goto out;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index bcd4247b5014..90dd1623de5a 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1211,13 +1211,15 @@ xfs_dqlock2(
>  int __init
>  xfs_qm_init(void)
>  {
> -	xfs_qm_dqzone =
> -		kmem_zone_init(sizeof(struct xfs_dquot), "xfs_dquot");
> +	xfs_qm_dqzone = kmem_cache_create("xfs_dquot",
> +					  sizeof(struct xfs_dquot),
> +					  0, 0, NULL);
>  	if (!xfs_qm_dqzone)
>  		goto out;
>  
> -	xfs_qm_dqtrxzone =
> -		kmem_zone_init(sizeof(struct xfs_dquot_acct), "xfs_dqtrx");
> +	xfs_qm_dqtrxzone = kmem_cache_create("xfs_dqtrx",
> +					     sizeof(struct xfs_dquot_acct),
> +					     0, 0, NULL);
>  	if (!xfs_qm_dqtrxzone)
>  		goto out_free_dqzone;
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7f1fc76376f5..d3c3f7b5bdcf 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1797,32 +1797,39 @@ MODULE_ALIAS_FS("xfs");
>  STATIC int __init
>  xfs_init_zones(void)
>  {
> -	xfs_log_ticket_zone = kmem_zone_init(sizeof(xlog_ticket_t),
> -						"xfs_log_ticket");
> +	xfs_log_ticket_zone = kmem_cache_create("xfs_log_ticket",
> +						sizeof(struct xlog_ticket),
> +						0, 0, NULL);
>  	if (!xfs_log_ticket_zone)
>  		goto out;
>  
> -	xfs_bmap_free_item_zone = kmem_zone_init(
> -			sizeof(struct xfs_extent_free_item),
> -			"xfs_bmap_free_item");
> +	xfs_bmap_free_item_zone = kmem_cache_create("xfs_bmap_free_item",
> +					sizeof(struct xfs_extent_free_item),
> +					0, 0, NULL);
>  	if (!xfs_bmap_free_item_zone)
>  		goto out_destroy_log_ticket_zone;
>  
> -	xfs_btree_cur_zone = kmem_zone_init(sizeof(xfs_btree_cur_t),
> -						"xfs_btree_cur");
> +	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
> +					       sizeof(struct xfs_btree_cur),
> +					       0, 0, NULL);
>  	if (!xfs_btree_cur_zone)
>  		goto out_destroy_bmap_free_item_zone;
>  
> -	xfs_da_state_zone = kmem_zone_init(sizeof(xfs_da_state_t),
> -						"xfs_da_state");
> +	xfs_da_state_zone = kmem_cache_create("xfs_da_state",
> +					      sizeof(struct xfs_da_state),
> +					      0, 0, NULL);
>  	if (!xfs_da_state_zone)
>  		goto out_destroy_btree_cur_zone;
>  
> -	xfs_ifork_zone = kmem_zone_init(sizeof(struct xfs_ifork), "xfs_ifork");
> +	xfs_ifork_zone = kmem_cache_create("xfs_ifork",
> +					   sizeof(struct xfs_ifork),
> +					   0, 0, NULL);
>  	if (!xfs_ifork_zone)
>  		goto out_destroy_da_state_zone;
>  
> -	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
> +	xfs_trans_zone = kmem_cache_create("xf_trans",
> +					   sizeof(struct xfs_trans),
> +					   0, 0, NULL);
>  	if (!xfs_trans_zone)
>  		goto out_destroy_ifork_zone;
>  
> @@ -1832,70 +1839,82 @@ xfs_init_zones(void)
>  	 * size possible under XFS.  This wastes a little bit of memory,
>  	 * but it is much faster.
>  	 */
> -	xfs_buf_item_zone = kmem_zone_init(sizeof(struct xfs_buf_log_item),
> -					   "xfs_buf_item");
> +	xfs_buf_item_zone = kmem_cache_create("xfs_buf_item",
> +					      sizeof(struct xfs_buf_log_item),
> +					      0, 0, NULL);
>  	if (!xfs_buf_item_zone)
>  		goto out_destroy_trans_zone;
>  
> -	xfs_efd_zone = kmem_zone_init((sizeof(xfs_efd_log_item_t) +
> -			((XFS_EFD_MAX_FAST_EXTENTS - 1) *
> -				 sizeof(xfs_extent_t))), "xfs_efd_item");
> +	xfs_efd_zone = kmem_cache_create("xfs_efd_item",
> +					(sizeof(struct xfs_efd_log_item) +
> +					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
> +					sizeof(struct xfs_extent)),
> +					0, 0, NULL);
>  	if (!xfs_efd_zone)
>  		goto out_destroy_buf_item_zone;
>  
> -	xfs_efi_zone = kmem_zone_init((sizeof(xfs_efi_log_item_t) +
> -			((XFS_EFI_MAX_FAST_EXTENTS - 1) *
> -				sizeof(xfs_extent_t))), "xfs_efi_item");
> +	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
> +					 (sizeof(struct xfs_efi_log_item) +
> +					 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
> +					 sizeof(struct xfs_extent)),
> +					 0, 0, NULL);
>  	if (!xfs_efi_zone)
>  		goto out_destroy_efd_zone;
>  
> -	xfs_inode_zone =
> -		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
> -			KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD |
> -			KM_ZONE_ACCOUNT, xfs_fs_inode_init_once);
> +	xfs_inode_zone = kmem_cache_create("xfs_inode",
> +					   sizeof(struct xfs_inode), 0,
> +					   (SLAB_HWCACHE_ALIGN |
> +					    SLAB_RECLAIM_ACCOUNT |
> +					    SLAB_MEM_SPREAD | SLAB_ACCOUNT),
> +					   xfs_fs_inode_init_once);
>  	if (!xfs_inode_zone)
>  		goto out_destroy_efi_zone;
>  
> -	xfs_ili_zone =
> -		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
> -					KM_ZONE_SPREAD, NULL);
> +	xfs_ili_zone = kmem_cache_create("xfs_ili",
> +					 sizeof(struct xfs_inode_log_item), 0,
> +					 SLAB_MEM_SPREAD, NULL);
>  	if (!xfs_ili_zone)
>  		goto out_destroy_inode_zone;
> -	xfs_icreate_zone = kmem_zone_init(sizeof(struct xfs_icreate_item),
> -					"xfs_icr");
> +
> +	xfs_icreate_zone = kmem_cache_create("xfs_icr",
> +					     sizeof(struct xfs_icreate_item),
> +					     0, 0, NULL);
>  	if (!xfs_icreate_zone)
>  		goto out_destroy_ili_zone;
>  
> -	xfs_rud_zone = kmem_zone_init(sizeof(struct xfs_rud_log_item),
> -			"xfs_rud_item");
> +	xfs_rud_zone = kmem_cache_create("xfs_rud_item",
> +					 sizeof(struct xfs_rud_log_item),
> +					 0, 0, NULL);
>  	if (!xfs_rud_zone)
>  		goto out_destroy_icreate_zone;
>  
> -	xfs_rui_zone = kmem_zone_init(
> +	xfs_rui_zone = kmem_cache_create("xfs_rui_item",
>  			xfs_rui_log_item_sizeof(XFS_RUI_MAX_FAST_EXTENTS),
> -			"xfs_rui_item");
> +			0, 0, NULL);
>  	if (!xfs_rui_zone)
>  		goto out_destroy_rud_zone;
>  
> -	xfs_cud_zone = kmem_zone_init(sizeof(struct xfs_cud_log_item),
> -			"xfs_cud_item");
> +	xfs_cud_zone = kmem_cache_create("xfs_cud_item",
> +					 sizeof(struct xfs_cud_log_item),
> +					 0, 0, NULL);
>  	if (!xfs_cud_zone)
>  		goto out_destroy_rui_zone;
>  
> -	xfs_cui_zone = kmem_zone_init(
> +	xfs_cui_zone = kmem_cache_create("xfs_cui_item",
>  			xfs_cui_log_item_sizeof(XFS_CUI_MAX_FAST_EXTENTS),
> -			"xfs_cui_item");
> +			0, 0, NULL);
>  	if (!xfs_cui_zone)
>  		goto out_destroy_cud_zone;
>  
> -	xfs_bud_zone = kmem_zone_init(sizeof(struct xfs_bud_log_item),
> -			"xfs_bud_item");
> +	xfs_bud_zone = kmem_cache_create("xfs_bud_item",
> +					 sizeof(struct xfs_bud_log_item),
> +					 0, 0, NULL);
>  	if (!xfs_bud_zone)
>  		goto out_destroy_cui_zone;
>  
> -	xfs_bui_zone = kmem_zone_init(
> +	xfs_bui_zone = kmem_cache_create("xfs_bui_item",
>  			xfs_bui_log_item_sizeof(XFS_BUI_MAX_FAST_EXTENTS),
> -			"xfs_bui_item");
> +			0, 0, NULL);
>  	if (!xfs_bui_zone)
>  		goto out_destroy_bud_zone;
>  
> -- 
> 2.23.0
> 
