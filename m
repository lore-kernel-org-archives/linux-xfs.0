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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2373CC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 10:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D548864E37
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 10:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhBJKH2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 05:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhBJKFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Feb 2021 05:05:23 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBD3C06174A
        for <linux-xfs@vger.kernel.org>; Wed, 10 Feb 2021 02:04:41 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r38so883644pgk.13
        for <linux-xfs@vger.kernel.org>; Wed, 10 Feb 2021 02:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=V6pWFbilw67pavVTNyH4yjQHFkwJPbXSOSirF/1neho=;
        b=Mubg3+MtGZmJD2+eCHVQ+q+aTuJaEcyk4pRnfChFQIEdGZBkBtq4bvLQKVqtP/8yNi
         mvy9tynBfloYxxBY55xYda7ren7lKPIokzYQdOnoSYHt/sFcSPBp8VNTCxCxc3szGiTp
         0j0z44FG1piCPwqf1rwshgWIo2KsHeHS3cCyA8fK1HTL5X/bJQIbn9IO6V4flZjnwbPG
         uRZuPwE9s5kJwLIj0Egc5alFIfpFzLQFYv+VLXxQ1P75sMEA2p2SnKwSlbbRKaewOJnL
         VnT/lMcrl5cgMjtUAD+U5Il6FNWXQ2zKeVnyPhM+Qh2XtFaL30NkzhD+Q3gWlmx5sSQP
         dmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=V6pWFbilw67pavVTNyH4yjQHFkwJPbXSOSirF/1neho=;
        b=rfHl2ru/9xlUFa+ZEs3czf7cKaHWPXNeGFSeay8CJ9dzwEf4hFztcwoQNTNhAw6anD
         s6PAMjaCRCWjoagUx3eAWVPf0hOZt0s7VhBlBe9RGLoCzBiDUpOQeHBbKcuoQ5PBH1Y2
         DPlbTabH63gupUwJD2zHm3YMbcv1M8EYzi8Buz8yVnXZ9IEviVpnDIdDmkrfcrAJ4zYY
         GFDW5X/LYi76uS32rBDXQZXOBjaRmVKyb5NP/jqMxGc31zATfwdiwdLihkNSXiVkd+pK
         /ot1OoEvWgLgy1SMhkpCDRtQpgPv0n0JbZ94643MEJhCvNFEzYHwj8I1oiTo3hJ4uSRs
         Jt0w==
X-Gm-Message-State: AOAM531x8w2A145hLwHM0gHfZSeFbuWbHMDjGOl/RLN1Er5VXA2zqFxr
        53iUVr77wY88KnMtcIxM9r4=
X-Google-Smtp-Source: ABdhPJz9TNhCxEDR/zkg1dvdVZBqOK86K2gBthBdfGSKB9lsrRM86cy12zaABauxnBB9jPcYsDi3ow==
X-Received: by 2002:a63:6203:: with SMTP id w3mr2435919pgb.224.1612951480968;
        Wed, 10 Feb 2021 02:04:40 -0800 (PST)
Received: from garuda ([122.182.225.93])
        by smtp.gmail.com with ESMTPSA id b20sm1716238pfo.109.2021.02.10.02.04.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Feb 2021 02:04:40 -0800 (PST)
References: <161284387610.3058224.6236053293202575597.stgit@magnolia> <161284390991.3058224.12921304382202456726.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        chandanrlinux@gmail.com, Chaitanya.Kulkarni@wdc.com
Subject: Re: [PATCH 6/6] xfs_scrub: fix weirdness in directory name check code
In-reply-to: <161284390991.3058224.12921304382202456726.stgit@magnolia>
Date:   Wed, 10 Feb 2021 15:34:37 +0530
Message-ID: <875z30p7be.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 09 Feb 2021 at 09:41, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Remove the redundant second check of fd and ISDIR in check_inode_names,
> and rework the comment to describe why we can't run phase 5 if we found
> other corruptions in the filesystem.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  scrub/phase5.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
>
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index ee1e5d6c..1ef234bf 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -278,7 +278,12 @@ check_inode_names(
>  			goto out;
>  	}
>  
> -	/* Open the dir, let the kernel try to reconnect it to the root. */
> +	/*
> +	 * Warn about naming problems in the directory entries.  Opening the
> +	 * dir by handle means the kernel will try to reconnect it to the root.
> +	 * If the reconnection fails due to corruption in the parents we get
> +	 * ESTALE, which is why we skip phase 5 if we found corruption.
> +	 */
>  	if (S_ISDIR(bstat->bs_mode)) {
>  		fd = scrub_open_handle(handle);
>  		if (fd < 0) {
> @@ -288,10 +293,7 @@ check_inode_names(
>  			str_errno(ctx, descr_render(&dsc));
>  			goto out;
>  		}
> -	}
>  
> -	/* Warn about naming problems in the directory entries. */
> -	if (fd >= 0 && S_ISDIR(bstat->bs_mode)) {
>  		error = check_dirent_names(ctx, &dsc, &fd, bstat);
>  		if (error)
>  			goto out;


-- 
chandan
