Return-Path: <SRS0=k6ZN=2G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208BFC43603
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 16:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F138720717
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 16:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbfLPQxO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Dec 2019 11:53:14 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:59393 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfLPQxO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 11:53:14 -0500
Received: from mail-qk1-f172.google.com ([209.85.222.172]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MCGag-1iXVgQ1zLW-009Lmc; Mon, 16 Dec 2019 17:53:12 +0100
Received: by mail-qk1-f172.google.com with SMTP id z76so2766073qka.2;
        Mon, 16 Dec 2019 08:53:12 -0800 (PST)
X-Gm-Message-State: APjAAAWSy7q24yjWDIWvQ3YcznVV0B2CXymdLUJr9yVkYxIBzWDbnakP
        CcGM7vEXN1syFtNYtPgTYHqyGAi88feM3GCwThY=
X-Google-Smtp-Source: APXvYqx8OQ28y6zwlRWDG2wjFiQrXKgjpoyFeMfLdTx1B0TskmgazaNwwlSGO+Y/a0jpZf5xmEmtkNZeY6gnecHFA2U=
X-Received: by 2002:a37:b283:: with SMTP id b125mr189741qkf.352.1576515191229;
 Mon, 16 Dec 2019 08:53:11 -0800 (PST)
MIME-Version: 1.0
References: <20191213204936.3643476-1-arnd@arndb.de> <20191213205417.3871055-12-arnd@arndb.de>
 <20191213211728.GL99875@magnolia>
In-Reply-To: <20191213211728.GL99875@magnolia>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 16 Dec 2019 17:52:55 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3k9dq+9DnPFBKdzOe=ALPXXjCvBBj8r_xsqz1vTswGsg@mail.gmail.com>
Message-ID: <CAK8P3a3k9dq+9DnPFBKdzOe=ALPXXjCvBBj8r_xsqz1vTswGsg@mail.gmail.com>
Subject: Re: [PATCH v2 21/24] xfs: quota: move to time64_t interfaces
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:b0mKWonuY5xcyu40CrefNUDzjFx1xfsC/KkgRDd/UDY9c4T5TN1
 UxbAoCtpBcPVUsN9+jpx6MKF5TrPS7rPYa9EJs5T6j5hXDMfjcNJ4V1lv5kUuWCjqgp7OyV
 wZFI4mf+H/a2O6+ZUh6Dcej5lojL4TMNhnECbWDFGJ1VilbQQtpitTDoQaIBCG7xUbvfgEs
 dTea7yCp2GwlgCBj2bYBA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8i/krf8idpY=:Oa0oQseFk3Sx7eN72qMNa6
 d6NDz/jySMVJUM8lxjT+9trKDQYlxl9BM+qQhTx8Hu49ell6RXXrygobiwNo6yuE4OY6H0yOB
 uUHl839/ymPzT6aMOHdK9TdNoNWC4vxlbfxYod906VOELKKn6WlWvmfn6Dv2QUKO/Sw4TJsQo
 f7KtWNCCTASHAPVlS3OgfAlE7dmfWfTm2AwHA4+4WbOYCbNmaZuCxgmA7ZO0lcg93hhPwyDlr
 VjJaIUMJyqc3Fw8iwfrcZ1O41kazLnqkB5AqsZlAWrm7mTgoopikBiZYvtpCmhPQJc/kw8Ejz
 W7CcQQvByY0w+NiuUozLZqcoW2I6cSqEf49TBaoB4SYU+l9Lr0eC8XW4elPFJvjRZOonOUEM5
 YOz/aDZULXPSit39l1ge6B81ogmTc8GyRWoIz27TpwlCQRC26QLO375+5VzMTTbRIDqKc46gu
 EcQTmcjpSFXDv8H/inwCw6Ci1BHGzRJss+aN0G2zf90DG4FNg8UdbnaLRGahpg0tOpaIX3c1m
 12aWBeg1s9O2uFXtvDEaWqhkzUlxhob8qFUiyWmorAy92U3z3vXEJvMDt4S2H6TN7l+/4OzfD
 r3wn9e+4FsaMMUNLBz8K/nBaKK4D6EgJohKHGgYpl6tziDbRcUgO79NzHgPFocID+eQMjStPK
 vTvtryK5S8rY1BqsSqzk1V9VlqDopebZd1UHCEjBtTdxzE/v2nkwWW5TSpoYgIuJLauhwcFFv
 Td1txV4xBqzI5kZFi/NCfEOTY6ftlbZUm0+0skie84S2PE6nBILPo6ZB5Do9HQTY/AYketEsB
 p7ylfclF44MCXZM75vv7aclbX0581CcMH+3JFUmNUvmEP1fJHCeuOMwCqw6LlcEUM4t4P1QeU
 4CdXM1npGsmjPCdQhVhQ==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 10:17 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Fri, Dec 13, 2019 at 09:53:49PM +0100, Arnd Bergmann wrote:
> > As a preparation for removing the 32-bit time_t type and
> > all associated interfaces, change xfs to use time64_t and
> > ktime_get_real_seconds() for the quota housekeeping.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Looks mostly reasonable to me...
>
> The bigtime series refactors the triplicated timer handling and whatnot,
> but I don't think it would be difficult to rebase that series assuming
> this lands first (which it probably will, I expect a new incompat ondisk
> feature to take a /long/ time to get through review.)

Could you just merge my three patches into your tree then once
you are happy with all the changes?

> > @@ -183,7 +183,7 @@ xfs_qm_adjust_dqtimers(
> >                   (d->d_rtb_hardlimit &&
> >                    (be64_to_cpu(d->d_rtbcount) >
> >                     be64_to_cpu(d->d_rtb_hardlimit)))) {
> > -                     d->d_rtbtimer = cpu_to_be32(get_seconds() +
> > +                     d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
> >                                       mp->m_quotainfo->qi_rtbtimelimit);
>
> Hmm, so one thing that I clean up on the way to bigtime is the total
> lack of clamping here.  If (for example) it's September 2105 and
> rtbtimelimit is set to 1 year, this will cause an integer overflow.  The
> quota timer will be set to 1970 and expire immediately, rather than what
> I'd consider the best effort of February 2106.

I don't think clamping would be good here, that just replaces
one bug with another at the overflow time. If you would like to
have something better before this gets extended, I could try to
come up with a version that converts it to the nearest 64-bit
timestamp, similar to the way that time_before32() in the kernel
or the NTP protocol work.

If you think it can get extended properly soon, I'd just leave the
patch as it is today in order to remove the get_seconds()
interface for v5.6.

> (I'll grant you the current code also behaves like this...)
>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks,

       Arnd
