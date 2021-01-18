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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4565C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 04:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B51ED22513
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 04:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbhAREqv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Jan 2021 23:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731457AbhAREqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jan 2021 23:46:43 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAEEC061573
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jan 2021 20:46:03 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id q7so10185038pgm.5
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jan 2021 20:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=JFt/uiKKv2F/uW+OTZm1/dev4XjJ7kg5Iqti/QpaJJg=;
        b=jrSejZkFPO0uy/ykzLLMcZUMYO9sFywRdcFw7k1WqBUO3KrxJ1AfYNEEy3zX3/Yv6W
         niJ5R9U31+7KThlGgj1Dch1+CeBKlFfVRgBPLjSb/y8aIZCmjTpZZdULyMPJugSHrM83
         6mPD7bmuIICONfi2NNzx4BTnTihdl/medPuSSAF2BWCqEz6A/VjSUGUQ2Uuobr5gOe3a
         JfePGWUys0CnlGIFmPH3IY5lfEjsnbfQxsMFr2p4UJXyZqzBIu8k2djurKnm0r8aMXkh
         MoiKVLEykjLgBsV604Vrcyj0TiUPjCqVGM0pc1/k0xQJxBJZ6udbZAZ/4HlSaNL8bhaz
         YRNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=JFt/uiKKv2F/uW+OTZm1/dev4XjJ7kg5Iqti/QpaJJg=;
        b=UZiAdqu2+ais1QLYYFGT95hhvK9MgujyEpBw+ew26vfYpu2dYvrY/AVkk8w+k5eo8K
         sFhwbXxXfBna/avgpffOwOBsgzLbvg60OXCPCy7vnk7ZRHYi2onFSyJEp9aDBEMNAvTS
         WkioyxklpXcWd5BNMH3jcW7f/6sU449l+dJwfLlmpv4+YXw/Y52uq28NExj7mr8xj6PT
         dhb/Kt+bPcyLee4SpleRQ587lCa9cWkUqUQWWOEnamRrt8vNbQJGBKzTuoBhW8JcqL6J
         ZfqjDhR75YabzM6M4BUpQ/xNjXvKhPRBqP7hS/tmwkGN9IARwiE0e3oSevWwhE+kNdqV
         T8YA==
X-Gm-Message-State: AOAM533cxfsEswoDNecxOngOEtSa2l5mtxVOxgbzu4KtiyRIkO8eIhF5
        RdZ11g5g3DhXo22iC0ERSCcT9BzcRZs=
X-Google-Smtp-Source: ABdhPJxWz3LJgGAtvHi0vSmClyCYmc1o2WStMPl5z2uox7URoo1YVzPJx7hU/pEr3EmTahqOUyKE/w==
X-Received: by 2002:aa7:8d12:0:b029:1ae:4344:3b4f with SMTP id j18-20020aa78d120000b02901ae43443b4fmr23954441pfe.16.1610945162765;
        Sun, 17 Jan 2021 20:46:02 -0800 (PST)
Received: from garuda ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id me5sm9148779pjb.19.2021.01.17.20.46.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Jan 2021 20:46:02 -0800 (PST)
References: <161076031261.3386689.3320804567045193864.stgit@magnolia> <161076033047.3386689.5046709914905631064.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_scrub: load and unload libicu properly
In-reply-to: <161076033047.3386689.5046709914905631064.stgit@magnolia>
Date:   Mon, 18 Jan 2021 10:15:59 +0530
Message-ID: <87im7un988.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 16 Jan 2021 at 06:55, Darrick J. Wong wrote:
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
> index c3a7f385..755afaef 100644
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
> +# define unicrash_load()			(0)
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

... "Couldn't initialize ..."

The rest looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

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
