Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373CFC49361
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 04:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F317B61221
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 04:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhFUEn1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 00:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhFUEn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 00:43:27 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10928C061574
        for <linux-xfs@vger.kernel.org>; Sun, 20 Jun 2021 21:41:13 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v13so7828119ple.9
        for <linux-xfs@vger.kernel.org>; Sun, 20 Jun 2021 21:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=d3xESqIMFXbSL5Nk6BrbRI9stVcaf3XtQKgJ/F8sZhw=;
        b=Qtt0ysoPce6JfcSyHrfboZsXwKyA5Vff4U54C4Ogpqp7s7QfLcGWczlsqtCuxTcYPi
         Ml0QQ5ASZvJ1iMWM4QFHrPK5fQmAcMllpYIzrmuIFlDbLBlztpUoZX3U189+sjpdLxeI
         Q/SfI8Q2Byf9lysdhMOiokH8CylpoPYCyrwx8IFMGLn9aASCCGoKyYksrtYBo6hq2unU
         f24jrYVvLx+bDtOvCm8DsML/SaOIeOwj4qJQUYebtKDck0SAcBqqW1EW3y3QcmlFzltr
         pdAWSiO8y1Ye2v96ARzxn7ILthDw+768ro1IsFvO31cD4Py3eUJntebWrJswtrbTi0Kh
         KtBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=d3xESqIMFXbSL5Nk6BrbRI9stVcaf3XtQKgJ/F8sZhw=;
        b=GJAP1MegkAHOwHYAgdDFQEJqixoevu5aso5opQV50CCiR+QOOdCpavUBbVDGnNx/wX
         k0sGr1uQWQcIe49vBMynnxxzMho4Tj+usNa2p8spTl8Z530YBxQYnSgEQn1Wjt05gH1G
         txXcebNWfmUKCl/hzO+wKdYAF2xdXQia1N/aMM70jaOR5APWgIB8bkhhZ/OOAW3Sb1yo
         3PVT32wEAQy80kMUfwfs8hiOC30pHS3gZXQom/seQJg1HYxWRq2NoSLpvLQ+ddd4zMtk
         xNBp/OvFxSzKjIj/Jn/lVwRNH8UbeedLAQrhEKVbWSK9Hf2g0FhAN31XMCnIgVClF4Jg
         eKQA==
X-Gm-Message-State: AOAM530nxucJjfWLd5CB98nRY0vKOb4VwzMUcp1XMVTgOaswFd5R5tny
        ItJw3eaPw/Pybgrjzchinmk=
X-Google-Smtp-Source: ABdhPJzjVTehemJNnSmoLrqp4FzeeWPFVBaenEIrtpGGo2JsQGWnRBsMtlg4HTAMqlmZO8t+2O67Lg==
X-Received: by 2002:a17:902:a512:b029:11a:a12c:5521 with SMTP id s18-20020a170902a512b029011aa12c5521mr16320114plq.60.1624250472425;
        Sun, 20 Jun 2021 21:41:12 -0700 (PDT)
Received: from garuda ([122.171.54.242])
        by smtp.gmail.com with ESMTPSA id c22sm7551061pfv.121.2021.06.20.21.41.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 20 Jun 2021 21:41:12 -0700 (PDT)
References: <162404243382.2377241.18273624393083430320.stgit@locust> <162404244503.2377241.5074228710477395763.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: print name of function causing fs shutdown instead of hex pointer
In-reply-to: <162404244503.2377241.5074228710477395763.stgit@locust>
Date:   Mon, 21 Jun 2021 10:11:08 +0530
Message-ID: <87mtrjde3f.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Jun 2021 at 00:24, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> In xfs_do_force_shutdown, print the symbolic name of the function that
> called us to shut down the filesystem instead of a raw hex pointer.
> This makes debugging a lot easier:
>
> XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> 	fs/xfs/xfs_log.c. Return address = ffffffffa038bc38
>
> becomes:
>
> XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> 	fs/xfs/xfs_log.c. Return address = xfs_trans_mod_sb+0x25
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 07c745cd483e..b7f979eca1e2 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -543,7 +543,7 @@ xfs_do_force_shutdown(
>  	}
>  
>  	xfs_notice(mp,
> -"%s(0x%x) called from line %d of file %s. Return address = "PTR_FMT,
> +"%s(0x%x) called from line %d of file %s. Return address = %pS",
>  		__func__, flags, lnnum, fname, __return_address);
>  
>  	if (flags & SHUTDOWN_CORRUPT_INCORE) {


-- 
chandan
