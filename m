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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F6FC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 04:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 473A222513
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 04:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbhAREsk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Jan 2021 23:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730896AbhAREsd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jan 2021 23:48:33 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91311C061575
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jan 2021 20:47:53 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n7so10205383pgg.2
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jan 2021 20:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=rvi23MzFOHPNroFgiPBfmeNxcVcE+osngOvabUzOWms=;
        b=g1HCR3W/ktC0hY+z1AW8JTl9i11BCl3dv4QjOYsxNWtmW7KqvkW9H337O0XmP5/xvx
         JOExG3YNcV41uuZnRPl7jS9M5fLSDkBxHxeNuPEmTWTekcUJYvefiDrR61dtUbgL6C/K
         +EDnVdePtyCO2HSnpqjTj5W9ptMd6246e9C6AF2L0atdQ/IZ922ocOmsF9Rf1cjDULPD
         rdgEOiB4Lh0wn7yUGcLWyIEyqgaIs1oENm3BNpOT3CUOeIZdlPEcHIPdP9lJYyWyC4gc
         zJzQfJhen76txUnPvIthUDzu6rXd81NHfmoKZvfpsVzEWM3N2aMqpM/PLA2rFuUz108i
         9mVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=rvi23MzFOHPNroFgiPBfmeNxcVcE+osngOvabUzOWms=;
        b=Gn1cOk1a4o6P/kFd/LTaJ1eg5yES5KvMYW+3c78V7hhYeBEovqxZ0lSbDSd1LVfMIo
         kXvPW7S9R6o/1C6s8TB9qfcdfSJrNK8TRh92rtnFAvSzck9y7xK2B4J1r6MkXq0/NZ++
         m+HjYn1qu08Kcu+jcjgexn8twxATmwYl2e/FvQWLqifJOYBK0IhC3QfyyRxGjE1ZRibd
         XmezTrOOD5tUQzV7nk1z9BkBUlkmTTX+O6fdRGkkYqbscV4IoUJMZqPOBNoa9y6zC+di
         KTCjZ5HWhKCeViM2Y7s9ZIUGSTUF3iikfejD1OU+kHGg/VP64tfepHHQ2tcVvmFX9G29
         Up3w==
X-Gm-Message-State: AOAM530gzrptpsbKOGihx+GEIdk/yO5LY8znwSKVMHNeZSqobEJBFIDC
        hv3+u4KWYgeDhJ2ePn3aIVeT6mb+Qy4=
X-Google-Smtp-Source: ABdhPJzEu0ByI5mZwQZhhVnaz7UKKtG2b9JctLS5bL9IaYzSFTFugE2anE9GGlmhhv5Wvp1EZKT8SQ==
X-Received: by 2002:aa7:9ec5:0:b029:19e:bfaf:1b24 with SMTP id r5-20020aa79ec50000b029019ebfaf1b24mr24465116pfq.51.1610945273123;
        Sun, 17 Jan 2021 20:47:53 -0800 (PST)
Received: from garuda ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id p22sm14913160pgk.21.2021.01.17.20.47.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Jan 2021 20:47:52 -0800 (PST)
References: <161076031261.3386689.3320804567045193864.stgit@magnolia> <161076033640.3386689.11320451390779411930.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_scrub: handle concurrent directory updates during name scan
In-reply-to: <161076033640.3386689.11320451390779411930.stgit@magnolia>
Date:   Mon, 18 Jan 2021 10:17:50 +0530
Message-ID: <87h7nen955.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 16 Jan 2021 at 06:55, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> The name scanner in xfs_scrub cannot lock a namespace (dirent or xattr)
> and the kernel does not provide a stable cursor interface, which means
> that we can see the same byte sequence multiple times during a scan.
> This isn't a confusing name error since the kernel enforces uniqueness
> on the byte sequence, so all we need to do here is update the old entry.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  scrub/unicrash.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
>
> diff --git a/scrub/unicrash.c b/scrub/unicrash.c
> index de3217c2..cb0880c1 100644
> --- a/scrub/unicrash.c
> +++ b/scrub/unicrash.c
> @@ -68,7 +68,7 @@ struct name_entry {
>  
>  	xfs_ino_t		ino;
>  
> -	/* Raw UTF8 name */
> +	/* Raw dirent name */
>  	size_t			namelen;
>  	char			name[0];
>  };
> @@ -627,6 +627,20 @@ unicrash_add(
>  	uc->buckets[bucket] = new_entry;
>  
>  	while (entry != NULL) {
> +		/*
> +		 * If we see the same byte sequence then someone's modifying
> +		 * the namespace while we're scanning it.  Update the existing
> +		 * entry's inode mapping and erase the new entry from existence.
> +		 */
> +		if (new_entry->namelen == entry->namelen &&
> +		    !memcmp(new_entry->name, entry->name, entry->namelen)) {
> +			entry->ino = new_entry->ino;
> +			uc->buckets[bucket] = new_entry->next;
> +			name_entry_free(new_entry);
> +			*badflags = 0;
> +			return;
> +		}
> +
>  		/* Same normalization? */
>  		if (new_entry->normstrlen == entry->normstrlen &&
>  		    !u_strcmp(new_entry->normstr, entry->normstr) &&


-- 
chandan
