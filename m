Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0815C25B0E
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 14:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiHPOcR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiHPOcQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 10:32:16 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CFABBA67
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 07:32:14 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id k2so10281470vsk.8
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 07:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=hrLkr9V3ESi2nz8i6sVxZxYs/c32UgrqN+gSuWkElBc=;
        b=abo+bWoP5WjHaLGU7ldrQzIpZyzH3irb/4dE4KPTs0osLGeFqiCDv/ZZ6Fp46hdF0y
         1r8GRCGODWg3Pia1BpUiA+EFJLZuIbSAfidqYU/0K1802XRFvEsL8sWBCBXvRLe04aJB
         TjXdqUV9O0F2dytz36sTax8Ga/UtsWABlxahdhXUVxVNt7ZViQI57vn0kkIGDEtk5YaZ
         o+25Oj7CdouK3suBQr1mSE4h7pZO2n99VUCGGW5n61fzu8sYKNEGQk0Lc5DGogti8Z4y
         Ke5+er54bd/AnMoaJAPzuZt3KcRc3GbZDOFbUxkH6DE5kbnl2Bg/kcOc4gA88duzp+6g
         IfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=hrLkr9V3ESi2nz8i6sVxZxYs/c32UgrqN+gSuWkElBc=;
        b=zsD7qzMa3bTAIYv64gxaCk/Xqy2+Sl8X5TssE/cHqeQ6nY+LswIPgB2AufCb9VLAFX
         ifI77IoLEU8WqTx2qDsoFIku3d0gw/XVVXlBVEuztUbOn87KMBcfLzD2jq3XbvfbNjoh
         /DEPIIiJM4pXDjKp6e++LPc4JvqHI3v3xqKGS2M68G9cn71WpmTrvFvcaqWFF3cgD74n
         SXkWXo4H84rcTzwmMyvCtxAwCYTQc+71T4bLZPun+heLrYFuL1IpouPjltZTnLei9j0a
         ASyg3pJZROMto/LtM7hKY8hNOm0e7t2xk8eT44ym7FCTNxyVXi9+U+mGaXuxtVOmQLqB
         imQQ==
X-Gm-Message-State: ACgBeo1a3QuZzF5zII4SifJRHN6RApn83l6VTDM1SfnaPTWSTgz7GCxU
        O5Z4/49BkZGaSRupvCjQMkTYjRKsM5wfswgMd2U7ZOpLtck=
X-Google-Smtp-Source: AA6agR49i9R3ZKn+u/Haf9Jv5FAivcaxYo35zK/BK3qU6DSA+DGMyblVgoG+z8GXqUpRWX386pcM5+CD4knWnIsN1YM=
X-Received: by 2002:a05:6102:3ecd:b0:358:57a1:d8a with SMTP id
 n13-20020a0561023ecd00b0035857a10d8amr8306085vsv.2.1660660333269; Tue, 16 Aug
 2022 07:32:13 -0700 (PDT)
MIME-Version: 1.0
References: <bug-216343-201763@https.bugzilla.kernel.org/> <bug-216343-201763-5uNVb4ysij@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216343-201763-5uNVb4ysij@https.bugzilla.kernel.org/>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 16 Aug 2022 17:32:01 +0300
Message-ID: <CAOQ4uxhjy=5UXk3vvU1wr+ap91VtGaGZjF7LPFKLUq5S27+izw@mail.gmail.com>
Subject: Re: [Bug 216343] XFS: no space left in xlog cause system hang
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 16, 2022 at 11:57 AM <bugzilla-daemon@kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216343
>
> --- Comment #3 from zhoukete@126.com ---
> (In reply to Amir Goldstein from comment #2)
> >
> > I don't think so.
> > I think this buffer write is in-flight.
>
> But how to explain the XFS_DONE flag is set.Is XFS_DONE flag means the io=
 had
> been done=EF=BC=9F
>

According to xfs_trans_dirty_buf() I think it could mean uptodate and
dirty buffer.

>
> >
> > Not sure if space cannot be released or just takes a lot of time.
>
> crash> ps -m 2006840
> [0 14:35:38.418] [UN]  PID: 2006840  TASK: ffff035f80de8f80  CPU: 51  COM=
MAND:
> "onestor-peon"
>
> pid 2006840 hang 14 hours. It is waiting for the xfs buf io finish.
> So I  think it is =E2=80=98cannot be released=E2=80=99 not take a lot of =
time.

Maybe the hardware never returned with a response?
Hard to say. Maybe someone else has ideas.

Thanks,
Amir.
