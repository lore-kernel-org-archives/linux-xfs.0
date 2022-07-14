Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8FA1C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 01:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiGNBj0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 21:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiGNBj0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 21:39:26 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B881CE06
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 18:39:25 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E75844435;
        Wed, 13 Jul 2022 20:39:03 -0500 (CDT)
Message-ID: <2a452d57-9e2e-7908-b3f5-0444b6a62761@sandeen.net>
Date:   Wed, 13 Jul 2022 20:39:24 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165767457703.891854.2108521135190969641.stgit@magnolia>
 <165767459958.891854.15344618102582353193.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/4] mkfs: terminate getsubopt arrays properly
In-Reply-To: <165767459958.891854.15344618102582353193.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/12/22 8:09 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Having not drank any (or maybe too much) coffee this morning, I typed:
> 
> $ mkfs.xfs -d agcount=3 -d nrext64=0
> Segmentation fault
> 
> I traced this down to getsubopt walking off the end of the dopts.subopts
> array.  The manpage says you're supposed to terminate the suboptions

(the getsubopt(3) manpage for those following along at home)

> string array with a NULL entry, but the structure definition uses
> MAX_SUBOPTS/D_MAX_OPTS directly, which means there is no terminator.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 61ac1a4a..9a58ff8b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -141,7 +141,7 @@ enum {
>  };
>  
>  /* Just define the max options array size manually right now */
> -#define MAX_SUBOPTS	D_MAX_OPTS
> +#define MAX_SUBOPTS	(D_MAX_OPTS + 1)

Hah, I had not noticed this before. So this relies on there being more
suboptions for -d than anything else, I guess. What could go wrong?

OK, so this fixes it because opt_params is a global, and it contains 
subopt_params[MAX_SUBOPTS];, so the last array entry will be null
(by virtue of globals being zeroed) and that's all perfectly clear :D

Well, it fixes it for now.  I'd like to add i.e.

@@ -251,6 +251,7 @@ static struct opt_params bopts = {
        .ini_section = "block",
        .subopts = {
                [B_SIZE] = "size",
+               [B_MAX_OPTS] = NULL,
        },

etc to each suboption array to be explicit about it, sound ok? I can do
that on commit if it seems ok.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Thanks,
-Eric

>  
>  #define SUBOPT_NEEDS_VAL	(-1LL)
>  #define MAX_CONFLICTS	8
> 
