Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8D6C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 21:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E4AF22D08
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 21:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbhASV2m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 16:28:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58077 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728427AbhASV2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 16:28:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611091619;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=Gj5D9Usn+mPC9ZTKiwWnOoxWAirE0fKM3sxhvSqQd0k=;
        b=FcPCCir9WD2NmtDQAw/Elf2V8o4B0f3+GysiLY4ER5f9Bl5AX1qxet9wpmxC/rQf7f+Rg0
        Tz8c3v7u7A6F2vm6OC6f0GJgUAhEaK8zBQI9j3GZQBRxCuNUTzFi3F3CGGTkJ1Q5rGRSS5
        MymxeMNQOAr+vqo+2wFJyiiqth21ImA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-nlLq9f1BNP-Mu8f0as091g-1; Tue, 19 Jan 2021 16:26:58 -0500
X-MC-Unique: nlLq9f1BNP-Mu8f0as091g-1
Received: by mail-ot1-f69.google.com with SMTP id z2so308342otk.1
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 13:26:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Gj5D9Usn+mPC9ZTKiwWnOoxWAirE0fKM3sxhvSqQd0k=;
        b=qw5xfeuU1GEwVnDnGGyXW7GlieYK/g4vDmTQsMygLb+ZmoICSgnEncBXNoPJoh3MYn
         vywtABhqb9FAYkiLT0YoVWEjlCCePJ3FhLuy7xD+02EWjRpYJy6ROiyt84jntTRz/GHU
         ttp/kdLLbKKhKA1SAoyJNbo4CE/w0QIEBXo4emrNsVmveOgbN6YayOBKkwJGiGgHwetO
         Pt8J7UMaXby9CibEU4vpNJ0S+1D7ie5bzb+pcfTuqSE8crah0RxfaSpnLoYSRbE20z83
         5JufJg7gi3Q0XuaC3qkqYzqpJg0GZka73fA5ZyP8G1Vf4jY0ufTSH290IsF6/e5XXPYX
         kPBw==
X-Gm-Message-State: AOAM5329nPvkSiwx8m6IkjtIuRWpG13WJq1bT2dAYoFeil8QxY3wbYQq
        xffXS5X1NT/xsdhxStOWLaEhbUR/2WPZkNypq5fphyHFa6j3uEqhGlutIj1oWOCZYcOAUg/9DTr
        7ORI+aokFqblVokiESiKnKR1/BGkppKJEnJRe
X-Received: by 2002:a05:6808:7d0:: with SMTP id f16mr1095654oij.109.1611091617428;
        Tue, 19 Jan 2021 13:26:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTjmPtRbNb6L1bbXn/BEx0k3yjfUcOI0Fq/rvxXBH9yKAPRKt2eHhhSW68OjnKuGgzUJ5PMJLXZowrNsDJgf8=
X-Received: by 2002:a05:6808:7d0:: with SMTP id f16mr1095643oij.109.1611091617249;
 Tue, 19 Jan 2021 13:26:57 -0800 (PST)
MIME-Version: 1.0
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de> <49ecc92b-6f67-5938-af41-209a0e303e8e@sandeen.net>
 <522af0f2-8485-148f-1ec2-96576925f88e@fishpost.de> <e96dc035-ba4b-1a50-bc2d-fba2d3e552d8@sandeen.net>
 <3a1bd0e4-a4b2-5822-ed1a-d9a443b8ace7@fishpost.de>
In-Reply-To: <3a1bd0e4-a4b2-5822-ed1a-d9a443b8ace7@fishpost.de>
Reply-To: nathans@redhat.com
From:   Nathan Scott <nathans@redhat.com>
Date:   Wed, 20 Jan 2021 08:26:45 +1100
Message-ID: <CAFMei7MbBu9zfoXfE9+mTo1TtMzov-DEPWj6KPfw7Aa_PMnU4g@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] debian: xfsprogs package clean-up
To:     Bastian Germann <bastiangermann@fishpost.de>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hey all,

On Wed, Jan 20, 2021 at 4:16 AM Bastian Germann
<bastiangermann@fishpost.de> wrote:
> [...]
> Nathan uploaded most of the versions, so I guess he can upload.
> The Debian package is "team maintained" though with this list address as
> recorded maintainer.
>

You should have the necessary permissions to do uploads since
yesterday Bastian - is that not the case?

BTW Eric, not directly related but I think the -rc versions being
added to the debian/changelog can lead to some confusion - I *think*
dpkg finds that version suffix to be more recent than the actual
release version string (seems odd, but that seemed to be the behaviour
I observed recently).  Could the release script(s) skip adding -rc
versions to debian/changelog?

cheers.

--
Nathan

