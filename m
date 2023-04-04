Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7F4C761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbjDDO1H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbjDDO1G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:27:06 -0400
X-Greylist: delayed 457 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Apr 2023 07:26:46 PDT
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 231BC19BF;
        Tue,  4 Apr 2023 07:26:45 -0700 (PDT)
Received: from [10.2.0.2] (unknown [37.19.199.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C1978325436;
        Tue,  4 Apr 2023 09:19:07 -0500 (CDT)
Message-ID: <e51e9fb1-ad5c-5cf8-fa04-4e3a10023739@sandeen.net>
Date:   Tue, 4 Apr 2023 09:19:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Content-Language: en-US
To:     Ryosuke Yasuoka <ryasuoka@redhat.com>, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230404084701.2791683-1-ryasuoka@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: Use for_each_perag() to iterate all available AGs
In-Reply-To: <20230404084701.2791683-1-ryasuoka@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/4/23 3:47 AM, Ryosuke Yasuoka wrote:
> for_each_perag_wrap() doesn't expect 0 as 2nd arg.
> To iterate all the available AGs, just use for_each_perag() instead.

Can you explain what goes wrong if it is zero? Is there a test for this?

If it's a general problem, what if the other 2 callers pass in the variable
start_agno with a value of 0?

(I may well be missing something obvious as those macros are a bit dense)

Thanks,
-Eric
 
> Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
> ---
>  fs/xfs/xfs_filestream.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 22c13933c8f8..48f43c340c58 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -151,7 +151,7 @@ xfs_filestream_pick_ag(
>  		 * grab.
>  		 */
>  		if (!max_pag) {
> -			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
> +			for_each_perag(args->mp, start_agno, args->pag)
>  				break;
>  			atomic_inc(&args->pag->pagf_fstrms);
>  			*longest = 0;
