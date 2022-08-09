Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F23C25B0C
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 16:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245034AbiHIQaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245146AbiHIQ3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 12:29:53 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154A01EED2;
        Tue,  9 Aug 2022 09:29:46 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id bq26so3108682vkb.8;
        Tue, 09 Aug 2022 09:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=x+ttcPoA/KoQ5avMwK51uUUH2vH4wW3EQ6pBYzXsPLc=;
        b=qyUPd0o2JLqZffNQwAgpwiKEO84tifagNR9igeIbMUnhHe9x4+oImzVhwposHFXH82
         BpJ47g95l7LZC4q46HiV7wkGLqUFgonl3YaBNIDgerlZOHpEUz+YRwL53BiqpoaY1RrH
         okQwZnLZy4sWH7zHc/ZfN39kvNnQ3Hn6VKyL+xBMD3bOcRtuPSQsqpW9oP5MQB6cnAb8
         ZypUMwaYAQMsiAEWZsJH3DYjy94JWXZ+NSR92RYGpDCcm19XbatrxpcMllRBrq92Qkea
         RS3uEwJ+UBlH4PYakg+u4Ec1O2iaP2xd+zhLQB9sXnkxHpfUIlVp7nkfvreh2+yXo1Iw
         Uzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=x+ttcPoA/KoQ5avMwK51uUUH2vH4wW3EQ6pBYzXsPLc=;
        b=S6euTVIfNZw0BfwvMJPA46hxLtlBdRCw6wDqtC9GGdxMwTttuaQWpT3YF6nCDHjqX5
         1N/bQO6pV38iVOjTgKRDFBRFlraQoAoIXXK8SSzAybHJfZopICtNNd8QcrgiHVJnmltO
         bjfCU4M5EvCEcM4kN9D8lW3z9Vvo+DnzIPL1FCBpAgfVx/8xhr/c/0VPnIZFVpQQbe2x
         W+Cr8nkIOAN0uPG9homo7pa/xLg0toiqItVUJxUYNHgOx6JAhAaeK0LqP8IO74UHS7S/
         PJwVOrNcfPNajK3NG7vp385Dfzrer95z4GuOLh9X3TIKY9FDt0YzC2TXK+Zw68+FAtug
         gkhA==
X-Gm-Message-State: ACgBeo36C3eqVnf9a8p2iGr/EICbpE11bMK5DhPDY2DjvHsmeIInI2F2
        ZXf0YP8RJSitQQ7ks6iW/axXuLqtCru8EAMxdlUEfA3R
X-Google-Smtp-Source: AA6agR4oiAbWrlC3abbXKBwJpp+fr+/+8lspL+iumX4ho2xyY756qZNmilfbIfgO4wlrlF5AmE6KaBAwjR//KZFHQfA=
X-Received: by 2002:a05:6122:da8:b0:376:c611:9cdf with SMTP id
 bc40-20020a0561220da800b00376c6119cdfmr10141817vkb.36.1660062585203; Tue, 09
 Aug 2022 09:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220809111708.92768-1-amir73il@gmail.com> <YvKLJMq+thXk6wsW@magnolia>
In-Reply-To: <YvKLJMq+thXk6wsW@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 9 Aug 2022 18:29:33 +0200
Message-ID: <CAOQ4uxh6vqnLtTVonPtns-zDfi5+-R8MJ=nrtgqusuVV8DWPgw@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 0/4] xfs stable candidate patches for
 5.10.y (from v5.15)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 9, 2022 at 6:28 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Tue, Aug 09, 2022 at 01:17:04PM +0200, Amir Goldstein wrote:
> > Hi Darrick,
> >
> > This is a small update of simple backports from v5.15 that shouldn't be
> > too hard to review.
> >
> > I rather take "remove support for disabling quota accounting" to 5.10.y
> > even though it is not a proper bug fix, as a defensive measure and in
> > order to match the expefctations of fstests from diabling quota.
>
> I don't agree with making quotaoff a nop after 136 releases of the 5.10
> series.  Turning off quota accounting on a running system might be
> risky, but anyone who's using it in 5.10 most likely expects it to
> continue working, infrequent warts and all.
>

OK.

> > These backports survived the standard auto group soak for over 40 runs
> > on the 5 test configs.
> >
> > Please ACK.
>
> Patches 2-4 are straightforward fixes, so:
> Acked-by: Darrick J. Wong <djwong@kernel.org>
>

Thanks,
Amir.
