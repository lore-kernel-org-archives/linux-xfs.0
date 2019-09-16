Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81E8C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A432721670
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388001AbfIPVYn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 17:24:43 -0400
Received: from sandeen.net ([63.231.237.45]:38846 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfIPVYm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 17:24:42 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5903532543A;
        Mon, 16 Sep 2019 16:24:41 -0500 (CDT)
Subject: Re: [PATCH] xfs: assure zeroed memory buffers for certain kmem
 allocations
To:     Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com
References: <20190916153504.30809-1-billodo@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <5f1bcfbd-f16b-6d8a-416d-3a0639b9c7fe@sandeen.net>
Date:   Mon, 16 Sep 2019 16:24:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190916153504.30809-1-billodo@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/16/19 10:35 AM, Bill O'Donnell wrote:
> Guarantee zeroed memory buffers for cases where potential memory
> leak to disk can occur. In these cases, kmem_alloc is used and
> doesn't zero the buffer, opening the possibility of information
> leakage to disk.
> 
> Introduce a xfs_buf_flag, _XBF_KMZ, to indicate a request for a zeroed
> buffer, and use existing infrastucture (xfs_buf_allocate_memory) to
> obtain the already zeroed buffer from kernel memory.
> 
> This solution avoids the performance issue that would occur if a
> wholesale change to replace kmem_alloc with kmem_zalloc was done.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

I think this can probably be further optimized by not obtaining zeroed
memory when we're about to fill the buffer from disk as the very
next step.

(in this case, xfs_buf_read_map calls xfs_buf_get_map and then immediately
reads the buffer from disk with _xfs_buf_read)  xfs_buf_read_map adds
XBF_READ to the flags during this process.

So I wonder if this can be simplified/optimized by just checking for XBF_READ
in xfs_buf_allocate_memory's flags, and if it's not set, then request
zeroed memory, because that indicates a buffer we'll be filling in from
memory and subsequently writing to disk.

-Eric

> ---
>  fs/xfs/xfs_buf.c | 8 ++++++--
>  fs/xfs/xfs_buf.h | 4 +++-
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 120ef99d09e8..916a3f782950 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -345,16 +345,19 @@ xfs_buf_allocate_memory(
>  	unsigned short		page_count, i;
>  	xfs_off_t		start, end;
>  	int			error;
> +	uint			kmflag_mask = 0;
>  
>  	/*
>  	 * for buffers that are contained within a single page, just allocate
>  	 * the memory from the heap - there's no need for the complexity of
>  	 * page arrays to keep allocation down to order 0.
>  	 */
> +	if (flags & _XBF_KMZ)
> +		kmflag_mask |= KM_ZERO;
>  	size = BBTOB(bp->b_length);
>  	if (size < PAGE_SIZE) {
>  		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> -		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);
> +		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS | kmflag_mask);
>  		if (!bp->b_addr) {
>  			/* low memory - use alloc_page loop instead */
>  			goto use_alloc_page;
> @@ -391,7 +394,7 @@ xfs_buf_allocate_memory(
>  		struct page	*page;
>  		uint		retries = 0;
>  retry:
> -		page = alloc_page(gfp_mask);
> +		page = alloc_page(gfp_mask | kmflag_mask);
>  		if (unlikely(page == NULL)) {
>  			if (flags & XBF_READ_AHEAD) {
>  				bp->b_page_count = i;
> @@ -683,6 +686,7 @@ xfs_buf_get_map(
>  	struct xfs_buf		*new_bp;
>  	int			error = 0;
>  
> +	flags |= _XBF_KMZ;
>  	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
>  
>  	switch (error) {
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index f6ce17d8d848..416ff588240a 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -38,6 +38,7 @@
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
>  #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
> +#define _XBF_KMZ	 (1 << 23)/* zeroed buffer required */
>  
>  typedef unsigned int xfs_buf_flags_t;
>  
> @@ -54,7 +55,8 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
> -	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
> +	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> +	{ _XBF_KMZ,             "KMEM_Z" }
>  
>  
>  /*
> 
