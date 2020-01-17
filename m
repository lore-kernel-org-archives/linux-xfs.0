Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D89DC33CB6
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 02:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F9DC207FF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 02:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgAQCUi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 21:20:38 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:48054 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729113AbgAQCUi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Jan 2020 21:20:38 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3C40C41464A385DAC902;
        Fri, 17 Jan 2020 10:20:36 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 10:20:27 +0800
Subject: Re: [PATCH] xfs/126: fix that corrupt xattr might fail with a small
 probability
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <guaneryu@gmail.com>, <jbacik@fusionio.com>,
        <fstests@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <zhengbin13@huawei.com>, <yi.zhang@huawei.com>
References: <20200108092758.41363-1-yukuai3@huawei.com>
 <20200108162227.GD5552@magnolia>
 <3c7e9497-e0ed-23e4-ff9c-4b1c1a77c9fa@huawei.com>
 <20200109164615.GA8247@magnolia>
 <51e99fd5-617f-6558-7a04-c4a198139cdd@huawei.com>
 <20200116160323.GC2149943@magnolia>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <bc9afd0d-91e5-ef0a-94cb-599b8a57b136@huawei.com>
Date:   Fri, 17 Jan 2020 10:20:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200116160323.GC2149943@magnolia>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/1/17 0:03, Darrick J. Wong wrote:
> Does adding "-o 4" to the blocktrash command make it work reliably?
> That should be close enough to the start of the attrleaf block that
> we'll reliably corrupt*some*  amount of stuff in the header.

Seems like a good idea!
After adding "-o 4", I tested over 200 times, and blocktrash never 
failed to corrupt xattr anymore.

Thanks!
Yu Kuai

