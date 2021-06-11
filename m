Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE75EC48BD1
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 12:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88D99613E9
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 12:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhFKMMe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 08:12:34 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4038 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhFKMMd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 08:12:33 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1fgR0gFdzWtX7;
        Fri, 11 Jun 2021 20:05:39 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 20:10:33 +0800
Received: from [10.174.179.215] (10.174.179.215) by
 dggema769-chm.china.huawei.com (10.1.198.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 20:10:33 +0800
Subject: Re: [PATCH -next] xfs: Fix -Wunused-variable warning
To:     <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
        <dchinner@redhat.com>
CC:     <linux-kernel@vger.kernel.org>
References: <20210611115950.32588-1-yuehaibing@huawei.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <c36787f3-862e-62af-065b-a13d3a1db054@huawei.com>
Date:   Fri, 11 Jun 2021 20:10:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210611115950.32588-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PLS ignore this.

On 2021/6/11 19:59, YueHaibing wrote:
> If DEBUG is n, gcc warns:
> 
> fs/xfs/libxfs/xfs_ialloc.c:2032:20: warning: unused variable ‘agi’ [-Wunused-variable]
> 
> Move it info #ifdef block to fix this.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 2ed6de6faf8a..a9973edd3c0a 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2029,7 +2029,9 @@ xfs_difree_finobt(
>  	xfs_agino_t			agino,
>  	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
>  {
> +#ifdef DEBUG
>  	struct xfs_agi			*agi = agbp->b_addr;
> +#endif
>  	struct xfs_btree_cur		*cur;
>  	struct xfs_inobt_rec_incore	rec;
>  	int				offset = agino - ibtrec->ir_startino;
> 
