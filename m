Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:49586 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750806AbdIKGoo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 02:44:44 -0400
Date: Mon, 11 Sep 2017 16:44:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170911064440.GP17782@dastard>
References: <20170906234617.GW17782@dastard>
 <20170908010441.GZ5426@ZenIV.linux.org.uk>
 <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910211110.GM17782@dastard>
 <20170910211907.GF5426@ZenIV.linux.org.uk>
 <20170910220814.GN17782@dastard>
 <20170910230723.GG5426@ZenIV.linux.org.uk>
 <20170911003113.GO17782@dastard>
 <20170911033222.GI5426@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911033222.GI5426@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Mon, Sep 11, 2017 at 04:32:22AM +0100, Al Viro wrote:
> On Mon, Sep 11, 2017 at 10:31:13AM +1000, Dave Chinner wrote:
> 
> > splice does not go down the direct IO path, so iomap_dio_actor()
> > should never be handled a pipe as the destination for the IO data.
> > Indeed, splice read has to supply the pages to be put into the pipe,
> > which the DIO path does not do - it requires pages be supplied to
> > it. So I'm not sure why we'd care about pipe destination limitations
> > in the DIO path?
> 
> splice doesn't give a rat's arse for direct IO; it's up to filesystem.

[....]

It's news to me that splice works on direct IO - I thought it was
still required page cache based IO for file data for this stuff to
work. I must have missed the memo saying that splice interfaces now
work on O_DIRECT fds, there's certainly no documentation or comments
in the code I could have read to find this out myself...

As it is, we have very little test coverage for splice interfaces,
and all that I am aware of assumes that sendfile/splice only works
for buffered IO. So I'm not surprised there are bugs in this code,
it's likely to be completely untested.

I'm guessing the warnings are being thrown because sendfile's
source and/or destination is opened O_DIRECT and something else has
also mmap()d the same files and is doing concurrent sendfile/splice
and page faults. Hell, it could even be sendfile to/from the same
file mixing buffered and direct IO, or perhaps vmsplice of a mapped
range of the same file it's using as the O_DIRECT destination fd.
None of which are sane things to do and fall under the "not
supported" category....

> iov_iter_get_pages() for pipe-backed destination does page allocation
> and inserts freshly allocated pages into pipe.

Oh, it's hidden more layers down than the code implied I needed to
look.

i.e. there's no obvious clue in the function names that there is
allocation happening in these paths (get_pipe_pages ->
__get_pipe_pages -> push_pipe -> page allocation). The function
names imply it's getting a reference to pages (like
(get_user_pages()) and the fact it does allocation is inconsistent
with it's naming.  Worse, when push_pipe() fails to allocate pages,
the error __get_pipe_pages() returns is -EFAULT, which further hides
the fact push_pipe() does memory allocation that can fail....

And then there's the companion interface that implies page
allocation: pipe_get_pages_alloc(). Which brings me back to there
being no obvious clue while reading the code from the top down that
pages are being allocated in push_pipe()....

Comments and documentation for this code would help, but I can't
find any of that, either. Hence I assumed naming followed familiar
patterns and so mistook these interfaces being one that does page
allocation and the other for getting references to pre-existing
pages.....

[snip]

> Normally a filesystem doesn't need to care about splice at all -
> just use generic_file_splice_read() and be done with that.
> It will use the normal ->read_iter(), with whatever locking, etc.,
> your filesystem would do on a normal read.

Yup, that's my point - this is exactly what XFS does, and so I had
no clue that the generic splice code had been changed to accept and
use O_DIRECT semantics because no filesystem code was changed to
enable it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
