Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F8AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Nov 2021 10:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7BC961AFB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Nov 2021 10:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbhKPKPa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 05:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbhKPKP0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 05:15:26 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6730C061206
        for <linux-xfs@vger.kernel.org>; Tue, 16 Nov 2021 02:12:24 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id y5so23261435ual.7
        for <linux-xfs@vger.kernel.org>; Tue, 16 Nov 2021 02:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Qo9WTf+qMiV4n2eNNwXHVAXMVEUZatbTf4RK8Hr38o=;
        b=Yau4QzFPgdwlQz1BghwNyui0lwtXQlf4Is9n/gOlP5QjDEA3CFGt9CwSQlt/d5tmlk
         3fJyJcCupX8CLg/ffWyLwl2BvodkjzESKoC1BNbiASfKD2EF8+vuL3F5cjsDlAtT+4P+
         1UstLtv2uolUzCkEfjfrk7AA6Gp6IBWAhz7sw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Qo9WTf+qMiV4n2eNNwXHVAXMVEUZatbTf4RK8Hr38o=;
        b=R5PprbXB67BKpfptCDu8rhXyr6o7xEFqVmRMYrXd4nwn9Cdk+BoaaeGh30/usJ0jPM
         fJCPMbQmXSBnWsRBnSnKqAlBLhBQrNVLnxjdq9ZqlvtCzK/Zx67vFWnKtut1/e0+wiLR
         9SFsANpeTomxLsyH7YcnICRb5MNuEoaHiwNNkh7phEpZAXtLnVgxqOT3fWoPx36L++Hl
         bXs+aUzVrVLmVtcvktXwIP6Ubmgu/xVKu1duhC82f2nLS6ZlcMUHpxkAnaJqqGNKzcjf
         +6/LgH4MQ8/SKRFpAlNpTh/bJ2YzBphsYBdDYDLmj9V7KpGqBFTtl5TVx9P6lsvsYhiZ
         EG7Q==
X-Gm-Message-State: AOAM532iAYv01deyvQj02AqmQq9I0GDN5PwA3gVN5d8C9htjXHknczSF
        TdJsEsSbjG4XWsjYNv0XuL4dLDLTkrQllDtKtAXE/44ptK8=
X-Google-Smtp-Source: ABdhPJwLkRmBrkYHCLR4uh7iDnvFVkyXtpUJ0H8oJbrZW1pAZVKF8+eZdqTdczzBh0bA/ch5Cyk/JSYY8R+n1M/eAqA=
X-Received: by 2002:a05:6102:38d4:: with SMTP id k20mr54374911vst.42.1637057544021;
 Tue, 16 Nov 2021 02:12:24 -0800 (PST)
MIME-Version: 1.0
References: <163660195990.22525.6041281669106537689.stgit@mickey.themaw.net>
 <163660197073.22525.11235124150551283676.stgit@mickey.themaw.net>
 <20211112003249.GL449541@dread.disaster.area> <CAJfpegvHDM_Mtc8+ASAcmNLd6RiRM+KutjBOoycun_Oq2=+p=w@mail.gmail.com>
 <20211114231834.GM449541@dread.disaster.area> <CAJfpegu4BwJD1JKngsrzUs7h82cYDGpxv0R1om=WGhOOb6pZ2Q@mail.gmail.com>
 <20211115222417.GO449541@dread.disaster.area> <f8425d1270fe011897e7e14eaa6ba8a77c1ed077.camel@themaw.net>
 <20211116030120.GQ449541@dread.disaster.area>
In-Reply-To: <20211116030120.GQ449541@dread.disaster.area>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 16 Nov 2021 11:12:13 +0100
Message-ID: <CAJfpegsvL6SjNZdk=J9N-gYWZK0uhg_bT579WRHyVisW1sGZ=Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: make sure link path does not go away at access
To:     Dave Chinner <david@fromorbit.com>
Cc:     Ian Kent <raven@themaw.net>, xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 16 Nov 2021 at 04:01, Dave Chinner <david@fromorbit.com> wrote:

> I *think* that just zeroing the buffer means the race condition
> means the link resolves as either wholly intact, partially zeroed
> with trailing zeros in the length, wholly zeroed or zero length.
> Nothing will crash, the link string is always null terminated even
> if the length is wrong, and so nothing bad should happen as a result
> of zeroing the symlink buffer when it gets evicted from the VFS
> inode cache after unlink.

That's my thinking.  However, modifying the buffer while it is being
processed does seem pretty ugly, and I have to admit that I don't
understand why this needs to be done in either XFS or EXT4.

> The root cause is "allowing an inode to be reused without waiting
> for an RCU grace period to expire". This might seem pedantic, but
> "without waiting for an rcu grace period to expire" is the important
> part of the problem (i.e. the bug), not the "allowing an inode to be
> reused" bit.

Yes.

Thanks,
Miklos
