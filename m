Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC34C2D0EC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 19:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFF7920768
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 19:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgDGTbO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 15:31:14 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56897 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgDGTbO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 15:31:14 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N2V8Z-1jASfn2uwJ-013y3T; Tue, 07 Apr 2020 21:31:12 +0200
Received: by mail-qt1-f171.google.com with SMTP id y25so3668768qtv.7;
        Tue, 07 Apr 2020 12:31:12 -0700 (PDT)
X-Gm-Message-State: AGi0PuYLwO3Ls/7U2pBdBnZlECB+7Kk3a9KyYGDaGEWzYPWIS3zmbhpf
        WKIvXAOHi5lr8/AGmCvAAlJNXyzF999HQHei79o=
X-Google-Smtp-Source: APiQypLkVUjIsS07lo91M6k5Sjnc44SUP7kJ+KtiyaCXLvrc3hnt4fDvAYvccEwWHSDkd433BlhqaRihUrvpkSWHcS0=
X-Received: by 2002:ac8:d8e:: with SMTP id s14mr3934207qti.204.1586287871440;
 Tue, 07 Apr 2020 12:31:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190205133821.1a243836@gandalf.local.home> <20190206021611.2nsqomt6a7wuaket@treble>
 <20190206121638.3d2230c1@gandalf.local.home> <CAK8P3a1hsca02=jPQmBG68RTUAt-jDR-qo=UFwf13nZ0k-nDgA@mail.gmail.com>
 <20200406221614.ac2kl3vlagiaj5jf@treble> <CAK8P3a3QntCOJUeUfNmqogO51yh29i4NQCu=NBF4H1+h_m_Pug@mail.gmail.com>
 <CAK8P3a2Bvebrvj7XGBtCwV969g0WhmGr_xFNfSRsZ7WX1J308g@mail.gmail.com>
 <20200407163253.mji2z465ixaotnkh@treble> <CAK8P3a3piAV7BbgH-y_zqj4XmLcBQqKZ-NHPcqo4OTF=4H3UFA@mail.gmail.com>
In-Reply-To: <CAK8P3a3piAV7BbgH-y_zqj4XmLcBQqKZ-NHPcqo4OTF=4H3UFA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 7 Apr 2020 21:30:55 +0200
X-Gmail-Original-Message-ID: <CAK8P3a38QrxsWNZ2PNuWVGqg533Fcm9fYBbq2ehkbFvzfrwQ7g@mail.gmail.com>
Message-ID: <CAK8P3a38QrxsWNZ2PNuWVGqg533Fcm9fYBbq2ehkbFvzfrwQ7g@mail.gmail.com>
Subject: Re: libelf-0.175 breaks objtool
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:4uzpzVgjqjbx5HIY4m3pFs5QUn2d57broua1FhIiNqiLSGcU2jB
 x23dMw9J/mJ1ZzNFnQ2yyltLYcm5XS2QWrdu8kjZIDYyKP9E0dULlNNUQW5CIQcLx92bYrp
 rixY9NasCTaNG6CxkyLPDGTBvMn5n/Kag0nBnOAE9YLTjj+DihS3dlBiIUx3UpT7qCAoZL2
 v+l/Hvtzjt/kJDKrihV5g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:K+ox3VD4Dew=:JdzJJPq3BOhwJs11EtF+4T
 /3gejP88WBDQ3z98shlkTPaSsqG4tZHqLIjm98bOJqO45780TrJVOGrKWPuz4glDIKGwz/zEy
 OPOF1JFNj63s//dqeZVHldU4lKXjzBYpHHjT8zCsGlb30gSFbVvrinKxmo3cOekbKMszwoE6B
 M4nrREySzGeMmsgt6Z9twKuYLwOj/zLBR9J9IGI9T7bQvaFKkh52xI/2Wy6bz7qmdNV+YmIC3
 j8x1sKf2BGxwdrZncwq4t30/9C98VpnVmXyn/IDnoArG91z4VprnOwK5m/djOePVU3Ko3MI3r
 QoDQJ5lCLRX2ul7LY4dcrrBFZDCBSf7v7MNjlwSzqaTYE5O7gcS8o3xlt8GhEZbY/9SycSmcV
 dkruVEXEJPkWPF6t1JeGsZvu5M8nRPuqux9MdE8McNiad681JFV1WzVlSIrYiVoMSfHzhyXVl
 TSoCnvV2YrZQ6blm1v7PWDhXmYzGb0rBGJR/STI2ScPjl22S8QGZsrwEQCAjFuv/5IiI32MwR
 fa1AcB0n258PnN7Se/vAoB2a12igpknTJ+fAuNML8/y7NREdx6lVKMtq+MkuHHb5RejWuu5Rs
 cAmUc3FdXmMOOSxIBnSyIzXVhJRPzicXV2zGtXNHUkD2YYqvkbAnC5mdlNbxv5WokAE03msgp
 OAN0rvelP80xj59R3UNALxV8uyoWb2uVU1YNYG/Pihj26XfFB2R91NPRHehlGX6jpZWg27dQD
 8krx05/PXy6eXolJZFFJHuvec6fTz/jqCNjhZKuy1xSxPDQetHL/3UPAmqPOYjvvJprin84WA
 F1a30B7tOORR5jraWZuebssBX9fFl6RNx9Zb7d7JOXpuR3ii4I=
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 7, 2020 at 8:44 PM Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Apr 7, 2020 at 6:33 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > On Tue, Apr 07, 2020 at 05:46:23PM +0200, Arnd Bergmann wrote:

> That is very possible. The -g has been there since xfs was originally merged
> back in 2002, and I could not figure out why it was there (unlike the
> -DSTATIC=""
> and -DDEBUG flags that are set in the same line).
>
> On the other hand, my feeling is that setting -g should not cause problems
> with objtool, if CONFIG_DEBUG_INFO is ok.

Nevermind, I now see the same problem in lots of files in a configuration
setting these options:

CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_DEBUG_INFO_DWARF4=y
CONFIG_DEBUG_INFO_BTF=y

Not sure which of these are actually relevant, but I had other configurations
setting DEBUG_INFO that are not affected.

       Arnd
