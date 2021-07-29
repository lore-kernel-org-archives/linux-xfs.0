Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2BFC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 08:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0E2B60D07
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 08:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhG2I1i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 04:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbhG2I1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jul 2021 04:27:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DDBC061757
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jul 2021 01:27:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id k4-20020a17090a5144b02901731c776526so14409937pjm.4
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jul 2021 01:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=p3VwD2JZhgtN8qHRB1rezk4FrFdCSVGWm6QCh1NBrWY=;
        b=tffyrEdA0fj4TlQY6XTJ4xFXLqJxfnY0O8sbfcho4dFS1Q5GwWC+EeviPJEuXias2e
         0vwUuWvrfE1UUV5mmHxaHgaBFRhgzKQCW1uqt+4f/HzWeALUjrwBwcBw0mkKoY/oB8Se
         Jz7MQCTCfmdOuTx239QyTSJEnewNOT9rjy9LtY0PxL/KAbM6KEiafE+WR3i5LBslO8dD
         tCufvsci7aTeSyPufcXLAtZ6pLHZE8Ffs6d/o1nn3zwTcbtHaBHeRxbRLcJp1ltc98bi
         79Oh7bCqbUv/4kTIKvUXoehhfR1gFso6FI4kxwhybixBZl6nHhFWvllwhVsQFlF4AXk3
         TRgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=p3VwD2JZhgtN8qHRB1rezk4FrFdCSVGWm6QCh1NBrWY=;
        b=LJxUIPmtsQASdZJ7AFjuxtVvk99R+TTJNMW9GqXX8yPut67fNukpNlP0P6B4FKpKco
         zjKxXX+xjH2qO+qIy7EoB0K1KglXo7aBqnirVeyqRwg+Q4LdKkjL4hRHhbVGzBk4NM82
         s/8mtNAc+aEPLAUqTyV/5KCzc5J17tM6/3gvShSpuL1GmVKNdl+T4FXVjJxylOt1m0tX
         2GIpbrO6cda2a1is2WbU2j3Lpj97UVQbcS1reun68r8pnyfWe7nqO7RqLrTqSbL+KGBq
         g+nApLre9XAx4mMoCIE1Qz8syrMHddQJXLNeQ6CEYkE2T0oNSx4KhfFUn6DfuWUE3IkM
         WEHg==
X-Gm-Message-State: AOAM531lZi4XyAnD8xsyIrt7ah5f+OpVKxuu9zOeh2T/woeVHuPOkG03
        eZasL+0tAxavACfpAuRcqIpQtMWX8GL6zQ==
X-Google-Smtp-Source: ABdhPJwEw9RCfFDBKAirDZdxzA+RQ0fIkxfdZmG0d2lzYMz1o9PoXCw6bZhBE6MT1ETzDpnIuIVQVg==
X-Received: by 2002:a05:6a00:1693:b029:333:da3a:8c86 with SMTP id k19-20020a056a001693b0290333da3a8c86mr3984655pfc.41.1627547254062;
        Thu, 29 Jul 2021 01:27:34 -0700 (PDT)
Received: from garuda ([122.167.157.25])
        by smtp.gmail.com with ESMTPSA id lt14sm2451688pjb.2.2021.07.29.01.27.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Jul 2021 01:27:33 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-8-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 07/16] xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
In-reply-to: <20210727062053.11129-8-allison.henderson@oracle.com>
Date:   Thu, 29 Jul 2021 13:57:31 +0530
Message-ID: <874kcdfrt8.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> Because xattrs can be over a page in size, we need to handle possible
> krealloc errors to avoid warnings.  If the allocation does fail, fall
> back to kmem_alloc_large, with a memcpy.
>
> The warning:
>    WARNING: CPU: 1 PID: 20255 at mm/page_alloc.c:3446
>                  get_page_from_freelist+0x100b/0x1690
>
> is caused when sizes larger that a page are allocated with the
> __GFP_NOFAIL flag option.  We encounter this error now because attr
> values can be up to 64k in size.  So we cannot use __GFP_NOFAIL, and
> we need to handle the error code if the allocation fails.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log_recover.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 12118d5..1212fa1 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2088,7 +2088,15 @@ xlog_recover_add_to_cont_trans(
>  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>  
> -	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
> +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);
> +	if (ptr == NULL) {
> +		ptr = kmem_alloc_large(len + old_len, KM_ZERO);
> +		if (ptr == NULL)
> +			return -ENOMEM;
> +
> +		memcpy(ptr, old_ptr, old_len);
> +	}
> +
>  	memcpy(&ptr[old_len], dp, len);
>  	item->ri_buf[item->ri_cnt-1].i_len += len;
>  	item->ri_buf[item->ri_cnt-1].i_addr = ptr;


-- 
chandan
