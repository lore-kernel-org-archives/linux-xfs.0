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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DC4C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 04:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A2DD224B0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 04:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbhARE54 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Jan 2021 23:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730151AbhARE54 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jan 2021 23:57:56 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1BDC061573
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jan 2021 20:57:15 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id g15so4661581pjd.2
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jan 2021 20:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=3gvT1o416OlNhG4KH4WoOm0rGRW9sHmcaWeEIf9GlnI=;
        b=N7Zrak+d09gREYpP2tf5Rx7MpmgNKApvENZYXAjZyo0X87i4WJPQZ3ldBuCmGdjlqU
         SeDH6dWlhhUPH5jAlPlhTpG60dFAx1GKmK6vL0BHA32Xb1I0YXSWDrUjbYAa+b74ZLaZ
         KEa0ybAXnxeKK3G7nj37/+X1zy6MLNE0U69INrCvB/HoDs1W9OS+EUpzlD8q3jciPBqR
         rIHjjhxDL0xDU/lgCYCjggQb66autbDkUAvUSS00Vb4TyzUD2pUOBPPOGXXmvxTzbMMk
         FA8LwJ5RpqcaDRoDKEdvfUZAnr6adILMTFwzpPfiR1Pc4ddzflkwJt2q+6qI0oNlf1c8
         erGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=3gvT1o416OlNhG4KH4WoOm0rGRW9sHmcaWeEIf9GlnI=;
        b=QoTdUgwgiqOsXth9v+ZRxPx8B4yTPz0Agpr3/RyzxZE7zYgjrL0EMsEBPyg21uEK7z
         pL6DimZUbMCa6w/qgZj5b/5Kc+4bDYUpNqLjPvNIFf4vrZ9ujvFLQzIEdgUM0PlS6ZFJ
         lgkbfnEgKdGiFXeBKVXbr66utvT5mxgZ62pDtQS3JArin5cex6cuU0Sy3Ro9Fn/TNiA3
         bJeP+D3Scrm0yVEoccGYQZUZdrHWCRkczR6zHBpjZXkgnh7RK41O8tq61vh6FUkmqBz+
         5yXGSVRj0Sr8Zh08hCKM5U/DlNFYfaqM0Mp4tlchqpHoVZTfyksidNzMMb8iniPKKWg+
         cHJg==
X-Gm-Message-State: AOAM531mk5TgAtsYcetT4qcYaUfZmaYkd93ftj7Vc1HwoK+pHeNCvO9z
        WKRfjmSFs2qaN58HAzdSwd1Fv+yRDlQ=
X-Google-Smtp-Source: ABdhPJyoIu0wQ4hBnn6CVjaon6fLgdxpM5qGLsjpG0aQPuHhsFGVwWgMvS0aZ6/9dnxocuxZeRmUhA==
X-Received: by 2002:a17:90a:e28c:: with SMTP id d12mr24302506pjz.236.1610945835280;
        Sun, 17 Jan 2021 20:57:15 -0800 (PST)
Received: from garuda ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id m8sm14746341pjr.39.2021.01.17.20.57.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Jan 2021 20:57:14 -0800 (PST)
References: <161076031261.3386689.3320804567045193864.stgit@magnolia> <161076032453.3386689.17554565086009869010.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_scrub: detect infinite loops when scanning inodes
In-reply-to: <161076032453.3386689.17554565086009869010.stgit@magnolia>
Date:   Mon, 18 Jan 2021 10:27:11 +0530
Message-ID: <87ft2yn8pk.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 16 Jan 2021 at 06:55, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> During an inode scan (aka phase 3) when we're scanning the inode btree
> to find files to check, make sure that each invocation of inumbers
> actually gives us an inobt record with a startino that's at least as
> large as what we asked for so that we always make forward progress.
>

Looks good to me,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  scrub/inodes.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
>
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 63865113..cc73da7f 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -119,6 +119,7 @@ scan_ag_inodes(
>  	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
>  	struct xfs_bulkstat	*bs;
>  	struct xfs_inumbers	*inumbers;
> +	uint64_t		nextino = cvt_agino_to_ino(&ctx->mnt, agno, 0);
>  	int			i;
>  	int			error;
>  	int			stale_count = 0;
> @@ -153,6 +154,21 @@ scan_ag_inodes(
>  	/* Find the inode chunk & alloc mask */
>  	error = -xfrog_inumbers(&ctx->mnt, ireq);
>  	while (!error && !si->aborted && ireq->hdr.ocount > 0) {
> +		/*
> +		 * Make sure that we always make forward progress while we
> +		 * scan the inode btree.
> +		 */
> +		if (nextino > inumbers->xi_startino) {
> +			str_corrupt(ctx, descr,
> +	_("AG %u inode btree is corrupt near agino %lu, got %lu"), agno,
> +				cvt_ino_to_agino(&ctx->mnt, nextino),
> +				cvt_ino_to_agino(&ctx->mnt,
> +						ireq->inumbers[0].xi_startino));
> +			si->aborted = true;
> +			break;
> +		}
> +		nextino = ireq->hdr.ino;
> +
>  		/*
>  		 * We can have totally empty inode chunks on filesystems where
>  		 * there are more than 64 inodes per block.  Skip these.


-- 
chandan
