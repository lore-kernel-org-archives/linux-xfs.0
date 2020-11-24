Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B151C2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 12:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD02F2076B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 12:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgKXMF5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 07:05:57 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8026 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733119AbgKXMF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 07:05:57 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CgN5B1s45zhXqD;
        Tue, 24 Nov 2020 20:05:34 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.208) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 24 Nov 2020
 20:05:52 +0800
Subject: Re: [PATCH 2/2] xfs: remove the extra processing of zero size in
 xfs_idata_realloc()
To:     Christoph Hellwig <hch@infradead.org>
CC:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20201124104531.561-1-thunder.leizhen@huawei.com>
 <20201124104531.561-3-thunder.leizhen@huawei.com>
 <20201124115232.GC32060@infradead.org>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <e5f4527c-f110-f373-5e17-7decb5aea722@huawei.com>
Date:   Tue, 24 Nov 2020 20:05:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20201124115232.GC32060@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.208]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/11/24 19:52, Christoph Hellwig wrote:
> On Tue, Nov 24, 2020 at 06:45:31PM +0800, Zhen Lei wrote:
>> krealloc() does the free operation when the parameter new_size is 0, with
>> ZERO_SIZE_PTR returned. Because all other places use NULL to check whether
>> if_data is available or not, so covert it from ZERO_SIZE_PTR to NULL.
> 
> This new code looks much harder to read than the version it replaced.

OK

> 
> 

