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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A7CC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 12:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5C1960F46
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 12:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhG1MSY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 08:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbhG1MSV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 08:18:21 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355CDC061757
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 05:18:19 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d17so2401354plh.10
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 05:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=YHv9XoyfG07um5ESWC9bkqc8haVhlf/KK78pSv25E7w=;
        b=AbthsXQpNPmMGsn+RSi5SbQ4r0eBs6KqBss1Nz+IBYtR0vkWn1c7/NM3tJ61abZQkF
         +8HrvP4ZPuHBZf/sd7DZWQZ3ktMrbIFlcgkAnHBwT4Mk3pIvSx3sfCOlUjU/8wA+eh7W
         cl/wrcOPla8T2dKPeXt698x7xY4oePmXL8PKNAnJcbjTEx1NpAVXptk0em/hhT+hl5vP
         Cyl9n7ve+PMOZX1iaLlNtYRmw+ERPMNcr7kcjh5QbnU6xgjCBXE06YcDh9uKZkqOAgUM
         dYCBUWND+EqzSetWXJBzOI+gagHKLO1YhWHaPOPFLl3KS8zW0kRQcHQMaJpXHzR8ErcM
         i62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=YHv9XoyfG07um5ESWC9bkqc8haVhlf/KK78pSv25E7w=;
        b=kfRkP1F+J0CSZmvVxs4k3W9ZzNWS0o6z6jCvCi0WUktDjCPrFGiFKCh+cPY+KoIDdE
         u8K7ac8OdgSjVeoDyzPTD9GpXVmP8B49ZhN87OfT6El8xfRtBQHG0YvbRjX9D3w0maRy
         TYHeh4XsAu26QwBedFUv9Sw0wck6gOH9GLvb7DVPRk34L3Oit68X5wz4kRV4LszDBdM6
         dlbSAa8RWOE6gWJQFb+F3UON+0212lXbSG7aNbF4nns4vwpexiHduEYjPrxASTO62XSE
         4lgpwy8loxxly72ukWOeOieuvw5QN0w6ylVJ5NCZXgU6fGA+YplmHso93ycABjDl07uM
         KAdg==
X-Gm-Message-State: AOAM533AkermtdlQHx96TTUoWm684HCZFLCKrvq+COKEjhCPjJ49chkr
        riP7UvDwOxcE6AOd2F3EmKjBMG9yToM+Ig==
X-Google-Smtp-Source: ABdhPJz7l6QNnQAtuVjeOhl73xU5cUkHF+IlXXHVWEXOfrq2nCCP3fAeYD4GdmzpdG3bX7kOu1wKdg==
X-Received: by 2002:a63:d04:: with SMTP id c4mr29644392pgl.368.1627474698628;
        Wed, 28 Jul 2021 05:18:18 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id i18sm7765910pgb.83.2021.07.28.05.18.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Jul 2021 05:18:18 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-5-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 04/16] xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
In-reply-to: <20210727062053.11129-5-allison.henderson@oracle.com>
Date:   Wed, 28 Jul 2021 17:48:16 +0530
Message-ID: <87wnpavdh3.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> During an attr rename operation, blocks are saved for later removal
> as rmtblkno2. The rmtblkno is used in the case of needing to alloc
> more blocks if not enough were available.  However, in the case
> that neither rmtblkno or rmtblkno2 are set, we can return as soon
> as xfs_attr_node_addname completes, rather than rolling the transaction
> with an -EAGAIN return.  This extra loop does not hurt anything right
> now, but it will be a problem later when we get into log items because
> we end up with an empty log transaction.  So, add a simple check to
> cut out the unneeded iteration.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d9d7d51..5040fc1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -409,6 +409,13 @@ xfs_attr_set_iter(
>  			if (error)
>  				return error;
>  
> +			/*
> +			 * If addname was successful, and we dont need to alloc
> +			 * or remove anymore blks, we're done.
> +			 */
> +			if (!args->rmtblkno && !args->rmtblkno2)
> +				return 0;
> +
>  			dac->dela_state = XFS_DAS_FOUND_NBLK;
>  		}
>  		return -EAGAIN;


-- 
chandan
