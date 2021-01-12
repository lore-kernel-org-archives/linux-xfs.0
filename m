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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003E8C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 11:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6F9223104
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 11:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbhALLQU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbhALLQT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 06:16:19 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DDAC061794
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jan 2021 03:15:39 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id w1so1403589pjc.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jan 2021 03:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=vCuENauhKiupbK3Hw0UhWADZCZ5iItrCDcBWq75EVw0=;
        b=olxVbswX5M1hNknJ7UzcD1PjgpA4tT+dtFFRDc7ZIJh2ZIF6gnVIHpMO0DzP3kRo9t
         urOQQVlVPpZPP4gzzRnwbCap+2/snz4rNJfh/OmZdLFr4m3u/8eg66+H1l4SNWC3c+d2
         lsWLf4UbLHdwVfZcwld58RP3ysIGc9iv1xH34oR6W4oXYLimhBNE8iVp1P/FIAA9g0/H
         0IXi708x7AF1ckKhHniCH/QENrujydvKrLb11gST0lgTn/gq0esx+pZZQeD7O4bzBoJT
         gXQBVB4AmSbyH+s4FUxt8USO8hYn6SIbPau5iUGu8km1rJQ6S2V2LPMg43e0Gnqdzu0p
         NHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=vCuENauhKiupbK3Hw0UhWADZCZ5iItrCDcBWq75EVw0=;
        b=KmoOpRjHwEJ9ZbryeorAmLeXGIGUnZIBcgXBfYilj//oyaYotnX44bc8capxG+MH4e
         SrgEd1yV/vPaQNQSz5PPPrlXZm1scy8cFTNzIn0E+WKuNlW+sZKxASTPNhIgFjdSDC27
         0M8UjF0QI3hQ9IAYs7pQCnZBEnsrp7l5+FXycAU/Rd87e3RBEZAdKM790c5EMnd+1gsF
         QzPHIuObvUp9LSP3KFxU3UhwsKFM2kxO3riQs0Yt/blap7KiHsUTbA6ex8pLL0EOn3kx
         DNTwfOupcCkS3WvJc20WFZSkJQcUSQRT311NqOQTr2kHTrEFVaNJYojo/lpkjX+Tv4ov
         MTCA==
X-Gm-Message-State: AOAM533AJEgJJYTgyYtnql7OvKt2hqbAvcjD2el11OuhRBfrQynzakdh
        06LxNlmxk2SgVbRlu6YYG6GjFGszvHQ=
X-Google-Smtp-Source: ABdhPJx2BIJD5evOsl3i6lrJYFtxNx7EragpaJZkpf+9vXie/KWuBrz9Zt/5tRIf4Bcf9h6PI1QDfg==
X-Received: by 2002:a17:902:9681:b029:db:fd65:d10e with SMTP id n1-20020a1709029681b02900dbfd65d10emr4751342plp.6.1610450138824;
        Tue, 12 Jan 2021 03:15:38 -0800 (PST)
Received: from garuda ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id g30sm2756230pfr.152.2021.01.12.03.15.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Jan 2021 03:15:38 -0800 (PST)
References: <161017371478.1142776.6610535704942901172.stgit@magnolia> <161017373322.1142776.5174880606166253807.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_scrub: handle concurrent directory updates during name scan
In-reply-to: <161017373322.1142776.5174880606166253807.stgit@magnolia>
Date:   Tue, 12 Jan 2021 16:45:35 +0530
Message-ID: <87a6tev220.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 09 Jan 2021 at 11:58, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> The name scanner in xfs_scrub cannot lock a namespace (dirent or xattr)
> and the kernel does not provide a stable cursor interface, which means
> that we can see the same byte sequence multiple times during a scan.
> This isn't a confusing name error since the kernel enforces uniqueness
> on the byte sequence, so all we need to do here is update the old entry.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  scrub/unicrash.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
>
> diff --git a/scrub/unicrash.c b/scrub/unicrash.c
> index de3217c2..f5407b5e 100644
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
> +			continue;

If the above condition evaluates to true, the memory pointed to by "new_entry"
is freed. The "continue" statement would cause the while loop to be executed
once more. At this stage, "entry" will still have the previously held non-NULL
value and hence the while loop is executed once more causing the invalid
address in "new_entry" to be dereferenced.

> +		}
> +
>  		/* Same normalization? */
>  		if (new_entry->normstrlen == entry->normstrlen &&
>  		    !u_strcmp(new_entry->normstr, entry->normstr) &&


--
chandan
