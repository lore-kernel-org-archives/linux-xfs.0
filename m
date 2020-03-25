Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0325C1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 16:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C3AA20772
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 16:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ki0nrAif"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgCYQ4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 12:56:19 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:43629 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgCYQ4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 12:56:19 -0400
Received: by mail-io1-f51.google.com with SMTP id n21so2935044ioo.10
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 09:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RoNZVKDTXtlb/MTXtMBen/OQHzZqGWTfOQvYlMYqqSc=;
        b=ki0nrAifN1qz0Gzt14jif2T1XfaUl4haRT4A/tAatKdNknQ95XBOZpP27qW9op2sL/
         lfQamXx3qY2IpuRIIMv7iZ7XEMUyuaX8EnmHew4/hHE0jZWOMwWoB8wx4D5pSMMxgKW1
         x0BgsOS6xCy9TAUmcE42A/t5dl0Ue4AdNN8PY4FRFFJlaLLydJCc90Z181LicWgBwF2J
         /Q3DommcldbcDmL5rBXqsrMTLqGsNqLQGcSPadUZvdSw56zKykTjAY4DduZ1b7t5Dw5u
         W84Evqpyt90RzaVXZcExu6yeQDlwQ9MIEdvGg7SQ0fE9wbcnRl/Cah7wxLeaHeq2hTu6
         /mgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RoNZVKDTXtlb/MTXtMBen/OQHzZqGWTfOQvYlMYqqSc=;
        b=hkGUNEpjrK/BHB7rhY9ouUzCqe1YTmt7npkwGHqlmNrtl2GnqI/CijSFuV9rYhURq2
         KZ549yVDzBFXkykjxnWWwSWFuD37lItw2zT0hQCtNBwbWipVTieEtHD7zYJAQJ7BFyGf
         bvIz+ilplYR3Q7UZ4SU6ubD3neeVLxVoUD2veALtStocJ48rhbHXnQtabuQ1neNH8r2H
         xuOvUKJWxj3VSUzbH9Kwss5LDlpJ/vcpWfnLInuub5E+49ree7ZmxFdZAwDOZU716W10
         08Ltkw2JGOxO6SjXn13p4kLXdyA+7scRt69HCgjTfEvRLHdJV2QQNtizIq01q+9UVXwG
         mR6w==
X-Gm-Message-State: ANhLgQ29x/rqsNWuO/92I/qMRbrfdFgdzcxRaqDMZ9iSW2TXwTX5q8gy
        CuWaWOwBkqOylTUz3T64xIFHC+4CA6viKZnenr4=
X-Google-Smtp-Source: ADFU+vtncFyajleqw6vCXJRX5kyY4pLW7U9+i+aSopBSwWcZ57bGiEL5ahaFA9l2oE9uLEjZV9uAxxwlQ25sqgSiEGE=
X-Received: by 2002:a5d:858f:: with SMTP id f15mr3790381ioj.113.1585155375743;
 Wed, 25 Mar 2020 09:56:15 -0700 (PDT)
MIME-Version: 1.0
References: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
 <20200324183819.36aa5448@harpe.intellique.com> <CABS7VHB2FJdCz+F+3y86wawmBSuaVmfnC57edHVsoRugAK2Nsg@mail.gmail.com>
 <20200324192610.0f19a868@harpe.intellique.com> <CABS7VHDt=v1SmSggnn8288uE5Cs27RqXpPsbiGk9=wyJ-pz1pQ@mail.gmail.com>
 <20200325152418.04340a72@harpe.intellique.com>
In-Reply-To: <20200325152418.04340a72@harpe.intellique.com>
From:   Pawan Prakash Sharma <pawanprakash101@gmail.com>
Date:   Wed, 25 Mar 2020 22:25:37 +0530
Message-ID: <CABS7VHCcB34bEoYmZT35CGRDkZ271VL8j5NDGNHvvb6oXsbXgg@mail.gmail.com>
Subject: Re: xfs duplicate UUID
To:     Emmanuel Florac <eflorac@intellique.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Note that even after freezing, the on-disk filesystem can contain
 information on files that are still in  the process of unlinking.
 These files will not be unlinked until the filesystem is unfrozen or a
 clean mount of the snapshot is complete.

hmmm, ok, so what is the right way to do it?
Should I mount the cloned volume with nouuid first so that log is
replayed and filesystem is clean, then umount it and then generated
the UUID for this using xfs_admin command?

Or should I use xfs_repair with -L option to clear the logs and then
generate the UUID with xfs_admin command. but as per man page when
using this option the filesystem will likely appear to be corrupt, and
can cause the loss of user files and/or data?

Man xfs_repair :
-L : Force Log Zeroing. Forces xfs_repair to zero the log even if it
is dirty (contains metadata changes). When using this option the
filesystem will likely appear to be corrupt, and can cause the loss of
user files and/or data.

Regards,
Pawan.

Regards,
Pawan.


On Wed, Mar 25, 2020 at 7:54 PM Emmanuel Florac <eflorac@intellique.com> wr=
ote:
>
> Le Tue, 24 Mar 2020 23:58:24 +0530
> Pawan Prakash Sharma <pawanprakash101@gmail.com> =C3=A9crivait:
>
> > >Your problem is that the log is dirty. You need to mount it once to
> > clean up the log, then you'll be able to change the UUID.
> >
> > But why xfs_freeze is not clearing that as man page says that it does
> > that?
>
> Please reply to the list so that anyone interested can learn about it.
>
> This is mentioned in the man page at the next line:
>
>  Note that even after freezing, the on-disk filesystem can contain
>  information on files that are still in  the process of unlinking.
>  These files will not be unlinked until the filesystem is unfrozen or a
>  clean mount of the snapshot is complete.
>
> You probably have open unlinked files (such as temporary files). It's
> very common.
>
> --
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |   <eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
