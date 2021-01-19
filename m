Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D6AC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 21:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD5E22DD3
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 21:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbhASVhB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 16:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728438AbhASVgX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 16:36:23 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514C7C061573
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 13:35:43 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id c12so2618529wrc.7
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 13:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XlQPhrxGlTWN8pr5XfOyBIjv5bg3V5TX4STCJbqq1Sk=;
        b=gP1KFJKG6brbo0mU2vX0dnGXgrYgZTquWSKBH0MYLqV7JgcRJOX8i/e0q5iAJyXISZ
         5Iw77NgvAOcGUVfnpk3YX567KyXR5qfDO75+2zajfBn9e1pD1AdYgWGalHipwvcSOwWv
         eZ4Pih/0BuPhnHx1Lar6WkzIhfcnhXhWi50024xulrY4A+iSSGpEgLrxc4gbqtuPRSaB
         NxcCuWqhJDYvOMl6E2DYNevvXseSGpVyl5Ftb279jJku9vghIJSUlbSE5NUqiZgukv11
         Kn7wg5x4j5oCd0fBcVbTRTqgpFGP+M7xfLOnMA9dpFFOjRpVcmQS5kMqYBM4OvNtUjwn
         iyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XlQPhrxGlTWN8pr5XfOyBIjv5bg3V5TX4STCJbqq1Sk=;
        b=T5Mbr76m5Lj9hKwytjayS93OpevdMurrDD/lIV57rh5zTFWZXt9Z+P7cPYON9SGNZw
         6zx6vMuhjweF9cQyX3La1f4cuS9RgfklT/WDlw3kvIH9Qx+PKixiQURES7A+UQW/2o2m
         nmNmI53f/YRvVBgdKrMTA54X11CfeLhyN2/AkQrwKrITwGJxJW/qXUBePdceDtaP4470
         L80TLqBe8TTbWWzwDV/JUoU4x94QTnNVRXnQ8d9tMtA6xoTrbY+wjv75cLHjV2jlSNfY
         EgNnv2UPXCs3Hc+u1q/Mb6u4FMxhVOm+BdVM++Pk83TR8s6SqeSV09lySJmqNOrIwj3O
         sVHQ==
X-Gm-Message-State: AOAM532OyC5ShX1jg/VIDW2rlVZ3m4nEfqK4Bw4n3dVgQksWto2XwkIY
        LMzNDwDUlA0eKWAZZjCqJ9TK7HzFN3zDA3vy
X-Google-Smtp-Source: ABdhPJwi+I7D+di53jWCn21QOGUE7CtHt5wbcw0q624MER1eV75CMsYT4ar8pxyTjLk16bJjarT+/g==
X-Received: by 2002:adf:f605:: with SMTP id t5mr6033114wrp.39.1611092142079;
        Tue, 19 Jan 2021 13:35:42 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:ebbc:e7b1:bde:1433? (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id c2sm85229wmd.10.2021.01.19.13.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 13:35:41 -0800 (PST)
To:     nathans@redhat.com
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
 <49ecc92b-6f67-5938-af41-209a0e303e8e@sandeen.net>
 <522af0f2-8485-148f-1ec2-96576925f88e@fishpost.de>
 <e96dc035-ba4b-1a50-bc2d-fba2d3e552d8@sandeen.net>
 <3a1bd0e4-a4b2-5822-ed1a-d9a443b8ace7@fishpost.de>
 <CAFMei7MbBu9zfoXfE9+mTo1TtMzov-DEPWj6KPfw7Aa_PMnU4g@mail.gmail.com>
From:   Bastian Germann <bastiangermann@fishpost.de>
Subject: Re: [PATCH v2 0/6] debian: xfsprogs package clean-up
Message-ID: <7455b035-34ae-7d0d-faf9-1c69cccf28b7@fishpost.de>
Date:   Tue, 19 Jan 2021 22:35:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAFMei7MbBu9zfoXfE9+mTo1TtMzov-DEPWj6KPfw7Aa_PMnU4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am 19.01.21 um 22:26 schrieb Nathan Scott:
> You should have the necessary permissions to do uploads since
> yesterday Bastian - is that not the case?

I just checked. Yes, it is the case. However, I was not notified about 
the upload permissions, which usually is the case. Thanks.
