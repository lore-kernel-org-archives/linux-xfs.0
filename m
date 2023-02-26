Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A27BC64ED6
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Feb 2023 23:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBZXM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBZXMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Feb 2023 18:12:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B621167C;
        Sun, 26 Feb 2023 15:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9R57lHZt77GG1sD2Fg/H6D+IgfEI4t7AC9sTlWVCIvI=; b=DZT9fR1pkl+6QXSJ7/oUSV0qzj
        9XsTl6GJfkexFt89OVnP9X5+vtukfaHFDck+t1zyn8py86pTxcKq+w4uJvH1mCjtlX2YLi9S7nVxJ
        FSFxN/oSUTjcfPx+581jiPeVd6fdAce7DBKFFkUoCMUTA7GAEQjqzYuWbhIdLpCQtvtay7GVhZjv1
        YqzxPIk6rYaQGtROWy8yz4oVsr3jSqqovYX8Dz9CSYZ3uUgx0FfGV+iIPZ1BuzZhO87Lkj1JAX/Ah
        W3eDArobCPUFkTSxrsVaSxA+4G+NzQzoHCI86+Z/aZ2FoDfcFUd9DHYuwlpUhCgS5rN7Re8ddX9PX
        2Y+LO7dQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pWQCD-00HEIV-IM; Sun, 26 Feb 2023 23:12:45 +0000
Date:   Sun, 26 Feb 2023 23:12:45 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFCv3 1/3] iomap: Allocate iop in ->write_begin() early
Message-ID: <Y/vnbc5A1InqhzWt@casper.infradead.org>
References: <cover.1677428794.git.ritesh.list@gmail.com>
 <34dafb5e15dba3bb0b0e072404ac6fb9f11561b8.1677428794.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34dafb5e15dba3bb0b0e072404ac6fb9f11561b8.1677428794.git.ritesh.list@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 27, 2023 at 01:13:30AM +0530, Ritesh Harjani (IBM) wrote:
> +++ b/fs/iomap/buffered-io.c
> @@ -535,11 +535,16 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  	size_t from = offset_in_folio(folio, pos), to = from + len;
>  	size_t poff, plen;
>  
> +	if (pos <= folio_pos(folio) &&
> +	    pos + len >= folio_pos(folio) + folio_size(folio))
> +		return 0;
> +
> +	iop = iomap_page_create(iter->inode, folio, iter->flags);
> +
>  	if (folio_test_uptodate(folio))
>  		return 0;
>  	folio_clear_error(folio);
>  
> -	iop = iomap_page_create(iter->inode, folio, iter->flags);
>  	if ((iter->flags & IOMAP_NOWAIT) && !iop && nr_blocks > 1)
>  		return -EAGAIN;

Don't you want to move the -EAGAIN check up too?  Otherwise an
io_uring write will dirty the entire folio rather than a block.

It occurs to me (even though I was the one who suggested the current
check) that pos <= folio_pos etc is actually a bit tighter than
necessary.  We could get away with:

	if (pos < folio_pos(folio) + block_size &&
	    pos + len > folio_pos(folio) + folio_size(folio) - block_size)

since that will also cause the entire folio to be dirtied.  Not sure if
it's worth it.
