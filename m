Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8CFC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 12:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B659207CB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 12:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="nv+sB7dO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389184AbgEZMlV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 08:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388497AbgEZMlT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 08:41:19 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99147C03E96D
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 05:41:19 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id h9so5724333qtj.7
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 05:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=Xh3pExmVkt8bZc1uS7lrd2mrVek8AS7U3TEQw0JwpIU=;
        b=nv+sB7dOHnON86Ux7BfVzKeMq5qmWXYjshSbUtztHcV2bh39qOI9HHMCttzQo3Vcxj
         Nw9FcPfSGLSGV1UeGvj3Rv7GvqCLpsLamgDtJjek5Z2Q52Iqc3MkKcOtxMGXsz2OavL9
         Smk5TpwN71EQU/C85k3DJ+idsE+7BQ9RbeZnjQG04w9PKuXf3uO4qfLxznbGjlfuzIM/
         P0KeJFGCGGM/px+py0kVlwSVwPq13IWOkDDWa6ATE0gwkWuEQDnbsFufxflM+KetcI0V
         HGw3xqa7J7O6/q/Ol2dpbZwCYokki74JmM4/3+I8sk7zKjTwW1yKOgch3+PrbXxwRx5a
         LdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=Xh3pExmVkt8bZc1uS7lrd2mrVek8AS7U3TEQw0JwpIU=;
        b=VQ33TSLT4TKpYUFeV86i8BHPleM474GAZF1LmlRPLxIN21AM9IsjihfFP/Aj0XAu1J
         zIhUx0uZQyNOlLzfUBugHkwN64KyPa1F3l25Y6k02hUqc5vCr2xBBaEQVO7ROwul6Yh3
         by2Dns9tzbud4z72G9gIG+ckSHjL7cunkmSGhdnnTob3vO2TTZDhIiu7xhLIaa0FtpIq
         aOpbO1h80lpri1pIP5P1ngGaRki3Qa54Fuesvm4EM0kULlXHDDo47rKxJRu6eC66U5h3
         56WOM+aKNOPZ0Z+KPdxlST6x0Qei0KqfsZyAc2gAqaYcPme4vrlwPWSWciDrRzbD9iRr
         RAfw==
X-Gm-Message-State: AOAM532nQe5h/tuo0YBffECmOmL1FuqM90pRzm8lC9SccGBSrvHWJVfH
        GE6pO5aN6TRmiQ8/+NWKNp0TsA==
X-Google-Smtp-Source: ABdhPJxEcaN9Hb9GI1QllH3utZeghc1M/xXaPn2E8ov4F1V30C4zuMwrKaYqJYy/9gIcpyAPsSLN7Q==
X-Received: by 2002:ac8:2f64:: with SMTP id k33mr990830qta.105.1590496878831;
        Tue, 26 May 2020 05:41:18 -0700 (PDT)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id k3sm16940389qkb.112.2020.05.26.05.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 05:41:18 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: linux-next build error (8)
Date:   Tue, 26 May 2020 08:41:17 -0400
Message-Id: <37C9957E-40A6-4C29-95FC-D982BABD26F6@lca.pw>
References: <CACT4Y+azkizw6QA0VCr0wv93oSkgaYCPc4txy9M=ivgBot1+zg@mail.gmail.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        syzbot <syzbot+792dec47d693ccdc05a0@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
In-Reply-To: <CACT4Y+azkizw6QA0VCr0wv93oSkgaYCPc4txy9M=ivgBot1+zg@mail.gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
X-Mailer: iPhone Mail (17E262)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On May 26, 2020, at 8:28 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
>=20
> Crashes (4):
> Manager Time Kernel Commit Syzkaller Config Log Report Syz repro C repro
> ci-upstream-linux-next-kasan-gce-root 2020/05/22 01:23 linux-next
> e8f32747 5afa2ddd .config log report
> ci-upstream-linux-next-kasan-gce-root 2020/05/21 15:01 linux-next
> e8f32747 1f30020f .config log report
> ci-upstream-linux-next-kasan-gce-root 2020/05/19 18:24 linux-next
> fb57b1fa 6d882fd2 .config log report
> ci-upstream-linux-next-kasan-gce-root 2020/03/18 16:19 linux-next
> 47780d78 0a96a13c .config log report

You=E2=80=99ll probably need to use an known good kernel version. For exampl=
e, a stock kernel or any of a mainline -rc / GA kernel to compile next-20200=
526 and then test from there.=
