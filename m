Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB9BC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 12:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A3A92086A
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 12:50:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="cnyPUGks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgEZMur (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 08:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729311AbgEZMur (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 08:50:47 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717F7C03E96D
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 05:50:47 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id z9so9298230qvi.12
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 05:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=DLCNFJm55L78u6JLrjP7OyErktPYrpCgbRX7hwvwKtc=;
        b=cnyPUGks4WG7f1LVMTdpOZNC4kV+McfCISkENX+gp8NXAn65+upAiiZ02qrX3bl6eq
         yEWnKfsxnb3DyFSV1Frt2snWcyDB3nDCx9rc3AZe8Pjl+caDFYGjATG/aImG2miiDbNT
         cS0O4gZkrt05mCT9aWr0i4ki7o7aF/6luaKbLevKdsQS3bEO7+hmtN4Lbx4bPvOQNcKR
         2GR2+w2658Yd+iM+rJkDNaqgdRoFcvkYcvohhfiPVWV7S6sg1xv7EdCM24BrbRDAl1V/
         /Sqntf2Yx7LnOy6ENtGMyFMudOPmD++ffcZiK9G0bVCpV2ph0Vf+gXV971k/nNqmEI1x
         8bBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=DLCNFJm55L78u6JLrjP7OyErktPYrpCgbRX7hwvwKtc=;
        b=i7VFQBTLnw9G55l7z9Z++2YgFTyiKej8ISDEiES+et1EpiKWzs0BjxnIgj/4nxCy4t
         3RdAA1IimxMfGrI9JZ7zwYdAgpt4h0ptcuoQzsZDPxnhSYkJM3axH6xk1zfIg4WJI2X8
         zZeXbqOuh5Br4sbqSIzDtPSzq7dJh4kfiPG+R4rb6RB1Qv0sVmwu03ul2CSchJsgZO5u
         2rF0BU7Xnu+eeOjZiqrfhz2fz//jaoaF0PWfLYUmG8JDSr9Jfh+ieVsbiKq07cGxS/M8
         TRcILP/2S09ZwQ06qXpuh/xqEeeLVOAkapaFNE8PQQZOYR+ld52NxIUDPucgU7rynuFU
         aAJQ==
X-Gm-Message-State: AOAM5322AdunPZYEd7rP9Qr690mELOjCZwObLzNmysf1qGnzySz3svsc
        iG8DFYeN5DfgJUaaFPEsDVJ3Fw==
X-Google-Smtp-Source: ABdhPJz6/3sxtTAYJs2aYTZoaxwsyfndBHnuVxA8piVB3Bep0lvYA5ww9cjYiCg5Pt/YMYsWZujXLA==
X-Received: by 2002:ad4:4aa3:: with SMTP id i3mr19989723qvx.28.1590497445933;
        Tue, 26 May 2020 05:50:45 -0700 (PDT)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id g51sm8538947qtb.69.2020.05.26.05.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 05:50:45 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: linux-next build error (8)
Date:   Tue, 26 May 2020 08:50:44 -0400
Message-Id: <94634EA6-1812-4E4C-B156-29482346D3C9@lca.pw>
References: <880bb80d-ffb4-f64d-f9dc-aeeb4d3c3cd3@i-love.sakura.ne.jp>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        syzbot <syzbot+792dec47d693ccdc05a0@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
In-Reply-To: <880bb80d-ffb4-f64d-f9dc-aeeb4d3c3cd3@i-love.sakura.ne.jp>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
X-Mailer: iPhone Mail (17E262)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On May 26, 2020, at 8:45 AM, Tetsuo Handa <penguin-kernel@i-love.sakura.ne=
.jp> wrote:
>=20
> The last occurrence was next-20200521. Do you know the commit which fixed
> this problem (so that we can confirm the problem was already fixed) ?

Not on top of my head, but I did confirm the issue was fixed since next-2020=
0525.=
