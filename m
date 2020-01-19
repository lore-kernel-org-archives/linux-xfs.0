Return-Path: <SRS0=5eVt=3I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE887C32771
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 03:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA5122082F
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 03:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgASDPa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 22:15:30 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9661 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726827AbgASDPa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 18 Jan 2020 22:15:30 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B9E93D6B0EE9A4D5440E;
        Sun, 19 Jan 2020 11:15:27 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sun, 19 Jan 2020
 11:15:19 +0800
Subject: Re: [RFC] iomap: fix race between readahead and direct write
To:     Gao Xiang <gaoxiang25@huawei.com>
CC:     Matthew Wilcox <willy@infradead.org>, <hch@infradead.org>,
        <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <houtao1@huawei.com>, <zhengbin13@huawei.com>,
        <yi.zhang@huawei.com>
References: <20200116063601.39201-1-yukuai3@huawei.com>
 <20200118230826.GA5583@bombadil.infradead.org>
 <f5328338-1a2d-38b4-283f-3fb97ad37133@huawei.com>
 <20200119014213.GA16943@bombadil.infradead.org>
 <64d617cc-e7fe-6848-03bb-aab3498c9a07@huawei.com>
 <20200119030123.GA223124@architecture4>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <b5ac76bd-567f-2a39-3be1-04e0ed136278@huawei.com>
Date:   Sun, 19 Jan 2020 11:15:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200119030123.GA223124@architecture4>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/1/19 11:01, Gao Xiang wrote:
> IMO, if use_list == true, it will call read_pages -> .readpages
> and go just like the current implementation.

The problem is that in the current implementatin, iomap_next_page()
add page to page cache and it is replaced with readahead_page()

Thanks!
Yu Kuai

