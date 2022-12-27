Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0870C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Dec 2022 03:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiL0Dmr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Dec 2022 22:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiL0Dmp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Dec 2022 22:42:45 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7D3616B
        for <linux-xfs@vger.kernel.org>; Mon, 26 Dec 2022 19:42:43 -0800 (PST)
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Nh0jb3p4HzqTHS;
        Tue, 27 Dec 2022 11:38:11 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 27 Dec 2022 11:42:41 +0800
Message-ID: <15de176d-7150-5b7c-eb1b-8b13ba9c60c5@huawei.com>
Date:   Tue, 27 Dec 2022 11:42:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] xfs: Fix deadlock on xfs_inodegc_queue
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
        <guoxuenan@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
References: <2eebcc2b-f4d4-594b-d05e-e2520d26b4c6@huawei.com>
 <20221226112300.GN1971568@dread.disaster.area>
From:   Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <20221226112300.GN1971568@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2022/12/26 19:23, Dave Chinner 写道:

> 
> Yup, but did you notice that xfs_trans_alloc() is doing GFP_KERNEL
> allocation from a context that is doing filesystem work on behalf of
> memory reclaim?
> 
> The right fix is to make the inodegc workers use
> memalloc_nofs_save() context, similar to what is done in
> xfs_end_ioend(), as both the IO completion workers and the inodegc
> workers can be doing work on behalf of memory reclaim....
> 
Yes, you're right, this does solve the problem. Dave, Thanks for the explanation.
I will send V2 patch.

> -Dave.
> 
