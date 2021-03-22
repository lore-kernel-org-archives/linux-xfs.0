Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465F6C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 02:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18E4F61944
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 02:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCVCwx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Mar 2021 22:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCVCwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Mar 2021 22:52:50 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D86C061574;
        Sun, 21 Mar 2021 19:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=h8rfe/V5CBmK/REP6cMTrUzXnGz4U3b9I1kdIR3et5k=; b=KEhiQQqfTcIylOJbGUNzsSymzd
        +yBuydDTs3s5ZLc7xk5HNne5icykerNaefm5mNR7EVaybDMdFdB/7i93DsVjW2BO7sc3f7baou67E
        kdCWwFqhsNoAcJwIH6agdMOAGrEEezSp8Oe4HhSs49/b5NMOz5GzVcm4otBaFezZuO/COk5qLsheq
        S+2Wn2A7JKco/C3kKtjpw9WN1WCMqjD2uVfBsny8Wa9pi+t1pb4dq6kfE2jOhCla/ASq6YQs1BIgn
        ecW74YBWhzD+bYYW7BsaJt/vRACEjiKbDS2n5rtJfgjpEleS/FGdITzbltTLuZNnsWRvaTQ07AQod
        +BZrOXhA==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOAgN-00AjS3-S6; Mon, 22 Mar 2021 02:52:48 +0000
Subject: Re: [PATCH] xfs: Rudimentary spelling fix
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210322024619.714927-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6d410ec3-438d-9510-d599-bb8b825a6d3e@infradead.org>
Date:   Sun, 21 Mar 2021 19:52:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322024619.714927-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/21/21 7:46 PM, Bhaskar Chowdhury wrote:
> 
> s/sytemcall/systemcall/
> 
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f93370bd7b1e..b5eef9f09c00 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2870,7 +2870,7 @@ xfs_finish_rename(
>  /*
>   * xfs_cross_rename()
>   *
> - * responsible for handling RENAME_EXCHANGE flag in renameat2() sytemcall
> + * responsible for handling RENAME_EXCHANGE flag in renameat2() systemcall
>   */
>  STATIC int
>  xfs_cross_rename(
> --

I'll leave it up to Darrick or someone else.

To me it's "syscall" or "system call".

-- 
~Randy

