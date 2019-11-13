Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81D6C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 18:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B4C3206E1
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 18:08:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DGtpJw8G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfKMSI6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 13:08:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKMSI5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 13:08:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADI4LhR106677;
        Wed, 13 Nov 2019 18:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=OBNEjGgcl7D4a7GxIdb6050iuE0G/zb6w+/4ggih/rg=;
 b=DGtpJw8GgD8TUMMD28InECQdJIYVtG4OBB3In7BDKw/2peoW/y0FoRl6RcDC5jdaWXB2
 B1kwSgPQs27mlLwv54lVK8048YQdobTIEOI5ZKgKiJICMcBgSgr3NR1jMazHlhn8sFxM
 e2Pnn+EbOkLZSpRCCYBp+slxPgVU8QlHyRvBsYYU4HC5ck6Q8nAgJ3QbUMLag+i6W2IU
 6rl6vchXQsbF3JJ1CRQFRu11+irNRyUYQcnQVi5GLWXZD3moMiGsdx1yglImwYldsxoY
 JttzwATQ+ArgXxNcQtDyN0pmQ11D43eprpyqFVdDb9HOQypBc3h0t8ZyfH46M8gRlGPO qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvtxaur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:08:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADI3okr160020;
        Wed, 13 Nov 2019 18:08:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w8ng3u99d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:08:52 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xADI8p7t023724;
        Wed, 13 Nov 2019 18:08:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 10:08:51 -0800
Date:   Wed, 13 Nov 2019 10:08:50 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: rework kmem_alloc_{io,large} to use GFP_*
 flags
Message-ID: <20191113180850.GK6235@magnolia>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-10-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113142335.1045631-10-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 03:23:33PM +0100, Carlos Maiolino wrote:
> Pass slab flags directly to these functions
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/kmem.c                 | 60 ++++-------------------------------
>  fs/xfs/kmem.h                 |  8 ++---
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/scrub/attr.c           |  8 ++---
>  fs/xfs/scrub/attr.h           |  3 +-
>  fs/xfs/xfs_buf.c              |  7 ++--
>  fs/xfs/xfs_log.c              |  2 +-
>  fs/xfs/xfs_log_cil.c          |  2 +-
>  fs/xfs/xfs_log_recover.c      |  3 +-
>  9 files changed, 22 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 79467813d810..44145293cfc9 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -8,54 +8,6 @@
>  #include "xfs_message.h"
>  #include "xfs_trace.h"
>  
> -static void *
> -__kmem_alloc(size_t size, xfs_km_flags_t flags)
> -{
> -	int	retries = 0;
> -	gfp_t	lflags = kmem_flags_convert(flags);
> -	void	*ptr;
> -
> -	trace_kmem_alloc(size, flags, _RET_IP_);
> -
> -	do {
> -		ptr = kmalloc(size, lflags);
> -		if (ptr || (flags & KM_MAYFAIL))
> -			return ptr;
> -		if (!(++retries % 100))
> -			xfs_err(NULL,
> -	"%s(%u) possible memory allocation deadlock size %u in %s (mode:0x%x)",
> -				current->comm, current->pid,
> -				(unsigned int)size, __func__, lflags);
> -		congestion_wait(BLK_RW_ASYNC, HZ/50);

Why is it ok to remove the "wait for congestion and retry" logic here?
Does GFP_NOFAIL do all that for us?

Same question for the other two patches that remove similar loops from
other functions.

> -	} while (1);
> -}
> -
> -
> -/*
> - * __vmalloc() will allocate data pages and auxiliary structures (e.g.
> - * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context here. Hence
> - * we need to tell memory reclaim that we are in such a context via
> - * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem here
> - * and potentially deadlocking.
> - */
> -static void *
> -__kmem_vmalloc(size_t size, xfs_km_flags_t flags)
> -{
> -	unsigned nofs_flag = 0;
> -	void	*ptr;
> -	gfp_t	lflags = kmem_flags_convert(flags);
> -
> -	if (flags & KM_NOFS)
> -		nofs_flag = memalloc_nofs_save();
> -
> -	ptr = __vmalloc(size, lflags, PAGE_KERNEL);
> -
> -	if (flags & KM_NOFS)
> -		memalloc_nofs_restore(nofs_flag);
> -
> -	return ptr;
> -}

I think this deletes too much -- as the comment says, a caller can pass
in GFP_NOFS and we have to push that context all the way through to
/any/ allocation that happens under __vmalloc.

However, it's possible that the mm developers have fixed __vmalloc to
pass GFP_NOFS through to every allocation that can be made.  Is that the
case?

The flags conversion parts looks ok though.

TBH this series would be better sequenced as (1) get rid of pointless
wrappers, (2) convert kmem* callers to use GFP flags, and (3) save
whatever logic changes for the end.  If nothing else I could pull the
first two parts and leave the third for later.

--D

> -
>  /*
>   * Same as kmem_alloc_large, except we guarantee the buffer returned is aligned
>   * to the @align_mask. We only guarantee alignment up to page size, we'll clamp
> @@ -63,7 +15,7 @@ __kmem_vmalloc(size_t size, xfs_km_flags_t flags)
>   * aligned region.
>   */
>  void *
> -kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags)
> +kmem_alloc_io(size_t size, int align_mask, gfp_t flags)
>  {
>  	void	*ptr;
>  
> @@ -72,24 +24,24 @@ kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags)
>  	if (WARN_ON_ONCE(align_mask >= PAGE_SIZE))
>  		align_mask = PAGE_SIZE - 1;
>  
> -	ptr = __kmem_alloc(size, flags | KM_MAYFAIL);
> +	ptr = kmalloc(size, flags | __GFP_RETRY_MAYFAIL);
>  	if (ptr) {
>  		if (!((uintptr_t)ptr & align_mask))
>  			return ptr;
>  		kfree(ptr);
>  	}
> -	return __kmem_vmalloc(size, flags);
> +	return __vmalloc(size, flags | __GFP_NOFAIL, PAGE_KERNEL);
>  }
>  
>  void *
> -kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> +kmem_alloc_large(size_t size, gfp_t flags)
>  {
>  	void	*ptr;
>  
>  	trace_kmem_alloc_large(size, flags, _RET_IP_);
>  
> -	ptr = __kmem_alloc(size, flags | KM_MAYFAIL);
> +	ptr = kmalloc(size, flags | __GFP_RETRY_MAYFAIL);
>  	if (ptr)
>  		return ptr;
> -	return __kmem_vmalloc(size, flags);
> +	return __vmalloc(size, flags | __GFP_NOFAIL, PAGE_KERNEL);
>  }
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 29d02c71fb22..9249323567ce 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -52,8 +52,8 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  	return lflags;
>  }
>  
> -extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
> -extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
> +extern void *kmem_alloc_io(size_t size, int align_mask, gfp_t flags);
> +extern void *kmem_alloc_large(size_t size, gfp_t);
>  static inline void  kmem_free(const void *ptr)
>  {
>  	kvfree(ptr);
> @@ -61,9 +61,9 @@ static inline void  kmem_free(const void *ptr)
>  
>  
>  static inline void *
> -kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
> +kmem_zalloc_large(size_t size, gfp_t flags)
>  {
> -	return kmem_alloc_large(size, flags | KM_ZERO);
> +	return kmem_alloc_large(size, flags | __GFP_ZERO);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index e78cba993eae..d3f872460ea6 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -479,7 +479,7 @@ xfs_attr_copy_value(
>  	}
>  
>  	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
> -		args->value = kmem_alloc_large(valuelen, 0);
> +		args->value = kmem_alloc_large(valuelen, GFP_KERNEL);
>  		if (!args->value)
>  			return -ENOMEM;
>  	}
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index d9f0dd444b80..bc09c46f4ff2 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -29,7 +29,7 @@ int
>  xchk_setup_xattr_buf(
>  	struct xfs_scrub	*sc,
>  	size_t			value_size,
> -	xfs_km_flags_t		flags)
> +	gfp_t			flags)
>  {
>  	size_t			sz;
>  	struct xchk_xattr_buf	*ab = sc->buf;
> @@ -80,7 +80,7 @@ xchk_setup_xattr(
>  	 * without the inode lock held, which means we can sleep.
>  	 */
>  	if (sc->flags & XCHK_TRY_HARDER) {
> -		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, 0);
> +		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, GFP_KERNEL);
>  		if (error)
>  			return error;
>  	}
> @@ -139,7 +139,7 @@ xchk_xattr_listent(
>  	 * doesn't work, we overload the seen_enough variable to convey
>  	 * the error message back to the main scrub function.
>  	 */
> -	error = xchk_setup_xattr_buf(sx->sc, valuelen, KM_MAYFAIL);
> +	error = xchk_setup_xattr_buf(sx->sc, valuelen, GFP_KERNEL);
>  	if (error == -ENOMEM)
>  		error = -EDEADLOCK;
>  	if (error) {
> @@ -324,7 +324,7 @@ xchk_xattr_block(
>  		return 0;
>  
>  	/* Allocate memory for block usage checking. */
> -	error = xchk_setup_xattr_buf(ds->sc, 0, KM_MAYFAIL);
> +	error = xchk_setup_xattr_buf(ds->sc, 0, GFP_KERNEL);
>  	if (error == -ENOMEM)
>  		return -EDEADLOCK;
>  	if (error)
> diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
> index 13a1d2e8424d..2c27a82574cb 100644
> --- a/fs/xfs/scrub/attr.h
> +++ b/fs/xfs/scrub/attr.h
> @@ -65,7 +65,6 @@ xchk_xattr_dstmap(
>  			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
>  }
>  
> -int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size,
> -		xfs_km_flags_t flags);
> +int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size, gfp_t flags);
>  
>  #endif	/* __XFS_SCRUB_ATTR_H__ */
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8a0cc7593212..678e024f7f1c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -346,15 +346,12 @@ xfs_buf_allocate_memory(
>  	unsigned short		page_count, i;
>  	xfs_off_t		start, end;
>  	int			error;
> -	xfs_km_flags_t		kmflag_mask = 0;
>  
>  	/*
>  	 * assure zeroed buffer for non-read cases.
>  	 */
> -	if (!(flags & XBF_READ)) {
> -		kmflag_mask |= KM_ZERO;
> +	if (!(flags & XBF_READ))
>  		gfp_mask |= __GFP_ZERO;
> -	}
>  
>  	/*
>  	 * for buffers that are contained within a single page, just allocate
> @@ -365,7 +362,7 @@ xfs_buf_allocate_memory(
>  	if (size < PAGE_SIZE) {
>  		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
>  		bp->b_addr = kmem_alloc_io(size, align_mask,
> -					   KM_NOFS | kmflag_mask);
> +					   GFP_NOFS | __GFP_ZERO);
>  		if (!bp->b_addr) {
>  			/* low memory - use alloc_page loop instead */
>  			goto use_alloc_page;
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 28e82d5d5943..dd65fdabf50e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1492,7 +1492,7 @@ xlog_alloc_log(
>  		prev_iclog = iclog;
>  
>  		iclog->ic_data = kmem_alloc_io(log->l_iclog_size, align_mask,
> -						KM_MAYFAIL | KM_ZERO);
> +					       GFP_KERNEL | __GFP_ZERO);
>  		if (!iclog->ic_data)
>  			goto out_free_iclog;
>  #ifdef DEBUG
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index aa1b923f7293..9250b6b2f0fd 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -186,7 +186,7 @@ xlog_cil_alloc_shadow_bufs(
>  			 */
>  			kmem_free(lip->li_lv_shadow);
>  
> -			lv = kmem_alloc_large(buf_size, KM_NOFS);
> +			lv = kmem_alloc_large(buf_size, GFP_NOFS);
>  			memset(lv, 0, xlog_cil_iovec_space(niovecs));
>  
>  			lv->lv_item = lip;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index d46240152518..76b99ebdfcd9 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -127,7 +127,8 @@ xlog_alloc_buffer(
>  	if (nbblks > 1 && log->l_sectBBsize > 1)
>  		nbblks += log->l_sectBBsize;
>  	nbblks = round_up(nbblks, log->l_sectBBsize);
> -	return kmem_alloc_io(BBTOB(nbblks), align_mask, KM_MAYFAIL | KM_ZERO);
> +	return kmem_alloc_io(BBTOB(nbblks), align_mask,
> +			     GFP_KERNEL | __GFP_ZERO);
>  }
>  
>  /*
> -- 
> 2.23.0
> 
