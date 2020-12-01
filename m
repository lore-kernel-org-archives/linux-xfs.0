Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D12C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 22:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F4EC2087C
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 22:13:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S1Fq2hOV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgLAWNV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 17:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgLAWNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 17:13:19 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FCCC0617A6
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 14:12:39 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id s27so7807823lfp.5
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 14:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zNo0eDx11R5r5Mt473lP4z7j4i15NYf5XYAT5tq3Gc0=;
        b=S1Fq2hOV/kCBqQU8MqqsgrJxYn/JkHGSu3iKGGI7rqsYDk3nXp4Wmv7ymBiaVZjkfx
         x/R8OjysAny2WzYn+051zNfaEQTfvUkUSJlJmD5nwstVM8N11SsWolyE9NGkZjGd2qk+
         XAspcHql8KHCJhg6JN517UT+nt1ue0tzsTvrs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zNo0eDx11R5r5Mt473lP4z7j4i15NYf5XYAT5tq3Gc0=;
        b=PZPijsbD6TgsVL1Luom5QgLU7tgTGjkugOwfnI1KQNoTQRXVGNLcOLlgOmJbWDPi2b
         Ojs5SaF1BPu5Z07KXdeVVBnZ/4zN3uZduZ1MZUyalza6JfxIVgBOLKZq7yL9Pu8QGw4b
         GXvCBlq9yRzv2DjEgIAZ61RgOTasADMbVq3zJUiHPQQ1ytUGmWKYvCSBiV9+FDIadhRW
         OE39uBhkFtRVvSw4WDB3jsuVeP994QPmbcVHlpCCzEwSMjY4Z6kvg/zmKYr0qdINd4uB
         OPRKP6OhppKgl+wdM8E99XCuNEBKdhzFzPDVbtr0pPes8c7D/TUeVb2znu094ex1TD2X
         9jJQ==
X-Gm-Message-State: AOAM531yEZ8gKlAQ3qaeV4B0KqFvkYf+slAlvhFwYLFVarU2ZTkx5k+R
        hYoLSh8yr9byLvBEd7+HhuQQwveYTE0HVQ==
X-Google-Smtp-Source: ABdhPJxyFxLWeIQy+soG9WMsx/X/oZNKwJX9ij7SrZ8Ekc/uS/Qc35KWABCic+dEWk89whruyvH2yw==
X-Received: by 2002:a19:fc0d:: with SMTP id a13mr2232843lfi.276.1606860757341;
        Tue, 01 Dec 2020 14:12:37 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id v20sm119991lfd.267.2020.12.01.14.12.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 14:12:36 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id r24so7778465lfm.8
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 14:12:35 -0800 (PST)
X-Received: by 2002:a19:c301:: with SMTP id t1mr2023760lff.105.1606860755499;
 Tue, 01 Dec 2020 14:12:35 -0800 (PST)
MIME-Version: 1.0
References: <e388f379-cd11-a5d2-db82-aa1aa518a582@redhat.com>
 <05a0f4fd-7f62-8fbc-378d-886ccd5b3f11@redhat.com> <20201201173905.GI143045@magnolia>
 <20201201205243.GK2842436@dread.disaster.area> <9ab51770-1917-fc05-ff57-7677f17b6e44@sandeen.net>
In-Reply-To: <9ab51770-1917-fc05-ff57-7677f17b6e44@sandeen.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 1 Dec 2020 14:12:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjymrd42E6XfiXwR3NF5Fs4EhTzhUukCojEWpz0Vagvtw@mail.gmail.com>
Message-ID: <CAHk-=wjymrd42E6XfiXwR3NF5Fs4EhTzhUukCojEWpz0Vagvtw@mail.gmail.com>
Subject: Re: [PATCH 2/2] statx: move STATX_ATTR_DAX attribute handling to filesystems
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Xiaoli Feng <xifeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 1, 2020 at 2:03 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> That's why I was keen to just add DAX unconditionally at this point, and if we want
> to invent/refine meanings for the mask, we can still try to do that?

Oh Gods.  Let's *not* make this some "random filesystem choice" where
now semantics depends on what some filesystem decided to do, and
different filesystems have very subtly different semantics.

This all screams "please keep this in the VFS layer" so that we at
least have _one_ place where these kinds of decisions are made.

I suspect very very few people actually end up caring about any of the
STATX flags at all, of course. The fact that the DAX one was
apparently entirely the wrong bit argues that this isn't all that
important.

               Linus
