Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AC1C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 12:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F5320787
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 12:19:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="XKz/N1CJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbgEZMTl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 08:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731015AbgEZMTl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 08:19:41 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB06C03E96D
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 05:19:40 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id z9so9256473qvi.12
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 05:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=iI5GDEByfzcccPx1CZ2MVqJrL75WIQY8kZJMrTcic2c=;
        b=XKz/N1CJdpPS5Nuwifs/FAEfvz2/svW5lvuwMPNXGAtQIt9sk7CXm0zyRkWG+EWPOU
         olb8CaQSNmONmsbfmD7vOoTiQIqjpjGg2v9eXxDv+v83c7L34LaNOjA8H+vzJpgvKhZi
         iDl/il8b/+odTfCmtXxeHpIcGlqp8JPdUCI3Fs3haXghjpHvEFt93ve1uqW0TP3LYFz1
         fCO0LX0nspV1nyWc9n9/pUqG+eqEQAL11uMHX3Pajg2A87ZsyCSIOntflKcjPCkt7F5D
         saMmicGNSA+QBdRMGEXNRYHcPytDH/7eYDwVsSJHKdDjndPS/VJ9otnKQk2g7KcNWqeW
         b2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=iI5GDEByfzcccPx1CZ2MVqJrL75WIQY8kZJMrTcic2c=;
        b=T1GllzOJGXg+mXMEicHg0gbyo07AgpjJXKFTrlOxJWYU0g3OoKaqD+/AwXfmCoOHJp
         BiSIw5SCRVOSr1EG6vV/FKb0lhHCtGQaCoxNlHR9tOxLVp0yllHu4Dlj95byclykdWnk
         3LZN9tAsF5nfF6+3afNpOtLSPL5/lUsd6Cc9oTkqUfzyY106Q/9o/sLtJxa7GIIv6ky4
         j4911LtnahsRfWB5tbH1W6tc6MwPx/NlsliocLTdZYFEPlekr8qnpObsTdmSiQSs124M
         JtE2gEtJVBYzPEI0PbR6oLpI9IxQP7qvB9Y1oNHYOShgc/pGptihoOcG+6ch+nXXQVUf
         UMUQ==
X-Gm-Message-State: AOAM5320961RY07U2AbTsUWyRZIMr6TTXGpeqmyVUFXxflNsruBeI4Oy
        sCg6HwbECUqu7Qphak6U5XrA2w==
X-Google-Smtp-Source: ABdhPJye811qnLvWAYcUoCMlGqcgjL24JcOcT0bLGsmMe8kRGfVClWw0Tuj+9yIno2lvDhgWgvi3mA==
X-Received: by 2002:a0c:fe03:: with SMTP id x3mr19231630qvr.18.1590495579276;
        Tue, 26 May 2020 05:19:39 -0700 (PDT)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id n85sm13817468qkn.31.2020.05.26.05.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 05:19:38 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: linux-next build error (8)
Date:   Tue, 26 May 2020 08:19:37 -0400
Message-Id: <3979FAE7-0119-4F82-A933-FC175781865C@lca.pw>
References: <CACT4Y+ap21MXTjR3wF+3NhxEtgnKSm09tMsUnbKy2_EKEgh0kg@mail.gmail.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        syzbot <syzbot+792dec47d693ccdc05a0@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
In-Reply-To: <CACT4Y+ap21MXTjR3wF+3NhxEtgnKSm09tMsUnbKy2_EKEgh0kg@mail.gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
X-Mailer: iPhone Mail (17E262)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On May 26, 2020, at 8:09 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
>=20
> +linux-next and XFS maintainers
>=20
> Interesting. This seems to repeat reliably and this machine is not
> known for any misbehavior and it always happens on all XFS files.
> Did XFS get something that crashes gcc's?

Are you still seeing this in today=E2=80=99s linux-next? There was an issue h=
ad already been sorted out.=
