Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56115C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Mar 2022 03:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236862AbiCBDVy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 22:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiCBDVx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 22:21:53 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53284B0A51;
        Tue,  1 Mar 2022 19:21:10 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4K7fR10Lj5z1GC0v;
        Wed,  2 Mar 2022 11:16:29 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 11:21:07 +0800
Subject: Re: [PATCH 3/8] mm: khugepaged: skip DAX vma
To:     Yang Shi <shy828301@gmail.com>
CC:     <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
        <kirill.shutemov@linux.intel.com>, <songliubraving@fb.com>,
        <riel@surriel.com>, <willy@infradead.org>, <ziy@nvidia.com>,
        <akpm@linux-foundation.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <darrick.wong@oracle.com>
References: <20220228235741.102941-1-shy828301@gmail.com>
 <20220228235741.102941-4-shy828301@gmail.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6177c880-a34e-2539-764a-0de38c0cbc11@huawei.com>
Date:   Wed, 2 Mar 2022 11:21:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220228235741.102941-4-shy828301@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/3/1 7:57, Yang Shi wrote:
> The DAX vma may be seen by khugepaged when the mm has other khugepaged
> suitable vmas.  So khugepaged may try to collapse THP for DAX vma, but
> it will fail due to page sanity check, for example, page is not
> on LRU.

Yep. There is PageLRU check in khugepaged_scan_{file,pmd}.

> 
> So it is not harmful, but it is definitely pointless to run khugepaged
> against DAX vma, so skip it in early check.
> 

This patch looks good to me. Thanks.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

> Signed-off-by: Yang Shi <shy828301@gmail.com>
> ---
>  mm/khugepaged.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 82c71c6da9ce..a0e4fa33660e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -448,6 +448,10 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
>  	if (vm_flags & VM_NO_KHUGEPAGED)
>  		return false;
>  
> +	/* Don't run khugepaged against DAX vma */
> +	if (vma_is_dax(vma))
> +		return false;
> +
>  	if (vma->vm_file && !IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) -
>  				vma->vm_pgoff, HPAGE_PMD_NR))
>  		return false;
> 

