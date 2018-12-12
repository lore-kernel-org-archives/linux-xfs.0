Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47854 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727799AbeLLSOF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 13:14:05 -0500
Date: Wed, 12 Dec 2018 10:13:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [GIT PULL] xfs: fixes for v4.20-rc6
Message-ID: <20181212181357.GZ24487@magnolia>
References: <20181208163639.GR24487@magnolia>
 <CAHk-=who9EqvvGaazise-dh7_DH6rLOULWXzysinyAPnHS4B0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=who9EqvvGaazise-dh7_DH6rLOULWXzysinyAPnHS4B0A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, david@fromorbit.com, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Sat, Dec 08, 2018 at 11:24:48AM -0800, Linus Torvalds wrote:
> On Sat, Dec 8, 2018 at 8:36 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > Finally, the most important fix is to the pipe splicing code (aka the
> > generic copy_file_range fallback) to avoid pointless short directio
> > reads by only asking the filesystem for as much data as there are
> > available pages in the pipe buffer.  Our previous fix (simulated short
> > directio reads because the number of pages didn't match the length of
> > the read requested) caused subtle problems on overlayfs, so that part is
> > reverted.
> 
> Honestly, I really wish you simply wouldn't send me "xfs" fixes that
> aren't really xfs-specific at all.
> 
> All the splice patches (and honestly, I feel some of the iomap ones
> too) that have come in through the xfs tree should have been handled
> separately as actual VFS patches. Or at least had acks from Al or
> something.
> 
> I'm looking at that splice patch, and my initial reaction was "Hmm.
> but that breaks 0 vs -EAGAIN". But then I realized that that's why
> you're validating pipe->nrbufs, because the special temporary
> per-thread pipe is always supposed to be empty on entry, so a zero
> length can't happen.
> 
> But just the fact that I felt like I had to go and look at one of
> these commits makes me go "this is not an XFS fix at all, it shouldn't
> have been treated as an XFS patch, and the original commit that
> *caused* the problem shouldn't have been treated as one either".
> 
> So please. I want to feel like when I get a XFS pull from the XFS
> maintainer, I don't need to worry about it, and I can just do the git
> pull without having to check details.
> 
> But that means that when you do changes outside of XFS code, those
> changes need to be handled _differently_. And they shouldn't be
> bypassing Al etc. And even if you can't get an Ack from Al, send them
> separately, so that I can check them without there being any XFS
> issues that are mixed up with the pull.

Ok, I'll put xfs and vfs changesets in separate pull requests in the
future.  Thanks for the feedback.

--D

> So the patch looks good, and I'm merging this, but I really really
> don't have to feel like I need to look at xfs pulls this way.
> 
>                  Linus
