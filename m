Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF3BC77B75
	for <linux-xfs@archiver.kernel.org>; Mon, 15 May 2023 15:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242176AbjEOPIt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 May 2023 11:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242184AbjEOPIp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2023 11:08:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7358E76
        for <linux-xfs@vger.kernel.org>; Mon, 15 May 2023 08:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684163277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lAB1RqGJjv7PATcYU8PN0nreEXGtl3T5aJhXqT4yzo8=;
        b=iJGO+8gQIN6asMYI42vv2PrzJ5Yu/jeIKwvkcshkX54EOJ3GKaSx+s3bJ1yUhfn5R2Sdi9
        QEKeSAYyB3e9lJjBPbCUzmPitRtMAiiEmucWwbG3J+JFe9BVUltTdfnp65wioiVDh+TerV
        SnQLrNhi8/5XK2TkTmPZ6hvjMviqRtQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-QXq2lZQqOcyeb6_ols8E2g-1; Mon, 15 May 2023 11:07:55 -0400
X-MC-Unique: QXq2lZQqOcyeb6_ols8E2g-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7578369dff3so3073494485a.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 May 2023 08:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684163275; x=1686755275;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAB1RqGJjv7PATcYU8PN0nreEXGtl3T5aJhXqT4yzo8=;
        b=KP9+CuAy5q4O+A70ZO5PE72HA0sP3Bpkw2RKJlakjn90C75Dyy2cmffCNHxAWY+j0r
         gnol3vK35rR1qqqn+p6ezWEKqivAdR7apgwJrXU73WieRtMyhIh90IResDr/kP3LV8EM
         I/gGOlrz7emoQbCb9M2RzBq5LhebVW5l4NCbSsVWM9s0DyHeEwpADuXcCY6rB9tmn4rk
         fk6Ixp4+49XoYxvVlcOQUHEJlgM7bE9pQk580vjwbdaCmdkrxyhiHgtsHW0eAPqkHwVT
         JoamjRt7sGG1WqMTzZeEJrSnVP6vmLx6ffMwFIMTpI2VQG8fH+uKjOhSPPLZdNe7DEYX
         G8bg==
X-Gm-Message-State: AC+VfDyYxFE3T2uW9YnKlJLmf7kyluytgawYWx+de8zCIE97AYUoqeyQ
        hEj9QabgQI96dtCtwmIsbLda/OOn0oPn3CwgscjASQZKj2b3ArMr/Gqm4X1XCxDmVSB4v6+kDoJ
        oL6ftsyc6eyJsKzi/3TED
X-Received: by 2002:ad4:5d44:0:b0:5fd:93b7:5a96 with SMTP id jk4-20020ad45d44000000b005fd93b75a96mr59124186qvb.26.1684163275206;
        Mon, 15 May 2023 08:07:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5fM0kDXOeCHFTDqAarNE23N9hNNNP5tvo5fd6QQkUS51uAPuJy+nC99z887hxJo0oAeeDkJQ==
X-Received: by 2002:ad4:5d44:0:b0:5fd:93b7:5a96 with SMTP id jk4-20020ad45d44000000b005fd93b75a96mr59124143qvb.26.1684163274928;
        Mon, 15 May 2023 08:07:54 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id z24-20020ae9c118000000b0075935a24760sm1484836qki.136.2023.05.15.08.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 08:07:53 -0700 (PDT)
Date:   Mon, 15 May 2023 11:10:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [RFCv5 3/5] iomap: Add iop's uptodate state handling functions
Message-ID: <ZGJLXcTkzdyHY25d@bfoster>
References: <cover.1683485700.git.ritesh.list@gmail.com>
 <5372f29f986052f37b45c368a0eb8eed25eb8fdb.1683485700.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5372f29f986052f37b45c368a0eb8eed25eb8fdb.1683485700.git.ritesh.list@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 08, 2023 at 12:57:58AM +0530, Ritesh Harjani (IBM) wrote:
> Firstly this patch renames iop->uptodate to iop->state bitmap.
> This is because we will add dirty state to iop->state bitmap in later
> patches. So it makes sense to rename the iop->uptodate bitmap to
> iop->state.
> 
> Secondly this patch also adds other helpers for uptodate state bitmap
> handling of iop->state.
> 
> No functionality change in this patch.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  fs/iomap/buffered-io.c | 78 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 58 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index e732581dc2d4..5103b644e115 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
...
> @@ -43,6 +43,47 @@ static inline struct iomap_page *to_iomap_page(struct folio *folio)
...
> +/*
> + * iop related helpers for checking uptodate/dirty state of per-block
> + * or range of blocks within a folio
> + */
> +static bool iop_test_full_uptodate(struct folio *folio)
> +{
> +	struct iomap_page *iop = to_iomap_page(folio);
> +	struct inode *inode = folio->mapping->host;
> +
> +	WARN_ON(!iop);

It looks like an oops or something is imminent here if iop is NULL. Why
the warn (here and in a couple other places)?

Brian

> +	return iop_bitmap_full(iop, i_blocks_per_folio(inode, folio));
> +}
> +
> +static bool iop_test_block_uptodate(struct folio *folio, unsigned int block)
> +{
> +	struct iomap_page *iop = to_iomap_page(folio);
> +
> +	WARN_ON(!iop);
> +	return iop_test_block(iop, block);
> +}
> +
>  static void iop_set_range_uptodate(struct inode *inode, struct folio *folio,
>  				   size_t off, size_t len)
>  {
> @@ -53,12 +94,11 @@ static void iop_set_range_uptodate(struct inode *inode, struct folio *folio,
>  	unsigned long flags;
>  
>  	if (iop) {
> -		spin_lock_irqsave(&iop->uptodate_lock, flags);
> -		bitmap_set(iop->uptodate, first_blk, nr_blks);
> -		if (bitmap_full(iop->uptodate,
> -				i_blocks_per_folio(inode, folio)))
> +		spin_lock_irqsave(&iop->state_lock, flags);
> +		iop_set_range(iop, first_blk, nr_blks);
> +		if (iop_test_full_uptodate(folio))
>  			folio_mark_uptodate(folio);
> -		spin_unlock_irqrestore(&iop->uptodate_lock, flags);
> +		spin_unlock_irqrestore(&iop->state_lock, flags);
>  	} else {
>  		folio_mark_uptodate(folio);
>  	}
> @@ -79,12 +119,12 @@ static struct iomap_page *iop_alloc(struct inode *inode, struct folio *folio,
>  	else
>  		gfp = GFP_NOFS | __GFP_NOFAIL;
>  
> -	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
> +	iop = kzalloc(struct_size(iop, state, BITS_TO_LONGS(nr_blocks)),
>  		      gfp);
>  	if (iop) {
> -		spin_lock_init(&iop->uptodate_lock);
> +		spin_lock_init(&iop->state_lock);
>  		if (folio_test_uptodate(folio))
> -			bitmap_fill(iop->uptodate, nr_blocks);
> +			iop_set_range(iop, 0, nr_blocks);
>  		folio_attach_private(folio, iop);
>  	}
>  	return iop;
> @@ -93,15 +133,13 @@ static struct iomap_page *iop_alloc(struct inode *inode, struct folio *folio,
>  static void iop_free(struct folio *folio)
>  {
>  	struct iomap_page *iop = to_iomap_page(folio);
> -	struct inode *inode = folio->mapping->host;
> -	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
>  
>  	if (!iop)
>  		return;
>  	WARN_ON_ONCE(atomic_read(&iop->read_bytes_pending));
>  	WARN_ON_ONCE(atomic_read(&iop->write_bytes_pending));
> -	WARN_ON_ONCE(bitmap_full(iop->uptodate, nr_blocks) !=
> -			folio_test_uptodate(folio));
> +	WARN_ON_ONCE(iop_test_full_uptodate(folio) !=
> +		     folio_test_uptodate(folio));
>  	folio_detach_private(folio);
>  	kfree(iop);
>  }
> @@ -132,7 +170,7 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
>  
>  		/* move forward for each leading block marked uptodate */
>  		for (i = first; i <= last; i++) {
> -			if (!test_bit(i, iop->uptodate))
> +			if (!iop_test_block_uptodate(folio, i))
>  				break;
>  			*pos += block_size;
>  			poff += block_size;
> @@ -142,7 +180,7 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
>  
>  		/* truncate len if we find any trailing uptodate block(s) */
>  		for ( ; i <= last; i++) {
> -			if (test_bit(i, iop->uptodate)) {
> +			if (iop_test_block_uptodate(folio, i)) {
>  				plen -= (last - i + 1) * block_size;
>  				last = i - 1;
>  				break;
> @@ -450,7 +488,7 @@ bool iomap_is_partially_uptodate(struct folio *folio, size_t from, size_t count)
>  	last = (from + count - 1) >> inode->i_blkbits;
>  
>  	for (i = first; i <= last; i++)
> -		if (!test_bit(i, iop->uptodate))
> +		if (!iop_test_block_uptodate(folio, i))
>  			return false;
>  	return true;
>  }
> @@ -1634,7 +1672,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  	 * invalid, grab a new one.
>  	 */
>  	for (i = 0; i < nblocks && pos < end_pos; i++, pos += len) {
> -		if (iop && !test_bit(i, iop->uptodate))
> +		if (iop && !iop_test_block_uptodate(folio, i))
>  			continue;
>  
>  		error = wpc->ops->map_blocks(wpc, inode, pos);
> -- 
> 2.39.2
> 

