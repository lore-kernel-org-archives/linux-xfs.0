Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC88C64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 20:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E6CF20870
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 20:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f+XordXx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbgLAUF5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 15:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbgLAUF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 15:05:57 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32E8C0613D4
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 12:05:16 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id v14so6961446lfo.3
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 12:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HEphcGQwY2jeNYDME47hDdQV9bR2WcuThTyY8CTMagA=;
        b=f+XordXx1HtHQauAu4wnySGZ7GOsfsrQOPdsZpcQHvfL87zHN51ik0PwYfToHQidR0
         PlZ/E4mqzBriHmbzSkQser0B1m99iGnRC3rEB7nXytmUcWTvmQp/DGH5GienWzwN/RKd
         ej/bdilwW2TBGDr+jCbzKtRZ0888o0ynwCvig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HEphcGQwY2jeNYDME47hDdQV9bR2WcuThTyY8CTMagA=;
        b=RrQM3kH4XSHUHl6xSYLqQaAWTqIxILWctKuOHaRlg6oTEmRvaJ/fr4h3Go2L/MfXMF
         6ljPNQ7k1DITv2y0S8UUYZfVGZB7+D9G9VXbu2ggCQJApmz1fjPLNReqzaKobAGpnukS
         WutchCpo2ZTOt1xyCRN4ATQsKc4OTnxC3kPeuWqrqybhfxbv0IMmox9nSZ37IOu3Ud+D
         n1U0sSU457ylaOOc13YI/G+Kc/sKwHINXHzREPW1+jp1PPnfB/TKk4WsWbPDN8AmJUvh
         LdWiSalf7RJQC5z6b4d2YUOKwNijwBudMkHptKHhM2KpHbBsCsC3PuJaGLfjQ5bHGjdA
         bvqA==
X-Gm-Message-State: AOAM5335D9f6yJ+RejAhql++6LRqFubP99eHP3KjmQQ6LoLBIzXs4g3w
        mQvsjYAb/Gmuajj737HPnVfdAOdOMLMkSQ==
X-Google-Smtp-Source: ABdhPJzV2eGaTyfTzY0NOAtXx5nQ0wymcDS/HCznNCljoWvhaMQkrQGJN+GrqeBNaE8iJH75SdmcQw==
X-Received: by 2002:a19:ac4c:: with SMTP id r12mr1868568lfc.109.1606853114233;
        Tue, 01 Dec 2020 12:05:14 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id o14sm66244lfo.258.2020.12.01.12.05.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 12:05:13 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id r24so6897120lfm.8
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 12:05:13 -0800 (PST)
X-Received: by 2002:a19:5003:: with SMTP id e3mr1997442lfb.148.1606853112635;
 Tue, 01 Dec 2020 12:05:12 -0800 (PST)
MIME-Version: 1.0
References: <e388f379-cd11-a5d2-db82-aa1aa518a582@redhat.com> <05a0f4fd-7f62-8fbc-378d-886ccd5b3f11@redhat.com>
In-Reply-To: <05a0f4fd-7f62-8fbc-378d-886ccd5b3f11@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 1 Dec 2020 12:04:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgOu9vgUfOSsjO3hHHxGDn4BKhitC_8XCfgmGKiiSm_ag@mail.gmail.com>
Message-ID: <CAHk-=wgOu9vgUfOSsjO3hHHxGDn4BKhitC_8XCfgmGKiiSm_ag@mail.gmail.com>
Subject: Re: [PATCH 2/2] statx: move STATX_ATTR_DAX attribute handling to filesystems
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
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

On Tue, Dec 1, 2020 at 8:59 AM Eric Sandeen <sandeen@redhat.com> wrote:
>
> It's a bit odd to set STATX_ATTR_DAX into the statx attributes in the VFS;
> while the VFS can detect the current DAX state, it is the filesystem which
> actually sets S_DAX on the inode, and the filesystem is the place that
> knows whether DAX is something that the "filesystem actually supports" [1]
> so that the statx attributes_mask can be properly set.
>
> So, move STATX_ATTR_DAX attribute setting to the individual dax-capable
> filesystems, and update the attributes_mask there as well.

I'm not really understanding the logic behind this.

The whole IS_DAX(inode) thing exists in various places outside the
low-level filesystem, why shouldn't stat() do this?

If IS_DAX() is incorrect, then we have much bigger problems than some
stat results. We have core functions like generic_file_read_iter() etc
all making actual behavioral judgements on IS_DAX().

And if IS_DAX() is correct, then why shouldn't this just be done in
generic code? Why move it to every individual filesystem?

               Linus
