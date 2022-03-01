Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD56BC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 01:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiCABNV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 20:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiCABNU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 20:13:20 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26D9F44
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 17:12:40 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id f37so24294472lfv.8
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 17:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7sPR5FUt6BL5vY4zH7orS+P13v54d72vP0e3RrfoSc8=;
        b=dNq4touzRtz7uHynhq2fJfbFKWoMp3PFbmT4jP+lWtA+XEV7MUTaj9Bwb0dDhwVCKm
         Q/BC42Z7ZY0u0gvdOMlG7LxxZ5h5HJ2Yte8aQDgGIv9cAV05D8AcjdgXO3040/xi0YYq
         UaAoEYAw2FUw8zaH6DSetc0Wr5+8+bf3j3dq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7sPR5FUt6BL5vY4zH7orS+P13v54d72vP0e3RrfoSc8=;
        b=ikpbDS7eOUWYq1U3wgCeEBmAY+AebcgvcASi4MGPC1ylDokp/pNaqoeVPckraRxfxA
         faKGTHNHKtxrtTu+gT/sU/rQtQMaLBmDrrYICFQ8mLxEIlJzWAwT/n3DdhbElUxNADN/
         hVds7nMPqDjyIHmcQFpDcSJSIXtlbU+9ParsKcwhjt7Jo5/SZ/6Ns9bmoFXUjr21zylP
         CVJ6Kjil+oRHM8oA1O2QcqliYZRx1aUMUFu80nUQqlLnF1JGEdI81Kvs4A2dlaRJEqhD
         cCbM27prWWmZ3yCStwzui8SXJMgmyd2OsFjLwx1fAM6b8mWULnELGhIewNc1ryO4cZpu
         KQdg==
X-Gm-Message-State: AOAM533ZkgzCKg8p9pj3VspsZou01db+DChwn019/26uDWb4TfyWAas/
        vipopN3GbdfauCa37tjUrBy13lYemjhjdFnAH7o=
X-Google-Smtp-Source: ABdhPJwm223NvnhFenkr7w1gdXPitkv1kjYzECkSUpLN9Qr5QyPg0qVPWKbgZ7TB9e3kN4frULJ+xQ==
X-Received: by 2002:ac2:4423:0:b0:438:cc25:81ae with SMTP id w3-20020ac24423000000b00438cc2581aemr13816280lfl.212.1646097159041;
        Mon, 28 Feb 2022 17:12:39 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id p9-20020a19f109000000b00443a79313a8sm1216106lfh.271.2022.02.28.17.12.37
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 17:12:37 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id t13so12340990lfd.9
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 17:12:37 -0800 (PST)
X-Received: by 2002:ac2:4d91:0:b0:443:127b:558a with SMTP id
 g17-20020ac24d91000000b00443127b558amr14616139lfe.542.1646097157337; Mon, 28
 Feb 2022 17:12:37 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
 <20220219210354.GF59715@dread.disaster.area> <CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
 <YhN76/ONC9qgIKQc@silpixa00400314> <CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
 <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
 <Yh0y75aegqS4jIP7@silpixa00400314> <Yh1aLfy/oBawCJIg@gondor.apana.org.au>
In-Reply-To: <Yh1aLfy/oBawCJIg@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 28 Feb 2022 17:12:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi+xewHz=BH7LcZAxrj9JXi66s9rp+kBqRchVG3a-b2BA@mail.gmail.com>
Message-ID: <CAHk-=wi+xewHz=BH7LcZAxrj9JXi66s9rp+kBqRchVG3a-b2BA@mail.gmail.com>
Subject: Re: Intel QAT on A2SDi-8C-HLN4F causes massive data corruption with
 dm-crypt + xfs
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Kyle Sanderson <kyle.leet@gmail.com>,
        Dave Chinner <david@fromorbit.com>, qat-linux@intel.com,
        Linux-Kernal <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 28, 2022 at 3:26 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Indeed, qat has been disabled for dm-crypt since
>
> commit b8aa7dc5c7535f9abfca4bceb0ade9ee10cf5f54
> Author: Mikulas Patocka <mpatocka@redhat.com>
> Date:   Thu Jul 9 23:20:41 2020 -0700
>
>     crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY
>
> So this should no longer be an issue with an up-to-date kernel.

Ok, that commit message doesn't exactly make it clear that it also
fixes a major disk corruption issue.

It sounds like it was incidental and almost accidental that it fixed
that thing, and nobody realized it should perhaps be also moved to
stable.

Oh, except I think you *also* need commit cd74693870fb ("dm crypt:
don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY") that
actually reacts to that flag.

Which also wasn't marked for stable, and which is why 5.10 is ok, but
5.9 (which has that first commit, but not the second) is not ok.

Of course, maybe they got marked for stable separately and actually
have been back-ported, but it doesn't sound like that happened.. I
didn't actually check.

                  Linus
