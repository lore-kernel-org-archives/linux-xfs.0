Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38465C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11F6B22BEF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389590AbhAKRde (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbhAKRdd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 12:33:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C735C061794
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 09:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z9GPfqtyXo0xTkAyAVH5YsAENFM3PxDe2QC1iNpPM50=; b=gat0549BoNBq6WkEAEzkJzutjs
        8VOQUo/0iyLBuiX6MK6AcQ9jZO+5AsZ61N/rHI7LwxgxnJhDoR45sgp+901C3XXIlqmowweBWJWi3
        SFFhyyV1dsEF4Kq/D3fqG0yYk3kR0ihnU1+wliieiZ/ZpdzfGx8uX45ovUwCuDpV2oJlf6JWY918C
        0TVKHC3qSg4chKMAu84y6msDbu1zAM7HbMWLMuwi5Y+Rqx1N3L2MdQlNqfij42s1ZNM+3Qxwuz3AR
        5lT7gY0Crkaxd6wYb7fQR2hrzTJX3D7KB1LSs570neJ95Vkx9d7Sfx1iZdGc81tUk0gyYQu/zxsHo
        pr83Ih0w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kz13h-003Z3u-LW; Mon, 11 Jan 2021 17:32:50 +0000
Date:   Mon, 11 Jan 2021 17:32:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 3/4] xfs: hoist out xfs_resizefs_init_new_ags()
Message-ID: <20210111173249.GC848188@infradead.org>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108190919.623672-4-hsiangkao@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	xfs_mount_t		*mp,

Please use the struct type here.

> +	/*
> +	 * Write new AG headers to disk. Non-transactional, but need to be
> +	 * written and completed prior to the growfs transaction being logged.
> +	 * To do this, we use a delayed write buffer list and wait for
> +	 * submission and IO completion of the list as a whole. This allows the
> +	 * IO subsystem to merge all the AG headers in a single AG into a single
> +	 * IO and hide most of the latency of the IO from us.
> +	 *
> +	 * This also means that if we get an error whilst building the buffer
> +	 * list to write, we can cancel the entire list without having written
> +	 * anything.
> +	 */

Maybe move the comment on top of the whole function, as it really
explains what the function does.

