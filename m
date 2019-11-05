Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F1DCA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 03:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC80F214D8
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 03:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbfKEDIO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 22:08:14 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6149 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727861AbfKEDIO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 22:08:14 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E69B818E32CC7FF4FE48;
        Tue,  5 Nov 2019 11:08:11 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 5 Nov 2019
 11:08:01 +0800
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
To:     Christoph Hellwig <hch@infradead.org>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191104152517.GD10485@infradead.org>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <c2c0ccb7-64c9-4549-6683-0984073ccd0b@hisilicon.com>
Date:   Tue, 5 Nov 2019 11:08:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20191104152517.GD10485@infradead.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On 2019/11/4 23:25, Christoph Hellwig wrote:
> On Mon, Nov 04, 2019 at 07:29:40PM +0800, Shaokun Zhang wrote:
>> From: Yang Guo <guoyang2@huawei.com>
>>
>> percpu_counter_compare will be called by xfs_mod_icount/ifree to check
>> whether the counter less than 0 and it is a expensive function.
>> let's check it only when delta < 0, it will be good for xfs's performance.
> 
> How much overhead do you see?  In the end the compare is just a debug

Thanks your reply, sorry for my not clear description.
__percpu_counter_compare itself is not expensive, but __percpu_counter_sum
called by __percpu_counter_compare is high load, I will list it in next thread.

> check, so if it actually shows up we should remove it entirely.
> 

I'm not sure about it, so I check the delta to do less modification.

Thanks,
Shaokun

> 

