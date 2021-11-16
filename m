Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D5CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Nov 2021 16:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D51D61504
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Nov 2021 16:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbhKPQHz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 11:07:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238814AbhKPQHx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 11:07:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637078695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IQYqrYWzH5LMm02dblZ0VbWUHvwdTF0Rr46Metf8L3g=;
        b=Uav/75OcjYp1prq8/9vVfTUWRowJnEHXveMJr+pPhWCl2ZGZZCpoA2FoxTZagOEczEUpai
        UkctwNSE+c4FS1+M1aL82M15mI7niOYIQ+EdyWQ3bMHi/asP1c2hiiINRqLq1dz5g8LbI/
        Aq1xKdBTBbWKYMVF5TJDuN+ocpqpl8g=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-ivkpmYx1P3yzWju2cbXl0Q-1; Tue, 16 Nov 2021 11:04:54 -0500
X-MC-Unique: ivkpmYx1P3yzWju2cbXl0Q-1
Received: by mail-qt1-f197.google.com with SMTP id u14-20020a05622a198e00b002b2f35a6dcfso3383449qtc.21
        for <linux-xfs@vger.kernel.org>; Tue, 16 Nov 2021 08:04:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IQYqrYWzH5LMm02dblZ0VbWUHvwdTF0Rr46Metf8L3g=;
        b=pZpYG5GTQBiLJC8oggHC0PlHLyjHAnApZowHouglAN/eswx/2ZbQJ+XJnnUphObZpz
         yTuXu3Ts/9pkZngPX0dFOuEqec7JrpSpgvtjRiq4A4bQn7ItA3LkbwBvcfpcGxm1QSg9
         E4Ft1CuWx/b1HK0a8b9KO2S28DitwodpzKvSyBe5cMtM1Cfy+qO5O0QoZwgPRdfnVVOX
         fPSDp1zG0hoxYxq+ApvAefO1KqVA7FXa3WYAJe9D308cGSpRkF7wRd46fy1oMdFbDV/5
         yLWc2hGm1+i7kfxarD/VPXJhJgtVXFTxsLYj0wXX6XGzfCsMFO5erXRuBq4UzZB9xaZn
         hEew==
X-Gm-Message-State: AOAM530BM5r670sa/Msy7PpEzW6cyG7DfXysUck496/VE+FMB5+QTbdX
        90SOaMCznq1xjWgD9Yxbo1arX32aZKuAK8OpNayepDppTprLC4ZZH7mQdDP1LAtGh0k92P57wdD
        JOmFOwEd3K4+e+Qrseu4u
X-Received: by 2002:ac8:5787:: with SMTP id v7mr8755676qta.79.1637078693510;
        Tue, 16 Nov 2021 08:04:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1VmixXkHPd8zrvy0yn0CKnKhyT/INH+jtxoy7BwJ1qOemuevJEj2WkOO1YOifT68fo90R1Q==
X-Received: by 2002:ac8:5787:: with SMTP id v7mr8755630qta.79.1637078693258;
        Tue, 16 Nov 2021 08:04:53 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id f18sm8939102qko.34.2021.11.16.08.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:04:52 -0800 (PST)
Date:   Tue, 16 Nov 2021 11:04:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Dave Chinner <david@fromorbit.com>, Ian Kent <raven@themaw.net>,
        xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: make sure link path does not go away at access
Message-ID: <YZPWoj6mM/N2reKz@bfoster>
References: <163660195990.22525.6041281669106537689.stgit@mickey.themaw.net>
 <163660197073.22525.11235124150551283676.stgit@mickey.themaw.net>
 <20211112003249.GL449541@dread.disaster.area>
 <CAJfpegvHDM_Mtc8+ASAcmNLd6RiRM+KutjBOoycun_Oq2=+p=w@mail.gmail.com>
 <20211114231834.GM449541@dread.disaster.area>
 <CAJfpegu4BwJD1JKngsrzUs7h82cYDGpxv0R1om=WGhOOb6pZ2Q@mail.gmail.com>
 <20211115222417.GO449541@dread.disaster.area>
 <f8425d1270fe011897e7e14eaa6ba8a77c1ed077.camel@themaw.net>
 <20211116030120.GQ449541@dread.disaster.area>
 <CAJfpegsvL6SjNZdk=J9N-gYWZK0uhg_bT579WRHyVisW1sGZ=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsvL6SjNZdk=J9N-gYWZK0uhg_bT579WRHyVisW1sGZ=Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 16, 2021 at 11:12:13AM +0100, Miklos Szeredi wrote:
> On Tue, 16 Nov 2021 at 04:01, Dave Chinner <david@fromorbit.com> wrote:
> 
> > I *think* that just zeroing the buffer means the race condition
> > means the link resolves as either wholly intact, partially zeroed
> > with trailing zeros in the length, wholly zeroed or zero length.
> > Nothing will crash, the link string is always null terminated even
> > if the length is wrong, and so nothing bad should happen as a result
> > of zeroing the symlink buffer when it gets evicted from the VFS
> > inode cache after unlink.
> 
> That's my thinking.  However, modifying the buffer while it is being
> processed does seem pretty ugly, and I have to admit that I don't
> understand why this needs to be done in either XFS or EXT4.
> 

Agreed. I'm also not following what problem this is intended to solve..?

Hmm.. it looks to me that the ext4 code zeroes the symlink to
accommodate its own truncate/teardown code because it will access the
field via a structure to interpret it as a (empty?) data mapping. IOW,
it doesn't seem to have anything to do with the vfs or path
walks/lookups but rather is an internal implementation detail of ext4.
It would probably be best if somebody who knows ext4 better could
comment on that before we take anything from it. Of course, there is the
fact that ext4 doing this seemingly doesn't disturb/explode the vfs, but
really neither does the current XFS code so it's kind of hard to say
whether one approach is any more or less correct purely based on the
fact that the code exists.

Brian

> > The root cause is "allowing an inode to be reused without waiting
> > for an RCU grace period to expire". This might seem pedantic, but
> > "without waiting for an rcu grace period to expire" is the important
> > part of the problem (i.e. the bug), not the "allowing an inode to be
> > reused" bit.
> 
> Yes.
> 
> Thanks,
> Miklos
> 

