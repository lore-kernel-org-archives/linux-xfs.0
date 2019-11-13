Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A1AC43141
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A3FD20409
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 17:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZPUmQRPW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKMRIU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 12:08:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48986 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfKMRIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 12:08:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADGxJb0048086;
        Wed, 13 Nov 2019 17:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=GlFZmVACGTmeINm4H3oNclM+P39uP5ZiIKEiTyXZRCc=;
 b=ZPUmQRPWpwN7+7h6/rKTVkrcrNeL3N2L9dvwjMQG/Fxys1cM9OCFKQDdVqu90HlW0pVU
 0T9d1QqJiJHoH7ivToZydIM5GF3TQ95J4Vrgh4eEFVaxaThafSForIfpZH7EKspHnUMD
 uNFWD3a3h14AdACrwLKuMx7A1KGKCzn0E/wJwrT1w8UWt8FzLIDX1GvSPWXClPS8pInR
 m1JYVgoX3g2Ar1UV1IMISBNLjGcqF7iDCcGztJr4YhMwPB84sEGOgGuHHWzR6tnoq98R
 yizpC6ZSzfybIarG2Q7drJI8FvYxoqiTDSM/3pSmrf7nHHSXIHV4cKYv3LkN63pfX8R2 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvtwyae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:08:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADGxW5P172480;
        Wed, 13 Nov 2019 17:08:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w8ng3m10d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:08:15 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xADH8FWW018749;
        Wed, 13 Nov 2019 17:08:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 09:08:15 -0800
Date:   Wed, 13 Nov 2019 09:08:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: Remove kmem_zone_free() wrapper
Message-ID: <20191113170810.GZ6219@magnolia>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113142335.1045631-4-cmaiolino@redhat.com>
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

On Wed, Nov 13, 2019 at 03:23:27PM +0100, Carlos Maiolino wrote:
> We can remove it now, without needing to rework the KM_ flags.
> 
> Use kmem_cache_free() directly.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/kmem.h                  | 6 ------
>  fs/xfs/libxfs/xfs_btree.c      | 2 +-
>  fs/xfs/libxfs/xfs_da_btree.c   | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c | 8 ++++----
>  fs/xfs/xfs_bmap_item.c         | 4 ++--
>  fs/xfs/xfs_buf.c               | 6 +++---
>  fs/xfs/xfs_buf_item.c          | 4 ++--
>  fs/xfs/xfs_dquot.c             | 2 +-
>  fs/xfs/xfs_extfree_item.c      | 4 ++--
>  fs/xfs/xfs_icache.c            | 4 ++--
>  fs/xfs/xfs_icreate_item.c      | 2 +-
>  fs/xfs/xfs_inode_item.c        | 2 +-
>  fs/xfs/xfs_log.c               | 2 +-
>  fs/xfs/xfs_refcount_item.c     | 4 ++--
>  fs/xfs/xfs_rmap_item.c         | 4 ++--
>  fs/xfs/xfs_trans.c             | 2 +-
>  fs/xfs/xfs_trans_dquot.c       | 2 +-
>  17 files changed, 27 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 70ed74c7f37e..6143117770e9 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -81,12 +81,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
>  #define kmem_zone	kmem_cache
>  #define kmem_zone_t	struct kmem_cache
>  
> -static inline void
> -kmem_zone_free(kmem_zone_t *zone, void *ptr)
> -{
> -	kmem_cache_free(zone, ptr);
> -}
> -
>  extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
>  
>  static inline void *
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 98843f1258b8..ac0b78ea417b 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -384,7 +384,7 @@ xfs_btree_del_cursor(
>  	/*
>  	 * Free the cursor.
>  	 */
> -	kmem_zone_free(xfs_btree_cur_zone, cur);
> +	kmem_cache_free(xfs_btree_cur_zone, cur);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 46b1c3fb305c..c5c0b73febae 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -107,7 +107,7 @@ xfs_da_state_free(xfs_da_state_t *state)
>  #ifdef DEBUG
>  	memset((char *)state, 0, sizeof(*state));
>  #endif /* DEBUG */
> -	kmem_zone_free(xfs_da_state_zone, state);
> +	kmem_cache_free(xfs_da_state_zone, state);
>  }
>  
>  void
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 15d6f947620f..ad2b9c313fd2 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -120,10 +120,10 @@ xfs_iformat_fork(
>  		break;
>  	}
>  	if (error) {
> -		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
> +		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
>  		ip->i_afp = NULL;
>  		if (ip->i_cowfp)
> -			kmem_zone_free(xfs_ifork_zone, ip->i_cowfp);
> +			kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
>  		ip->i_cowfp = NULL;
>  		xfs_idestroy_fork(ip, XFS_DATA_FORK);
>  	}
> @@ -531,10 +531,10 @@ xfs_idestroy_fork(
>  	}
>  
>  	if (whichfork == XFS_ATTR_FORK) {
> -		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
> +		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
>  		ip->i_afp = NULL;
>  	} else if (whichfork == XFS_COW_FORK) {
> -		kmem_zone_free(xfs_ifork_zone, ip->i_cowfp);
> +		kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
>  		ip->i_cowfp = NULL;
>  	}
>  }
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 243e5e0f82a3..ee6f4229cebc 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -35,7 +35,7 @@ void
>  xfs_bui_item_free(
>  	struct xfs_bui_log_item	*buip)
>  {
> -	kmem_zone_free(xfs_bui_zone, buip);
> +	kmem_cache_free(xfs_bui_zone, buip);
>  }
>  
>  /*
> @@ -201,7 +201,7 @@ xfs_bud_item_release(
>  	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
>  
>  	xfs_bui_release(budp->bud_buip);
> -	kmem_zone_free(xfs_bud_zone, budp);
> +	kmem_cache_free(xfs_bud_zone, budp);
>  }
>  
>  static const struct xfs_item_ops xfs_bud_item_ops = {
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ccccfb792ff8..a0229c368e78 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -238,7 +238,7 @@ _xfs_buf_alloc(
>  	 */
>  	error = xfs_buf_get_maps(bp, nmaps);
>  	if (error)  {
> -		kmem_zone_free(xfs_buf_zone, bp);
> +		kmem_cache_free(xfs_buf_zone, bp);
>  		return NULL;
>  	}
>  
> @@ -328,7 +328,7 @@ xfs_buf_free(
>  		kmem_free(bp->b_addr);
>  	_xfs_buf_free_pages(bp);
>  	xfs_buf_free_maps(bp);
> -	kmem_zone_free(xfs_buf_zone, bp);
> +	kmem_cache_free(xfs_buf_zone, bp);
>  }
>  
>  /*
> @@ -949,7 +949,7 @@ xfs_buf_get_uncached(
>  	_xfs_buf_free_pages(bp);
>   fail_free_buf:
>  	xfs_buf_free_maps(bp);
> -	kmem_zone_free(xfs_buf_zone, bp);
> +	kmem_cache_free(xfs_buf_zone, bp);
>   fail:
>  	return NULL;
>  }
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 6b69e6137b2b..3458a1264a3f 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -763,7 +763,7 @@ xfs_buf_item_init(
>  	error = xfs_buf_item_get_format(bip, bp->b_map_count);
>  	ASSERT(error == 0);
>  	if (error) {	/* to stop gcc throwing set-but-unused warnings */
> -		kmem_zone_free(xfs_buf_item_zone, bip);
> +		kmem_cache_free(xfs_buf_item_zone, bip);
>  		return error;
>  	}
>  
> @@ -939,7 +939,7 @@ xfs_buf_item_free(
>  {
>  	xfs_buf_item_free_format(bip);
>  	kmem_free(bip->bli_item.li_lv_shadow);
> -	kmem_zone_free(xfs_buf_item_zone, bip);
> +	kmem_cache_free(xfs_buf_item_zone, bip);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 4f969d94fb74..153815bf18fc 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -56,7 +56,7 @@ xfs_qm_dqdestroy(
>  	mutex_destroy(&dqp->q_qlock);
>  
>  	XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot);
> -	kmem_zone_free(xfs_qm_dqzone, dqp);
> +	kmem_cache_free(xfs_qm_dqzone, dqp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index a05a1074e8f8..6ea847f6e298 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -39,7 +39,7 @@ xfs_efi_item_free(
>  	if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
>  		kmem_free(efip);
>  	else
> -		kmem_zone_free(xfs_efi_zone, efip);
> +		kmem_cache_free(xfs_efi_zone, efip);
>  }
>  
>  /*
> @@ -244,7 +244,7 @@ xfs_efd_item_free(struct xfs_efd_log_item *efdp)
>  	if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
>  		kmem_free(efdp);
>  	else
> -		kmem_zone_free(xfs_efd_zone, efdp);
> +		kmem_cache_free(xfs_efd_zone, efdp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 944add5ff8e0..950e8a51ec66 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -44,7 +44,7 @@ xfs_inode_alloc(
>  	if (!ip)
>  		return NULL;
>  	if (inode_init_always(mp->m_super, VFS_I(ip))) {
> -		kmem_zone_free(xfs_inode_zone, ip);
> +		kmem_cache_free(xfs_inode_zone, ip);
>  		return NULL;
>  	}
>  
> @@ -104,7 +104,7 @@ xfs_inode_free_callback(
>  		ip->i_itemp = NULL;
>  	}
>  
> -	kmem_zone_free(xfs_inode_zone, ip);
> +	kmem_cache_free(xfs_inode_zone, ip);
>  }
>  
>  static void
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 3ebd1b7f49d8..490fee22b878 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -55,7 +55,7 @@ STATIC void
>  xfs_icreate_item_release(
>  	struct xfs_log_item	*lip)
>  {
> -	kmem_zone_free(xfs_icreate_zone, ICR_ITEM(lip));
> +	kmem_cache_free(xfs_icreate_zone, ICR_ITEM(lip));
>  }
>  
>  static const struct xfs_item_ops xfs_icreate_item_ops = {
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 726aa3bfd6e8..3a62976291a1 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -667,7 +667,7 @@ xfs_inode_item_destroy(
>  	xfs_inode_t	*ip)
>  {
>  	kmem_free(ip->i_itemp->ili_item.li_lv_shadow);
> -	kmem_zone_free(xfs_ili_zone, ip->i_itemp);
> +	kmem_cache_free(xfs_ili_zone, ip->i_itemp);
>  }
>  
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 3806674090ed..6a147c63a8a6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3468,7 +3468,7 @@ xfs_log_ticket_put(
>  {
>  	ASSERT(atomic_read(&ticket->t_ref) > 0);
>  	if (atomic_dec_and_test(&ticket->t_ref))
> -		kmem_zone_free(xfs_log_ticket_zone, ticket);
> +		kmem_cache_free(xfs_log_ticket_zone, ticket);
>  }
>  
>  xlog_ticket_t *
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index d5708d40ad87..8eeed73928cd 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -34,7 +34,7 @@ xfs_cui_item_free(
>  	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
>  		kmem_free(cuip);
>  	else
> -		kmem_zone_free(xfs_cui_zone, cuip);
> +		kmem_cache_free(xfs_cui_zone, cuip);
>  }
>  
>  /*
> @@ -206,7 +206,7 @@ xfs_cud_item_release(
>  	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
>  
>  	xfs_cui_release(cudp->cud_cuip);
> -	kmem_zone_free(xfs_cud_zone, cudp);
> +	kmem_cache_free(xfs_cud_zone, cudp);
>  }
>  
>  static const struct xfs_item_ops xfs_cud_item_ops = {
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 02f84d9a511c..4911b68f95dd 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -34,7 +34,7 @@ xfs_rui_item_free(
>  	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
>  		kmem_free(ruip);
>  	else
> -		kmem_zone_free(xfs_rui_zone, ruip);
> +		kmem_cache_free(xfs_rui_zone, ruip);
>  }
>  
>  /*
> @@ -229,7 +229,7 @@ xfs_rud_item_release(
>  	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
>  
>  	xfs_rui_release(rudp->rud_ruip);
> -	kmem_zone_free(xfs_rud_zone, rudp);
> +	kmem_cache_free(xfs_rud_zone, rudp);
>  }
>  
>  static const struct xfs_item_ops xfs_rud_item_ops = {
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index f4795fdb7389..3b208f9a865c 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -71,7 +71,7 @@ xfs_trans_free(
>  	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_end_intwrite(tp->t_mountp->m_super);
>  	xfs_trans_free_dqinfo(tp);
> -	kmem_zone_free(xfs_trans_zone, tp);
> +	kmem_cache_free(xfs_trans_zone, tp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 16457465833b..ff1c326826d3 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -872,6 +872,6 @@ xfs_trans_free_dqinfo(
>  {
>  	if (!tp->t_dqinfo)
>  		return;
> -	kmem_zone_free(xfs_qm_dqtrxzone, tp->t_dqinfo);
> +	kmem_cache_free(xfs_qm_dqtrxzone, tp->t_dqinfo);
>  	tp->t_dqinfo = NULL;
>  }
> -- 
> 2.23.0
> 
