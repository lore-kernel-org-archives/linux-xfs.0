Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917FAC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiB1T0y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiB1T0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:26:53 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44ED4114FE1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:26:08 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id v28so18811173ljv.9
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k5Nq2+gFOwIAZZv1z8A5AiR5tZQQa62jzNlsasSMp48=;
        b=hA07tqoOhzsc3WOqNCaR4tUruW+rdsfqY8YOw2mN7ILGOov8LZJfGyOH0+67N/0EaR
         4t/JTBCib0ytZP3PxoAumfh81bQl7oYkHnLaS7IusFI7m+FXPGCuZ+b2epjKsi5SuwbN
         6G/m+gkEWqvwTgFEdCkiL46LSGGVnwGjPchjI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k5Nq2+gFOwIAZZv1z8A5AiR5tZQQa62jzNlsasSMp48=;
        b=4qbblFxrCa5I1zva3T1UmbMR1mB38cwrc5l+H8/Ooy05yvpm1ONLFzp8OCtkBe7wdq
         xXUAdfoNfK5VI9+P2+1R8/qwL9kn17r2j1i/HiVrP25kL6y6hUQdCuKwTld6QlST+n0z
         XPNU37V6583LydrU2Bp35b+pDD/jyIuIYeavpllUOIgK32uUfvjIYDSnRN6h0wEmamYl
         nvVWn6WoQH6QgSPMIshB9w0zMNgeMZz0VLzQ76FQgInfS59h91wXuiqRty43eMjOqm4b
         A+unlvR5q0m/lxw+8iFmivKVJTVXKwTVCUcFHfVbOzKem12T2hFjOJBSNUh7AGjR/MQm
         d5kA==
X-Gm-Message-State: AOAM530ChW4taCwVSTLhKU7ax1ePIGorbCeazlwT9Md1xZtRAzHQYPG3
        ntRBNZAGufh8WT7PzrN7WHImBlXN51683vXAOcM=
X-Google-Smtp-Source: ABdhPJyflzP+AY920mN7JhFxiGa+RFA/7X8HLZ+zfHoCeJcYQeT1KEJusuii5KGrhkZOHoEoTdW92A==
X-Received: by 2002:a2e:9694:0:b0:246:3853:fe18 with SMTP id q20-20020a2e9694000000b002463853fe18mr15233313lji.348.1646076366369;
        Mon, 28 Feb 2022 11:26:06 -0800 (PST)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id o25-20020ac24959000000b00443fdf504bcsm1099391lfi.161.2022.02.28.11.26.05
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 11:26:05 -0800 (PST)
Received: by mail-lf1-f43.google.com with SMTP id b11so23098359lfb.12
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:26:05 -0800 (PST)
X-Received: by 2002:a05:6512:3042:b0:437:96f5:e68a with SMTP id
 b2-20020a056512304200b0043796f5e68amr14128474lfb.449.1646076365434; Mon, 28
 Feb 2022 11:26:05 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
 <20220219210354.GF59715@dread.disaster.area> <CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
 <YhN76/ONC9qgIKQc@silpixa00400314> <CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
In-Reply-To: <CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 28 Feb 2022 11:25:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
Message-ID: <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
Subject: Re: Intel QAT on A2SDi-8C-HLN4F causes massive data corruption with
 dm-crypt + xfs
To:     Kyle Sanderson <kyle.leet@gmail.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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

On Mon, Feb 28, 2022 at 12:18 AM Kyle Sanderson <kyle.leet@gmail.com> wrote:
>
> Makes sense - this kernel driver has been destroying users for many
> years. I'm disappointed that this critical bricking failure isn't
> searchable for others.

It does sound like we should just disable that driver entirely until
it is fixed.

Or at least the configuration that can cause problems, if there is
some particular sub-case. Although from a cursory glance and the
noises made in this thread, it looks like it's all of the 'qat_aeads'
cases (since that uses qat_alg_aead_enc() which can return -EAGAIN),
which effectively means that all of the QAT stuff.

So presumably CRYPTO_DEV_QAT should just be marked as

        depends on BROKEN || COMPILE_TEST

or similar?

              Linus
