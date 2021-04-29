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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD39FC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 07:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C2EE6143D
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 07:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhD2H3N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 03:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbhD2H3M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Apr 2021 03:29:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAC2C06138B
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 00:28:24 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id v191so3701170pfc.8
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 00:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=PqBlVsc2rA3Qm1B+9a56oIOY0r+uMzLrZKrA0BgFWnY=;
        b=eO1E7OY6tfeOZX1dMOnHLZHheLNFDXSenVb0BlRXmKmw/A8t7H19oM4dpEZoVbu2/H
         YTpCZhNjoJGh5+GNhQjNePBZFBhUhtnVh3sHfLroQZWpRTXVV+hEtDAaycPOVa8GJdMk
         3s7T9vikUOmnuUR588NYdlm4vzSxXIOzi/7+/zpfHOyEnYEefuon7AoLBUfgNgreMJxs
         l7fp+zcURGnCCb0KsvH1nTLU7+a3YPLUcynvx5Bqfy0wPQUaNgr/v75QvG7L5EjUU3l7
         VKKqRviGwCzajxoggP9n9XsEHMZcEQHcnjnDFwkHPAtyHjZnJf+PbhlnYrNhwMnS8HrB
         lKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=PqBlVsc2rA3Qm1B+9a56oIOY0r+uMzLrZKrA0BgFWnY=;
        b=ZsOVXpniOw+rMEh3azEroxi2bd7RWXwCTP41d2Yk8cw+dNPcm/FNqfPt3wlpFq2TDl
         p9a80hBcNOhEOgK6zlxFqekhM9lLTYzZpL3zU0E9+RU6z+zMuRMIxBMhFVZuVVJQjx4+
         Hdz3jWsiwJFSt6adaxw8eko7wL/ez/ALHarTBCwU3rHMiRjcMZ/9MGvKFog/yeh/jsC2
         Qt0ZsbUADAWB5do/GHzxg8YnhEVvCDk8kwuj5YacWP17gtD0M/KB/mmflTrEG2p6SsHW
         /MiLv2FdR21wLsyHPtxiZxwb9pCXM83C6mSNIVJAFjqm9+mU3HRYiYqPyfI7Wv0dAk3f
         eaxw==
X-Gm-Message-State: AOAM531ISWG+sAdj3D3sTMmdpDJKeThVTSGYObgeq4uM2bhbu+bOSHG8
        dyK5+3ACxPc/yRjHLgbYWN4fhPQiNKg=
X-Google-Smtp-Source: ABdhPJyaspka0KKMNi8way/ZNWadG57b1Pg2QB26S3aDf8/E1PWnkZAI47L5xQv7baurw5ILoAE5hQ==
X-Received: by 2002:a63:8f15:: with SMTP id n21mr7169879pgd.366.1619681303520;
        Thu, 29 Apr 2021 00:28:23 -0700 (PDT)
Received: from garuda ([122.179.68.135])
        by smtp.gmail.com with ESMTPSA id z12sm6767050pjt.29.2021.04.29.00.28.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Apr 2021 00:28:23 -0700 (PDT)
References: <20210429054416.GJ1251862@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range
In-reply-to: <20210429054416.GJ1251862@magnolia>
Date:   Thu, 29 Apr 2021 12:58:20 +0530
Message-ID: <87k0ola6sr.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 29 Apr 2021 at 11:14, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> The final parameter of filemap_write_and_wait_range is the end of the
> range to flush, not the length of the range to flush.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Fixes: 46afb0628b86 ("xfs: only flush the unshared range in xfs_reflink_unshare")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_reflink.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 4dd4af6ac2ef..060695d6d56a 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1522,7 +1522,8 @@ xfs_reflink_unshare(
>  	if (error)
>  		goto out;
>  
> -	error = filemap_write_and_wait_range(inode->i_mapping, offset, len);
> +	error = filemap_write_and_wait_range(inode->i_mapping, offset,
> +			offset + len - 1);
>  	if (error)
>  		goto out;
>  


-- 
chandan
