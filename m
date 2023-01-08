Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BBFC54EBD
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Jan 2023 18:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjAHSOt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Jan 2023 13:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbjAHSOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2023 13:14:48 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780B82C4
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 10:14:47 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id h26so6298755qtu.2
        for <linux-xfs@vger.kernel.org>; Sun, 08 Jan 2023 10:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h51R+ZkCMi+RC7MRiEU6pABB37URB661iTnvdM9gNWA=;
        b=EOfGUk7uclaUQpp6QDx/YJWltvUbXFGOjVmIuKaF/ZXf/62ZmCBg6CgnB577nrDV54
         gj/Iq3dFeRkEiKYGLOH/NyvDme9xprGayZPyFPU+4uFOIYcPviDTEL6multlFLNXpR3y
         qb5MFEhg0ds6JwN/8RYGi7ihzsZsT1PRvvMCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h51R+ZkCMi+RC7MRiEU6pABB37URB661iTnvdM9gNWA=;
        b=tbfDzud3WQHFbyiyXbUgGlivvvz/DQ/ghWN2WVC37GonlhtDoZP38rOsteAg3kmb1o
         RWyt+Oto0f8G43te7U6QSIIJN03W4eM7+yDXZtQsVMbBA8X3YE4fOiRHAZygb/V5zUtP
         9NWg6/LCyPg96s8ptLzIu2liI2btOwrEONZmBz5PJZ1XFhdgO7CoU4h4HrZFNp2i0yNJ
         SL/lA3l3Jca2vK45h12H63Sfy079X5s554Q+W1XPViMGZJsXX6cmorXaeoDa7FlXGLhf
         j5RzO5mSKIgV0atY2fAXDVx0OEIyws3s0XEjROZbIp/Z8qeBfWb23+YvPgR8xTHLAidM
         Al7A==
X-Gm-Message-State: AFqh2kru20/1YOEVQ29In12uS5Mbwpdy+SfVCNgzQTafR5GHe7W42zgH
        foMY5o70DGbu98Fz+X+lnJu9mCGM0rP4WVYi
X-Google-Smtp-Source: AMrXdXtKFYn3+04tAs25q5QtN1yfVhsvXi/4drI5GT+m8o9j0W7RVTUg2R8FRnwh4K3P68sqtNA90w==
X-Received: by 2002:ac8:706:0:b0:3a8:199b:dcaf with SMTP id g6-20020ac80706000000b003a8199bdcafmr85498176qth.17.1673201686220;
        Sun, 08 Jan 2023 10:14:46 -0800 (PST)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com. [209.85.222.179])
        by smtp.gmail.com with ESMTPSA id bn34-20020a05620a2ae200b006cfc7f9eea0sm4010049qkb.122.2023.01.08.10.14.45
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 10:14:45 -0800 (PST)
Received: by mail-qk1-f179.google.com with SMTP id k3so3116867qki.13
        for <linux-xfs@vger.kernel.org>; Sun, 08 Jan 2023 10:14:45 -0800 (PST)
X-Received: by 2002:a05:620a:674:b0:6ff:a7de:ce22 with SMTP id
 a20-20020a05620a067400b006ffa7dece22mr3325069qkh.72.1673201685236; Sun, 08
 Jan 2023 10:14:45 -0800 (PST)
MIME-Version: 1.0
References: <167320037778.1795566.14815059333113369420.stg-ugh@magnolia>
In-Reply-To: <167320037778.1795566.14815059333113369420.stg-ugh@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 8 Jan 2023 12:14:29 -0600
X-Gmail-Original-Message-ID: <CAHk-=wiBVEPW1ns1Foj2VonD68JSt3WpNDk-OxOd3i1WsTGFJQ@mail.gmail.com>
Message-ID: <CAHk-=wiBVEPW1ns1Foj2VonD68JSt3WpNDk-OxOd3i1WsTGFJQ@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: bug fixes for 6.2
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, shiina.hironori@fujitsu.com,
        wen.gang.wang@oracle.com, wuguanghao3@huawei.com,
        zeming@nfschina.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 8, 2023 at 12:00 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Please pull this branch with a pile of various bug fixes.

This came in just as I was writing the rc3 announcement email, since I
needed to get that done before I lose wifi again during travels today.

Oh well, no biggie.

> Speaking of problems: I'm in the process of updating my gpg key so that
> I can do ed25519 signatures, but I still suck at using gpg(1) so wish me
> luck.

Heh. Not that I'm sure why rsa4096 wouldn't be good enough, but maybe
you know something I don't...

>  The -fixes-2 tag should be signed by the same old rsa4096 key
> that I've been using.  I /think/ the -fixes-1 tag got signed with the
> new subkey, but (afaict) the new subkey hasn't yet landed in
> pgpkeys.git, so I went back to the old key so we can get the bugfixes
> landed without blocking on maintainer stupidity.  Or at least more
> stupidity than usual.

It's not like the keys have to be in pgpkeys.git..

You can always just sign the new key with the old key (which
presumably y ou want to do anyway), and send me new key in email - or
just use the key servers if they happen to work.

But the old key obviously worked just fine.

Thanks,

      Linus
