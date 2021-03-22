Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AEFC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 04:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7174461967
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 04:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhCVEDe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 00:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhCVEDF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 00:03:05 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4473BC061574;
        Sun, 21 Mar 2021 21:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=qkxewrQlJK5/shxaPgCG1PvVmFC3aSiTWgp0bhbRIoI=; b=FwBJQP8/Abo91fpN2ZDsfgh3l6
        +vNEe4Pe8fosCMV4hhlvTI0L281mKpLbIwznBh48xyO9ZmJFgdAM3+3Iv5qwkVwbfCGxJIYTZa3uB
        6+Kniiz90VSvvt4h9HdedxK0BP6c/NdHo2kXwpoTfojKKCshazEUZJtCorCURxIZvzhHt3Q0/ty1v
        KNoE3WjLtKD/pMYRGw5aYicaK83RSnfslZ3fyQ7ojOmpJ6AuBxxbdTZ7DD/308sCeV8sod5Oq7SK3
        0Zp6STclBZ0t2w8VvHs8Q6BWg91H71gDtaF9224vhobgS+fMfAisQNYTtqHeLjJ0jwpej8VTcVamN
        JtwdVoGg==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOBmR-00Aq4e-5j; Mon, 22 Mar 2021 04:03:03 +0000
Subject: Re: [PATCH V2] xfs: Rudimentary spelling fix
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210322034538.3022189-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <77c33126-ad02-0054-d563-c067d887b267@infradead.org>
Date:   Sun, 21 Mar 2021 21:03:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322034538.3022189-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/21/21 8:45 PM, Bhaskar Chowdhury wrote:
> s/sytemcall/syscall/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>   Changes from V1:
>    Randy's suggestion incorporated.
> 
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f93370bd7b1e..3087d03a6863 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2870,7 +2870,7 @@ xfs_finish_rename(
>  /*
>   * xfs_cross_rename()
>   *
> - * responsible for handling RENAME_EXCHANGE flag in renameat2() sytemcall
> + * responsible for handling RENAME_EXCHANGE flag in renameat2() syscall
>   */
>  STATIC int
>  xfs_cross_rename(
> --


-- 
~Randy

