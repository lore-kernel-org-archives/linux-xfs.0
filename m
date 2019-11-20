Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82C1C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 19:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6CD621823
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 19:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bK1fdwKZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfKTTCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 14:02:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42950 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfKTTCl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 14:02:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIxQ1k030935;
        Wed, 20 Nov 2019 19:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=YWgW2KvhelyhP8PQZNYtTtP4zVd0W7tF5rTEZJVTf8g=;
 b=bK1fdwKZ6l7An7mX5W1JZK308mfEx2+FNYCw98IhMveCZqYKNF6TxU/ljDvHcCXatOj0
 iKyIczcMhRB47FNppjUT4y/yC72nXnyXKbXgZ4mL0jOMAVP68ANh2pXfodBcJujk84oU
 KkJsFfzE6yWYvRp5ZEg9sgd8Uehg2Zgi9gmUsATmTmmZzbD4lewqEi6N2cNBjGwlZaXI
 2k4riI5VBMVLH6mb1yl4mfHFrV904pIEuorVjQRrGdJmTmFSbjTkPqrGfSyXufNBdbmK
 CLkyJEowCbuENrDbLGt2dwFGn//AaVzJYWhiBTX2k56qdvoxQ6cwWXhemn5Y33O9iGyz 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8htykd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 19:02:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIxD73131215;
        Wed, 20 Nov 2019 19:00:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wcemhb00x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 19:00:36 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAKJ0Yln020999;
        Wed, 20 Nov 2019 19:00:34 GMT
Received: from localhost (/10.159.246.236)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 11:00:34 -0800
Date:   Wed, 20 Nov 2019 11:00:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: Remove kmem_realloc
Message-ID: <20191120190033.GQ6219@magnolia>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
 <20191120104425.407213-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120104425.407213-5-cmaiolino@redhat.com>
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

On Wed, Nov 20, 2019 at 11:44:24AM +0100, Carlos Maiolino wrote:
> We can use krealloc() with __GFP_NOFAIL directly
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> V2:
> 	- Fix small conflict in kmem.h due removal of kmem_free()
> 	- Small comment update on xfs_iroot_realloc()
> 
>  fs/xfs/kmem.c                  | 22 ----------------------
>  fs/xfs/kmem.h                  |  1 -
>  fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c | 10 +++++-----
>  fs/xfs/xfs_log_recover.c       |  2 +-
>  fs/xfs/xfs_mount.c             |  4 ++--
>  6 files changed, 9 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 2644fdaa0549..6e10e565632c 100644
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
> index b9ee67fa747b..a18c27c99721 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -55,7 +55,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  extern void *kmem_alloc(size_t, xfs_km_flags_t);
>  extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
>  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
> -extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
>  
>  static inline void *
>  kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index e75e7c021187..78c9f6c7a36a 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -607,7 +607,7 @@ xfs_iext_realloc_root(
>  	if (new_size / sizeof(struct xfs_iext_rec) == RECS_PER_LEAF)
>  		new_size = NODE_SIZE;
>  
> -	new = kmem_realloc(ifp->if_u1.if_root, new_size, KM_NOFS);
> +	new = krealloc(ifp->if_u1.if_root, new_size, GFP_NOFS | __GFP_NOFAIL);
>  	memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
>  	ifp->if_u1.if_root = new;
>  	cur->leaf = new;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index ceb322c7105e..82799dddf97d 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -380,15 +380,15 @@ xfs_iroot_realloc(
>  
>  		/*
>  		 * If there is already an existing if_broot, then we need
> -		 * to realloc() it and shift the pointers to their new
> +		 * to krealloc() it and shift the pointers to their new
>  		 * location.  The records don't change location because
>  		 * they are kept butted up against the btree block header.
>  		 */
>  		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
>  		new_max = cur_max + rec_diff;
>  		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
> -		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
> -				KM_NOFS);
> +		ifp->if_broot = krealloc(ifp->if_broot, new_size,
> +				GFP_NOFS | __GFP_NOFAIL);
>  		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
>  						     ifp->if_broot_bytes);
>  		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
> @@ -497,8 +497,8 @@ xfs_idata_realloc(
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
> index cb02deb5dedc..5423171e0b7d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4211,7 +4211,7 @@ xlog_recover_add_to_cont_trans(
>  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>  
> -	ptr = kmem_realloc(old_ptr, len + old_len, 0);
> +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(&ptr[old_len], dp, len);
>  	item->ri_buf[item->ri_cnt-1].i_len += len;
>  	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index c352567c8ef5..12a1cdf8e292 100644
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
> -- 
> 2.23.0
> 
