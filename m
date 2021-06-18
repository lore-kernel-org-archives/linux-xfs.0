Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A10CC48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 05:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B83C60E0B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 05:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhFRGBN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 02:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbhFRGBN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 02:01:13 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3F4C061574
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 22:59:04 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y4so458417pfi.9
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 22:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=W23P/5fsUj5phPepRdwyvTorQWW7nQB/Qbw/XE9SC+k=;
        b=QsGDk67qoPULelyMqGg05Gdtz/CM6TF6i6pKRfiyQDqNnJvnqTU4+3ZfaL9d7/WLz8
         yo4Pb84Kro0UZ+CwFz+UCLhBltuQf8SwHSX69t4h/zTzmegeYOzG7C9GxkgG2ybXbTzk
         z2hzWeSqNNvl2sn36OwS76IrVIPBSts9/zJOMrNhe7l5eWceUNksYSKNbhNveHARzaWv
         Qol6yRpJy3BdBKnQiRk5KfXdi6tRd+fmGGVK65a+dxxHgFRj6ZZ8R6I1MuRhH4ScvhKq
         FCiscLrmCiqog1Yci4y+E624Ubs2SnzXTLw9+4WFWz0r9siVtS4Zf3u9SHpqiQYSRZqe
         epew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=W23P/5fsUj5phPepRdwyvTorQWW7nQB/Qbw/XE9SC+k=;
        b=I7WUTC2gq5T4O4LQsaIhV/N/0WhpJ9fGFF+Cfff07F3kkU0peqOq0AD6lRegEObf7A
         sP6Ii+vGVLEcn7m6dl4vR6/9oYuuN+7bxx862fWmW6i++uKC03aAlMTAtJpIcJgNP3bf
         anfaWXCDL7O+4i/o+nCjjJ4aQ7QVli4QDTcpDBm7izBz42gcktYw+w0fvCiehYLloI8K
         9BL/nxgvfeUpa8s2hlz2Pr2lrHF66wuIi0WXTaTwupv2OHsNootHogitRAboiaFIJpM5
         lSJV/fUpHdD2qaVUwNQ+lr04mGQh/c8+9WmYYlb9wObWiQTmeBRvqWdltxdEsl2/gq95
         Kiyg==
X-Gm-Message-State: AOAM530y1JEOnydpDOdiBW61oGISKlUh8OzmxXjahu0lOPaEaJZz/ObH
        ORqyiczHwIUjLOBZgIq6iJU+GaOBEjhyww==
X-Google-Smtp-Source: ABdhPJygCUHAKEjWLnaeIUIxKtjRQjok2lS+w7/PkabG6dC7xyfQjM0FM2nXbwmv8hR1Ect+GpwJmg==
X-Received: by 2002:aa7:9ac5:0:b029:300:5ff6:1186 with SMTP id x5-20020aa79ac50000b02903005ff61186mr525580pfp.53.1623995944064;
        Thu, 17 Jun 2021 22:59:04 -0700 (PDT)
Received: from garuda ([122.167.197.147])
        by smtp.gmail.com with ESMTPSA id r10sm7714778pga.48.2021.06.17.22.59.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Jun 2021 22:59:03 -0700 (PDT)
References: <20210616163212.1480297-1-hch@lst.de> <20210616163212.1480297-3-hch@lst.de>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: list entry elements don't need to be initialized
In-reply-to: <20210616163212.1480297-3-hch@lst.de>
Date:   Fri, 18 Jun 2021 11:29:01 +0530
Message-ID: <877diru316.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Jun 2021 at 22:02, Christoph Hellwig wrote:
> list_add does not require the added element to be initialized.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 8999c78f3ac6d9..32cb0fc459a364 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -851,7 +851,7 @@ xlog_write_unmount_record(
>  		.lv_iovecp = &reg,
>  	};
>  	LIST_HEAD(lv_chain);
> -	INIT_LIST_HEAD(&vec.lv_list);
> +
>  	list_add(&vec.lv_list, &lv_chain);
>  
>  	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
> @@ -1587,7 +1587,7 @@ xlog_commit_record(
>  	};
>  	int	error;
>  	LIST_HEAD(lv_chain);
> -	INIT_LIST_HEAD(&vec.lv_list);
> +
>  	list_add(&vec.lv_list, &lv_chain);
>  
>  	if (XLOG_FORCED_SHUTDOWN(log))


-- 
chandan
