Return-Path: <SRS0=7iaS=VP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC25C76191
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jul 2019 13:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E011020880
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jul 2019 13:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfGRN1z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jul 2019 09:27:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33156 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfGRN1z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jul 2019 09:27:55 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E362C92388982DDB1E24;
        Thu, 18 Jul 2019 21:27:51 +0800 (CST)
Received: from [10.151.23.176] (10.151.23.176) by smtp.huawei.com
 (10.3.19.202) with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 18 Jul
 2019 21:27:42 +0800
Subject: Re: [RFC PATCH] iomap: generalize IOMAP_INLINE to cover tail-packing
 case
To:     Christoph Hellwig <hch@infradead.org>
CC:     Andreas Gruenbacher <agruenba@redhat.com>,
        Chao Yu <yuchao0@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <chao@kernel.org>
References: <20190703075502.79782-1-yuchao0@huawei.com>
 <CAHpGcM+s77hKMXo=66nWNF7YKa3qhLY9bZrdb4-Lkspyg2CCDw@mail.gmail.com>
 <39944e50-5888-f900-1954-91be2b12ea5b@huawei.com>
 <20190711122831.3970-1-agruenba@redhat.com>
 <20190718123155.GA21252@infradead.org>
From:   Gao Xiang <gaoxiang25@huawei.com>
Message-ID: <cb859e68-1f7f-48a6-593b-4047963086ba@huawei.com>
Date:   Thu, 18 Jul 2019 21:27:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190718123155.GA21252@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.151.23.176]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20190718132741.OhpdLdSgoQyLrdWahb9_BgaIR-rsauZRG7E18TMDJGo@z>



On 2019/7/18 20:31, Christoph Hellwig wrote:
> That being said until the tail packing fs (erofs?) actually uses
> buffer_heads we should not need this hunk, and I don't think erofs
> should have any reason to use buffer_heads.

Yes, erofs will not use buffer_head to support sub-page blocksize
in the long term. too heavy and no need...

Thanks,
Gao Xiang
