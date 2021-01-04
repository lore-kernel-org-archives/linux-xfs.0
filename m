Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604D3C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 15:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D32E22286
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 15:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbhADPgZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:36:25 -0500
Received: from sandeen.net ([63.231.237.45]:56966 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbhADPgZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jan 2021 10:36:25 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 771D15286D9;
        Mon,  4 Jan 2021 09:34:22 -0600 (CST)
To:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org
References: <20210104112952.328169-1-zlang@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] mkfs: fix wrong inobtcount usage error output
Message-ID: <ab94d283-dccd-f449-f4ef-543a3a065dbe@sandeen.net>
Date:   Mon, 4 Jan 2021 09:35:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210104112952.328169-1-zlang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/4/21 5:29 AM, Zorro Lang wrote:
> When mkfs fails, it shows:
>   ...
>   /* metadata */         [-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
>                            inobtcnt=0|1,bigtime=0|1]\n\
>   ...
> 
> The "inobtcnt=0|1" is wrong usage, it must be inobtcount, there's not
> an alias. To avoid misadvice, fix it.

Good catch, thanks.

(it's funny how we abbreviate some things and not others)

> Signed-off-by: Zorro Lang <zlang@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 47acc127..0581843f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -928,7 +928,7 @@ usage( void )
>  /* blocksize */		[-b size=num]\n\
>  /* config file */	[-c options=xxx]\n\
>  /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
> -			    inobtcnt=0|1,bigtime=0|1]\n\
> +			    inobtcount=0|1,bigtime=0|1]\n\
>  /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
>  			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
>  			    sectsize=num\n\
> 
