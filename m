Return-Path: <SRS0=bjGU=EK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEC1C2D0A3
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Nov 2020 09:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F8A7221F9
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Nov 2020 09:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cn2A9XXF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgKDJh0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Nov 2020 04:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgKDJh0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Nov 2020 04:37:26 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7300C0613D3
        for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2020 01:37:25 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id i26so16113897pgl.5
        for <linux-xfs@vger.kernel.org>; Wed, 04 Nov 2020 01:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fMVVeLT3xBRGayR48DYMFNwUvOXbtuhQ9iL6Gf9bWF8=;
        b=Cn2A9XXFMHXar1l0baS8OwJYn+rgr510+qKG9lPAJVJ5cYIR2WoLWNcPwUo8BeKjKb
         Hwpp8+fEwKB6cy0anwKnpEjaU/1v1WW92GZ+6tHLcFqTNKCS4TDz7ICyWh5lhxHdIMNd
         C1WYdSpNp7fxGnLn+MqW6QnMdDAPm4Nd0Bk/b7cQVBibDnqdF2e+DgM05IL0iMgU+mwT
         jBV0lFx040I9YlteXE7paHd/me9Fd57ll9MPuFBMgMZMP2ULWSGJTuMr/z4zqlpOo2nw
         6jjt00w5OtRhExHotjjz1AcBThSpG+QA1Z0j/KE4hSYItYehCfwFSyuUamoIq+hyvdD0
         EpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fMVVeLT3xBRGayR48DYMFNwUvOXbtuhQ9iL6Gf9bWF8=;
        b=RD74Q6pqz+Ak2tuXsI8+m+0N0V6/sDNaBfIMpDWWU78mAzxvptVA/wd3Ditc7F7om+
         IKg9LF7gd1oCITM2EvGh+O5LpPhDpVCK+viTVM7JCvh9xNRLaL0QxgEbmKkYrhIDi2+4
         C4zRDvmpKZbsJLjQCu++8HUgONlcLNruo6D4idfba3aIjZ42UYDBVXG6pW2XTLFrhZqV
         NjWXRPR8he3ycPNcHAr3bhRnb0eBryBPukxjJO+aFTbbA5vBvUW3WNhct2vZ4st96bIe
         tg9Vw2xYidezw5aTJbUPhoOFNAGFQVWLNrIgi1EaiXfCjJodY+RxEsujyqAukqOMzVYv
         7RVA==
X-Gm-Message-State: AOAM532qXlohbFtuk3AD0vUnI5FtlI6NNRvXV8qJgUSdbBkpb+veJZB0
        iJ4pgPhRjVQtP06z1s0QLclhVwX3Sr8=
X-Google-Smtp-Source: ABdhPJxC5g0utgiog0T+Z5DJaZJCQah06Yb7k282TyTjrXMwxsmhqdvdichoM4VPJ2vJSkTs6H3t9g==
X-Received: by 2002:a65:4bc8:: with SMTP id p8mr16784956pgr.335.1604482645521;
        Wed, 04 Nov 2020 01:37:25 -0800 (PST)
Received: from garuda.localnet ([122.171.54.58])
        by smtp.gmail.com with ESMTPSA id x123sm1784752pfb.212.2020.11.04.01.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:37:24 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: only flush the unshared range in xfs_reflink_unshare
Date:   Wed, 04 Nov 2020 15:07:22 +0530
Message-ID: <1998006.DMGvZ8J8Fo@garuda>
In-Reply-To: <20201103183733.GI7123@magnolia>
References: <20201103183733.GI7123@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 4 November 2020 12:07:33 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's no reason to flush an entire file when we're unsharing part of
> a file.  Therefore, only initiate writeback on the selected range.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 16098dc42add..6fa05fb78189 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1502,7 +1502,8 @@ xfs_reflink_unshare(
>  			&xfs_buffered_write_iomap_ops);
>  	if (error)
>  		goto out;
> -	error = filemap_write_and_wait(inode->i_mapping);
> +
> +	error = filemap_write_and_wait_range(inode->i_mapping, offset, len);
>  	if (error)
>  		goto out;
>  
> 


-- 
chandan



