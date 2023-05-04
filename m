Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AACC77B7C
	for <linux-xfs@archiver.kernel.org>; Thu,  4 May 2023 12:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjEDMnP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 May 2023 08:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjEDMnP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2023 08:43:15 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C416185
        for <linux-xfs@vger.kernel.org>; Thu,  4 May 2023 05:43:13 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QBtjJ465fzsR5v;
        Thu,  4 May 2023 20:41:24 +0800 (CST)
Received: from [10.174.178.185] (10.174.178.185) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 4 May 2023 20:43:10 +0800
Subject: Re: [PATCH 5/4] xfs: fix negative array access in xfs_getbmap
To:     "Darrick J. Wong" <djwong@kernel.org>, <david@fromorbit.com>
References: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
 <20230501212434.GM59213@frogsfrogsfrogs>
CC:     Dave Chinner <dchinner@redhat.com>, <linux-xfs@vger.kernel.org>
From:   "yebin (H)" <yebin10@huawei.com>
Message-ID: <6453A85E.9090302@huawei.com>
Date:   Thu, 4 May 2023 20:43:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20230501212434.GM59213@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2023/5/2 5:24, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> In commit 8ee81ed581ff, Ye Bin complained about an ASSERT in the bmapx
> code that trips if we encounter a delalloc extent after flushing the
> pagecache to disk.  The ioctl code does not hold MMAPLOCK so it's
> entirely possible that a racing write page fault can create a delalloc
> extent after the file has been flushed.  The proposed solution was to
> replace the assertion with an early return that avoids filling out the
> bmap recordset with a delalloc entry if the caller didn't ask for it.
>
> At the time, I recall thinking that the forward logic sounded ok, but
> felt hesitant because I suspected that changing this code would cause
> something /else/ to burst loose due to some other subtlety.
>
> syzbot of course found that subtlety.  If all the extent mappings found
> after the flush are delalloc mappings, we'll reach the end of the data
> fork without ever incrementing bmv->bmv_entries.  This is new, since
> before we'd have emitted the delalloc mappings even though the caller
> didn't ask for them.  Once we reach the end, we'll try to set
> BMV_OF_LAST on the -1st entry (because bmv_entries is zero) and go
> corrupt something else in memory.  Yay.
>
> I really dislike all these stupid patches that fiddle around with debug
> code and break things that otherwise worked well enough.  Nobody was
> complaining that calling XFS_IOC_BMAPX without BMV_IF_DELALLOC would
> return BMV_OF_DELALLOC records, and now we've gone from "weird behavior
> that nobody cared about" to "bad behavior that must be addressed
> immediately".
>
> Maybe I'll just ignore anything from Huawei from now on for my own sake.
I am very sorry for introducing a new issue and causing you inconvenience.
The issue fixed by commit 8ee81ed581ff was triggered by doing our syzkaller
testing，and my intention is to fix the issue without any malice and offend.

I fully agree with you that we should be more cautious in modifying the code
that was originally working well. I will do more self code review and 
test before
sending patches to upstream.
> Reported-by: syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-xfs/20230412024907.GP360889@frogsfrogsfrogs/
> Fixes: 8ee81ed581ff ("xfs: fix BUG_ON in xfs_getbmap()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   fs/xfs/xfs_bmap_util.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f032d3a4b727..fbb675563208 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -558,7 +558,9 @@ xfs_getbmap(
>   		if (!xfs_iext_next_extent(ifp, &icur, &got)) {
>   			xfs_fileoff_t	end = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
>   
> -			out[bmv->bmv_entries - 1].bmv_oflags |= BMV_OF_LAST;
> +			if (bmv->bmv_entries > 0)
> +				out[bmv->bmv_entries - 1].bmv_oflags |=
> +								BMV_OF_LAST;
>   
>   			if (whichfork != XFS_ATTR_FORK && bno < end &&
>   			    !xfs_getbmap_full(bmv)) {
> .
>

