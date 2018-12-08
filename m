Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36318 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbeLHTZI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Dec 2018 14:25:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id g11-v6so6314613ljk.3
        for <linux-xfs@vger.kernel.org>; Sat, 08 Dec 2018 11:25:07 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id x18-v6sm1295144lji.27.2018.12.08.11.25.04
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Dec 2018 11:25:05 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id t9-v6so6305182ljh.6
        for <linux-xfs@vger.kernel.org>; Sat, 08 Dec 2018 11:25:04 -0800 (PST)
MIME-Version: 1.0
References: <20181208163639.GR24487@magnolia>
In-Reply-To: <20181208163639.GR24487@magnolia>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 8 Dec 2018 11:24:48 -0800
Message-ID: <CAHk-=who9EqvvGaazise-dh7_DH6rLOULWXzysinyAPnHS4B0A@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: fixes for v4.20-rc6
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: david@fromorbit.com, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Sat, Dec 8, 2018 at 8:36 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Finally, the most important fix is to the pipe splicing code (aka the
> generic copy_file_range fallback) to avoid pointless short directio
> reads by only asking the filesystem for as much data as there are
> available pages in the pipe buffer.  Our previous fix (simulated short
> directio reads because the number of pages didn't match the length of
> the read requested) caused subtle problems on overlayfs, so that part is
> reverted.

Honestly, I really wish you simply wouldn't send me "xfs" fixes that
aren't really xfs-specific at all.

All the splice patches (and honestly, I feel some of the iomap ones
too) that have come in through the xfs tree should have been handled
separately as actual VFS patches. Or at least had acks from Al or
something.

I'm looking at that splice patch, and my initial reaction was "Hmm.
but that breaks 0 vs -EAGAIN". But then I realized that that's why
you're validating pipe->nrbufs, because the special temporary
per-thread pipe is always supposed to be empty on entry, so a zero
length can't happen.

But just the fact that I felt like I had to go and look at one of
these commits makes me go "this is not an XFS fix at all, it shouldn't
have been treated as an XFS patch, and the original commit that
*caused* the problem shouldn't have been treated as one either".

So please. I want to feel like when I get a XFS pull from the XFS
maintainer, I don't need to worry about it, and I can just do the git
pull without having to check details.

But that means that when you do changes outside of XFS code, those
changes need to be handled _differently_. And they shouldn't be
bypassing Al etc. And even if you can't get an Ack from Al, send them
separately, so that I can check them without there being any XFS
issues that are mixed up with the pull.

So the patch looks good, and I'm merging this, but I really really
don't have to feel like I need to look at xfs pulls this way.

                 Linus
