Return-Path: <SRS0=myhp=BJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5E6C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 02:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5BAF22B48
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 02:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c3i5eMxv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgG3C1z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 22:27:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36053 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726353AbgG3C1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 22:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596076072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mVpH86nrp4dZZcn3Jtx63a1hxKRGCJ0Vr4RI3jcWe6I=;
        b=c3i5eMxviBvzhAI5UbmF2EDW8WB0OhnWZWqFpxN+JsNg5ixqKUqOAE7mU43GoR52rGhKfC
        jU8KBU8vxKlzJk5bNNZOLVHe+1aMnmYw8NwvVzjBLWUDcGZGUM7LKcOa8O4UShRTs5E3Dp
        sORZJ/DeRIiD53f1o8YlDdmFVGYov0o=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-e7P0pxUAPuC0lEdX9tK6yQ-1; Wed, 29 Jul 2020 22:27:49 -0400
X-MC-Unique: e7P0pxUAPuC0lEdX9tK6yQ-1
Received: by mail-pg1-f199.google.com with SMTP id i1so19893558pgn.13
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 19:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mVpH86nrp4dZZcn3Jtx63a1hxKRGCJ0Vr4RI3jcWe6I=;
        b=Gyll4a+KFBwVzJQDHtlu41riiFNMt3+AlQ6nHD97ezxvRTQjiYtMcj6YZ0r/bJgplv
         dv6EJtAfuoZ1T0I4AEDpTD34S1JYS/ii1CmZTmn75u3sDyfseG6ktUK78xNPW3/6UY8b
         +Yyp2pItUF9peivSMkK6vniJuTYH0a+ylfCvQ1F2nBreWxB7vjLkljO5p2a5oXb9AJVa
         pPC6EkoTroX5NzId9ipT9i7RUHnEu0i5GkjVZg++J8CJGJEMsIs9qqGduQ9PSQErgTf5
         x0Rf3bAH19c453VxLaz1y2KZsDigMa6XQc4p1bZpHFNnfjqH0Puch19K5YEQm4E6QmFV
         Nm5Q==
X-Gm-Message-State: AOAM533oquboQYlKwdwPcD/adllPfnspNOijt6irdPK54CXiSkKr2grM
        N8I5NPTRdRAoxYzDwUs+RPwVhRElBth6u9K43e9WwIlwE4Sortx2KP4ppLE2g53HpmSlKD5w4dS
        hTLaY+2G191W1LNy5gYs/
X-Received: by 2002:a17:90b:3805:: with SMTP id mq5mr816820pjb.94.1596076068812;
        Wed, 29 Jul 2020 19:27:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXYnYX753dycaDyvSqN8KadG5qbAQ+i8wCUG8dvGmpGgJUHiu2RKAEtXiyQUAxyrq5XYYzgQ==
X-Received: by 2002:a17:90b:3805:: with SMTP id mq5mr816795pjb.94.1596076068370;
        Wed, 29 Jul 2020 19:27:48 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j13sm3943995pfa.149.2020.07.29.19.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 19:27:47 -0700 (PDT)
Date:   Thu, 30 Jul 2020 10:27:36 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     hch@infradead.org, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [RFC PATCH] iomap: add support to track dirty state of sub pages
Message-ID: <20200730022736.GA23366@xiangao.remote.csb>
References: <20200730011901.2840886-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730011901.2840886-1-yukuai3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Kuai,

On Thu, Jul 30, 2020 at 09:19:01AM +0800, Yu Kuai wrote:
> commit 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O
> without buffer heads") replace the per-block structure buffer_head with
> the per-page structure iomap_page. However, iomap_page can't track the
> dirty state of sub pages, which will cause performance issue since sub
> pages will be writeback even if they are not dirty.
> 
> For example, if block size is 4k and page size is 64k:
> 
> dd if=/dev/zero of=testfile bs=4k count=16 oflag=sync
> 
> With buffer_head implementation, the above dd cmd will writeback 4k in
> each round. However, with iomap_page implementation, the range of
> writeback in each round is from the start of the page to the end offset
> we just wrote.
> 
> Thus add support to track dirty state for sub pages in iomap_page.

AFAIK, the current focus is also on the numbers in the original
discussion thread, so it'd be better to show some numbers with
large PAGE_SIZE on this with some workloads as well.

https://lore.kernel.org/r/20200729230503.GA2005@dread.disaster.area

e.g. My guess is if the dirty blocks in the page are highly fragmented, maybe
it'd be better to writeback the whole page in an IO rather than individual blocks.

At a very quick glance, the approach looks good to me.

Thanks,
Gao Xiang

> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  fs/iomap/buffered-io.c | 51 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index bcfc288dba3f..ac2676146b98 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -29,7 +29,9 @@ struct iomap_page {
>  	atomic_t		read_count;
>  	atomic_t		write_count;
>  	spinlock_t		uptodate_lock;
> +	spinlock_t		dirty_lock;
>  	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
> +	DECLARE_BITMAP(dirty, PAGE_SIZE / 512);
>  };
>  
>  static inline struct iomap_page *to_iomap_page(struct page *page)
> @@ -53,7 +55,9 @@ iomap_page_create(struct inode *inode, struct page *page)
>  	atomic_set(&iop->read_count, 0);
>  	atomic_set(&iop->write_count, 0);
>  	spin_lock_init(&iop->uptodate_lock);
> +	spin_lock_init(&iop->dirty_lock);
>  	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
> +	bitmap_zero(iop->dirty, PAGE_SIZE / SECTOR_SIZE);
>  
>  	/*
>  	 * migrate_page_move_mapping() assumes that pages with private data have
> @@ -135,6 +139,44 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
>  	*lenp = plen;
>  }
>  
> +static void
> +iomap_iop_set_or_clear_range_dirty(
> +	struct page *page,
> +	unsigned int off,
> +	unsigned int len,
> +	bool is_set)
> +{
> +	struct iomap_page *iop = to_iomap_page(page);
> +	struct inode *inode = page->mapping->host;
> +	unsigned int first = off >> inode->i_blkbits;
> +	unsigned int last = (off + len - 1) >> inode->i_blkbits;
> +	unsigned long flags;
> +	unsigned int i;
> +
> +	spin_lock_irqsave(&iop->dirty_lock, flags);
> +	for (i = first; i <= last; i++)
> +		if (is_set)
> +			set_bit(i, iop->dirty);
> +		else
> +			clear_bit(i, iop->dirty);
> +	spin_unlock_irqrestore(&iop->dirty_lock, flags);
> +}
> +
> +static void
> +iomap_set_or_clear_range_dirty(
> +	struct page *page,
> +	unsigned int off,
> +	unsigned int len,
> +	bool is_set)
> +{
> +	if (PageError(page))
> +		return;
> +
> +	if (page_has_private(page))
> +		iomap_iop_set_or_clear_range_dirty(
> +			page, off, len, is_set);
3> +}
> +
>  static void
>  iomap_iop_set_range_uptodate(struct page *page, unsigned off, unsigned len)
>  {
> @@ -705,6 +747,8 @@ __iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
>  	if (unlikely(copied < len && !PageUptodate(page)))
>  		return 0;
>  	iomap_set_range_uptodate(page, offset_in_page(pos), len);
> +	iomap_set_or_clear_range_dirty(
> +		page, offset_in_page(pos), len, true);
>  	iomap_set_page_dirty(page);
>  	return copied;
>  }
> @@ -1030,6 +1074,8 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
>  		WARN_ON_ONCE(!PageUptodate(page));
>  		iomap_page_create(inode, page);
>  		set_page_dirty(page);
> +		iomap_set_or_clear_range_dirty(
> +			page, offset_in_page(pos), length, true);
>  	}
>  
>  	return length;
> @@ -1386,7 +1432,8 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  	for (i = 0, file_offset = page_offset(page);
>  	     i < (PAGE_SIZE >> inode->i_blkbits) && file_offset < end_offset;
>  	     i++, file_offset += len) {
> -		if (iop && !test_bit(i, iop->uptodate))
> +		if (iop && (!test_bit(i, iop->uptodate) ||
> +		    !test_bit(i, iop->dirty)))
>  			continue;
>  
>  		error = wpc->ops->map_blocks(wpc, inode, file_offset);
> @@ -1435,6 +1482,8 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  		 */
>  		set_page_writeback_keepwrite(page);
>  	} else {
> +		iomap_set_or_clear_range_dirty(
> +			page, 0, end_offset - page_offset(page) + 1, false);
>  		clear_page_dirty_for_io(page);
>  		set_page_writeback(page);
>  	}
> -- 
> 2.25.4
> 

