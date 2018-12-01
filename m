Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46047 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbeLAUVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Dec 2018 15:21:22 -0500
MIME-Version: 1.0
References: <20181129060110.159878-1-sashal@kernel.org> <20181129060110.159878-25-sashal@kernel.org>
 <20181129121458.GK19305@dastard> <20181129124756.GA25945@kroah.com>
 <20181129224019.GM19305@dastard> <20181130082203.GA26830@kroah.com>
 <20181130101441.GA213156@sasha-vm> <20181130215005.GP19305@dastard> <20181201074909.GC213156@sasha-vm>
In-Reply-To: <20181201074909.GC213156@sasha-vm>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 1 Dec 2018 11:09:05 +0200
Message-ID: <CAOQ4uxhCH3oxVWDMVRcXMZO3JSTCA1Pp5AYnHP5pDxyNktqONw@mail.gmail.com>
Subject: Re: XFS patches for stable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sashal@kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Greg KH <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Luis R. Chamberlain" <mcgrof@kernel.org>

> >> It's getting to the point that with the amount of known issues with XFS
> >> on LTS kernels it makes sense to mark it as CONFIG_BROKEN.
> >
> >Really? Where are the bug reports?
>
> In 'git log'! You report these every time you fix something in upstream
> xfs but don't backport it to stable trees:
>
> $ git log --oneline v4.18-rc1..v4.18 fs/xfs
> d4a34e165557 xfs: properly handle free inodes in extent hint validators
> 9991274fddb9 xfs: Initialize variables in xfs_alloc_get_rec before using them
> d8cb5e423789 xfs: fix fdblocks accounting w/ RMAPBT per-AG reservation
> e53c4b598372 xfs: ensure post-EOF zeroing happens after zeroing part of a file
> a3a374bf1889 xfs: fix off-by-one error in xfs_rtalloc_query_range
> 232d0a24b0fc xfs: fix uninitialized field in rtbitmap fsmap backend
> 5bd88d153998 xfs: recheck reflink state after grabbing ILOCK_SHARED for a write
> f62cb48e4319 xfs: don't allow insert-range to shift extents past the maximum offset
> aafe12cee0b1 xfs: don't trip over negative free space in xfs_reserve_blocks
> 10ee25268e1f xfs: allow empty transactions while frozen
> e53946dbd31a xfs: xfs_iflush_abort() can be called twice on cluster writeback failure
> 23fcb3340d03 xfs: More robust inode extent count validation
> e2ac836307e3 xfs: simplify xfs_bmap_punch_delalloc_range
>
> Since I'm assuming that at least some of them are based on actual issues
> users hit, and some of those apply to stable kernels, why would users
> want to use an XFS version which is knowingly buggy?
>

Sasha,

There is one more point to consider.
Until v4.16, reflink and rmapbt features were experimental:
76883f7988e6 xfs: remove experimental tag for reverse mapping
1e369b0e199b xfs: remove experimental tag for reflinks

And MANY of the bug fixes flowing in through XFS tree to master
are related to those new XFS features and also to vfs functionality
that depends on them (e.g. clone/dedupe), so there MAY be no
bug reports at all for XFS in stable trees.

IMO users should NOT be expecting XFS to be stable with those
features enabled (they are still disabled by default)
when running on stable kernels below v4.16.

Allow me to act as a self-appointed mediator here and say:
There is obviously some bad blood between xfs developers and stable
tree maintainers.
The conflicts are caused by long standing frustration on both sides.
We would all be better off with looking forward on how to improve the
situation instead dwelling on past mistakes.
This issue was on the agenda at the XFS team meeting on last LSF/MM.
The path towards compliance has been laid out by xfs maintainers.
Luis, Sasha and myself have been working to improve the filesystem
test coverage for stable tree candidate patches.
We have still some way to go.

The stable candidate patches that triggered the recent flames
was outside of the fs/xfs subsystem, which AUTOSEL already know
to stay away from, so nobody had any intention to stir things up.

At the end of the day, most xfs developers work for companies that
ship enterprise distros and need to maintain stable trees, so I would
hope that it is in the best interest of everyone involved to cooperate
on the goal of better stable-xfs ecosystem.

On my part, I would be happy if AUTOSEL could point me at
candidate patch *series* for review instead of single patches.
For that matter, it sure wouldn't hurt if an xfs developer sending
out a patch series would cc:stable on the cover letter and if a developer
would be kind enough to add some backporting hints to the cover letter
text that would be very helpful indeed.

Thanks,
Amir.
