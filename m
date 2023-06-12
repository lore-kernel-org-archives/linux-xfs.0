Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1D1C7EE2E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 06:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjFLGLv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 02:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjFLGLu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 02:11:50 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB40BE
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 23:11:49 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-5151934a4e3so5868097a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 23:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686550307; x=1689142307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BipWuiASuB2niftXYaodHb7vCsVXt3eFLDs2b9I5S74=;
        b=X8fJHCahRG+vHrfOzR5OlBSSAbC2reAF+V95M3oKLBwzJwHezO2lxxlo+kF5Z1sNeQ
         sthOuJHsQATkSSz83e6aNybNt1HDmkZnuaq2Igb3xo41ZCHp6JYjPmGWZOcL5+hlZQW5
         HVvuzfKZgTdqC5YUc6gpE9ufdWedBeNmdf7zc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686550307; x=1689142307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BipWuiASuB2niftXYaodHb7vCsVXt3eFLDs2b9I5S74=;
        b=Rpgm4uFGWDXAdUnK/6Jv2ARfWHxE4+JTECz16lkmnyc5fVT4S5KmdgnF43RWwoXA7c
         H49tfCwRw4to6NwRy5SQZl0y6529aCg9OTF7O23TCaRg+OByazrpg0/QI9yHtVwJGRM/
         mKscRb2+CQ4zS90TsKuvtJbYTHrZ/DU3dvMtm5iezXx82u2K5wW3qc7J8rtliaWmQd0x
         jRTu0y+OxpdaEtP+NcHlSzv/kkUVqcJqRmUXsq+v4B0eyUtkTHQwtZGsapimizhF47D2
         7c8ojDdDJys1HkrdiNWuG8ZOfZqelHwpdzMg3OEaHVgxZ6kiFCi7YgvBq19wspHHNA4v
         d+EA==
X-Gm-Message-State: AC+VfDzSE7QcZ/yZgMGbYjS7BBBt1i5Ble6KgeY3i2Hnqw22CaNQd9t1
        qhaypMV9j2ybqevy1mSsawa5t2GLGWfvyV96uKAKFg==
X-Google-Smtp-Source: ACHHUZ7zizl/kq88SOHinTSykjwi5xIPhNnokZlF4Y1+FXYGIXim5wK7e4CFZjhsmaSSFRp41GidXg==
X-Received: by 2002:a17:906:db03:b0:974:1f0e:ec2d with SMTP id xj3-20020a170906db0300b009741f0eec2dmr8951833ejb.15.1686550307471;
        Sun, 11 Jun 2023 23:11:47 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id bi9-20020a170906a24900b009745417ca38sm4699763ejb.21.2023.06.11.23.11.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 23:11:46 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-51480d3e161so5864385a12.3
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 23:11:46 -0700 (PDT)
X-Received: by 2002:aa7:cd95:0:b0:514:95d5:3994 with SMTP id
 x21-20020aa7cd95000000b0051495d53994mr3761992edv.32.1686550305937; Sun, 11
 Jun 2023 23:11:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area> <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area> <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
 <ZIaqMpGISWKgHLK6@dread.disaster.area> <CAHk-=wgwJptCbaHwt+TpGgh04fTVAHd60AY3Jj1rX+Spf0fVyg@mail.gmail.com>
 <ZIax1FLfNajWk25A@dread.disaster.area>
In-Reply-To: <ZIax1FLfNajWk25A@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 11 Jun 2023 23:11:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj0NuJaRNC4o6FVAJgKAFJ5HWcBV5VJw6RGV0ZahqOOZA@mail.gmail.com>
Message-ID: <CAHk-=wj0NuJaRNC4o6FVAJgKAFJ5HWcBV5VJw6RGV0ZahqOOZA@mail.gmail.com>
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 11, 2023 at 10:49=E2=80=AFPM Dave Chinner <david@fromorbit.com>=
 wrote:
>
> On Sun, Jun 11, 2023 at 10:34:29PM -0700, Linus Torvalds wrote:
> >
> > So that "!=3D" should obviously have been a "=3D=3D".
>
> Same as without the condition - all the fsstress tasks hang in
> do_coredump().

Ok, that at least makes sense. Your "it made things worse" made me go
"What?" until I noticed the stupid backwards test.

I'm not seeing anything else that looks odd in that commit
f9010dbdce91 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps
regression").

Let's see if somebody else goes "Ahh" when they wake up tomorrow...

              Linus
