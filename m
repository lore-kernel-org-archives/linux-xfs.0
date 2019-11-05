Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF37C17460
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 14:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE9B121882
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 14:13:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VSCq5op4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388428AbfKEONV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 09:13:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32912 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389179AbfKEONV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 09:13:21 -0500
Received: by mail-wr1-f68.google.com with SMTP id s1so21598064wro.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 06:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PjuYHacnuTiWEigw6ZpIgLiUJujsPJkOZzzzszbAhOs=;
        b=VSCq5op4iSO/g/Frz7q6ypbw+Lc8Gt6ZQyQzK1Uqxh+6N/rOOSWKypIR1w7mHDEQf3
         JM88uiwU1NexuwsKabEmYtN+pkLV0ZXO+MhplMsTzvmVDmtFsSFsLrUvJN66ZqW1fuF2
         omCueQeWbzJk7wdp/J2/Teq/byvGsDGuE/hprTIxT8mIDwu3kpnL5OWpM7uRup3elyjb
         54xn05kfqeXXHl5396WnWgkfMarj2R02zQje1TGZ1qUbCM7fNDcO1KWX5QFL3l+UwIqX
         IoSt6IPS2z2OkNNYIWNGYc6CTgimza8he0JA963rE4QFyp8veXd/hEhO3Za6gUqUcupF
         RlUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PjuYHacnuTiWEigw6ZpIgLiUJujsPJkOZzzzszbAhOs=;
        b=l1zxobdOfuKidP80NzyM9DL5ELHCBDMUMPBUOCkbNDHopkWq3OCpVO/WOrVOgQ/QBY
         x0HPwPA4nu5b3p0Rv8xgdoQtnl+7RUxtgFNQuzb3oqNjpgjku0GMe9mhdmk+Duoqh7UP
         Bg6WOO1XRh6BjakCcarliNLYRnYpfwDqPyfBAPS0j73KR1FmjAL3cZMargg4zExLq03l
         +d+hHDie3QI4xQgKAaEppxDyFS6D3/7PzvF7pXP4K78yR+WXIuZVTz9PzWFILH1FJZX1
         qyinJ+yxVwy2rjyDUtUsaS1/W/wPvebLmAD+LtK2YFea0JkTHfX77GGUKsI6QL41etzB
         qVSg==
X-Gm-Message-State: APjAAAXFjV71a6f2MDujf2iTddQ+Je17mXqCVGCWzQv4wnc8HZgPX7Ok
        4D2SfEJq+60nbeUFjlF/QJTTUY9eecET48b+HnQ=
X-Google-Smtp-Source: APXvYqyP+ODbRhvJok6460IXhmFouoyrNSOde8/brMwCYOOL38ppOQvMCLMNk9dyfBcwxNsdt+xOeVk0gfXCTB/Ub0Q=
X-Received: by 2002:a5d:4584:: with SMTP id p4mr10516101wrq.345.1572963198990;
 Tue, 05 Nov 2019 06:13:18 -0800 (PST)
MIME-Version: 1.0
References: <CALjAwxiuTYAVvGGUXLx6Bo-zNuW5+WXL=A8DqR5oD6D5tsKwng@mail.gmail.com>
 <20191105085446.abx27ahchg2k7d2w@orion> <CALjAwxiNExFd_eeMAFNLrMU8EKn0FNWrRrgeMWj-CCT4s7DRjA@mail.gmail.com>
 <20191105103652.n5zwf6ty3wvhti5f@orion>
In-Reply-To: <20191105103652.n5zwf6ty3wvhti5f@orion>
From:   Sitsofe Wheeler <sitsofe@gmail.com>
Date:   Tue, 5 Nov 2019 14:12:53 +0000
Message-ID: <CALjAwxiMqjfBX3tZJv3MqMQ776v1aNcwme0B-AuhmEgMNUqgMw@mail.gmail.com>
Subject: Re: Tasks blocking forever with XFS stack traces
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 5 Nov 2019 at 10:37, Carlos Maiolino <cmaiolino@redhat.com> wrote:
>
>
> Hi Sitsofe.
>
> ...
> > <snip>
> > > >
> > > > Other directories on the same filesystem seem fine as do other XFS
> > > > filesystems on the same system.
> > >
> > > The fact you mention other directories seems to work, and the first stack trace
> > > you posted, it sounds like you've been keeping a singe AG too busy to almost
> > > make it unusable. But, you didn't provide enough information we can really make
> > > any progress here, and to be honest I'm more inclined to point the finger to
> > > your MD device.
> >
> > Let's see if we can pinpoint something :-)
> >
> > > Can you describe your MD device? RAID array? What kind? How many disks?
> >
> > RAID6 8 disks.
>
> >
> > > What's your filesystem configuration? (xfs_info <mount point>)
> >
> > meta-data=/dev/md126             isize=512    agcount=32, agsize=43954432 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
> >          =                       reflink=0
> > data     =                       bsize=4096   blocks=1406538240, imaxpct=5
> >          =                       sunit=128    swidth=768 blks
>
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal               bsize=4096   blocks=521728, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>                                                 ^^^^^^  This should have been
>                                                         configured to 8 blocks, not 1
>
> > Yes there's more. See a slightly elided dmesg from a longer run on
> > https://sucs.org/~sits/test/kern-20191024.log.gz .
>
> At a first quick look, it looks like you are having lots of IO contention in the
> log, and this is slowing down the rest of the filesystem. What caught my

Should it become so slow that a task freezes entirely and never
finishes? Once the problem hits it's not like anything makes any more
progress on those directories nor was there very much generating dirty
data.

If this were to happen again though what extra information would be
helpful (I'm guessing things like /proc/meminfo output)?

> attention at first was the wrong configured log striping for the filesystem and
> I wonder if this isn't the responsible for the amount of IO contention you are
> having in the log. This might well be generating lots of RMW cycles while
> writing to the log generating the IO contention and slowing down the rest of the
> filesystem, I'll try to take a more careful look later on.

My understanding is that the md "chunk size" is 64k so basically
you're saying the sectsz should have been manually set to be as big as
possible at mkfs time? I never realised this never happened by default
(I see the sunit seems to be correct given the block size of 4096 but
I'm unsure about swidth)...

> I can't say anything if there is any bug related with the issue first because I
> honestly don't remember, second because you are using an old distro kernel which
> I have no idea to know which bug fixes have been backported or not. Maybe

Very true.

> somebody else can remember of any bug that might be related, but the amount of
> threads you have waiting for log IO, and that misconfigured striping for the log
> smells smoke to me.
>
> I let you know if I can identify anything else later.

Thanks.

--
Sitsofe | http://sucs.org/~sits/
