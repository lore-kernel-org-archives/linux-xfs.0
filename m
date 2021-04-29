Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3DEC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 17:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E71613FF
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 17:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241057AbhD2Rv7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 13:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbhD2Rv7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Apr 2021 13:51:59 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36FEC06138C
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 10:51:11 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z13so25143372lft.1
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 10:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6As9QWB6Bh2AmK0gqxTfBNY3/GVKKNOfvjuvOCjRnsY=;
        b=CMBlR2cONsJRSVTzvsEhjwLrLl8X3/1UbmXgxMCZsoJVtJgmnPSAXsraEDcY8C0qhJ
         dF+0hqGhEuxcsoVcg63yfRv8tKMj+gxh5WAt8Ebm+NroA4rNJ0HxHMlPloS2ve88C9xH
         godFDieuF8yt8hRTWJ7DH02vPp+8OcauXV558=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6As9QWB6Bh2AmK0gqxTfBNY3/GVKKNOfvjuvOCjRnsY=;
        b=SKbKgmQWSnzM2+6du3NUmM45PmMZVbBCvtZrru/67bhFz8N9QSo4Bn1OQfUYYqQimm
         uMRtij0EcB/EJ0nuKbVCpTq8298yMdteeTVG3YvD/00HgUVqQ4IGsXdN08iiPPXCZnvU
         dU7okqSHB/SNfmaGMksspIyuyi+cZCoWj0xyl2W6+cb94D3qmQ/OSpDC42y6j9fZwUGg
         O3rAVxRrOkpsVPOSzL7If21yPCfRHRm5KKV0D6a2Hx5A13Tf5Zzc1/JPTZ5cVwJilTi8
         riAOHA9iBi1M/trl3lJlHD/8aQWRW3a+ZYqMkky7BfaikwX8IDvmJXdrlvwYdswM1Ky+
         7dgQ==
X-Gm-Message-State: AOAM530hxnLkgqIbVJl6AvLkaoJoLTrsM5rgW5QaAdTJ8F/+Z6vbAW93
        xU3Jfp3CENJG+w+UsmI4/5BQ5y/yUwYM4HVW
X-Google-Smtp-Source: ABdhPJweo+6xPLBfX7FPrEpsuKgw7sKBjg+yV0QWoX1M+XXEC+yW7M3w34oEYERfLI1M2Nfw3Eqh/g==
X-Received: by 2002:a05:6512:b25:: with SMTP id w37mr535371lfu.272.1619718670189;
        Thu, 29 Apr 2021 10:51:10 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id w14sm41707lfp.147.2021.04.29.10.51.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 10:51:08 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id 2so13418208lft.4
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 10:51:07 -0700 (PDT)
X-Received: by 2002:ac2:5f92:: with SMTP id r18mr484354lfe.253.1619718667143;
 Thu, 29 Apr 2021 10:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210429170619.GM3122264@magnolia>
In-Reply-To: <20210429170619.GM3122264@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 29 Apr 2021 10:50:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgpn570yfA+EM5yZ0T-m0c5jnLcx3WGSu3xR8E4DGvCFg@mail.gmail.com>
Message-ID: <CAHk-=wgpn570yfA+EM5yZ0T-m0c5jnLcx3WGSu3xR8E4DGvCFg@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new code for 5.13
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 29, 2021 at 10:06 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Unfortunately, some of our refactoring work collided with Miklos'
> patchset that refactors FS_IOC_[GS]ETFLAGS and FS_IOC_FS[GS]ETXATTR.

Ok, the resolution looked reasonably straightforward to me, and I
ended up with what looks like the same end result you did.

But I only did a visual inspection of our --cc diffs (you seem to use
--patience, which made my initial diff look different) and obviously
verified that it all builds cleanly, I didn't do any actual testing.

So please double-check that everything still looks good,

                 Linus
