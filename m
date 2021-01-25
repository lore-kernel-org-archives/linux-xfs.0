Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D866C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F33E22ADF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbhAZFSJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:18:09 -0500
Received: from sandeen.net ([63.231.237.45]:37170 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729344AbhAYOSJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 09:18:09 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B4D985EDAB;
        Mon, 25 Jan 2021 08:15:24 -0600 (CST)
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
References: <20210125095809.219833-1-chandanrlinux@gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] xfsprogs: xfs_fsr: Interpret arguments of qsort's
 compare function correctly
Message-ID: <da50be67-cc9a-8a99-84dc-a4ae3ee4fd73@sandeen.net>
Date:   Mon, 25 Jan 2021 08:17:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125095809.219833-1-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/25/21 3:58 AM, Chandan Babu R wrote:
> The first argument passed to qsort() in fsrfs() is an array of "struct
> xfs_bulkstat". Hence the two arguments to the cmp() function must be
> interpreted as being of type "struct xfs_bulkstat *" as against "struct
> xfs_bstat *" that is being used to currently typecast them.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Yikes. Broken since 5.3.0, and the structures have different sizes and
different bs_extents offsets. :(

Fixes: 4cca629d6 ("misc: convert xfrog_bulkstat functions to have v5 semantics")
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

At least it's only affecting the whole-fs defragment which is generally not
recommended, but is still available and does get used.

I wonder if it explains this bug report:

Jan 07 20:52:44 <Tharn>	hey, quick question... the first time I ran xfs_fsr last night, it ran for 2 hours and looking at the console log, it ended with a lot of "start inode=0" repeating

> ---
>  fsr/xfs_fsr.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 77a10a1d..635e4c70 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -702,9 +702,8 @@ out0:
>  int
>  cmp(const void *s1, const void *s2)
>  {
> -	return( ((struct xfs_bstat *)s2)->bs_extents -
> -	        ((struct xfs_bstat *)s1)->bs_extents);
> -
> +	return( ((struct xfs_bulkstat *)s2)->bs_extents -
> +	        ((struct xfs_bulkstat *)s1)->bs_extents);
>  }
>  
>  /*
> 
