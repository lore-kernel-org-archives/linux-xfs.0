Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:23240 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932500AbcLGURf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2016 15:17:35 -0500
Date: Thu, 8 Dec 2016 07:16:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] libxcmd: add non-iterating user commands
Message-ID: <20161207201637.GI4219@dastard>
References: <20161207034724.1613-1-david@fromorbit.com>
 <20161207034724.1613-7-david@fromorbit.com>
 <CAOQ4uxj2AROKtg=ZE64Q-RJbMaiRdP7SvoosmvCD4C1h-X-4bA@mail.gmail.com>
 <CAOQ4uxhrtaHauNJypezpFAT0VCN61oZLFKtxuBLw32jn7FOSFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhrtaHauNJypezpFAT0VCN61oZLFKtxuBLw32jn7FOSFw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Wed, Dec 07, 2016 at 04:21:31PM +0200, Amir Goldstein wrote:
> On Wed, Dec 7, 2016 at 6:49 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Wed, Dec 7, 2016 at 5:47 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> From: Dave Chinner <dchinner@redhat.com>
> >>
> >
> > Thank you for fixing this!
> > See some typo fixes below.
> > I will test the fix later today.
> >
> 
> Short of one compilation warning I commented on,
> I tested these changes and found no regression with -g quick run
> I also verified that my test can be converted to use the one shot commands,
> e.g.:
> 
> $XFS_IO_PROG -r foo \
>        -C "open foo" \
>        -C "pwrite -S 0x61 0 16" \
>        -C "file 0" \
>        -C "pread -v 0 16" \
> | _filter_xfs_io
> 
> $XFS_IO_PROG -r bar \
>        -C "mmap -r 0 16" \
>        -C "open bar" \
>        -C "pwrite -S 0x61 0 16" \
>        -C "mread -v 0 16" \
> | _filter_xfs_io
> 
> Notice that I used explicit -C for all commands including the implicit
> one shot commands.
> 
> 1. Do you think that xfs_io should error on -c "open foo"  to force
> explicit -C "open foo"?

No.

>     it can't be breaking any existing users, because -c "open foo" is
> already very broken.

Maybe so, but there are users of it. e.g:

$ git grep open |grep XFS_IO
tests/overlay/001:      $XFS_IO_PROG -c "open" $f >>$seqres.full
$

This is precisely why I made oneshot commands just work silently
with "-c" - who knows what will break if we start rejecting commands
that otherwise work just fine when there is only one open file....

> 2. You marked mmap ONE_SHOT, but not all the m* commands.
>    Stands to reason that they should all be marked ONE_SHOT. because iterating
>    the file table has nothing to do with the m* commands. no?

It is not clear to me what the correct thing to do here is, I don't
have the time right now to look into it, so I didn't
change mread/mwrite/msync behaviour. If it's broken before it is
still broken now.

> About the fix to overlay/016.
> How would you prefer to address the conditional availability of xfs_io -C?
> 
> 1. new helper _require_xfs_io_one_shot_command
> 2. _require_xfs_io_command "open" (which internally checks for xfs_io -C "open")
> 3. third option?

I don't really care - #2 is probably neatest. If what you do is too
ugly to live then I'll let you know.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
