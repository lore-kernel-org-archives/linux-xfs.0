Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24FBC32771
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 02:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E9D52075A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 02:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgAGCJ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jan 2020 21:09:58 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:41500 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727250AbgAGCJ6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Jan 2020 21:09:58 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C36D1DC97F6905CA2BEE;
        Tue,  7 Jan 2020 10:09:55 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 7 Jan 2020
 10:09:45 +0800
Subject: Re: [PATCH 2/2] xfs: fix stale data exposure problem when punch hole,
 collapse range or zero range across a delalloc extent
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <bfoster@redhat.com>, <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <cmaiolino@redhat.com>, <hch@lst.de>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zhengbin13@huawei.com>,
        <yi.zhang@huawei.com>, <houtao1@huawei.com>
References: <20191226134721.43797-1-yukuai3@huawei.com>
 <20191226134721.43797-3-yukuai3@huawei.com>
 <20200106215755.GB472651@magnolia>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <f4bf9490-0476-3a6a-55e0-786186669c6c@huawei.com>
Date:   Tue, 7 Jan 2020 10:09:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200106215755.GB472651@magnolia>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/1/7 5:57, Darrick J. Wong wrote:
> So your solution is to split the delalloc reservation to constrain the
> allocation to the range that's being operated on?
Yes, I'm trying to split delalloc reservation.
> 
> If so, I think a better solution (at least from the perspective of
> reducing fragmentation) would be to map the extent unwritten and force a
> post-writeback conversion[1] but I got shot down for performance reasons
> the last time I suggested that.
I'm wondering if spliting delalloc reservation have the same performance 
issue.

Thanks!
Yu Kuai

