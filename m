Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA76C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4421C20758
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UgIVZjv7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgHQGv0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 02:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgHQGvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 02:51:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7153C061388
        for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2020 23:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nxocjBN1g76Ev0BphMiEupUjfJ0rNMrExH6SvYA4EzU=; b=UgIVZjv7d7o5AuoSKsTWXHNyqO
        QGGAm4jxFM/tX58lI40lCcCasyB10kUKoADZYgPzj8/OrNUcH4cxKRRVLYyhz/I9c6eFRacC78rIu
        nvHhGYhyvsU+aKwjAflP9ASJk90PIEOzl6lpJlRXpZYHy9O9UhaeCK5G6SSos1SPaduyy9YvUxcZh
        cB2iDmu9vWnbSBao7iLmrZprqYH34KeKW43V1eQ1tKNZfwIbhD/4t2ttjgJTePC4KPmIDjUBzei5j
        Cs7IKNT39hfZO94xEGzBN2x5L9EJmkA8OYR/Zo7a5qdYgRaNoEJSZNCfT5t0gj4cQD6eDoTpX/SkL
        f3EQ/CNg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7YzL-0006TQ-BW; Mon, 17 Aug 2020 06:51:23 +0000
Date:   Mon, 17 Aug 2020 07:51:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V2 01/10] xfs: Add helper for checking per-inode extent
 count overflow
Message-ID: <20200817065123.GA23516@infradead.org>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
 <20200814080833.84760-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814080833.84760-2-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +int
> +xfs_iext_count_may_overflow(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	int			nr_to_add)
> +{
> +	struct xfs_ifork	*ifp;
> +	uint64_t		max_exts = 0;
> +	uint64_t		nr_exts;
> +
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +		max_exts = MAXEXTNUM;
> +		break;
> +
> +	case XFS_ATTR_FORK:
> +		max_exts = MAXAEXTNUM;
> +		break;
> +
> +	default:
> +		ASSERT(0);
> +		break;
> +	}
> +
> +	ifp = XFS_IFORK_PTR(ip, whichfork);
> +	nr_exts = ifp->if_nextents + nr_to_add;
> +
> +	if (nr_exts > max_exts)
> +		return -EFBIG;
> +
> +	return 0;
> +}

Maybe it's just me, but I would structure this very different (just
cosmetic differences, though).  First add a:

static inline uint32_t xfs_max_extents(int whichfork)
{
	return XFS_ATTR_FORK ? MAXAEXTNUM : MAXEXTNUM;
}

to have a single place that determines the max number of extents.

And the simplify the helper down to:

int
xfs_iext_count_may_overflow(
	struct xfs_inode	*ip,
	int			whichfork,
	int			nr_to_add)
{
	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
	uint64_t		max_exts = xfs_max_extents(whichfork);
	uint64_t		nr_exts;

	if (check_add_overflow(ifp->if_nextents, nr_to_add, &nr_exts) ||
	    nr_exts > max_exts))
		return -EFBIG;
	return 0;
}

which actually might be small enough for an inline function now.
