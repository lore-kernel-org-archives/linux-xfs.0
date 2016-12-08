Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:61931 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932427AbcLHWWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2016 17:22:54 -0500
Date: Fri, 9 Dec 2016 09:22:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] libxcmd: add non-iterating user commands
Message-ID: <20161208222249.GJ4219@dastard>
References: <20161207034724.1613-1-david@fromorbit.com>
 <20161207034724.1613-7-david@fromorbit.com>
 <CAOQ4uxj2AROKtg=ZE64Q-RJbMaiRdP7SvoosmvCD4C1h-X-4bA@mail.gmail.com>
 <CAOQ4uxhrtaHauNJypezpFAT0VCN61oZLFKtxuBLw32jn7FOSFw@mail.gmail.com>
 <20161207201637.GI4219@dastard>
 <CAOQ4uxh+QX5uzJCXtEG8vg0qhUTgQ0QG1ZWDkr1ryH0kQxi0ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh+QX5uzJCXtEG8vg0qhUTgQ0QG1ZWDkr1ryH0kQxi0ZA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Thu, Dec 08, 2016 at 12:14:24PM +0200, Amir Goldstein wrote:
> On Wed, Dec 7, 2016 at 10:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Dec 07, 2016 at 04:21:31PM +0200, Amir Goldstein wrote:
> ...
> >>
> >> 1. Do you think that xfs_io should error on -c "open foo"  to force
> >> explicit -C "open foo"?
> >
> > No.
> >
> >>     it can't be breaking any existing users, because -c "open foo" is
> >> already very broken.
> >
> > Maybe so, but there are users of it. e.g:
> >
> > $ git grep open |grep XFS_IO
> > tests/overlay/001:      $XFS_IO_PROG -c "open" $f >>$seqres.full
> > $
> >
> > This is precisely why I made oneshot commands just work silently
> > with "-c" - who knows what will break if we start rejecting commands
> > that otherwise work just fine when there is only one open file....
> >
> 
> Interesting example. Here -c "open" is actually an 'alias' for
> -c "stat", which could have been non one shot.
> Nevertheless, I see your point.
> 
> >> 2. You marked mmap ONE_SHOT, but not all the m* commands.
> >>    Stands to reason that they should all be marked ONE_SHOT. because iterating
> >>    the file table has nothing to do with the m* commands. no?
> >
> > It is not clear to me what the correct thing to do here is, I don't
> > have the time right now to look into it, so I didn't
> > change mread/mwrite/msync behaviour. If it's broken before it is
> > still broken now.
> >
> 
> Very well, but I am not sure why mmap should be marked one shot?

Look at the help documentation:

$ xfs_io -c "help mmap"
mmap [N] | [-rwx] [-s size] [off len] -- mmap a range in the current file, show mappings

 maps a range within the current file into memory

 Example:
 'mmap -rw 0 1m' - maps one megabyte from the start of the current file
....

It explicitly and repeatedly says "current file" in the
description of it's operation. Any typical user is going to read
that and think that it means "current open file", not "map a range
on all open files".

> Possibly, mmap caught your filters because it is CMD_NOFILE_OK,
> but in fact, the only case where mmap with no open files works is
> after mmaping files and closing all open files.

Well, yes. We've come across applications that do exactly this
in the past, and had to simulate their behaviours. It's entirely
reasonable to want to list or change the active mappings after all
the open files have been closed.

> Currently, this command:
> $ xfs_io -c "mmap 0 4" -C "mmap" foo bar
> 
> Results in:
> [000] 0x7f17319ae000 - 0x7f17319ae004 rwx             bar (0 : 4)
> 
> IMO, it would be more useful if it resulted in:
>  000  0x7f27e289d000 - 0x7f27e289d004 rwx             foo (0 : 4)
> [001] 0x7f27e289c000 - 0x7f27e289c004 rwx             bar (0 : 4)
> 
> Which will allow following up with more specific -C m* commands
> and it would be more consistent with the result of:
> $ xfs_io -C "file" foo bar
>  000  foo            (foreign,non-sync,non-direct,read-write)
> [001] bar            (foreign,non-sync,non-direct,read-write)

Maybe so but, unfortunately, mapping tables are different to the
file tables.

As I have already said: it's not clear what the correct behaviour
here is because mapping commands /don't iterate the mapping table/.
The exception is the mmap command, and that mapping table iteration
behaviour is the reason I changed mmap to be a oneshot command,
otherwise it does stupid things when multiple files are open
and they are iterated.

If you want to have mmap commands do sane things for iteration, then
you need to address the file vs mapping iteration problem, not hack
special one-off behaviours into the mmap commands.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
