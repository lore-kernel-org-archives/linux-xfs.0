Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405BAC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 09:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1356961AD1
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 09:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhKOJ0Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 04:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbhKOJZf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Nov 2021 04:25:35 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413BAC06121E
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 01:21:15 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id r15so6177456uao.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 01:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tZRzmfr33ksKeGczCmevzip8qq4bvVpQ08XPdQssnGM=;
        b=Y84O2jZqcupp8FDVBul7yU6K8vTd5w3H9tzfxrA7LsguHQZteSZok4EkX2CPJY7dZn
         3w8nxo4AjZrg+As2RYcufNPbIGt69kE8Vljtp8OCBe5Ejr0+zQ5J+aQDF3h9zQEnl9mC
         ASWxFDzY2HScF4fbXg1VHe2h/605lZgd2tF1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tZRzmfr33ksKeGczCmevzip8qq4bvVpQ08XPdQssnGM=;
        b=4G4QQjOOdorM06KoV3H6nsQIEBHjw/PqbbIuzb/9jChCpWwaVxF423dIc6Qku+6k+N
         MZqZBhBWy2+5IgRNgObsdepiKLrVOvyKc6ZVywrso4ZrsOZT64bPQZyO0WvFNPbkaOrA
         SU0xndIJEhgW2i2nFiQpc4vum1yp82EbEJkwLFHkVhw+XElu1kVCPhsk4ZV5XLtZkn02
         B+RYtFF0CQArL9n3uD9K/vPZkxzHaaOM08i3CAOASKJ6q9FXUVstQM1ImTrO4IVj6pAp
         hb6Plm4jARWZgWDsuR+VK0qChZVka70tlmQucOAJ68huY7yyYyw/LlLyupW/fK2pqCBh
         SmxQ==
X-Gm-Message-State: AOAM532Eivr79p8hIqnd9iXbBeNVsLve5c4arbBul9CRsjjNMidlco1t
        qGtNJ0tQMTHDV5rSdPVCrWhVXCAa0W9+LwSA0o5lKA==
X-Google-Smtp-Source: ABdhPJz6Az5+mHWva6UQPGv4CesuEhoWD83B1tbTD9++PDTzvwyfRwLJrKTpW6bVxPpoAioKST8WlGxph+8gyAztdMA=
X-Received: by 2002:a67:ec94:: with SMTP id h20mr39959755vsp.59.1636968074344;
 Mon, 15 Nov 2021 01:21:14 -0800 (PST)
MIME-Version: 1.0
References: <163660195990.22525.6041281669106537689.stgit@mickey.themaw.net>
 <163660197073.22525.11235124150551283676.stgit@mickey.themaw.net>
 <20211112003249.GL449541@dread.disaster.area> <CAJfpegvHDM_Mtc8+ASAcmNLd6RiRM+KutjBOoycun_Oq2=+p=w@mail.gmail.com>
 <20211114231834.GM449541@dread.disaster.area>
In-Reply-To: <20211114231834.GM449541@dread.disaster.area>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 15 Nov 2021 10:21:03 +0100
Message-ID: <CAJfpegu4BwJD1JKngsrzUs7h82cYDGpxv0R1om=WGhOOb6pZ2Q@mail.gmail.com>
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

On Mon, 15 Nov 2021 at 00:18, Dave Chinner <david@fromorbit.com> wrote:
> I just can't see how this race condition is XFS specific and why
> fixing it requires XFS to sepcifically handle it while we ignore
> similar theoretical issues in other filesystems...

It is XFS specific, because all other filesystems RCU free the in-core
inode after eviction.

XFS is the only one that reuses the in-core inode object and that is
very much different from anything the other filesystems do and what
the VFS expects.

I don't see how clearing the quick link buffer in ext4_evict_inode()
could do anything bad.  The contents are irrelevant, the lookup will
be restarted anyway, the important thing is that the buffer is not
freed and that it's null terminated, and both hold for the ext4,
AFAICS.

I tend to agree with Brian and Ian at this point: return -ECHILD from
xfs_vn_get_link_inline() until xfs's inode resue vs. rcu walk
implications are fully dealt with.  No way to fix this from VFS alone.

Thanks,
Miklos
