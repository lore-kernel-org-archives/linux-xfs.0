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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBFCC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 14:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C5D364F4F
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 14:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhCDOm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 09:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbhCDOm1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 09:42:27 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44329C061574;
        Thu,  4 Mar 2021 06:41:47 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l18so7130785pji.3;
        Thu, 04 Mar 2021 06:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=iLdrSrR89fZUIl66tJJxjyxwv/A0Dvm9FKzcVfrVOlY=;
        b=Oi9hEKG4V0qjmi4r9h/CRXk0CdivpcBmREzbbojxkfEXVPk8RHOlHeyBILQnu5Ltfu
         m7ZZw7AudC6tbYvU4xc0BY592ovjrpMxA6KYBbnUveluT0O4SUvCeZ/xK5nhUoOu9PYF
         59mkvkIn9dW5qTSTCUmIn2AMYA+AdJx/+KWaRKDnqxV+P5VPYcaRimDW1xxEwXQMdGX6
         7lt0roXVVAMExqgZPgf5bO3hvBa6lLl1GJclJbp4CJXJKOjjSuqvWkqaFTHQ6gxAPyaB
         fb1iLkm446UrAoBspDuhRx+pfRbMeE2Z3YXN74LIdlY/9sPiXyoAVm67e4a8OMjkP6+y
         9ptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=iLdrSrR89fZUIl66tJJxjyxwv/A0Dvm9FKzcVfrVOlY=;
        b=sP0tGp2Rx2yWnSO9Bxp38H55ZgImX8n/KAILcM2l/4rFgsnIhZ4a/UQ1nN/HAB/msf
         Q+h0hn+t8kdgMa3K41i0c0Zym/KAfZYGJaQ5JGzcMkYSaD/MinYIAJeYn90eUN4PYFG0
         5OnHKi+/U/fczcwH+0x3CVz4Xpx22m6TuXdvqRWYZnbJTmu/YMmmvCAK/GmqTh+eGWCV
         EsbmRupir7OIfwwU3Sya6b+USaDsEMoLuxBrvsRxkpk6jASOnA3Xx0RxXBn7OGyCbrTG
         eSLi4zAY4vd3MshZk0cF24qTEaMv/eBXPN2bE6T6znPJbEtedL9Hj/FeOQGFvGvHiAm4
         kckA==
X-Gm-Message-State: AOAM531ZJ3/MhyewB30bcqUUtkMrbydCVvlK+1vtHqKb0U+rQFlIJyUg
        0OZ/9bEYKGU6ClSKVmcI1PA=
X-Google-Smtp-Source: ABdhPJwx/zKw7yAYFfv2bv9whKBJ2pXqqrk6yoFwrdchZehuUszU4vRncdy+ajK4oEeG34gS8MN21Q==
X-Received: by 2002:a17:902:d893:b029:e3:f3ce:cc6a with SMTP id b19-20020a170902d893b02900e3f3cecc6amr4296368plz.28.1614868906867;
        Thu, 04 Mar 2021 06:41:46 -0800 (PST)
Received: from garuda ([122.179.119.194])
        by smtp.gmail.com with ESMTPSA id b3sm26487127pgd.48.2021.03.04.06.41.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Mar 2021 06:41:46 -0800 (PST)
References: <161472735404.3478298.8179031068431918520.stgit@magnolia> <161472735969.3478298.17752955323122832118.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/4] generic/623: don't fail on core dumps
In-reply-to: <161472735969.3478298.17752955323122832118.stgit@magnolia>
Date:   Thu, 04 Mar 2021 20:11:43 +0530
Message-ID: <87o8fzouag.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Mar 2021 at 04:52, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> This test is designed to fail an mmap write and see what happens.
> Typically this is a segmentation fault.  If the user's computer is
> configured to capture core dumps, this will cause the test to fail, even
> though we got the reaction we wanted.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/623 |    1 +
>  1 file changed, 1 insertion(+)
>
>
> diff --git a/tests/generic/623 b/tests/generic/623
> index 7be38955..04411405 100755
> --- a/tests/generic/623
> +++ b/tests/generic/623
> @@ -37,6 +37,7 @@ _scratch_mount
>  # status on the page.
>  file=$SCRATCH_MNT/file
>  $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
> +ulimit -c 0
>  $XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
>  	-c "mwrite 0 4k" $file | _filter_xfs_io
>  


-- 
chandan
