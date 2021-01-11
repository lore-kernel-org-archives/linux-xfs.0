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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F59C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 14:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B50A2242A
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 14:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbhAKOQA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 09:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbhAKOQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 09:16:00 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F1AC061786
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 06:15:19 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l23so10663740pjg.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 06:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=IizNjDFeJbI7hfbC6n/Py3kHP+YRxbjw9FVQmR83v0g=;
        b=JDbYUEKk690UT7u5JXMObLwKEPvORcal99xGKvCaI9teKckE+F3Mjud4YRQMTuEm97
         eQGMTQel8fNSljCV3SVclmR2Vyy2T4nqpYps402iDWzRsPj7BCyQdv0K19BpIBw+vFdY
         cKD7sdKkBCKkjdI53Cj+5Z/wYoc8yRQ0pydlATZ4rUPTZMmzF8eOkRPAsimXNFBcsfuu
         UWIRSa9XX3UNkTopBYg3o0xRyDGkzsYTEu5R59CZnJEb/29IkF64Buph6gCfdrvALeOc
         CEmZRPI01KW/lDDNt3aTlAObYUP337XvzDqroneI6ut+RznFalyqWUQETSF5aEQ4lKd1
         8ezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=IizNjDFeJbI7hfbC6n/Py3kHP+YRxbjw9FVQmR83v0g=;
        b=SS4K1hB9gR1kTDCPYyqRlUumkAKfIPAXXENE7RWDGCPY5LuDvhzjfrI2bX4cC/7tTw
         exLXQ9lY1SuzR4NYfjDGX7JcWZoQoZZqOaOjQQc7EA/J21JVH4KJ2+B8oUXShh+lBdG5
         +cc6FmJQiFb0SlgsI1P76f6gLGFpxXdyoJzjcp1yfcYgygMawP3ddVQ6Sw7Lgex/aG3G
         1r53RTGsOrkGdu4tZ2mz2U3L1IUxb+nTu/a8m/Ou/yh+OHdqatt3CZHRNK/CCMOf+MVO
         iTK+qTHR7EKzLRNMLyHDppNPcHtcYk/+4IOqihOSW+vHojc4Y7BtvAf7jUXIGvPAU2n1
         RCng==
X-Gm-Message-State: AOAM533F7kjk9/yvmrWQ98dEzuBec2HIKgq2jJ79KjhyADaiaqpfSaz3
        RyeEGmtbocKPrOsdlGhxeoCUF8PE/4c=
X-Google-Smtp-Source: ABdhPJzozFAH7GlyWP7rXu7X2yNzg0T50QXCMc8veyTM6KNJ6jQWRaauTesn9tu4cJX0HMq7HAbqJQ==
X-Received: by 2002:a17:90a:ec10:: with SMTP id l16mr18765622pjy.127.1610374519130;
        Mon, 11 Jan 2021 06:15:19 -0800 (PST)
Received: from garuda ([122.179.76.16])
        by smtp.gmail.com with ESMTPSA id bx17sm13547475pjb.12.2021.01.11.06.15.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 06:15:18 -0800 (PST)
References: <161017371478.1142776.6610535704942901172.stgit@magnolia> <161017372698.1142776.3985444129678928114.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_scrub: load and unload libicu properly
In-reply-to: <161017372698.1142776.3985444129678928114.stgit@magnolia>
Date:   Mon, 11 Jan 2021 19:45:15 +0530
Message-ID: <87zh1fo8zw.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 09 Jan 2021 at 11:58, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Make sure we actually load and unload libicu properly.  This isn't
> strictly required since the library can bootstrap itself, but unloading
> means fewer things for valgrind to complain about.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  scrub/unicrash.c  |   17 +++++++++++++++++
>  scrub/unicrash.h  |    4 ++++
>  scrub/xfs_scrub.c |    6 ++++++
>  3 files changed, 27 insertions(+)
>
>
> diff --git a/scrub/unicrash.c b/scrub/unicrash.c
> index d5d2cf20..de3217c2 100644
> --- a/scrub/unicrash.c
> +++ b/scrub/unicrash.c
> @@ -722,3 +722,20 @@ unicrash_check_fs_label(
>  	return __unicrash_check_name(uc, dsc, _("filesystem label"),
>  			label, 0);
>  }
> +
> +/* Load libicu and initialize it. */
> +bool
> +unicrash_load(void)
> +{
> +	UErrorCode		uerr = U_ZERO_ERROR;
> +
> +	u_init(&uerr);
> +	return U_FAILURE(uerr);
> +}
> +
> +/* Unload libicu once we're done with it. */
> +void
> +unicrash_unload(void)
> +{
> +	u_cleanup();
> +}
> diff --git a/scrub/unicrash.h b/scrub/unicrash.h
> index c3a7f385..32cae3d4 100644
> --- a/scrub/unicrash.h
> +++ b/scrub/unicrash.h
> @@ -25,6 +25,8 @@ int unicrash_check_xattr_name(struct unicrash *uc, struct descr *dsc,
>  		const char *attrname);
>  int unicrash_check_fs_label(struct unicrash *uc, struct descr *dsc,
>  		const char *label);
> +bool unicrash_load(void);
> +void unicrash_unload(void);
>  #else
>  # define unicrash_dir_init(u, c, b)		(0)
>  # define unicrash_xattr_init(u, c, b)		(0)
> @@ -33,6 +35,8 @@ int unicrash_check_fs_label(struct unicrash *uc, struct descr *dsc,
>  # define unicrash_check_dir_name(u, d, n)	(0)
>  # define unicrash_check_xattr_name(u, d, n)	(0)
>  # define unicrash_check_fs_label(u, d, n)	(0)
> +# define unicrash_init()			(0)

The above should probably be defining unicrash_load().

> +# define unicrash_unload()			do { } while (0)
>  #endif /* HAVE_LIBICU */
>  
>  #endif /* XFS_SCRUB_UNICRASH_H_ */
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index 1edeb150..6b202912 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -603,6 +603,11 @@ main(
>  	setlocale(LC_ALL, "");
>  	bindtextdomain(PACKAGE, LOCALEDIR);
>  	textdomain(PACKAGE);
> +	if (unicrash_load()) {
> +		fprintf(stderr,
> +			_("%s: could initialize Unicode library.\n"), progname);
> +		goto out;
> +	}
>  
>  	pthread_mutex_init(&ctx.lock, NULL);
>  	ctx.mode = SCRUB_MODE_REPAIR;
> @@ -788,6 +793,7 @@ main(
>  	phase_end(&all_pi, 0);
>  	if (progress_fp)
>  		fclose(progress_fp);
> +	unicrash_unload();
>  
>  	/*
>  	 * If we're being run as a service, the return code must fit the LSB


-- 
chandan
