Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187A2C77B7C
	for <linux-xfs@archiver.kernel.org>; Thu, 11 May 2023 03:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjEKDNR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 May 2023 23:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjEKDNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2023 23:13:16 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EF3E5F
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 20:13:15 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-50db7f0a1b4so4508891a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 20:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683774793; x=1686366793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EDnTsrzakt3ajSHudc1yKbwW/H67XWoB0uN90nyyCvs=;
        b=ME19NADmGNfc8wQwCFtevoC6UC5Mktf7aqYI5IQ8m0kDgvOeoWilrilAcy5jJ33RRh
         mluwPj826qDIWrtbc1iw9QU6BwwbLYBhfbPVIM1nr9mWQ3/FEZ2SO0DMnRoadH3CeuYL
         kW5sbWX0/RvCs7YIdeqXXpCA+1rlxpfSJ+w/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683774793; x=1686366793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EDnTsrzakt3ajSHudc1yKbwW/H67XWoB0uN90nyyCvs=;
        b=gd1YhoBXBstodWMzQFuZTzR2kLO2eTjKkYbIEsEP9h+6djvzCeeTTrRKgpMNyIiBK5
         Yo9VAyTStUrb94rEz/TyA5dPKx799YkVgXVw7YlWdIGvyrw/41IbjWS6oyTyWt0szH+w
         j+Fhc5XKwQxpeHQhsHQ779dSYpNj2V7F6IWw/mcaMgQrSopKII58FKlNBoOKJspbJfE5
         0JY31N/L3aF7+q7JbeuD5dZzveBnPuxac4sJGhAsYuZqNxKwlqmjsXK3hNWn8PS3moqI
         1EQCqCohbdHKQCBohfLmus1brudBCzCImN+bAWfOjlmC/0Fz+tXd8lUH/oAKvfDtJ5Lu
         OHww==
X-Gm-Message-State: AC+VfDzBIvl3BvZIgjzVA0j/pPyy+NnuhNdCtLZf784u9XrO/UhWQM3z
        HTP36u70X4LntrNhWNmogbvuCanICnd3MkW8izBZ+A==
X-Google-Smtp-Source: ACHHUZ6n5b4u2PFzBCe6HfYIDC3pPfiAButXz6capCIyRaRJj6CkzFoT45VGQ3HgOCLgYvW+JVnOLw==
X-Received: by 2002:a05:6402:641:b0:50c:161b:9152 with SMTP id u1-20020a056402064100b0050c161b9152mr15767904edx.13.1683774793238;
        Wed, 10 May 2023 20:13:13 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id l23-20020aa7c3d7000000b004f9e6495f94sm2479698edr.50.2023.05.10.20.13.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 20:13:12 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-9661a1ff1e9so871429766b.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 20:13:12 -0700 (PDT)
X-Received: by 2002:a17:907:783:b0:959:a9a1:5885 with SMTP id
 xd3-20020a170907078300b00959a9a15885mr15848627ejb.31.1683774791923; Wed, 10
 May 2023 20:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230511015846.GH2651828@dread.disaster.area> <20230511020107.GI2651828@dread.disaster.area>
 <CAHk-=wjJ1veddRdTUs5BfofupuPxMoVHBUbAOmHw6p4pXPq5FQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjJ1veddRdTUs5BfofupuPxMoVHBUbAOmHw6p4pXPq5FQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 May 2023 22:12:55 -0500
X-Gmail-Original-Message-ID: <CAHk-=whtWTqXXD29n4z0qni-xM_4OPE-6u3vw_qjkiz05BHVZg@mail.gmail.com>
Message-ID: <CAHk-=whtWTqXXD29n4z0qni-xM_4OPE-6u3vw_qjkiz05BHVZg@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: bug fixes for 6.4-rc2
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 10, 2023 at 9:49=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That sounds like you will fail all build farms that happen to have
> this compiler version.

Side note: it might have helped if you indicated it was some very
particular old compiler. It's hard to tell. What made me decide to
unpull was really the fact that you seemed so cavalier about it.

The whole "no warnings" thing has been quite important. CONFIG_WERROR
can sometimes be annoying - particularly when a new compiler
introduces a new warning - but it got introduced because I got
*really* tired of people just ignoring warning, and as we had one or
two build warnings, new ones didn't stand out either.

So no, it's *not* ok to say "warnings are harmless". Because they
really really aren't. Unheeded warnings just beget more warnings, and
you end up being warning-blind.

And CONFIG_WERROR is important, because without that, maintainers
won't react to new warnings, because they'll do their random config
testing on farms, and not *look* at the result, they just look at
success/failure reports. I understand why it is like that, but it does
mean that yes, warnings need to actually cause failures.

So then a new warning in one subsystem will fail the build of all the
other subsystems too.

And who knows - maybe the warning came from some odd experimental (or
really old) compiler version that warned about other things too. It
happens. If so, it's fine - to paraphrase (and mangle): "you can make
some compilers happy all of the time, and all compilers happy some of
the time, but you can't make all compilers happy all of the time".

But if you already found the warning before it even hit the main tree,
I suspect it will hit more than a few oddball situations.

            Linus
