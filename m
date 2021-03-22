Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB16C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 18:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ED6E61984
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 18:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhCVStV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 14:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhCVStM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 14:49:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E98C061574;
        Mon, 22 Mar 2021 11:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=loT5UYtQDOxU6jMiAjmZZSIUXyIHjkuc0nbgC0EWv+c=; b=uAk8cqcdA2ZsbDBj3iWT4a6gmt
        j3uipYI8Kj4bhDHq0DH+dWQhurWO/57KtXg59RO9GIBmhMgDNlbvge1xvGeJTg1JGpZcXb+stCixO
        7/8Qc2tKJLzc2cJ49b4ecR+/pIIhMofXf8T8dplktMb7I1UGRLHpxdsG8+NM+lpG4XyjdQe9LJ+Nd
        IptHmXfDXAKDKqbdPNiH53nd3af21wyxAGAIzZExdQ59ZS4PQWKT/p/sjMQqiOQHrN5c2y3Ko8+v0
        zPNbDes52NixOAtwkseuxV2xsGC9rSXWuM/q6Z5RclETiX2OFHl0npZDBhL1+gGYzj2svAnShKyPN
        g/bn53yQ==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOPb3-008w4A-8J; Mon, 22 Mar 2021 18:48:35 +0000
Subject: Re: [PATCH] xfs: Fix a typo
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210322063926.3755645-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <bd1318da-cb43-a77a-5683-88ec3df3c2d5@infradead.org>
Date:   Mon, 22 Mar 2021 11:48:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322063926.3755645-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/21/21 11:39 PM, Bhaskar Chowdhury wrote:
> 
> s/strutures/structures/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  fs/xfs/xfs_aops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index b4186d666157..1cc7c36d98e9 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -158,7 +158,7 @@ xfs_end_ioend(
>  	nofs_flag = memalloc_nofs_save();
> 
>  	/*
> -	 * Just clean up the in-memory strutures if the fs has been shut down.
> +	 * Just clean up the in-memory structures if the fs has been shut down.
>  	 */
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		error = -EIO;
> --


-- 
~Randy

