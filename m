Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3AC3C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 18:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAA65206ED
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 18:23:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kIpcZAKh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfKMSXu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 13:23:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfKMSXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 13:23:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADI99NL081003;
        Wed, 13 Nov 2019 18:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=M/m5SboMlqWm6cjjm5P7GS0W7t5VMS84aiHUDhbp/mA=;
 b=kIpcZAKhn/HjMN0XlteeisQ+QshrIsiOckcE0AW+2ss50DqhwyDaa0V8w0S6yE5qiRFj
 IRI1aXKOJPL1RkebVLGtG/24ol5qwgG+v2RdKtRQspLcH7JlCwkRFjkVkWuSDh4seg7s
 AecK5nDuAx0pbwdXSRiJtFUTHmDPSZGKGu9CsLYDo1eoWp4SF2nBJP8wrIhHDYFKYUFJ
 RoBd4+7mxEnAEPf/58hCXn/Riz6AZnd1o//HYAjIuB9L5PjnU3QHXC0z18pzsVP0xTDV
 BPS47dk+0uP2zX4LGockZzENbxEQRhDMuRTIPmqt2XSNY315EZi4rtUV6n9HMblsW4te Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w5p3qx8yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:23:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADIDj8Y007330;
        Wed, 13 Nov 2019 18:23:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w7vbdb1ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:23:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xADINiTF026457;
        Wed, 13 Nov 2019 18:23:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 10:23:44 -0800
Date:   Wed, 13 Nov 2019 10:23:43 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: Remove kmem_alloc_{io, large} and
 kmem_zalloc_large
Message-ID: <20191113182343.GH6219@magnolia>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-12-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113142335.1045631-12-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 03:23:35PM +0100, Carlos Maiolino wrote:
> Getting rid of these functions, is a bit more complicated, giving the
> fact they use a vmalloc fallback, and (in case of _io version) uses an
> alignment check, so they have their useness.
> 
> Instead of keeping both of them, I think sharing the same function for
> both cases is a more interesting idea, giving the fact they both have
> the same purpose, with the only difference being the alignment check,
> which can be selected by using a flag.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/kmem.c                 | 39 +++++++++++------------------------
>  fs/xfs/kmem.h                 | 10 +--------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/scrub/attr.c           |  2 +-
>  fs/xfs/scrub/symlink.c        |  3 ++-
>  fs/xfs/xfs_acl.c              |  3 ++-
>  fs/xfs/xfs_buf.c              |  4 ++--
>  fs/xfs/xfs_ioctl.c            |  8 ++++---
>  fs/xfs/xfs_ioctl32.c          |  3 ++-
>  fs/xfs/xfs_log.c              |  5 +++--
>  fs/xfs/xfs_log_cil.c          |  2 +-
>  fs/xfs/xfs_log_recover.c      |  4 ++--
>  fs/xfs/xfs_rtalloc.c          |  3 ++-
>  13 files changed, 36 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 44145293cfc9..bb4990970647 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -8,40 +8,25 @@
>  #include "xfs_message.h"
>  #include "xfs_trace.h"
>  
> -/*
> - * Same as kmem_alloc_large, except we guarantee the buffer returned is aligned
> - * to the @align_mask. We only guarantee alignment up to page size, we'll clamp
> - * alignment at page size if it is larger. vmalloc always returns a PAGE_SIZE
> - * aligned region.
> - */
>  void *
> -kmem_alloc_io(size_t size, int align_mask, gfp_t flags)
> +xfs_kmem_alloc(size_t size, gfp_t flags, bool align, int align_mask)

A boolean for the align /and/ an alignment mask?  Yuck.

I think I'd rather have:

void *
kmem_alloc(
	size_t		size,
	gfp_t		flags,
	unsigned int	align_mask)
{
	... allocation logic ...
}

and in kmem.h:

static inline void *
kmem_alloc_io(
	size_t		size,
	gfp_t		flags,
	unsigned int	align_mask)
{
	trace_kmem_alloc_io(size, flags, align_mask, _RET_IP_);
	return kmem_alloc(size, flags, align_mask);
}

static inline void *
kmem_alloc_large(
	size_t		size,
	gfp_t		flags)
{
	trace_kmem_alloc_large(size, flags, _RET_IP_);
	return kmem_alloc(size, flags, 0);
}

because there's little sense in cluttering up the large allocation call
sites with "false, 0" parameters that make no sense for an incore memory
allocation that has no alignment requirements.

--D

>  {
>  	void	*ptr;
>  
> -	trace_kmem_alloc_io(size, flags, _RET_IP_);
> -
> -	if (WARN_ON_ONCE(align_mask >= PAGE_SIZE))
> -		align_mask = PAGE_SIZE - 1;
> -
>  	ptr = kmalloc(size, flags | __GFP_RETRY_MAYFAIL);
>  	if (ptr) {
> -		if (!((uintptr_t)ptr & align_mask))
> +		if (align) {
> +			trace_kmem_alloc_io(size, flags, _RET_IP_);
> +			if (WARN_ON_ONCE(align_mask >= PAGE_SIZE))
> +				align_mask = PAGE_SIZE - 1;
> +
> +			if (!((uintptr_t)ptr & align_mask))
> +				return ptr;
> +			kfree(ptr);
> +		} else {
> +			trace_kmem_alloc_large(size, flags, _RET_IP_);
>  			return ptr;
> -		kfree(ptr);
> +		}
>  	}
>  	return __vmalloc(size, flags | __GFP_NOFAIL, PAGE_KERNEL);
>  }
> -
> -void *
> -kmem_alloc_large(size_t size, gfp_t flags)
> -{
> -	void	*ptr;
> -
> -	trace_kmem_alloc_large(size, flags, _RET_IP_);
> -
> -	ptr = kmalloc(size, flags | __GFP_RETRY_MAYFAIL);
> -	if (ptr)
> -		return ptr;
> -	return __vmalloc(size, flags | __GFP_NOFAIL, PAGE_KERNEL);
> -}
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 791e770be0eb..ee4c0152cdeb 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -15,20 +15,12 @@
>   * General memory allocation interfaces
>   */
>  
> -extern void *kmem_alloc_io(size_t size, int align_mask, gfp_t flags);
> -extern void *kmem_alloc_large(size_t size, gfp_t);
> +extern void *xfs_kmem_alloc(size_t, gfp_t, bool, int);
>  static inline void  kmem_free(const void *ptr)
>  {
>  	kvfree(ptr);
>  }
>  
> -
> -static inline void *
> -kmem_zalloc_large(size_t size, gfp_t flags)
> -{
> -	return kmem_alloc_large(size, flags | __GFP_ZERO);
> -}
> -
>  /*
>   * Zone interfaces
>   */
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d3f872460ea6..eeb90f63cf2e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -479,7 +479,7 @@ xfs_attr_copy_value(
>  	}
>  
>  	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
> -		args->value = kmem_alloc_large(valuelen, GFP_KERNEL);
> +		args->value = xfs_kmem_alloc(valuelen, GFP_KERNEL, false, 0);
>  		if (!args->value)
>  			return -ENOMEM;
>  	}
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index bc09c46f4ff2..90239b902b47 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -57,7 +57,7 @@ xchk_setup_xattr_buf(
>  	 * Don't zero the buffer upon allocation to avoid runtime overhead.
>  	 * All users must be careful never to read uninitialized contents.
>  	 */
> -	ab = kmem_alloc_large(sizeof(*ab) + sz, flags);
> +	ab = xfs_kmem_alloc(sizeof(*ab) + sz, flags, false, 0);
>  	if (!ab)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> index 5641ae512c9e..78f6d0dd8f2e 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -22,7 +22,8 @@ xchk_setup_symlink(
>  	struct xfs_inode	*ip)
>  {
>  	/* Allocate the buffer without the inode lock held. */
> -	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, 0);
> +	sc->buf = xfs_kmem_alloc(XFS_SYMLINK_MAXLEN + 1,
> +				 GFP_KERNEL | __GFP_ZERO, false, 0);
>  	if (!sc->buf)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 91693fce34a8..988598e4e07c 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -186,7 +186,8 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		struct xfs_acl *xfs_acl;
>  		int len = XFS_ACL_MAX_SIZE(ip->i_mount);
>  
> -		xfs_acl = kmem_zalloc_large(len, 0);
> +		xfs_acl = xfs_kmem_alloc(len, GFP_KERNEL | __GFP_ZERO,
> +					 false, 0);
>  		if (!xfs_acl)
>  			return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 678e024f7f1c..b36e4c4d3b9a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -361,8 +361,8 @@ xfs_buf_allocate_memory(
>  	size = BBTOB(bp->b_length);
>  	if (size < PAGE_SIZE) {
>  		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> -		bp->b_addr = kmem_alloc_io(size, align_mask,
> -					   GFP_NOFS | __GFP_ZERO);
> +		bp->b_addr = xfs_kmem_alloc(size, GFP_NOFS | __GFP_ZERO, true,
> +					    align_mask);
>  		if (!bp->b_addr) {
>  			/* low memory - use alloc_page loop instead */
>  			goto use_alloc_page;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 364961c23cd0..72e26b7ac48f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -398,7 +398,8 @@ xfs_attrlist_by_handle(
>  	if (IS_ERR(dentry))
>  		return PTR_ERR(dentry);
>  
> -	kbuf = kmem_zalloc_large(al_hreq.buflen, 0);
> +	kbuf = xfs_kmem_alloc(al_hreq.buflen, GFP_KERNEL | __GFP_ZERO,
> +			      false, 0);
>  	if (!kbuf)
>  		goto out_dput;
>  
> @@ -436,7 +437,7 @@ xfs_attrmulti_attr_get(
>  
>  	if (*len > XFS_XATTR_SIZE_MAX)
>  		return -EINVAL;
> -	kbuf = kmem_zalloc_large(*len, 0);
> +	kbuf = xfs_kmem_alloc(*len, GFP_KERNEL | __GFP_ZERO, false, 0);
>  	if (!kbuf)
>  		return -ENOMEM;
>  
> @@ -1756,7 +1757,8 @@ xfs_ioc_getbmap(
>  	if (bmx.bmv_count > ULONG_MAX / recsize)
>  		return -ENOMEM;
>  
> -	buf = kmem_zalloc_large(bmx.bmv_count * sizeof(*buf), 0);
> +	buf = xfs_kmem_alloc(bmx.bmv_count * sizeof(*buf),
> +			     GFP_KERNEL | __GFP_ZERO, false, 0);
>  	if (!buf)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 3c0d518e1039..99886b1ba319 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -381,7 +381,8 @@ xfs_compat_attrlist_by_handle(
>  		return PTR_ERR(dentry);
>  
>  	error = -ENOMEM;
> -	kbuf = kmem_zalloc_large(al_hreq.buflen, 0);
> +	kbuf = xfs_kmem_alloc(al_hreq.buflen, GFP_KERNEL | __GFP_ZERO,
> +			      false, 0);
>  	if (!kbuf)
>  		goto out_dput;
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index dd65fdabf50e..c5e26080262c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1491,8 +1491,9 @@ xlog_alloc_log(
>  		iclog->ic_prev = prev_iclog;
>  		prev_iclog = iclog;
>  
> -		iclog->ic_data = kmem_alloc_io(log->l_iclog_size, align_mask,
> -					       GFP_KERNEL | __GFP_ZERO);
> +		iclog->ic_data = xfs_kmem_alloc(log->l_iclog_size,
> +					       GFP_KERNEL | __GFP_ZERO,
> +					       true, align_mask);
>  		if (!iclog->ic_data)
>  			goto out_free_iclog;
>  #ifdef DEBUG
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 9250b6b2f0fd..2585dbf653cc 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -186,7 +186,7 @@ xlog_cil_alloc_shadow_bufs(
>  			 */
>  			kmem_free(lip->li_lv_shadow);
>  
> -			lv = kmem_alloc_large(buf_size, GFP_NOFS);
> +			lv = xfs_kmem_alloc(buf_size, GFP_NOFS, false, 0);
>  			memset(lv, 0, xlog_cil_iovec_space(niovecs));
>  
>  			lv->lv_item = lip;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 76b99ebdfcd9..3eb23f71a415 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -127,8 +127,8 @@ xlog_alloc_buffer(
>  	if (nbblks > 1 && log->l_sectBBsize > 1)
>  		nbblks += log->l_sectBBsize;
>  	nbblks = round_up(nbblks, log->l_sectBBsize);
> -	return kmem_alloc_io(BBTOB(nbblks), align_mask,
> -			     GFP_KERNEL | __GFP_ZERO);
> +	return xfs_kmem_alloc(BBTOB(nbblks), GFP_KERNEL | __GFP_ZERO, true,
> +			      align_mask);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 1875484123d7..b2fa5f1a6acb 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -864,7 +864,8 @@ xfs_alloc_rsum_cache(
>  	 * lower bound on the minimum level with any free extents. We can
>  	 * continue without the cache if it couldn't be allocated.
>  	 */
> -	mp->m_rsum_cache = kmem_zalloc_large(rbmblocks, 0);
> +	mp->m_rsum_cache = xfs_kmem_alloc(rbmblocks, GFP_KERNEL | __GFP_ZERO,
> +					  false, 0);
>  	if (!mp->m_rsum_cache)
>  		xfs_warn(mp, "could not allocate realtime summary cache");
>  }
> -- 
> 2.23.0
> 
