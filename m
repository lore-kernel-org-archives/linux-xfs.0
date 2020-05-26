Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B3FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 13:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8FFD2084C
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 13:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="YExECrTn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgEZNuB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 09:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgEZNuB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 09:50:01 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51ACC03E96D
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 06:50:00 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id p4so9408697qvr.10
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 06:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8fJRiPAc3HDtyhiCAoUiDnY6LS5y4g0laHXS3FIiskU=;
        b=YExECrTnk+mF5c2HK2Lh1qB2UDnoe4QyXjbydDneUnPHu428wtPSwlrQZXFentZV44
         f6BnSjWlZNwvvj0iiNxZMhEW+ds1BnaKZrFsjzdARdhUaNqWlNjd8cby9xzAquqHjPx6
         XD7BtvY71j1jntRg37nWc1jymJZmjWfWo4soLs1tHzhS80rHNBORT9HRKDwTHty72Y30
         d0tSEjBeTuHp23rXTosBG/3t7fP6/91i8ld2tplnkzQHF2uD5sDeZlAXkBV4x/lhC7B+
         P0TTecnYDN6FZfAZ8jtAewragrQlbRs5JmrmeCnUaDuQWXnjQHoOiG+aF0nUKmftDNtM
         9kCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8fJRiPAc3HDtyhiCAoUiDnY6LS5y4g0laHXS3FIiskU=;
        b=mCjT0YHi1LAxKKiGx82nuxLSXE3YwTIAarFyoG9+7vDCI3les4+hhkm+CLLMswWg8G
         IVyX3G6j42GyGKruM0oNdZT1nzvouii91jBBJhEiv0nb1PxwgKAsezpfTZAJrtMZU+4n
         8Pi4mBxlBh2EeZtkoZwI2gkIBNgaZHuXmCVDwCSvH0qM2P0/H2mkDbFXuol4Tg3df6i8
         ikvaPr/tD5S6kdbm9+6o6vg1laItg+d0WZJ6CcsTFiiEX8ldkqZ15KRGEOwwviTvYEnS
         MHYzDABzXYzMyUNmCzxnNQ/YX3pjG96ciLtC6vqw8OkWyvmZlCFBJbr7QfrbjMvPyMAL
         3Fng==
X-Gm-Message-State: AOAM532mNqEy/XCIbIi5FDT5jTNlpwnMwzv9oQTO1jxSBJ7y1E4tcmJy
        dDB43IxA0xi8zcbFSqi5oPDXzg==
X-Google-Smtp-Source: ABdhPJyV+NcXxBYWZhnPXkt80xxfhiAFWQOiezvus6kmRl+IjrZMtqBf6RcPX5KSurs0dI/iRysHyg==
X-Received: by 2002:a0c:e4d4:: with SMTP id g20mr18913293qvm.228.1590500999975;
        Tue, 26 May 2020 06:49:59 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id z10sm17786315qtu.22.2020.05.26.06.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 06:49:59 -0700 (PDT)
Date:   Tue, 26 May 2020 09:49:53 -0400
From:   Qian Cai <cai@lca.pw>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        syzbot <syzbot+792dec47d693ccdc05a0@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: linux-next build error (8)
Message-ID: <20200526134953.GA991@lca.pw>
References: <CACT4Y+azkizw6QA0VCr0wv93oSkgaYCPc4txy9M=ivgBot1+zg@mail.gmail.com>
 <37C9957E-40A6-4C29-95FC-D982BABD26F6@lca.pw>
 <CACT4Y+audgm3QWaVW5uPZF08VXhhNZvtXcW+1cTww53gmWCsKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4Y+audgm3QWaVW5uPZF08VXhhNZvtXcW+1cTww53gmWCsKA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 03:26:40PM +0200, Dmitry Vyukov wrote:
> On Tue, May 26, 2020 at 2:41 PM Qian Cai <cai@lca.pw> wrote:
> >
> >
> >
> > > On May 26, 2020, at 8:28 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > Crashes (4):
> > > Manager Time Kernel Commit Syzkaller Config Log Report Syz repro C repro
> > > ci-upstream-linux-next-kasan-gce-root 2020/05/22 01:23 linux-next
> > > e8f32747 5afa2ddd .config log report
> > > ci-upstream-linux-next-kasan-gce-root 2020/05/21 15:01 linux-next
> > > e8f32747 1f30020f .config log report
> > > ci-upstream-linux-next-kasan-gce-root 2020/05/19 18:24 linux-next
> > > fb57b1fa 6d882fd2 .config log report
> > > ci-upstream-linux-next-kasan-gce-root 2020/03/18 16:19 linux-next
> > > 47780d78 0a96a13c .config log report
> >
> > You’ll probably need to use an known good kernel version. For
> > example, a stock kernel or any of a mainline -rc / GA kernel to
> > compile next-20200526 and then test from there.
> 
> People also argued for the opposite -- finding bugs only on rc's is
> too late. I think Linus also did not want bugs from entering the
> mainline tree.
> 
> Ideally, all kernel patches tested on CI for simpler bugs before
> entering any tree. And then fuzzing finds only harder to hit bugs.
> syzbot is a really poor CI and it wasn't built to be a one.

I had only suggested it as a way to workaround/confirm this bug which
will cause abormal memory usage for compilation workloads. Once you get
a working next-0526 kernel, you should be able to use that to compile
future -next trees.

I would also agree that our maintainers should make the quality bar
higher for linux-next commits, so I could get some vacations.
