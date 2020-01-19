Return-Path: <SRS0=5eVt=3I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FC0C32771
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 02:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 620C72468C
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 02:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgASCvx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 21:51:53 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60552 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727573AbgASCvx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 18 Jan 2020 21:51:53 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2D13A706A1201A9528AE;
        Sun, 19 Jan 2020 10:51:48 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sun, 19 Jan 2020
 10:51:38 +0800
Subject: Re: [RFC] iomap: fix race between readahead and direct write
To:     Matthew Wilcox <willy@infradead.org>
CC:     <hch@infradead.org>, <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <houtao1@huawei.com>,
        <zhengbin13@huawei.com>, <yi.zhang@huawei.com>
References: <20200116063601.39201-1-yukuai3@huawei.com>
 <20200118230826.GA5583@bombadil.infradead.org>
 <f5328338-1a2d-38b4-283f-3fb97ad37133@huawei.com>
 <20200119014213.GA16943@bombadil.infradead.org>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <64d617cc-e7fe-6848-03bb-aab3498c9a07@huawei.com>
Date:   Sun, 19 Jan 2020 10:51:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200119014213.GA16943@bombadil.infradead.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/1/19 9:42, Matthew Wilcox wrote:
> Did you read my patch series?  The current code allocates pages,
> but does not put them in the page cache until after iomap is called.
> My patch series changes that to put the pages in the page cache as soon
> as they're allocated, and before iomap is called.

I just read you patch series again.

At first, if you try to add all pages to pagecache and lock them before
iomap_begin. I thought aboult it before, but I throw away the idea
becacuse all other operation that will lock the page will need to wait
for readahead to finish. And it might cause problem for performance
overhead. And if you try to add each page to page cache and call iomap
before adding the next page. Then, we are facing the same CPU overhead
issure.

Then, there might be a problem in your implementation.
if 'use_list' is set to true here:
+	bool use_list = mapping->a_ops->readpages;

Your code do not call add_to_page_cache_lru for the page.
+		if (use_list) {
+			page->index = page_offset;
+			list_add(&page->lru, &page_pool);
+		} else if (!add_to_page_cache_lru(page, mapping, page_offset,
+					gfp_mask)) {
+			if (nr_pages)
+				read_pages(mapping, filp, &page_pool,
+						page_offset - nr_pages,
+						nr_pages);
+			nr_pages = 0;
+			continue;
+		}

And later, you replace 'iomap_next_page' with 'readahead_page'
+static inline
+struct page *readahead_page(struct address_space *mapping, loff_t pos)
+{
+	struct page *page = xa_load(&mapping->i_pages, pos / PAGE_SIZE);
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+
+	return page;
+}
+

It seems that the page will never add to page cache.

Thanks!
Yu Kuai

