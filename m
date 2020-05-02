Return-Path: <SRS0=mmaA=6Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C38C47254
	for <linux-xfs@archiver.kernel.org>; Sat,  2 May 2020 09:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D44E9216FD
	for <linux-xfs@archiver.kernel.org>; Sat,  2 May 2020 09:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HyHpgfki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgEBJRf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 May 2020 05:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgEBJRe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 May 2020 05:17:34 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D384C061A0C;
        Sat,  2 May 2020 02:17:34 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id t12so6558275ile.9;
        Sat, 02 May 2020 02:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YVcRg1TrVCrnzX9/CrxJZUFs+WS0GmVpZmQMp8hTcKE=;
        b=HyHpgfkibgZcyDOxbUHPPRxt94BWqhqlA58VUYo4kxdpjAxSQf6qIQlFu76d1LIObC
         XRKuTMTwyqGkSsq8EkpJcT6xIz2nJcQWclh1K2CrqoVJ9OOqFE5KhqltKYJXT9KR0bfU
         XmjAa0Y4KN06EqPqlV4P5YwgCizu8cEvlWt5V3AM7C1vsLxv/XYO8Iga1lRnZ6Q3j0HL
         trRsvuWKNW5z2ScPP9/U9MApcXr308SAvjOhenM5zprmHYpBOGx4RDcTyEn6xB7txiNs
         i+4pyhJUxIJXu1VpuJ35ntWHvV0Gu5c5oEVRV96MXtqmzGQld33MIu+SjtD8+LvlYh7R
         /KGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YVcRg1TrVCrnzX9/CrxJZUFs+WS0GmVpZmQMp8hTcKE=;
        b=kW4mL6ZdhRfnYoCi+6Kv3dJlfBS6lHcXCi/JLyVAMM9rDeuTYW1dHW+5NokgS5kbm5
         s4D6aKGzid5wQBmsOCsU56DVKq57dDp2XFdBq3grpl1ZFc9bc/emtOHp03g6MVA9o9bk
         ZjlDWymkUhZcF+Srgt1fSew26PXwCPguItnl1ttT3m/u3OLW5/nivA4PhXXLmsgBpGol
         nFmASr0rd7hRWhn6O7mU6vk7nz7dVNkmE6b7iVbEsGM7L3yp4PIlUj/tgV+grzAtfqdi
         m3/+57SDIJJgmIFTRiQM4tvOr2Ut2nOxybvQruNmE5a+s0VCsfWnxB1S2PbbOXqMzHlW
         4mhQ==
X-Gm-Message-State: AGi0PuZNnDKRZcTlH2G46RHDuamGHgqrdyBhVhcE2PFGarx7H71wMGbH
        qPNW/MQIF1Z+1fg1mpP7mNVcppR0PisCkGjbXgz2xx5r
X-Google-Smtp-Source: APiQypJCup02DClBP/kjk32DUwVFM5G6oBR7gMNpx39ZqQ2I5NVbFI4sKHYw616Vkes2GexvSbfWoKF/6yOeb6TRGAg=
X-Received: by 2002:a92:390f:: with SMTP id g15mr7720385ila.72.1588411053290;
 Sat, 02 May 2020 02:17:33 -0700 (PDT)
MIME-Version: 1.0
References: <171ca5e76d2.11a198ab91526.7776557945472155733@mykernel.net>
 <171ca7ca308.ed1c416b1605.5683082771269054301@mykernel.net>
 <CAOQ4uxgVRW9QKVg8edem2OKH1cjLF1+h5YW+nPfkoQg3OiaxgQ@mail.gmail.com> <171d3944dec.fa74976d195.2610320131996757607@mykernel.net>
In-Reply-To: <171d3944dec.fa74976d195.2610320131996757607@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 2 May 2020 12:17:21 +0300
Message-ID: <CAOQ4uxj=2jwk0OeR+EZp9P_48WX58XXddjR2y8n56mTsi1N9jg@mail.gmail.com>
Subject: Re: system hang on a syncfs test with nfs_export enabled
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     linux-unionfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, miklos <miklos@szeredi.hu>,
        guaneryu <guaneryu@gmail.com>, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

+CC  xfs folks

On Sat, May 2, 2020 at 7:10 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-30 20:22:06 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Thu, Apr 30, 2020 at 12:48 PM Chengguang Xu <cgxu519@mykernel.net> =
wrote:
>  > >
>  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-30 17:15:20 Che=
ngguang Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
>  > >  > Hi
>  > >  >
>  > >  > I'm doing some tests for my new version of syncfs improvement pat=
ch and I found an
>  > >  > interesting problem when combining dirty data && godown && nfs_ex=
port.
>  > >  >
>  > >  > My expectation  is  Pass or Fail  all tests listed below, Test2 l=
ooks a bit strange and in my
>  > >  > opinion there is no strong connection between nfs_export/index an=
d dirty data.
>  > >  > Any idea?
>  > >  >
>  > >  >
>  > >  > Test env and step like below:
>  > >  >
>  > >  > Test1:
>  > >  > Compile module with nfs_export enabled
>  > >  > Run xfstest generic/474   =3D=3D> PASS
>  > >  >
>  > >  > Test2:
>  > >  > Compile module with nfs_export enabled
>  > >  > Comment syncfs step in the test
>  > >  > Run xfstest generic/474   =3D=3D> Hang
>  > >  >
>  > >  > Test3:
>  > >  > Compile module with nfs_export disabled
>  > >  > Run xfstest generic/474   =3D=3D> PASS
>  > >  >
>  > >  > Test4:
>  > >  > Compile module with nfs_export disabled
>  > >  > Comment syncfs step in the test
>  > >  > Run xfstest generic/474   =3D=3D> FAIL
>  > >  >
>  > >
>  > > Additional information:
>  > >
>  > > Overlayfs version: latest next branch of miklos tree (5.7-rc2)
>  > > Underlying fs: xfs
>  > >
>  >
>  > Please test also against 5.7-rc2. Maybe we introduced some
>  > regression in -next.
>  >
>  > Please dump waiting processes stack by echo w > /proc/sysrq-trigger
>  > to see where in kernel does the test hang.
>  >
>  > I cannot think of anything in nfs_export/index that should affect
>  > generic/474, but we will find out soon...
>  >
>
> I=E2=80=98m on vacation this week and it seems hard to reproduce the prob=
lem on my laptop, maybe there were some config problems.
> I'll do more analyses next week on my testing machine.
>

Forgot to say - I also tried and failed to reproduce.

Looking under the lamppost, I suspect changes in xfs shutdown
in v5.7-rc1:

git log --oneline --grep shutdown v5.6.. -- fs/xfs
842a42d126b4 xfs: shutdown on failure to add page to log bio
5781464bd1ee xfs: move the ioerror check out of xlog_state_clean_iclog
12e6a0f449d5 xfs: remove the aborted parameter to xlog_state_done_syncing
a582f32fade2 xfs: simplify log shutdown checking in xfs_log_release_iclog
8a6271431339 xfs: fix unmount hang and memory leak on shutdown during quota=
off
13859c984301 xfs: cleanup xfs_log_unmount_write
b941c71947a0 xfs: mark XLOG_FORCED_SHUTDOWN as unlikely
6b789c337a59 xfs: fix iclog release error check race with shutdown

If you are able to reproduce, please try to reproduce with v5.6.
It could be an intersection between changes to xfs shutdown and
the way that kernel internal modules interact with xfs.

Trying to look at wide spread test coverage of -overlay + xfs shutdown,
I count only 2 generic tests that exercise this combination:
generic/474 and generic/461. The rest of the shutdown tests require
either local_device or metadata_journaling.

I think that at least Darrick runs -overlay as part of validating
an xfs pull request to Linus, so there should be fare amount of test
coverage for these two tests.

generic/461 seems to do something quite close to what you did when
commenting out syncfs in generic/474, but is not in 'quick' group, so it
may get less wide testing coverage.
I wonder why is is not quick, though. On my system it runs for 24s.

Thanks,
Amir.
