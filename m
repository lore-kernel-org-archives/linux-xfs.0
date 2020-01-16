Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA24AC33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 12:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AEEB21582
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 12:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgAPMWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 07:22:14 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:55684 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726018AbgAPMWO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Jan 2020 07:22:14 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3D94B96F6DDE0750BD2E;
        Thu, 16 Jan 2020 20:22:08 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 Jan 2020
 20:22:01 +0800
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
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <51e99fd5-617f-6558-7a04-c4a198139cdd@huawei.com>
Date:   Thu, 16 Jan 2020 20:22:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200109164615.GA8247@magnolia>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



ON 2020/1/10 0:46, Darrick J. Wong wrote:
> It sounds like a reasonable idea, though I was suggesting doing the
> snapshot-and-check in the xfs_db source, not fstests.

The problem is that blocktrash do changed some bits of the attr block,
however, corrupt will still fail if the change is only inside the 'zero'
range.

So, I think it's hard to fix the problem by doing the snapshot-and-check
in the xfs_db source.

Thanks!
Yu Kuai

