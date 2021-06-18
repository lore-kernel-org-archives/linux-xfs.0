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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CCBC48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 05:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 101E461369
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 05:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhFRFyt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 01:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhFRFys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 01:54:48 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49933C061574
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 22:52:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c15so4038681pls.13
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 22:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=bstSfRFIS5dbIoxeLlhmy1swFU+PaS8DK3Dgr6Hp5bA=;
        b=JWqGPbv5oMl0KLLDq/yqK5i6eEXLUF3+w0OJ0yhlOKx4KhoOxXVTeeejTLmbmeUYKA
         uBcokuC8yxDYf0TZLczzvQDWD06EZIx3sgcE4UIu9ypP/plNJHFux/KqQsUPadwWIBj+
         qbkyLINsn+WcO+MwTqSS3ZfwBgQeYu0+SBNH+uKS4NOtnAC4Tb8JVTHyxZhhEI+pakiF
         ChAK+4b7aTtXSpnQq0ryftsDqm4e1lT7RgON7MsXswjoudivlDHF2Y6odwBmjDdGpjXP
         iKwp8h1qvWmKioxdxUs+hsb/5K+d03+gp694HbXW0yqu2Y/uyr+UDYVDUZIqSq2QdUKV
         k0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=bstSfRFIS5dbIoxeLlhmy1swFU+PaS8DK3Dgr6Hp5bA=;
        b=nuP7zBN+nBRjSzmXLXZVmxt9s2FMhphFRSwvyTP70iDkQG9GYq5iat9nqVOHL4TM/E
         qcM1fTW9LfkN+CsYoYD468pMAogrBVPCvydRwus8aAZRU/h7eIjnYxo6/Zki5X9tu3hC
         SFk64uTBj/gD4dldzVC0bqpdLxOgo0HTTubKJW8RqoMG9pXHr922rPKg8IG6/NFgeTrk
         73Vq9wrmBl1HuVQPpd7YD5cg1Q1Be5oVct5pYCyWEkcZ2XIXYGEA5wNSqUOjVo3U1yrQ
         wnpYTGFDmU5z8CLnidlNRKbSyXqedzXF8iPoMIqtQQ4a/jPwLLiAgiPMVRg8zudGHdih
         rEww==
X-Gm-Message-State: AOAM533eV43rOnazrHPf9sbUHt+lv3lw466nCb8zje0q1I41oXhBc2NO
        bHkpPjMk0/FrYz6zHQE6pp3J2YvHjF3gaA==
X-Google-Smtp-Source: ABdhPJzEW1KkW9TdZWTgM+u/scnuYxCpC5TKkoiUxpJ908CcAlczIVVryDF5W3s4HsnzOpXAzi+N7g==
X-Received: by 2002:a17:90b:1e11:: with SMTP id pg17mr9186838pjb.12.1623995558570;
        Thu, 17 Jun 2021 22:52:38 -0700 (PDT)
Received: from garuda ([122.167.197.147])
        by smtp.gmail.com with ESMTPSA id k9sm7376666pgq.27.2021.06.17.22.52.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Jun 2021 22:52:38 -0700 (PDT)
References: <20210616163212.1480297-1-hch@lst.de> <20210616163212.1480297-2-hch@lst.de>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: change the type of ic_datap
In-reply-to: <20210616163212.1480297-2-hch@lst.de>
Date:   Fri, 18 Jun 2021 11:22:35 +0530
Message-ID: <878s37u3bw.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Jun 2021 at 22:02, Christoph Hellwig wrote:
> Turn ic_datap from a char into a void pointer given that it points
> to arbitrary data.
>

xlog_alloc_log() has the following statement,

iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;

Maybe the "char *" typecast can be converted to "void *" as part of this
patch.

The remaining changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 2 +-
>  fs/xfs/xfs_log_priv.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e921b554b68367..8999c78f3ac6d9 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3613,7 +3613,7 @@ xlog_verify_iclog(
>  		if (field_offset & 0x1ff) {
>  			clientid = ophead->oh_clientid;
>  		} else {
> -			idx = BTOBBT((char *)&ophead->oh_clientid - iclog->ic_datap);
> +			idx = BTOBBT((void *)&ophead->oh_clientid - iclog->ic_datap);
>  			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
>  				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
>  				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index e4e421a7033558..96dbe713954f7e 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -185,7 +185,7 @@ typedef struct xlog_in_core {
>  	u32			ic_offset;
>  	enum xlog_iclog_state	ic_state;
>  	unsigned int		ic_flags;
> -	char			*ic_datap;	/* pointer to iclog data */
> +	void			*ic_datap;	/* pointer to iclog data */
>  
>  	/* Callback structures need their own cacheline */
>  	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;


-- 
chandan
