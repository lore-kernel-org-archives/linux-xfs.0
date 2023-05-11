Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CA0C77B7F
	for <linux-xfs@archiver.kernel.org>; Thu, 11 May 2023 17:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbjEKRri (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 May 2023 13:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238737AbjEKRrh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2023 13:47:37 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2BA10CB
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 10:47:36 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-965fc25f009so1335818266b.3
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 10:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683827254; x=1686419254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8VdR6WrftpkhTyZnWassmoziOk7oZDdGi581GRz1T8=;
        b=Pg5jRG0aDsuAA/EngwXMfYQrHLPQ0dxRd8YhtX2f6Drh1jCKUDTFiN6vX7s50sIHrK
         69NuVf1hz/leeFg6bEYwt6WB8fMq5nUnhKWyYSBTaB6txcwZWUs5pVSPpdIBmJ6SrCrB
         BVwwrK82I4KxoFA7iiM/SYT/xsGhwVQXWtZR4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683827254; x=1686419254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y8VdR6WrftpkhTyZnWassmoziOk7oZDdGi581GRz1T8=;
        b=UNC5ZID8XNXWfi8bi/rtuG4hbUd1opXnCSFTURpJYBZk3nyTx4mah0vErYheNABLjS
         J1kMB4i//GV1brKAOp3mdu2tkXPGXVSonF7c0eQywi26sZE1K8fNIUZ6xqxfaKQCbBS0
         BejCLTWh8D1+6CxmviMDHMFjpEFMuNOATXoQvfiAP7UWy5jiEfwz5bPSdgWD8q4Fio6H
         Zq+0r5itSTgRNYZXvnbGzhH1m+pyf3I4mHC+0t/tUthk5x1zdcWq10myoIfI3yjsnTOs
         WkeezD3DzZD8QO5Pmu9+dm9YQqVZGfKaqDhpGWQvg6abqijU4sXxmXK/jMBlvqTax0kT
         BA1w==
X-Gm-Message-State: AC+VfDxliuG5OfoIL3i8/GknmZpmBRfFr0q5wBYK6ost9xS4baBkZKcc
        RczK/tk/TAf7Z7MSXEfX3X/uA7P6Ew3oUhwt04E4VF2F
X-Google-Smtp-Source: ACHHUZ6pb/r4g68/hTtmOediRkM3r3igTiPz2uRP65muD5ChHZqFhvz1/NpfQrTVu3UT7nZIByS+Tg==
X-Received: by 2002:a17:907:7da9:b0:966:538f:843b with SMTP id oz41-20020a1709077da900b00966538f843bmr15671218ejc.77.1683827254475;
        Thu, 11 May 2023 10:47:34 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id k21-20020a170906055500b009584c5bcbc7sm4218707eja.49.2023.05.11.10.47.33
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 10:47:33 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-50bc5197d33so16451210a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 10:47:33 -0700 (PDT)
X-Received: by 2002:a17:907:3e9c:b0:966:471c:2565 with SMTP id
 hs28-20020a1709073e9c00b00966471c2565mr17182564ejc.48.1683827253155; Thu, 11
 May 2023 10:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230511015846.GH2651828@dread.disaster.area> <20230511020107.GI2651828@dread.disaster.area>
 <CAHk-=wjJ1veddRdTUs5BfofupuPxMoVHBUbAOmHw6p4pXPq5FQ@mail.gmail.com> <20230511165029.GE858799@frogsfrogsfrogs>
In-Reply-To: <20230511165029.GE858799@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 May 2023 12:47:16 -0500
X-Gmail-Original-Message-ID: <CAHk-=wh6ze_y5_Q89VOuruDnenSVmN4fL1J-rh-vovmrDkxaQw@mail.gmail.com>
Message-ID: <CAHk-=wh6ze_y5_Q89VOuruDnenSVmN4fL1J-rh-vovmrDkxaQw@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: bug fixes for 6.4-rc2
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 11, 2023 at 11:50=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> ...and which version is that?  The build robot report just says ia64
> without specifying any details about what compiler was running, etc:

Actually, you should find it if you follow the links to the config.

We have the compiler version saved in the config file partly exactly
for reasons like that.

HOWEVER.

If it's *this* report:

> https://lore.kernel.org/linux-xfs/20230510165934.5Zgh4%25lkp@intel.com/T/=
#u

then don't even worry about it.

That's not even a compiler warning - that "ignoring unreachable code"
is from smatch.

So if *that* single line of

   fs/xfs/scrub/fscounters.c:459 xchk_fscounters() warn: ignoring
unreachable code.

was all this was about, then there are no worries with that pull request.

Those extra warnings (some of them compiler warnings enabled with W=3D2
for extra warnings, some from smatch) are not a cause for worry. They
are janitorial.

I thought you had an actual failed build report due to some warning.
Those we *do* need to fix, exactly because they will affect other
peoples ability to do basic sanity testing.

So if you can confirm that it was just that one smatch warning line
and nothing else, then I'll happily do that pull.

            Linus
