Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CEBC0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 08:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjFVIT0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 04:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjFVITZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 04:19:25 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE5E1BF7
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 01:19:19 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b46d945510so13265801fa.1
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 01:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687421958; x=1690013958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jGGvqqE0iXpE5LTzLAVwkzyU1NQE4PZV50jStpmqkA=;
        b=hm1JL0K7rYFtsZxq2mKu64ci1aLDPQ1nPl/6LjQEeRcO06rAtdXJWWd5mzRR0M3fT9
         cQ4rrrgi4Ccmh4UQm7uxKbNbyn0oWzRXcpgO/TkfONQKuZvSgoeqU0GrrP46IQl4FeLq
         Fd3ThmAqqx1JGre0UtCZJ0jWDV2YNTJ6hZz9vKPF7mpjUL21/tHSsrb9QfqbWlvy7Smf
         Ziv5rggnb95pOSYLR05CFFfyArcuDRCcP21TBjmPTsVG4OhZaX8/l6pG5w6dT3no/gnE
         so8KQqm149KEPzMmOP1En7d3oBcm7AeEaEA6TcuXVESuY1P9dVoHbU7zIDhAaVxTtDsc
         xaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687421958; x=1690013958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/jGGvqqE0iXpE5LTzLAVwkzyU1NQE4PZV50jStpmqkA=;
        b=l2Hcfb5gSbhUQLNBu6QXptzY0jrfrlJEf6mqVZH5d5bfej7gLb8Y9LrtDOHcT/Uvfd
         pWv17bK6TO1GLea5R/dKO4omE8vOjUMnRjwGYY9P6Pclxqg0bszcuezCb2i1kyXHv7oo
         U9NQwCscwF+bpdZ8FI6isTZTZZTNdbVRR8Kbdm02AOEc53ekKvjj3UHJxfBFZmcWgzUe
         4R9fzDSUPpaxUovUkdzcEOUDyMuAnyIbOTD0ngFhVgX0kRSxeQ/Nn0Ix3zuPLu2I7Pxd
         aN/M3FVNpxbqjrWfRs5svNP/8Yz5Q6JKZLAGuHXaw7xOp4AHk02VybgNmznPooQjj8HW
         hZIQ==
X-Gm-Message-State: AC+VfDzdbaEvLpM2mUNYJeWi9FZArwkK6COKtrevxIGdr9xugnmdzWDX
        PYP8l5DLL0+CNxn55YdAR4jlm2qvdR1ZlvOeYnH4QSQ7E1o=
X-Google-Smtp-Source: ACHHUZ5bZmhxeRrdAj30sjqthphK4ssxECIs6CeQFbevIXdS9X9LWzaoz2JsZV+e6t8V2FAZoMl6iltVN4Ndmk9BK/4=
X-Received: by 2002:a05:651c:323:b0:2b4:74f0:4ad5 with SMTP id
 b3-20020a05651c032300b002b474f04ad5mr6080734ljp.4.1687421957417; Thu, 22 Jun
 2023 01:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <20230622154405.9696.409509F4@e16-tech.com>
In-Reply-To: <20230622154405.9696.409509F4@e16-tech.com>
From:   Masahiko Sawada <sawada.mshk@gmail.com>
Date:   Thu, 22 Jun 2023 17:18:40 +0900
Message-ID: <CAD21AoCMnN6NWDHYzq9JDDDzWqokxT2E2inm_18dCHkMSGFrLw@mail.gmail.com>
Subject: Re: Question on slow fallocate
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 22, 2023 at 4:44=E2=80=AFPM Wang Yugui <wangyugui@e16-tech.com>=
 wrote:
>
> Hi,
>
> > Hi all,
> >
> > When testing PostgreSQL, I found a performance degradation. After some
> > investigation, it ultimately reached the attached simple C program and
> > turned out that the performance degradation happens on only the xfs
> > filesystem (doesn't happen on neither ext3 nor ext4). In short, the
> > program alternately does two things to extend a file (1) call
> > posix_fallocate() to extend by 8192 bytes and (2) call pwrite() to
> > extend by 8192 bytes. If I do only either (1) or (2), the program is
> > completed in 2 sec, but if I do (1) and (2) alternatively, it is
> > completed in 90 sec.
> >
> > $ gcc -o test test.c
> > $ time ./test test.1 1
> > total   200000
> > fallocate       200000
> > filewrite       0
> >
> > real    0m1.305s
> > user    0m0.050s
> > sys     0m1.255s
> >
> > $ time ./test test.2 2
> > total   200000
> > fallocate       100000
> > filewrite       100000
> >
> > real    1m29.222s
> > user    0m0.139s
> > sys     0m3.139s
> >
> > Why does it take so long in the latter case? and are there any
> > workaround or configuration changes to deal with it?
> >
>
> I test it on xfs linux 6.1.35 and 6.4-rc7
>
> the result is almost same.
>
> $ time ./test test.1 1
> real    0m1.382s
>
> $ time ./test test.2 2
> real    0m9.262s
>
> linunx kernel version please.

I test it on:

$ uname -r
6.1.29-50.88.amzn2023.x86_64

and

$ uname -r
4.18.0-372.9.1.el8.x86_64

Regards,

--=20
Masahiko Sawada
Amazon Web Services: https://aws.amazon.com
