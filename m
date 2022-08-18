Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E36C3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 11:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244491AbiHRL4Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 07:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244287AbiHRLzu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 07:55:50 -0400
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D79FAB433
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 04:55:48 -0700 (PDT)
Received: by mail-qk1-f170.google.com with SMTP id m5so898816qkk.1
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 04:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=85NezJFMBVXtq4N+YZNNZu+Un4/G1Q4uCCY11kAn1KY=;
        b=Q3Jo4Ao1gk8x66zgVc1KDMFQhk5x+Id108pNl82iYx7Rs//pdEPKIqXBEHNl/Uk+eW
         ++rvhzeC5DO/ldfO67uZzqAIB5/W3LD578/Ra/EcXmOwXuhM2s9M1b0xPXnWdXVaGG2V
         uwnzWTqKxjmKgysvfke21c+MP/tqnuxJ6xtX+9GJzpt+kpCENOG5v6zg9CRE5POzgFZX
         BhnXv/1ZgpNilpGs8wBANZ54SsuD57I+qAReaGerMRhLm2F/aDQ2P2BBRIsQSADPDPVm
         EE2ePYCi1galciskkFfXKeW2YaFpgKxwxPevRoH/or1eN0swlVhT4PMIP22HDRIvNBCV
         6FFQ==
X-Gm-Message-State: ACgBeo3g3a8GAL8/3b/ODdnYMHQer83fZYvRwYmpxGt2oksEtNafrDMx
        YNqDGmc2Uke1fCGFLLclcgyh5lr8xtOniw==
X-Google-Smtp-Source: AA6agR5rkxdl871IkLOQTte12Znj7xY5PmMc3u4APsTUZFdzqzkxezYOHvFIitQ/lbZ/NjmmtHYpSQ==
X-Received: by 2002:a05:620a:24d4:b0:6bb:760:4b8f with SMTP id m20-20020a05620a24d400b006bb07604b8fmr1704138qkn.83.1660823747140;
        Thu, 18 Aug 2022 04:55:47 -0700 (PDT)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id q66-20020ae9dc45000000b006bba6c614casm1340578qkf.13.2022.08.18.04.55.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 04:55:46 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-324ec5a9e97so34165887b3.7
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 04:55:46 -0700 (PDT)
X-Received: by 2002:a5b:6c1:0:b0:669:a7c3:4c33 with SMTP id
 r1-20020a5b06c1000000b00669a7c34c33mr2355446ybq.543.1660823746108; Thu, 18
 Aug 2022 04:55:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220817204015.31420-1-pvorel@suse.cz> <Yv4MBF79PnJKJbwm@yuki>
 <Yv4eiT5L+M7dMkQ5@pevik> <Yv4i0gWiHTkfWB5m@yuki>
In-Reply-To: <Yv4i0gWiHTkfWB5m@yuki>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 18 Aug 2022 13:55:34 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUMBjCTwPu7wxrnagXnbyVxxmXN+vHmML0Lr=SyrTw0nQ@mail.gmail.com>
Message-ID: <CAMuHMdUMBjCTwPu7wxrnagXnbyVxxmXN+vHmML0Lr=SyrTw0nQ@mail.gmail.com>
Subject: Re: [Automated-testing] [RFC PATCH 1/1] API: Allow to use xfs
 filesystems < 300 MB
To:     Cyril Hrubis <chrubis@suse.cz>
Cc:     Petr Vorel <pvorel@suse.cz>, ltp@lists.linux.it,
        Li Wang <liwang@redhat.com>, Martin Doucha <mdoucha@suse.cz>,
        automated-testing@yoctoproject.org,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        automated-testing@lists.yoctoproject.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Cyril,

On Thu, Aug 18, 2022 at 1:28 PM Cyril Hrubis <chrubis@suse.cz> wrote:
> > > I'm starting to wonder if we should start tracking minimal FS size per
> > > filesystem since btrfs and xfs will likely to continue to grow and with
> > > that we will end up disabling the whole fs related testing on embedded
> > > boards with a little disk space. If we tracked that per filesystem we
> > > would be able to skip a subset of filesystems when there is not enough
> > > space. The downside is obviously that we would have to add a bit more
> > > complexity to the test library.
> >
> > Maybe I could for start rewrite v2 (I've sent it without Cc kernel devs now it's
> > mainly LTP internal thing) as it just to have 300 MB for XFS and 256 MB for the
> > rest. That would require to specify filesystem when acquiring device (NULL would
> > be for the default filesystem), that's would be worth if embedded folks counter
> > each MB. It'd be nice to hear from them.
>
> The 256MB limit was set previously due to btrfs, I bet that we can
> create smaller images for ext filesytems for example.

Yeah, we used to have ext2 root file systems that fit on 1440 KiB floppies.
IIRC, ext3 does have a minimum size of 32 MiB or so.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
