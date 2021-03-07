Return-Path: <SRS0=xiMZ=IF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE375C433DB
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 12:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E026501D
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 12:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCGMIF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 07:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhCGMHl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Mar 2021 07:07:41 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA29C06174A
        for <linux-xfs@vger.kernel.org>; Sun,  7 Mar 2021 04:07:40 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id lr13so14349555ejb.8
        for <linux-xfs@vger.kernel.org>; Sun, 07 Mar 2021 04:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rATENos7+MdMi1AQ2hRE9KJFszbL1b4Fnef7mg7FIuE=;
        b=In66PxE+5SUqvT1bF1mqC+/nAnO9KmWxiP2a8V6lh7hjQ0GK7NqO86Xhe56nymHNpJ
         bNc9Xv96E1QxGX0dIssCadl0NuFN1z8fErRs3xqg5ddoHOqTJwzVizAmvw/bWb0RY2iP
         hANYKEf9TKFPKuKl0oNLXTb+h7XNXxu9HVTHovhyDKdg4WTJw6kLV1X3R5EAh3PmOTcK
         Dq094Z1qL/rr5/chwUYDHskyZSGCBI0SoSfuqcwUe5vMK4G3p/nUqIJnmekIN7bYp1IL
         /a0ZY43jk6n/e7N2Gy9QLJQvDmhN7mPHDGJZNlXxfP6IXu7Ez+vBNr64u088oRY6yHdD
         fYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rATENos7+MdMi1AQ2hRE9KJFszbL1b4Fnef7mg7FIuE=;
        b=L/MsFPfq5FPKnMhITmhCUQZZIRtZtqSowQ4pubUtqmHMddb1nW4MeLI75caXKwkeaS
         L77muXArWl2YAI8SoAD/Flj0nLp+tFkh/ohW5euz24X+jIq9ekBIYuHZPrjdGMcAOzKF
         RMFwUkVnTmmLGSIInsAW+SIPRRg98xIsXQTC9gTwZjS56DH8n/ke1/pidMXkIHAuAksJ
         ySuG+YIj8zZUfbx1uREeMj4kL6FbuzO1SiSK/Sj4niUimrCT2/jfFnoXulMxL6yGzcsP
         LuRhgrPu1e8QBxonAo3NZLShKMtyh5IENeV3nFna/auUyB3frCHmGdiV3eQOram6HfXt
         kTbw==
X-Gm-Message-State: AOAM530Kg0REdVVN2K/aBvUgP3NhMIwxLipslPpExxcMKQdqr4zRNidl
        6Or5My1i3z0eWjz3saVwvuU1dmlVWxUftw==
X-Google-Smtp-Source: ABdhPJw6hAu0kZXpGCA4zHLMVIOUO8yFWQbNtxws8N11rBWbELHM2mJSl/J4bf/+hnguic9HTrYYjw==
X-Received: by 2002:a17:906:3e92:: with SMTP id a18mr10178965ejj.95.1615118859410;
        Sun, 07 Mar 2021 04:07:39 -0800 (PST)
Received: from ?IPv6:2003:d0:6f2c:df00:2a7b:9283:37dc:e408? (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id g25sm5068321edp.95.2021.03.07.04.07.38
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Mar 2021 04:07:38 -0800 (PST)
Subject: Re: [PATCH v2 0/2] debian: Fix problems introduced with 5.10.0
To:     linux-xfs@vger.kernel.org
References: <20210221093946.3473-1-bastiangermann@fishpost.de>
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <8f1f91b8-b2a8-e0c3-eb8c-092e16802404@fishpost.de>
Date:   Sun, 7 Mar 2021 13:07:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210221093946.3473-1-bastiangermann@fishpost.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am 21.02.21 um 10:39 schrieb Bastian Germann:
> There were two bugs introduced with the 5.6 -> 5.10 change in Debian:
> RISC-V does not build. Fix that by regenerating it.
> The new libinih package did not have a udeb package which is needed by
> xfsprogs-udeb. Explicitly depend on newer libinih versions.
> 
> Changelog:
>   v2: Drop Dimitri's Ubuntu changes (related to CET)
> 
> Bastian Germann (2):
>    debian: Regenerate config.guess using debhelper
>    debian: Build-depend on libinih-dev with udeb package
> 
>   debian/changelog | 10 ++++++++++
>   debian/control   |  2 +-
>   debian/rules     |  1 +
>   3 files changed, 12 insertions(+), 1 deletion(-)

Any chance of getting this reviewed series in the tree?
