Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:13471 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750911AbdILGDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2017 02:03:18 -0400
Date: Tue, 12 Sep 2017 16:02:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170912060214.GS17782@dastard>
References: <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910211110.GM17782@dastard>
 <20170910211907.GF5426@ZenIV.linux.org.uk>
 <20170910220814.GN17782@dastard>
 <20170910230723.GG5426@ZenIV.linux.org.uk>
 <20170911003113.GO17782@dastard>
 <20170911033222.GI5426@ZenIV.linux.org.uk>
 <20170911064440.GP17782@dastard>
 <20170911200713.GK5426@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911200713.GK5426@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Mon, Sep 11, 2017 at 09:07:13PM +0100, Al Viro wrote:
> On Mon, Sep 11, 2017 at 04:44:40PM +1000, Dave Chinner wrote:
> 
> > > iov_iter_get_pages() for pipe-backed destination does page allocation
> > > and inserts freshly allocated pages into pipe.
> > 
> > Oh, it's hidden more layers down than the code implied I needed to
> > look.
> > 
> > i.e. there's no obvious clue in the function names that there is
> > allocation happening in these paths (get_pipe_pages ->
> > __get_pipe_pages -> push_pipe -> page allocation). The function
> > names imply it's getting a reference to pages (like
> > (get_user_pages()) and the fact it does allocation is inconsistent
> > with it's naming.  Worse, when push_pipe() fails to allocate pages,
> > the error __get_pipe_pages() returns is -EFAULT, which further hides
> > the fact push_pipe() does memory allocation that can fail....
> > 
> > And then there's the companion interface that implies page
> > allocation: pipe_get_pages_alloc(). Which brings me back to there
> > being no obvious clue while reading the code from the top down that
> > pages are being allocated in push_pipe()....
> > 
> > Comments and documentation for this code would help, but I can't
> > find any of that, either. Hence I assumed naming followed familiar
> > patterns and so mistook these interfaces being one that does page
> > allocation and the other for getting references to pre-existing
> > pages.....
> 
> _NONE_ of those is a public interface - they are all static, to start
> with.

It still requires comments to explain *why* the code is doing what
it's doing. You wrote the code, the whole explaination of it is in
your head. I can't see any of that, so when I read the code I sit
there thinking "why the fuck is it doing this?" because there's no
explanations of the WTF? moments in the code...

> The whole damn point is to have normal ->read_iter() work for read-to-pipe
> without changes.  That's why -EFAULT as error (rather than some other
> mechanism for saying that pipe is full), etc.

... like this one.

That needs a *fucking big comment* because it's not at all obvious
why ENOMEM conditions are being hidden with EFAULT.

Comments and documentation are not for the person who writes the
code - they are for the stupid morons like me that need all the
help they can get to understand complex code that does tricksy,
subtle, non-obvious shit to work correctly.

> Filesystem should *not* be changed to use that.  At all.  As far as it is
> concerned,
> 	copy_to_iter()
> 	copy_page_to_iter()
> 	iov_iter_get_pages()
> 	iov_iter_get_pages_alloc()
> 	iov_iter_advance()
> are black boxes.

The implementation may be a black box, but the operations the black
box is performing for the callers still needs to be explained.

> Note that one of the bugs there applies to normal read() as well - if you
> are reading from a hole in file into an array with a read-only page in
> the middle, you want a short read.

And there's another WTF? moment.....

How do we get a read only page in the middle of an array of pages
we've been told to write data into? And why isn't that a bug in the
code that supplied us with those pages?

> Ignoring return value from iov_iter_zero()
> is wrong for iovec-backed case as well as for pipes.
> 
> Another one manages to work for iovec-backed case, albeit with rather odd
> resulting semantics.  readv(2) is underspecified (to put it politely) enough
> for compliance, but it's still bloody strange.  Namely, if you have a contiguous
> 50Mb chunk of file on disk and run into e.g. a failure to fault the destination
> pages in halfway through that extent, you act as if *nothing* in the damn thing
> had been read, nevermind that 25Mb had been actually already read and that had
> there been a discontinuity 5Mb prior, the first 20Mb would've been reported
> read just fine.
> 
> Strictly speaking that behaviour doesn't violate POSIX.

This is direct IO. POSIX compliant behaviour went out the window
long ago..... :/

> It is, however,
> atrocious from the QoI standpoint, and for no good reason whatsoever.
> It's quite easy to do better, and doing so would've eliminated the problems
> in pipe-backed case as well (see below).  In addition to that, I would
> consider teaching bio_iov_iter_get_pages() to take the maximal bio size
> as an explict argument.  That would've killed the need of copying the
> iterator and calling iov_iter_advance() in iomap_dio_actor() at all.
> Anyway, the minimal candidate fix follows; it won't do anything about
> the WARN_ON() in there, seeing that those are deliberate "program is
> doing something bogus" things, but it should eliminate all crap with
> ->splice_read() misreporting the amount of data it has copied.

I'll run your updated patch through my testing, but seeing as I have
nothing that tests splice+direct IO I'm not going to be able to test
that right now. I have slightly more important things to that need
urgent attention than writing splice+DIO test cases....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
