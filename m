Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B996AC35267
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1FE2075E
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D07/sJnx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIQEbY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 00:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQEbX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 00:31:23 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96224C06174A;
        Wed, 16 Sep 2020 21:31:23 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d9so422509pfd.3;
        Wed, 16 Sep 2020 21:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fkEcIzJKG70a3dQiQZGrebteknUOYsWQd1XOUwQA0PA=;
        b=D07/sJnxciiKZb+wru8HsfxeDtjs/eHymFLQxSgu9B7kZjogNvv4YOhUSaCxjBf2S/
         RnG3Lv43CMoZqbn4GyswL4+oUD8eYr7w3jU0WvAB4Ta7QxGQEoA3HEvfL0++xQwlmSgJ
         YAUyrj/PWdMrzzCK3GPVaq48lrydSDtpvqC30qQo4OIduPp/6UzGPhCb5nSmeY+Vle4i
         /GALDxinIZyzCW0UPC+96ubX5MsbirNJY427CD+45D2DCSpLFkc3GL4o+eTqed+flVQR
         /e4M8U7hzxwh2OK7pUnN6mFoiVmQyiQEI4TQNzAnWgZD+MCWxkE8TyEiWINwcITkra+h
         h0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fkEcIzJKG70a3dQiQZGrebteknUOYsWQd1XOUwQA0PA=;
        b=RKA7LDrXKoZt0Di11FHUFCVnp0WXoHi0PuHFRKlE3j1MRUQ6geVVFr9WXUiyqzYRfM
         iLbe/RDgHrhmIrJvhc0fr+9iJeCNq5nX+i1rnLtToUIZuMjPDw1crDa2YQcsmr39pN23
         t4FmG9zPGFuiec3BW7wJeF0X+9vfwjxTtOh04xmX4De8NbXVDV+iOBdViW/GooJC9BvB
         Kn8NupMvNuAPhDI9GEVtIaMfg5SyD5cXj8ezO2ZZc9m7i99qtbYPktcgywjhGEAU5LOy
         Ob6yauSADGd1HHZaw2t0RDyS3wfYVV61AgRLpQcWHX4DSeQsU92t8ptvcC3cD/vz3pbW
         u5/A==
X-Gm-Message-State: AOAM533LXhOgz1St4FB5TwSVDX1w0UVyJNXgmx7KJbs+V07RuG8hbcIi
        BcJVCIqDJZCD1/9hoKyxw6/yVybNucI=
X-Google-Smtp-Source: ABdhPJza/Z9+pCSCfClJlGq9w0SNiarBY7pATrKZDKDpgdZPcWbeLpUxY9HpPQb6X7YPeAD3sD4OYQ==
X-Received: by 2002:a05:6a00:7d1:b029:142:2501:34e7 with SMTP id n17-20020a056a0007d1b0290142250134e7mr9583076pfu.64.1600317082903;
        Wed, 16 Sep 2020 21:31:22 -0700 (PDT)
Received: from garuda.localnet ([122.179.62.198])
        by smtp.gmail.com with ESMTPSA id g192sm18441824pfb.168.2020.09.16.21.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 21:31:22 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com,
        darrick.wong@oracle.com, zlang@redhat.com
Subject: Re: [PATCH 1/2] xfs: Add realtime group
Date:   Thu, 17 Sep 2020 10:01:14 +0530
Message-ID: <2800094.qH4kZmeDBE@garuda>
In-Reply-To: <20200917042844.6063-1-chandanrlinux@gmail.com>
References: <20200917042844.6063-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday 17 September 2020 9:58:43 AM IST Chandan Babu R wrote:
> This commit adds a new group to classify tests that can work with
> realtime devices.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---

Sorry, I forgot to add version number and also a changelog.

V1 -> V2:
  Remove xfs/070 from realtime group.
  
>  tests/xfs/group | 50 ++++++++++++++++++++++++-------------------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ed0d389e..b99ca082 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -87,11 +87,11 @@
>  087 fuzzers
>  088 fuzzers
>  089 fuzzers
> -090 rw auto
> +090 rw auto realtime
>  091 fuzzers
>  092 other auto quick
>  093 fuzzers
> -094 metadata dir ioctl auto
> +094 metadata dir ioctl auto realtime
>  095 log v2log auto
>  096 mkfs v2log auto quick
>  097 fuzzers
> @@ -119,7 +119,7 @@
>  119 log v2log auto freeze
>  120 fuzzers
>  121 shutdown log auto quick
> -122 other auto quick clone
> +122 other auto quick clone realtime
>  123 fuzzers
>  124 fuzzers
>  125 fuzzers
> @@ -128,7 +128,7 @@
>  128 auto quick clone fsr
>  129 auto quick clone
>  130 fuzzers clone
> -131 auto quick clone
> +131 auto quick clone realtime
>  132 auto quick
>  133 dangerous_fuzzers
>  134 dangerous_fuzzers
> @@ -188,7 +188,7 @@
>  188 ci dir auto
>  189 mount auto quick
>  190 rw auto quick
> -191-input-validation auto quick mkfs
> +191-input-validation auto quick mkfs realtime
>  192 auto quick clone
>  193 auto quick clone
>  194 rw auto
> @@ -272,7 +272,7 @@
>  273 auto rmap fsmap
>  274 auto quick rmap fsmap
>  275 auto quick rmap fsmap
> -276 auto quick rmap fsmap
> +276 auto quick rmap fsmap realtime
>  277 auto quick rmap fsmap
>  278 repair auto
>  279 auto mkfs
> @@ -287,7 +287,7 @@
>  288 auto quick repair fuzzers
>  289 growfs auto quick
>  290 auto rw prealloc quick ioctl zero
> -291 auto repair
> +291 auto repair realtime
>  292 auto mkfs quick
>  293 auto quick
>  294 auto dir metadata
> @@ -329,17 +329,17 @@
>  330 auto quick clone fsr quota
>  331 auto quick rmap clone
>  332 auto quick rmap clone collapse punch insert zero
> -333 auto quick rmap
> -334 auto quick rmap
> -335 auto rmap
> -336 auto rmap
> -337 fuzzers rmap
> -338 auto quick rmap
> -339 auto quick rmap
> -340 auto quick rmap
> -341 auto quick rmap
> -342 auto quick rmap
> -343 auto quick rmap collapse punch insert zero
> +333 auto quick rmap realtime
> +334 auto quick rmap realtime
> +335 auto rmap realtime
> +336 auto rmap realtime
> +337 fuzzers rmap realtime
> +338 auto quick rmap realtime
> +339 auto quick rmap realtime
> +340 auto quick rmap realtime
> +341 auto quick rmap realtime
> +342 auto quick rmap realtime
> +343 auto quick rmap collapse punch insert zero realtime
>  344 auto quick clone
>  345 auto quick clone
>  346 auto quick clone
> @@ -402,10 +402,10 @@
>  403 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  404 dangerous_fuzzers dangerous_scrub dangerous_repair
>  405 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -406 dangerous_fuzzers dangerous_scrub dangerous_repair
> -407 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -408 dangerous_fuzzers dangerous_scrub dangerous_repair
> -409 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> +406 dangerous_fuzzers dangerous_scrub dangerous_repair realtime
> +407 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
> +408 dangerous_fuzzers dangerous_scrub dangerous_repair realtime
> +409 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
>  410 dangerous_fuzzers dangerous_scrub dangerous_repair
>  411 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  412 dangerous_fuzzers dangerous_scrub dangerous_repair
> @@ -415,7 +415,7 @@
>  416 dangerous_fuzzers dangerous_scrub dangerous_repair
>  417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  418 dangerous_fuzzers dangerous_scrub dangerous_repair
> -419 auto quick swap
> +419 auto quick swap realtime
>  420 auto quick clone punch seek
>  421 auto quick clone punch seek
>  422 dangerous_scrub dangerous_online_repair
> @@ -477,8 +477,8 @@
>  478 dangerous_fuzzers dangerous_norepair
>  479 dangerous_fuzzers dangerous_norepair
>  480 dangerous_fuzzers dangerous_norepair
> -481 dangerous_fuzzers dangerous_norepair
> -482 dangerous_fuzzers dangerous_norepair
> +481 dangerous_fuzzers dangerous_norepair realtime
> +482 dangerous_fuzzers dangerous_norepair realtime
>  483 dangerous_fuzzers dangerous_norepair
>  484 dangerous_fuzzers dangerous_norepair
>  485 dangerous_fuzzers dangerous_norepair
> 


-- 
chandan



