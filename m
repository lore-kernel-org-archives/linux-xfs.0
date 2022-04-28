Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429CBC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 16:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345528AbiD1Qtu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 12:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiD1Qtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 12:49:49 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E864A90B
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 09:46:34 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id w1so9673333lfa.4
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 09:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUCMX2s+rfJjnCRjPBsqTrvIeHc/xB8tXJiukV/x6uw=;
        b=CFs7namgLcbBdzCbwOWn2HbPugYal+FkQVh5xTQTuNZ4X2cDs80Xv/mDS6+440fwDi
         CC2DbosLjDm+BxDHJcapajycT4b0+dLD2PsDJ3JXhK3ksFxCFasZN9PIAY59aQp8gteJ
         Xpt91Gtmx1ig/8drEurcSZU7ZSUfFnYJPjHFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUCMX2s+rfJjnCRjPBsqTrvIeHc/xB8tXJiukV/x6uw=;
        b=I3gl7IuLgv+TvsXylTDxbL9kRaEG5SFGmMC3hpI/fbB2T00wz09EK3rINYW6RoNP9P
         8PhWD3k5zZIEguqp3Zf96Mw+DyAXj6LqetkMMkNis4Ruim9lcARnq2ioqrUuWElu+dVX
         Ed99sJLDKXpRrZAktL8IOwR4Zk5UYhdYrV/kVKnKiQLi58k9cUPkWW8XxPYaTNlujZ2Y
         i2fBHEXrblBo4yjq0z4BVLg0sRXVs4bSSCtYHgoOU+4vMdnsIb2bdHcBSqKJFR+Hfox2
         KumhjHkZtTxkXfhZcdW254yMeGAxAKsd4KoO4eAM4P9VEsU8xSIpV+pthR2w00Anw+Yj
         QMIA==
X-Gm-Message-State: AOAM5313kbKbj1qnG5b7fiOjQ5EYV0kbh24pJVfYoIDeToY2xdc9D93y
        a7LVVvqP+DQeIJ55M7DvcnfXTYSvhaMBUWNbNio=
X-Google-Smtp-Source: ABdhPJxr9A65ko7hN5eEQVybXGDCr0tfnIgNja2QoKFsaGjXWKhbI1FREq15TnG7DUgdYOBHRgDBMw==
X-Received: by 2002:a05:6512:3fa0:b0:44a:f66c:8365 with SMTP id x32-20020a0565123fa000b0044af66c8365mr25282821lfa.152.1651164391941;
        Thu, 28 Apr 2022 09:46:31 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id s13-20020a195e0d000000b00471fec5ec68sm45315lfb.18.2022.04.28.09.46.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 09:46:31 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id w19so9638837lfu.11
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 09:46:30 -0700 (PDT)
X-Received: by 2002:a05:6512:3c93:b0:44b:4ba:c334 with SMTP id
 h19-20020a0565123c9300b0044b04bac334mr24872519lfv.27.1651164390506; Thu, 28
 Apr 2022 09:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220428061921.GS1098723@dread.disaster.area>
In-Reply-To: <20220428061921.GS1098723@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 28 Apr 2022 09:46:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVgPPczqyLyOg8fmGYc1z+-ngPKkS_bCTwefcLXfp4CQ@mail.gmail.com>
Message-ID: <CAHk-=wiVgPPczqyLyOg8fmGYc1z+-ngPKkS_bCTwefcLXfp4CQ@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: fixes for 5.18-rc5
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 11:19 PM Dave Chinner <david@fromorbit.com> wrote:
>
> It's all minor stuff;  a 5.18 build regession fix, a deadlock fix
> and an update to remove redundant fields from the XFS entry in the
> MAINTAINERS file.

Done.

I had to look twice at that patch going "why does it complain about
the xfs flags thing" until I realized it was due to XBF_UNMAPPED being
(1 <<31) and the compiler then seeing explicit negative values being
assigned.

We have a lot of "int flags" in various places, very much not just
xfs, and yeah, we should probably try to clean them up.

But 99% of the time it's just not worth the noise.

And xfs only hit it because you guys literally used up the whole 'int'
for it, normally the compiler won't make a peep about it.

Thanks,
                     Linus
