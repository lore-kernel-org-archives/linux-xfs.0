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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D4A9C48BD1
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 08:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E041A613F1
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 08:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhFJI7t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 04:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhFJI7s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 04:59:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148BDC061574;
        Thu, 10 Jun 2021 01:57:53 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id md2-20020a17090b23c2b029016de4440381so3411012pjb.1;
        Thu, 10 Jun 2021 01:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ijWZr6HXHyIcQWn5sH05q8yu47bOscUp5VhIIoB/qUI=;
        b=jJG8ndrRtefLijwy87Q438NPh0jliDP/q3liBUoLkVYyzttfDudX2xnxyyavuWYP48
         cj1Cs7daQuY7R0b+Q5ouu436bVfCxjUoAXLGu2v+UEAy62JfMhw5FGOzUB9pvJfgGvFV
         qTF4FL9bAV2unbEu5UCDhJ9ogDQbbM6m0X9PFQxGW+NdmnSKHjp9ubL8rpac/elHGBQO
         HwuiFczrtoWsNpIIoGp72CVRA5t5/N6ppa9mEzJYs51vOI/PeE5DCIfxi72dEE246nIS
         wD/h6a+Ss2kMMHCUh+oGdD2pVg84uw/NU6tjLlroIva3Td+B8x2oh7nbriLHhBX0gAr5
         moZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ijWZr6HXHyIcQWn5sH05q8yu47bOscUp5VhIIoB/qUI=;
        b=gZKCqCidapb0RKmpSaOC365XiIbQQRHkot1mEjwGF3ZOOKOrSvpr5hF5LSC2IGTzZ/
         S+Jp7a+mVI050Nqnm3XAXdDwEBjll6zqwzKYyV2SQrphL9pjgZSdiBjgPJMjzOb15nnQ
         wktRjxIA3jsrFxLBvdPsy1/qkIje3F43EGWMUzgyWZHcd3GN0Pn/DTc1IL23MUNtPoKB
         D788kXrDXGIV96tCCOVI91k1j2NTt2opiy7jrMRgXM9NtGLDEcFpkqwKN0yBkhn9Kgqd
         wb21kUqcmcuuouJKH+sMkT12YkklmgBETo2xADFpkSvqhLXytIyzKqQSioAjb+DMIGRL
         ZUGw==
X-Gm-Message-State: AOAM5320y51VdJY1u2ILPR2rr+IC9FULVUWeFI1Tzr4TZcLpbPNeQ1el
        2gssevRheL2D11PvO1zKbZQ=
X-Google-Smtp-Source: ABdhPJw74agagSohQPUJDaeCCsNd1D5MMcdD93LSVrrIs3c2mbR6der628jrKvnngN6PS8un7xq3qQ==
X-Received: by 2002:a17:90a:8c14:: with SMTP id a20mr2278053pjo.167.1623315472589;
        Thu, 10 Jun 2021 01:57:52 -0700 (PDT)
Received: from garuda ([122.171.171.192])
        by smtp.gmail.com with ESMTPSA id ep6sm7091441pjb.24.2021.06.10.01.57.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Jun 2021 01:57:52 -0700 (PDT)
References: <162317276202.653489.13006238543620278716.stgit@locust> <162317279504.653489.6631181052382825481.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 06/13] fstests: clean up open-coded golden output
In-reply-to: <162317279504.653489.6631181052382825481.stgit@locust>
Date:   Thu, 10 Jun 2021 14:27:48 +0530
Message-ID: <87tum6p04z.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jun 2021 at 22:49, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Fix the handful of tests that open-coded 'QA output created by XXX'.
>

Grep shows that the files modified by this patch are the only ones having open
coded header in a *.out file. Hence,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/btrfs/006.out   |    2 +-
>  tests/btrfs/012.out   |    2 +-
>  tests/generic/184.out |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
>
> diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
> index a9769721..b7f29f96 100644
> --- a/tests/btrfs/006.out
> +++ b/tests/btrfs/006.out
> @@ -1,4 +1,4 @@
> -== QA output created by 006
> +QA output created by 006
>  == Set filesystem label to TestLabel.006
>  == Get filesystem label
>  TestLabel.006
> diff --git a/tests/btrfs/012.out b/tests/btrfs/012.out
> index 2a41e7e4..7aa5ae94 100644
> --- a/tests/btrfs/012.out
> +++ b/tests/btrfs/012.out
> @@ -1 +1 @@
> -== QA output created by 012
> +QA output created by 012
> diff --git a/tests/generic/184.out b/tests/generic/184.out
> index 2d19691d..4c300543 100644
> --- a/tests/generic/184.out
> +++ b/tests/generic/184.out
> @@ -1 +1 @@
> -QA output created by 184 - silence is golden
> +QA output created by 184


--
chandan
