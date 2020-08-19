Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF13C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 16:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94792207FF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 16:51:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fPu242pu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHSQvq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 12:51:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35100 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgHSQvp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Aug 2020 12:51:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07JGgJcO185680;
        Wed, 19 Aug 2020 16:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=oFma/arm+OR4ccDJXqljkOwrPqh7e3xTQCOgoSb8Bjk=;
 b=fPu242puhuQGQxljH7hNZJabgLufZbKL4SjqLhme9961vnR13oVHQQ9YwbOwuh6e+KpB
 rJCmNWgnXDSb4DCtNnRsN8DWAjsDuYpxNG/SWX5KEWIjiWeqXmNWgc/a7OOHMbMJpWB1
 lhxaOD8p2mAmDuy6smrKA6Obj45nNR3FyhkP5Q72EmCd4Z1Lp+NaEZfsAWRkPMKdTFos
 wjAqjfVzjOGPEY9wPepULeZ9+y3eLQggSeVejS1VDOevBq1C7NtOaCiRjlp7hSr2YT65
 k2wxntwUGW3AFqYWoqi4xGqXPl+2sLJncqzHi8qlJ8hVpN3Xi1W6DTsWGhbvnp1SiKA7 ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74rbs8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 16:51:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07JGgx4K070116;
        Wed, 19 Aug 2020 16:51:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32xsn007hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 16:51:37 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07JGpbRK022671;
        Wed, 19 Aug 2020 16:51:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Aug 2020 09:51:36 -0700
Date:   Wed, 19 Aug 2020 09:51:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: remove kmem_realloc()
Message-ID: <20200819165136.GD6096@magnolia>
References: <20200819130050.115687-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819130050.115687-1-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=5 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=5 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 19, 2020 at 03:00:50PM +0200, Carlos Maiolino wrote:
> Remove kmem_realloc() function and convert its users to use MM API
> directly (krealloc())
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

woot!
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> This is essentially the same patches as the original series, just both patches
> squashed together.
> 
>  fs/xfs/kmem.c                  | 22 ----------------------
>  fs/xfs/kmem.h                  |  1 -
>  fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
>  fs/xfs/xfs_log_recover.c       |  2 +-
>  fs/xfs/xfs_mount.c             |  4 ++--
>  fs/xfs/xfs_trace.h             |  1 -
>  7 files changed, 8 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index e841ed781a257..e986b95d94c9b 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -93,25 +93,3 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
>  		return ptr;
>  	return __kmem_vmalloc(size, flags);
>  }
> -
> -void *
> -kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
> -{
> -	int	retries = 0;
> -	gfp_t	lflags = kmem_flags_convert(flags);
> -	void	*ptr;
> -
> -	trace_kmem_realloc(newsize, flags, _RET_IP_);
> -
> -	do {
> -		ptr = krealloc(old, newsize, lflags);
> -		if (ptr || (flags & KM_MAYFAIL))
> -			return ptr;
> -		if (!(++retries % 100))
> -			xfs_err(NULL,
> -	"%s(%u) possible memory allocation deadlock size %zu in %s (mode:0x%x)",
> -				current->comm, current->pid,
> -				newsize, __func__, lflags);
> -		congestion_wait(BLK_RW_ASYNC, HZ/50);
> -	} while (1);
> -}
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 8e8555817e6d3..fb1d066770723 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -59,7 +59,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  extern void *kmem_alloc(size_t, xfs_km_flags_t);
>  extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
>  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
> -extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
>  static inline void  kmem_free(const void *ptr)
>  {
>  	kvfree(ptr);
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index 52451809c4786..b4164256993d8 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -603,7 +603,7 @@ xfs_iext_realloc_root(
>  	if (new_size / sizeof(struct xfs_iext_rec) == RECS_PER_LEAF)
>  		new_size = NODE_SIZE;
>  
> -	new = kmem_realloc(ifp->if_u1.if_root, new_size, KM_NOFS);
> +	new = krealloc(ifp->if_u1.if_root, new_size, GFP_NOFS | __GFP_NOFAIL);
>  	memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
>  	ifp->if_u1.if_root = new;
>  	cur->leaf = new;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 0cf853d42d622..7575de5cecb1f 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -386,8 +386,8 @@ xfs_iroot_realloc(
>  		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
>  		new_max = cur_max + rec_diff;
>  		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
> -		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
> -				KM_NOFS);
> +		ifp->if_broot = krealloc(ifp->if_broot, new_size,
> +					 GFP_NOFS | __GFP_NOFAIL);
>  		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
>  						     ifp->if_broot_bytes);
>  		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
> @@ -496,8 +496,8 @@ xfs_idata_realloc(
>  	 * in size so that it can be logged and stay on word boundaries.
>  	 * We enforce that here.
>  	 */
> -	ifp->if_u1.if_data = kmem_realloc(ifp->if_u1.if_data,
> -			roundup(new_size, 4), KM_NOFS);
> +	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
> +				      GFP_NOFS | __GFP_NOFAIL);
>  	ifp->if_bytes = new_size;
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e2ec91b2d0f46..45dca18a95204 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2097,7 +2097,7 @@ xlog_recover_add_to_cont_trans(
>  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>  
> -	ptr = kmem_realloc(old_ptr, len + old_len, 0);
> +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(&ptr[old_len], dp, len);
>  	item->ri_buf[item->ri_cnt-1].i_len += len;
>  	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index c8ae49a1e99c3..0bc623c175e93 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -80,9 +80,9 @@ xfs_uuid_mount(
>  	}
>  
>  	if (hole < 0) {
> -		xfs_uuid_table = kmem_realloc(xfs_uuid_table,
> +		xfs_uuid_table = krealloc(xfs_uuid_table,
>  			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
> -			0);
> +			GFP_KERNEL | __GFP_NOFAIL);
>  		hole = xfs_uuid_table_size++;
>  	}
>  	xfs_uuid_table[hole] = *uuid;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index abb1d859f226a..d898d7ac4dc31 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3676,7 +3676,6 @@ DEFINE_EVENT(xfs_kmem_class, name, \
>  DEFINE_KMEM_EVENT(kmem_alloc);
>  DEFINE_KMEM_EVENT(kmem_alloc_io);
>  DEFINE_KMEM_EVENT(kmem_alloc_large);
> -DEFINE_KMEM_EVENT(kmem_realloc);
>  
>  TRACE_EVENT(xfs_check_new_dalign,
>  	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
> -- 
> 2.26.2
> 
