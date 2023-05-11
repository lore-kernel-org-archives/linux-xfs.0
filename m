Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F6CC7EE22
	for <linux-xfs@archiver.kernel.org>; Thu, 11 May 2023 02:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjEKCtr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 May 2023 22:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjEKCtq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2023 22:49:46 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910FE40DF
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 19:49:45 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so74967890a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 19:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683773384; x=1686365384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrpmepZ1du4fgmw9IWA4rEcAyH7ZJYwPG2z7RiwU7qI=;
        b=O+2AV1uZVlRRj2G+vTbig4fsOjksA0/VAVH2V/0wlQhzxtBVe8VKn+HI+ZVkRRXZqs
         d3oreLS+pR/nF4YFnVIaqzfLtVQ9s52Yf+v6HaUzCmKKZZkjq7+wy/jHkXt1GnQIkzqx
         hsA9jbmmoBKbbIy5G+PBKyQEIwqHHr9Rkc76o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683773384; x=1686365384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LrpmepZ1du4fgmw9IWA4rEcAyH7ZJYwPG2z7RiwU7qI=;
        b=FONfhhyyckSz13rWDnhGdjchOScMA5NmC722f4g/F/egZIJHkCRLfqWWPVYFLdu3GF
         iPIC+aZBz91745Vi2UbpEpOwcNClkhHOSahKim8/htUttMZlEmM+Bm6DjgqOUsUjbj7X
         /ypH3t6mtl9OVWR1qVxZL8LXUno6Z22+OXAnuJZpXSAlyUKWZr/MzU5pdgRPKacTYk8w
         p5oUm1ApDYD9/SB/PYarQQyvWQ8foaUSrqs2x6LdzirCgDAHD0z5F1RjYRZLOq+/7KNj
         bopnJYK6S9XKZ0aXNzvmaaUkfrc170gJ2h0jq9bmdTYmYbDteqv4YVx7uC4Uc19434TJ
         X41g==
X-Gm-Message-State: AC+VfDwNw/PhVHLATB3MJDa2LON/81dyC9mZwNo5Dg38IMmpCyBUSEoA
        JF7/Iu7cdl97IwRmrsomdQSSsn6z3tXCPDKMYYAy4Q==
X-Google-Smtp-Source: ACHHUZ7Ia2ueT2zbmQYAxBfB0iCIkW0KKyXIMbNnaxuMG5KCo43R+DztwPhS1HlcP6hScY/fR2mxcg==
X-Received: by 2002:a05:6402:5244:b0:4ea:a9b0:a518 with SMTP id t4-20020a056402524400b004eaa9b0a518mr19065163edd.17.1683773383902;
        Wed, 10 May 2023 19:49:43 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id f20-20020a056402005400b0050dbc8980c3sm2281705edu.5.2023.05.10.19.49.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 19:49:43 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so74967765a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 19:49:42 -0700 (PDT)
X-Received: by 2002:a17:907:3f22:b0:96a:2b4:eb69 with SMTP id
 hq34-20020a1709073f2200b0096a02b4eb69mr6277573ejc.31.1683773382537; Wed, 10
 May 2023 19:49:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230511015846.GH2651828@dread.disaster.area> <20230511020107.GI2651828@dread.disaster.area>
In-Reply-To: <20230511020107.GI2651828@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 May 2023 21:49:25 -0500
X-Gmail-Original-Message-ID: <CAHk-=wjJ1veddRdTUs5BfofupuPxMoVHBUbAOmHw6p4pXPq5FQ@mail.gmail.com>
Message-ID: <CAHk-=wjJ1veddRdTUs5BfofupuPxMoVHBUbAOmHw6p4pXPq5FQ@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: bug fixes for 6.4-rc2
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 10, 2023 at 9:01=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> [ and now with the correct cc's. DOH! ]

[ Bah. And now with the correct cc's on the reply too. ]

We do not consider build warnings even remotely "harmless".

That sounds like you will fail all build farms that happen to have
this compiler version.

Which in turn just means that I'd have to revert the commit.

The fact that you seem to think that build warnings don't matter and
are harmless AND you imply that you can just leave some compiler
warning to the next release just makes me go "No, I don't want to pull
this".

So I pulled this. It built fine for me. But then I went "Dave says he
isn't even bothering to fix some build warning he seems to know about,
and isn't even planning on fixing it until 6.5, so no, I think I'll
unpull again".

When you decide that compiler warnings matter, please re-send.

                    Linus
