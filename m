Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD70C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 654AC206C2
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m8kLhf+3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfIRQcb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 12:32:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfIRQcb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 12:32:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IGNZb5021958;
        Wed, 18 Sep 2019 16:32:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=YB0/fgWDYl+Ri/vrGEiET1RppDkZr/BWmu95lEprp44=;
 b=m8kLhf+3o8IcbelTKMicAOIHwRcAoQnwqc5DwHsq/8vN9lKy1VMamoQr5zhG6g9F2JIs
 KIwxzR2Vu6nF3mRPWiif9KJh2PPd1DkuA5eedHxB4QNn1mtlw+l2n99nGuqAKpwql6PZ
 flataQZHFwXdnGFpIyiUuoMgbccUHRFGoW/1TCOkPKLkoYQpc/9t/bu9Ee5OadUqgha9
 sbHuezwK3gFg6h9Ku42ce7VsczPNf9hGN1fldr+iuB8MY5V6dKS25mOzIkgKVO6a/pfN
 3PKAsuQJo33rqf7qHF4N/aOnhgwC+xb59j2eXAZpUh59tbaPFZdGQwfdv2aaOAeUrGu6 VQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v385dw51b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 16:32:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IGMssK173876;
        Wed, 18 Sep 2019 16:32:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v37mmwr3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 16:32:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IGWE3k029183;
        Wed, 18 Sep 2019 16:32:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 09:32:13 -0700
Date:   Wed, 18 Sep 2019 09:32:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Bill O'Donnell" <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: assure zeroed memory buffers for certain kmem
 allocations
Message-ID: <20190918163212.GA568270@magnolia>
References: <20190916153504.30809-1-billodo@redhat.com>
 <20190918154733.24355-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918154733.24355-1-billodo@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 10:47:33AM -0500, Bill O'Donnell wrote:
> Guarantee zeroed memory buffers for cases where potential memory
> leak to disk can occur. In these cases, kmem_alloc is used and
> doesn't zero the buffer, opening the possibility of information
> leakage to disk.
> 
> Introduce a xfs_buf_flag, XBF_ZERO, to indicate a request for a zeroed
> buffer, and use existing infrastucture (xfs_buf_allocate_memory) to
> obtain the already zeroed buffer from kernel memory.
> 
> This solution avoids the performance issue that would occur if a
> wholesale change to replace kmem_alloc with kmem_zalloc was done.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
> v2: zeroed buffer not required for XBF_READ case. Correct placement
>     and rename the XBF_ZERO flag.
> 
>  fs/xfs/xfs_buf.c       | 9 +++++++--
>  fs/xfs/xfs_buf.h       | 2 ++
>  fs/xfs/xfs_trans_buf.c | 2 ++
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 120ef99d09e8..0d96efff451e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -345,6 +345,10 @@ xfs_buf_allocate_memory(
>  	unsigned short		page_count, i;
>  	xfs_off_t		start, end;
>  	int			error;
> +	uint			kmflag_mask = 0;
> +
> +	if ((flags & XBF_ZERO) && !(flags & XBF_READ))

The sole caller of xfs_buf_allocate_memory is xfs_buf_get_map.  If
_get_map is called from the *read_buf* functions, they pass in XBF_READ
to ensure buffer contents are read.  The other _get_map callers seem to
be initializing metadata blocks and do not set XBF_READ.

So I wonder, do you even need XBF_ZERO?  Or could this be reduced to:

	if (!(flags & XBF_READ))
		km_flag_mask |= KM_ZERO;

?

--D

> +		kmflag_mask |= KM_ZERO;
>  
>  	/*
>  	 * for buffers that are contained within a single page, just allocate
> @@ -354,7 +358,8 @@ xfs_buf_allocate_memory(
>  	size = BBTOB(bp->b_length);
>  	if (size < PAGE_SIZE) {
>  		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> -		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);
> +		bp->b_addr = kmem_alloc_io(size, align_mask,
> +					   KM_NOFS | kmflag_mask);
>  		if (!bp->b_addr) {
>  			/* low memory - use alloc_page loop instead */
>  			goto use_alloc_page;
> @@ -391,7 +396,7 @@ xfs_buf_allocate_memory(
>  		struct page	*page;
>  		uint		retries = 0;
>  retry:
> -		page = alloc_page(gfp_mask);
> +		page = alloc_page(gfp_mask | kmflag_mask);
>  		if (unlikely(page == NULL)) {
>  			if (flags & XBF_READ_AHEAD) {
>  				bp->b_page_count = i;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index f6ce17d8d848..dccdd653c9dc 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -33,6 +33,7 @@
>  /* flags used only as arguments to access routines */
>  #define XBF_TRYLOCK	 (1 << 16)/* lock requested, but do not wait */
>  #define XBF_UNMAPPED	 (1 << 17)/* do not map the buffer */
> +#define XBF_ZERO	 (1 << 18)/* zeroed buffer required */
>  
>  /* flags used only internally */
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
> @@ -52,6 +53,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
>  	{ XBF_TRYLOCK,		"TRYLOCK" },	/* should never be set */\
>  	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
> +	{ XBF_ZERO,		"KMEM_ZERO" }, \
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index b5b3a78ef31c..087d413c1490 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -123,6 +123,8 @@ xfs_trans_get_buf_map(
>  	xfs_buf_t		*bp;
>  	struct xfs_buf_log_item	*bip;
>  
> +	flags |= XBF_ZERO;
> +
>  	if (!tp)
>  		return xfs_buf_get_map(target, map, nmaps, flags);
>  
> -- 
> 2.21.0
> 
