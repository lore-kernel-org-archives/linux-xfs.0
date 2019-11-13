Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBEE9C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFAC220409
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:06:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aVcmoSr7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfKMRGu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 12:06:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59652 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfKMRGu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 12:06:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADGxLud018188;
        Wed, 13 Nov 2019 17:06:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=PRHChTIeNADtopZmumY3qPvenQHJrXcEtahIo9C6uwg=;
 b=aVcmoSr7MUnaKH9kObEvYlLNFMn2nrPpWCulAfh5jP0oYMFu7SxGwnDYRME9p2ChlaII
 CFDahkjV2li0TPcpMOzYf2c0EOUf2TK9Q2IAZnGk71T4h7j5aNRCWu+lXFy8KiqhdV5a
 ooXEdORKYDBVkI0RSHcSqRO9ID1RyjnMifESEkza8I2sQUOZrNoOTr5Hq+E+YJq5auk9
 Z1RdM1Ur4wgzvg0nQaodDjot1oLkuuajVVbCvz/mAjMA88sbop0YfF1EOCUgpuiJVkMO
 SJcvBg3ld/76BHj11oozB3AKGs9zOSQijzOFM54yrGLHqbT6r7sjjH+ncaLGyD5aVaYf Cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w5p3qwtkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:06:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADGxZ6q104100;
        Wed, 13 Nov 2019 17:06:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w7vppkvp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:06:45 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xADH6jLT005369;
        Wed, 13 Nov 2019 17:06:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 09:06:45 -0800
Date:   Wed, 13 Nov 2019 09:06:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: Remove kmem_zone_destroy() wrapper
Message-ID: <20191113170643.GY6219@magnolia>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113142335.1045631-3-cmaiolino@redhat.com>
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

On Wed, Nov 13, 2019 at 03:23:26PM +0100, Carlos Maiolino wrote:
> Use kmem_cache_destroy directly
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/kmem.h      |  6 ----
>  fs/xfs/xfs_buf.c   |  2 +-
>  fs/xfs/xfs_dquot.c |  6 ++--
>  fs/xfs/xfs_super.c | 70 +++++++++++++++++++++++-----------------------
>  4 files changed, 39 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 15c5800128b3..70ed74c7f37e 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -87,12 +87,6 @@ kmem_zone_free(kmem_zone_t *zone, void *ptr)
>  	kmem_cache_free(zone, ptr);
>  }
>  
> -static inline void
> -kmem_zone_destroy(kmem_zone_t *zone)
> -{
> -	kmem_cache_destroy(zone);
> -}
> -
>  extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
>  
>  static inline void *
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 3741f5b369de..ccccfb792ff8 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2075,7 +2075,7 @@ xfs_buf_init(void)
>  void
>  xfs_buf_terminate(void)
>  {
> -	kmem_zone_destroy(xfs_buf_zone);
> +	kmem_cache_destroy(xfs_buf_zone);
>  }
>  
>  void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 90dd1623de5a..4f969d94fb74 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1226,7 +1226,7 @@ xfs_qm_init(void)
>  	return 0;
>  
>  out_free_dqzone:
> -	kmem_zone_destroy(xfs_qm_dqzone);
> +	kmem_cache_destroy(xfs_qm_dqzone);
>  out:
>  	return -ENOMEM;
>  }
> @@ -1234,8 +1234,8 @@ xfs_qm_init(void)
>  void
>  xfs_qm_exit(void)
>  {
> -	kmem_zone_destroy(xfs_qm_dqtrxzone);
> -	kmem_zone_destroy(xfs_qm_dqzone);
> +	kmem_cache_destroy(xfs_qm_dqtrxzone);
> +	kmem_cache_destroy(xfs_qm_dqzone);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d3c3f7b5bdcf..d9ae27ddf253 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1921,39 +1921,39 @@ xfs_init_zones(void)
>  	return 0;
>  
>   out_destroy_bud_zone:
> -	kmem_zone_destroy(xfs_bud_zone);
> +	kmem_cache_destroy(xfs_bud_zone);
>   out_destroy_cui_zone:
> -	kmem_zone_destroy(xfs_cui_zone);
> +	kmem_cache_destroy(xfs_cui_zone);
>   out_destroy_cud_zone:
> -	kmem_zone_destroy(xfs_cud_zone);
> +	kmem_cache_destroy(xfs_cud_zone);
>   out_destroy_rui_zone:
> -	kmem_zone_destroy(xfs_rui_zone);
> +	kmem_cache_destroy(xfs_rui_zone);
>   out_destroy_rud_zone:
> -	kmem_zone_destroy(xfs_rud_zone);
> +	kmem_cache_destroy(xfs_rud_zone);
>   out_destroy_icreate_zone:
> -	kmem_zone_destroy(xfs_icreate_zone);
> +	kmem_cache_destroy(xfs_icreate_zone);
>   out_destroy_ili_zone:
> -	kmem_zone_destroy(xfs_ili_zone);
> +	kmem_cache_destroy(xfs_ili_zone);
>   out_destroy_inode_zone:
> -	kmem_zone_destroy(xfs_inode_zone);
> +	kmem_cache_destroy(xfs_inode_zone);
>   out_destroy_efi_zone:
> -	kmem_zone_destroy(xfs_efi_zone);
> +	kmem_cache_destroy(xfs_efi_zone);
>   out_destroy_efd_zone:
> -	kmem_zone_destroy(xfs_efd_zone);
> +	kmem_cache_destroy(xfs_efd_zone);
>   out_destroy_buf_item_zone:
> -	kmem_zone_destroy(xfs_buf_item_zone);
> +	kmem_cache_destroy(xfs_buf_item_zone);
>   out_destroy_trans_zone:
> -	kmem_zone_destroy(xfs_trans_zone);
> +	kmem_cache_destroy(xfs_trans_zone);
>   out_destroy_ifork_zone:
> -	kmem_zone_destroy(xfs_ifork_zone);
> +	kmem_cache_destroy(xfs_ifork_zone);
>   out_destroy_da_state_zone:
> -	kmem_zone_destroy(xfs_da_state_zone);
> +	kmem_cache_destroy(xfs_da_state_zone);
>   out_destroy_btree_cur_zone:
> -	kmem_zone_destroy(xfs_btree_cur_zone);
> +	kmem_cache_destroy(xfs_btree_cur_zone);
>   out_destroy_bmap_free_item_zone:
> -	kmem_zone_destroy(xfs_bmap_free_item_zone);
> +	kmem_cache_destroy(xfs_bmap_free_item_zone);
>   out_destroy_log_ticket_zone:
> -	kmem_zone_destroy(xfs_log_ticket_zone);
> +	kmem_cache_destroy(xfs_log_ticket_zone);
>   out:
>  	return -ENOMEM;
>  }
> @@ -1966,24 +1966,24 @@ xfs_destroy_zones(void)
>  	 * destroy caches.
>  	 */
>  	rcu_barrier();
> -	kmem_zone_destroy(xfs_bui_zone);
> -	kmem_zone_destroy(xfs_bud_zone);
> -	kmem_zone_destroy(xfs_cui_zone);
> -	kmem_zone_destroy(xfs_cud_zone);
> -	kmem_zone_destroy(xfs_rui_zone);
> -	kmem_zone_destroy(xfs_rud_zone);
> -	kmem_zone_destroy(xfs_icreate_zone);
> -	kmem_zone_destroy(xfs_ili_zone);
> -	kmem_zone_destroy(xfs_inode_zone);
> -	kmem_zone_destroy(xfs_efi_zone);
> -	kmem_zone_destroy(xfs_efd_zone);
> -	kmem_zone_destroy(xfs_buf_item_zone);
> -	kmem_zone_destroy(xfs_trans_zone);
> -	kmem_zone_destroy(xfs_ifork_zone);
> -	kmem_zone_destroy(xfs_da_state_zone);
> -	kmem_zone_destroy(xfs_btree_cur_zone);
> -	kmem_zone_destroy(xfs_bmap_free_item_zone);
> -	kmem_zone_destroy(xfs_log_ticket_zone);
> +	kmem_cache_destroy(xfs_bui_zone);
> +	kmem_cache_destroy(xfs_bud_zone);
> +	kmem_cache_destroy(xfs_cui_zone);
> +	kmem_cache_destroy(xfs_cud_zone);
> +	kmem_cache_destroy(xfs_rui_zone);
> +	kmem_cache_destroy(xfs_rud_zone);
> +	kmem_cache_destroy(xfs_icreate_zone);
> +	kmem_cache_destroy(xfs_ili_zone);
> +	kmem_cache_destroy(xfs_inode_zone);
> +	kmem_cache_destroy(xfs_efi_zone);
> +	kmem_cache_destroy(xfs_efd_zone);
> +	kmem_cache_destroy(xfs_buf_item_zone);
> +	kmem_cache_destroy(xfs_trans_zone);
> +	kmem_cache_destroy(xfs_ifork_zone);
> +	kmem_cache_destroy(xfs_da_state_zone);
> +	kmem_cache_destroy(xfs_btree_cur_zone);
> +	kmem_cache_destroy(xfs_bmap_free_item_zone);
> +	kmem_cache_destroy(xfs_log_ticket_zone);
>  }
>  
>  STATIC int __init
> -- 
> 2.23.0
> 
