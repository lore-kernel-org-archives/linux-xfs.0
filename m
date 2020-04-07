Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990F5C2BA80
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 18:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64E6920768
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 18:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgDGSob (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 14:44:31 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:37213 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGSob (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 14:44:31 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N1feo-1jAi7Z0sbQ-011x3p; Tue, 07 Apr 2020 20:44:29 +0200
Received: by mail-qt1-f180.google.com with SMTP id b10so3526301qtt.9;
        Tue, 07 Apr 2020 11:44:28 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ8gFi2hvXVNh/IDfrZw+5XGrGfrdFNApJQkA7YIPOLIZvwIeKD
        katH3iln/MTyHNH65SgN7SLdxT7ey3u+5NCGTKE=
X-Google-Smtp-Source: APiQypKgeOSDBPfhB1u6KIP702ET7PgnervxCjGhHD+k7vVuRMCphJPctLEDVz7EFynIzXKRIHAMuiP/RJU2OhJDfVo=
X-Received: by 2002:ac8:7292:: with SMTP id v18mr3736593qto.304.1586285067943;
 Tue, 07 Apr 2020 11:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190205133821.1a243836@gandalf.local.home> <20190206021611.2nsqomt6a7wuaket@treble>
 <20190206121638.3d2230c1@gandalf.local.home> <CAK8P3a1hsca02=jPQmBG68RTUAt-jDR-qo=UFwf13nZ0k-nDgA@mail.gmail.com>
 <20200406221614.ac2kl3vlagiaj5jf@treble> <CAK8P3a3QntCOJUeUfNmqogO51yh29i4NQCu=NBF4H1+h_m_Pug@mail.gmail.com>
 <CAK8P3a2Bvebrvj7XGBtCwV969g0WhmGr_xFNfSRsZ7WX1J308g@mail.gmail.com> <20200407163253.mji2z465ixaotnkh@treble>
In-Reply-To: <20200407163253.mji2z465ixaotnkh@treble>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 7 Apr 2020 20:44:11 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3piAV7BbgH-y_zqj4XmLcBQqKZ-NHPcqo4OTF=4H3UFA@mail.gmail.com>
Message-ID: <CAK8P3a3piAV7BbgH-y_zqj4XmLcBQqKZ-NHPcqo4OTF=4H3UFA@mail.gmail.com>
Subject: Re: libelf-0.175 breaks objtool
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:FOE0EA54SyWtQIMENFoNs85TPCpb5Kcf9NUCi9wsMX9f+URGxgJ
 xX96trz1uEbdVhSSI8AhLDGfyoF4ZY3uQ8dqPbsMlHWW2xffg7FUuAcnpiv71c4e3wJTQ3R
 pSKIGb11Mwqa41Oqt9i8E+IBB+3wkEHjH1IGbYdhVoah1hxfFkJIWwfF9F44Ck3AiWojZ3B
 MDpo0qA6ddsTJnkdnV/Kg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:5y9y3SeAyk8=:HpxMxQJf8uhJtzjNh/z4Cq
 vR1PABdsX0rkiriS72bCc1WRErctmtdhwdTSk8N3g2/7LOJ4V3X0/9zNJRxH/ptXY/+0Cwjz8
 DPPdNSad4bsZ/h/hv1G5jpyaG7rt98EZgaGLNdujCX+6mTw/qXG+a9LWTxRNGm/4yaYV3BvE1
 dwWf/8AGbtgf0NhNEhxxufGKfiTdArCWKAd/Z0rXU8bP+5K9zGx0d5wmSswgj3B+FE+j67nF3
 hYsJrwipBUym46aQD9rmL0xPwlYZKRKv0oIJlmP+d7qnHlHgab+3PCXejQYmerD2L+jZweRMA
 edbyk+nmtOyzJzbEcibQNis7Bug6K16her2Vupo2LT2+J+cJKrk2C4bt3TTBYD8XbeZoNSZC/
 hqcb0r5URdwjAsdUSKno5FQCo33qckSO1ScXz99MnRCRUwqQwM47iVrUEuebrWNFGG3V+bIUk
 buTe2W/Hh12QL7cOlBdulbebyva5hVwy1BKBVDIgC9Oj3Bb2WJGnlCEv0uixVxP6K5AX60MTW
 CJIVe4tHMuzYgIClLx0PA8H6CQdHd7zYkIaVyTqGfVaKMVSjsxSHaEv1z3FiXW5G9gv9LEONt
 MVGnh+LT9Z0w/MDaFJ1+16hea8JkMtAFxAvPPhg0age7YJ46ttprq7eS9hRLneCYcDYXfMzrL
 VUe3ewpyXyXwXQzaCwrpGVKyvd8vTcETUu92Ggzq2d//Cy1gUcQR6Yj6WREPy8FMkzMqONQ7B
 GSnHAzoazGxdyfoVjHN/s43ItDOpU6wEI5blL/t+V8soiPTmhr9X+uPSfZr2k6pwscFOAhG6h
 tqj18fNK3/+gTWkAB0Pc80W/Mbre5iOytgvaG1X/T5CEeDrcq0=
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 7, 2020 at 6:33 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> On Tue, Apr 07, 2020 at 05:46:23PM +0200, Arnd Bergmann wrote:
> > On Tue, Apr 7, 2020 at 12:31 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Tue, Apr 7, 2020 at 12:16 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > >
> > > It's also odd that I only see the problem in two specific files:
> > > arch/x86/realmode/rm/trampoline_64.o (in half of the randconfig builds)
> > > and fs/xfs/xfs_trace.o  (in only one configuration so far).
> > >
> > > With this patch I can avoid the first one, which is unconditionally
> > > built with -g (why?):
> > >
> > > --- a/arch/x86/realmode/rm/Makefile
> > > +++ b/arch/x86/realmode/rm/Makefile
> > > @@ -69,7 +69,7 @@ $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
> > >  # ---------------------------------------------------------------------------
> > >
> > >  KBUILD_CFLAGS  := $(REALMODE_CFLAGS) -D_SETUP -D_WAKEUP \
> > > -                  -I$(srctree)/arch/x86/boot
> > > +                  -I$(srctree)/arch/x86/boot -gz=none
> > >  KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
> > >  KBUILD_CFLAGS  += -fno-asynchronous-unwind-tables
> > >  GCOV_PROFILE := n
> > >
> > > I'll look at the other one tomorrow.
> >
> > I found where -g gets added in both cases, and adding -gz=none
> > seems to address all randconfigs with CONFIG_DEBUG_INFO=n:
> >
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -7,7 +7,7 @@
> >  ccflags-y += -I $(srctree)/$(src)              # needed for trace events
> >  ccflags-y += -I $(srctree)/$(src)/libxfs
> >
> > -ccflags-$(CONFIG_XFS_DEBUG) += -g
> > +ccflags-$(CONFIG_XFS_DEBUG) += -g $(call cc-option,-gz=none)
>
> Maybe they shouldn't have -g in the first place?

That is very possible. The -g has been there since xfs was originally merged
back in 2002, and I could not figure out why it was there (unlike the
-DSTATIC=""
and -DDEBUG flags that are set in the same line).

On the other hand, my feeling is that setting -g should not cause problems
with objtool, if CONFIG_DEBUG_INFO is ok.

       Arnd
