Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF00C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AC17206B6
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5bBmAbz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgJ2KMk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgJ2KMk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:12:40 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC11AC0613D3;
        Thu, 29 Oct 2020 03:12:09 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g12so1932194pgm.8;
        Thu, 29 Oct 2020 03:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ya7F/cXAS2kW6YPBdx/WL0ZD+cLn/kNmmmClJevJfXc=;
        b=d5bBmAbzdD2PBuaQbQz+t1c1ec+qtu/yvQkM8etz62vzwBpqbV78hgEU5Uj+mdAyAG
         PFWdPh7yYRXHhgYauTfDpxBOGUWQYJ35vcTYdKbT4IimptHx0tLr1a2Z8IBLk5jALDvK
         xT4b59La+6Jq3pnUVCwitn8l87agIPK19DoEi8NqwDLfncXNmgIxN0OtSU/P+nga4aLZ
         LJhj4mQEEbHVNInMUUyFSA7XjeumB4Peno20mDhHUfftVQc/Vaf6McPrnaFGPy7GteEA
         IDzk7EEh2VqYKGRlZRfXr9be1mMLzkNhS2mhXAiMecPzs9z0ZeIWfXIjfYR8+g/AEw2z
         F1vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ya7F/cXAS2kW6YPBdx/WL0ZD+cLn/kNmmmClJevJfXc=;
        b=FYZEFe43UiPErQjhHPzOj0S9+7nxFsEm2/t0cWHwfxRmOTnyFAC47U4h6cGjTTGI+u
         YO96YSvacBpzJFv1VC+Jqgcx4AEl5E6fdihyWvSN/IISWzklrSLKl9jAtl4JPcW8HNvZ
         AcH0FRa5MCuRki9TbIE1cDEmFOKmXUz4H97DJQJLEEHXflfysPsGwqLTJUHhqGUmeRZ3
         M4+kXxiRQfVrdlryK66KKGZGRQOxzZf8sGpmY8tCoHH7QXc3+4OyHOgOpGlxbOUkhzdN
         h1OuW4nPVdnIQoo8yhVRYyI8ELVMtzIwYawajGAmpATBKZxmRwBO/hri2FgsmSaqjj0l
         kKKg==
X-Gm-Message-State: AOAM532dVazgfUi1fjIoqeoUTyhVVYqer0qAqJMe7MlBv3Ldy98r8UWY
        m3Jxq5hq0qoZtamD1WZkLcc=
X-Google-Smtp-Source: ABdhPJwh70efz1n80imUMV8pe8qfg99QftGB6EoXHE2FbGd/t1qdc7z3Ivu0AzeqhHrGi1kgX1p6HA==
X-Received: by 2002:a17:90a:8906:: with SMTP id u6mr3701899pjn.35.1603966329528;
        Thu, 29 Oct 2020 03:12:09 -0700 (PDT)
Received: from garuda.localnet ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id 204sm2431639pfz.74.2020.10.29.03.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:12:08 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs/122: fix test for xfs_attr_shortform_t conversion
Date:   Thu, 29 Oct 2020 15:42:05 +0530
Message-ID: <2035765.IcyYpOg2Bb@garuda>
In-Reply-To: <160382539620.1203387.14717204905418805283.stgit@magnolia>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia> <160382539620.1203387.14717204905418805283.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 28 October 2020 12:33:16 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The typedef xfs_attr_shortform_t was converted to a struct in 5.10.
> Update this test to pass.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/122.out |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index 45c42e59..cfe09c6d 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -62,6 +62,7 @@ sizeof(struct xfs_agfl) = 36
>  sizeof(struct xfs_attr3_leaf_hdr) = 80
>  sizeof(struct xfs_attr3_leafblock) = 88
>  sizeof(struct xfs_attr3_rmt_hdr) = 56
> +sizeof(struct xfs_attr_shortform) = 8
>  sizeof(struct xfs_btree_block) = 72
>  sizeof(struct xfs_btree_block_lhdr) = 64
>  sizeof(struct xfs_btree_block_shdr) = 48
> 
> 


-- 
chandan



