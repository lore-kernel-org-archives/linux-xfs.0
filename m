Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AAEC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 13:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B336E208A7
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 13:26:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iDC+dqwt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgEZN0y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 09:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbgEZN0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 09:26:53 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D65C03E96E
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 06:26:53 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id er16so9417385qvb.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 06:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hmk6B8RUrIkz34C6PI8M98ThJVUuA5TDqt8agn6fqa4=;
        b=iDC+dqwtGL081U3BfohJc37CT4UlL3Od68C7HeX4CSkaSvXZhXO2RXuPnOUac824BD
         RZ8GI1L0xz3zOknKy+MHzsb343uIeuqR/0Z4vRkMp32hv1a9WeyHihfOCscx2AvC3XwR
         StBYwd2tLzmOvbSdVUySPtnMAXI9w12nYNOduf3pSynRu6GVPRBciOqkq8QWKZDp7sQz
         ebHR3Fg2UoNprP0RD1D4k76WGaTew49awzPUsIOQKrERakzv+VyrCNnZ6JmjwAVupkq2
         bFAzNDyAtfe2nVNFCeV58IfnfmOKXXvyFzrlzfF3HsyaFMLgPqOtUg6OsKSDiXXKAAf2
         zFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hmk6B8RUrIkz34C6PI8M98ThJVUuA5TDqt8agn6fqa4=;
        b=q2m4rvXEjip0EnWJA4ukzpssJfjlJme26ZycgPGCYUHfir7Yh7rLmdtXp81DBN2+cm
         lspepEUAhS5XjgCWBgD5ZKC9rMdXb3bwaBU1T2gD0g3mb2oFsY0ic6MTWzJ6CcjL2juI
         1Hn8IMifWbGoDD9RwM6ea72oGN1TG3SfftOhzkRFebWKAQfPOjVycyHTruTJt79UFnDv
         xzBgY3Wbx34Cfuunun2FuMixuuBtAEjjipuDGDmx7Z12hDT5kiwJAumzEektYERT3veJ
         S+JLCOVkg6BB9/X5xjnyTdiM6dCI+ouLtBXdkpAQzX4p+1H4UbYiZnAapyp4GDEYR/Or
         qkdg==
X-Gm-Message-State: AOAM531OoKozZGyngFtUTGKmefW/govjy10eAqCbwv2FfYxEKkGnrfQZ
        V9egnyOe+ynU6ZMEJjEWkCCf0Zbwh5vH2euNVv5X+g==
X-Google-Smtp-Source: ABdhPJy751+Ne/bm3PZICNFcj8aaxPdDg8GNmyBdEnMd2N34wGYIghfUSy6g0fy+hIgVlLYMhikhJYrzzCVVefl4gxk=
X-Received: by 2002:a0c:f153:: with SMTP id y19mr19321642qvl.22.1590499612050;
 Tue, 26 May 2020 06:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <CACT4Y+azkizw6QA0VCr0wv93oSkgaYCPc4txy9M=ivgBot1+zg@mail.gmail.com>
 <37C9957E-40A6-4C29-95FC-D982BABD26F6@lca.pw>
In-Reply-To: <37C9957E-40A6-4C29-95FC-D982BABD26F6@lca.pw>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 26 May 2020 15:26:40 +0200
Message-ID: <CACT4Y+audgm3QWaVW5uPZF08VXhhNZvtXcW+1cTww53gmWCsKA@mail.gmail.com>
Subject: Re: linux-next build error (8)
To:     Qian Cai <cai@lca.pw>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        syzbot <syzbot+792dec47d693ccdc05a0@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 2:41 PM Qian Cai <cai@lca.pw> wrote:
>
>
>
> > On May 26, 2020, at 8:28 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > Crashes (4):
> > Manager Time Kernel Commit Syzkaller Config Log Report Syz repro C repr=
o
> > ci-upstream-linux-next-kasan-gce-root 2020/05/22 01:23 linux-next
> > e8f32747 5afa2ddd .config log report
> > ci-upstream-linux-next-kasan-gce-root 2020/05/21 15:01 linux-next
> > e8f32747 1f30020f .config log report
> > ci-upstream-linux-next-kasan-gce-root 2020/05/19 18:24 linux-next
> > fb57b1fa 6d882fd2 .config log report
> > ci-upstream-linux-next-kasan-gce-root 2020/03/18 16:19 linux-next
> > 47780d78 0a96a13c .config log report
>
> You=E2=80=99ll probably need to use an known good kernel version. For exa=
mple, a stock kernel or any of a mainline -rc / GA kernel to compile next-2=
0200526 and then test from there.

People also argued for the opposite -- finding bugs only on rc's is
too late. I think Linus also did not want bugs from entering the
mainline tree.

Ideally, all kernel patches tested on CI for simpler bugs before
entering any tree. And then fuzzing finds only harder to hit bugs.
syzbot is a really poor CI and it wasn't built to be a one.
