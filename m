Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB2BC7EE2E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 05:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbjFLFfL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 01:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbjFLFeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 01:34:50 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43331127
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 22:34:49 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-51458187be1so7065469a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 22:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686548087; x=1689140087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ABer1Qpbiiz2YP6yXC9CjLyORxYGpFS/k9rP6ZJ+dM8=;
        b=UrWKpQm/HNULGfsOm+ZCPIz3WEbdKKudcxeTlp7bebNUGCSRQGkGcEjgGAkrQfbiWq
         7ITVfQD1mEA8zlXWT4Bjk2E010tPCVedKm6HPtXGBF7VH2KzbcSDOI+OSvK3dlU4DJtL
         930b90GZgWWpQuBc2TR6F7VDon5JDxDWr0Lr0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686548087; x=1689140087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ABer1Qpbiiz2YP6yXC9CjLyORxYGpFS/k9rP6ZJ+dM8=;
        b=hv+qhnA0syaDBd1L/qsKl9CGzNCygf1TDMEhVLBl+eoa+T+8/E42WE733Hq3Ge50z1
         04Wwy/0YZOLtJAzLZ+vWdPh3/cGW4Z8EAejiBjPSoRvmk/NEKtuYOEUGtjmzFsPpoo8O
         upcpLTgXJLoPSMpnV9hRMC44KVxxWYhIwEHpa862InuLoDu1QGMPX70rGrYBPWFB2x/F
         dS2JeNNqFnjOKT0K8APLhKXDLea0KI22rl6e0B1ZwcN00q/K9suQ//V2eX6pY3zZCQaR
         rNz6pTEg2cPy/HBB28uOtLc3AveJ/4wcmviFp8G1rEzfwSd/iMg4zsrwRd4gg64OK598
         nUaA==
X-Gm-Message-State: AC+VfDxvMtsGbkzcSiRHasK/a6/UQI7+ZxVRIK4ZNWzLKTP3JDkTIMpM
        /TTV7Tw+Qqat3vUpZkdNq4UqEZA3L5u4EEdYR2Dpyw==
X-Google-Smtp-Source: ACHHUZ7pXB0smPoKzMc7YcZAMW3Do9VcNzcAPDAx992vPmuCNtb7S7coeH8KoLs7qGuJXk/rOM6IVg==
X-Received: by 2002:aa7:d80f:0:b0:514:92d8:54b3 with SMTP id v15-20020aa7d80f000000b0051492d854b3mr4438119edq.12.1686548087636;
        Sun, 11 Jun 2023 22:34:47 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id n12-20020a05640204cc00b0051631518aabsm4543062edw.93.2023.06.11.22.34.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 22:34:46 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-977d6aa3758so731892766b.0
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 22:34:46 -0700 (PDT)
X-Received: by 2002:a17:906:7951:b0:94e:e97b:c65 with SMTP id
 l17-20020a170906795100b0094ee97b0c65mr10173252ejo.60.1686548086273; Sun, 11
 Jun 2023 22:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area> <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area> <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
 <ZIaqMpGISWKgHLK6@dread.disaster.area>
In-Reply-To: <ZIaqMpGISWKgHLK6@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 11 Jun 2023 22:34:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgwJptCbaHwt+TpGgh04fTVAHd60AY3Jj1rX+Spf0fVyg@mail.gmail.com>
Message-ID: <CAHk-=wgwJptCbaHwt+TpGgh04fTVAHd60AY3Jj1rX+Spf0fVyg@mail.gmail.com>
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 11, 2023 at 10:16=E2=80=AFPM Dave Chinner <david@fromorbit.com>=
 wrote:
>
> > +             /* vhost workers don't participate in core dups */
> > +             if ((current->flags & (PF_IO_WORKER | PF_USER_WORKER)) !=
=3D PF_USER_WORKER)
> > +                     goto out;
> > +
>
> That would appear to make things worse. mkfs.xfs hung in Z state on
> exit and never returned to the shell.

Well, duh, that's because I'm a complete nincompoop who just copied
the condition from the other cases, but those other cases were for
testing the "this is *not* a vhost worker".

Here the logic - as per the comment I added - was supposed to be "is
this a vhost worker".

So that "!=3D" should obviously have been a "=3D=3D".

Not that I'm at all convinced that that will fix the problem you are
seeing, but at least it shouldn't have made things worse like the
getting the condition completely wrong did.

                    Linus
