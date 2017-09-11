Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51492 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751902AbdIKDc0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Sep 2017 23:32:26 -0400
Date: Mon, 11 Sep 2017 04:32:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170911033222.GI5426@ZenIV.linux.org.uk>
References: <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
 <20170908010441.GZ5426@ZenIV.linux.org.uk>
 <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910211110.GM17782@dastard>
 <20170910211907.GF5426@ZenIV.linux.org.uk>
 <20170910220814.GN17782@dastard>
 <20170910230723.GG5426@ZenIV.linux.org.uk>
 <20170911003113.GO17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911003113.GO17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Mon, Sep 11, 2017 at 10:31:13AM +1000, Dave Chinner wrote:

> splice does not go down the direct IO path, so iomap_dio_actor()
> should never be handled a pipe as the destination for the IO data.
> Indeed, splice read has to supply the pages to be put into the pipe,
> which the DIO path does not do - it requires pages be supplied to
> it. So I'm not sure why we'd care about pipe destination limitations
> in the DIO path?

splice doesn't give a rat's arse for direct IO; it's up to filesystem.
generic_file_splice_read() simply sets up a pipe-backed iov_iter and
calls ->read_iter(), period.

iov_iter_get_pages() for pipe-backed destination does page allocation
and inserts freshly allocated pages into pipe.  copy_to_iter() does
the same + copies data; copy_page_to_iter() grabs an extra reference
to page and inserts it into pipe, not that O_DIRECT ->read_iter()
had been likely to use the last one.

Normally O_DIRECT would work just fine - pages get allocated, references
to them put into pipe cyclic buffer *and* into a number of bio, bio
would get submitted and once the IO is completed we unlock the pipe,
making those pages available for readers.

With minimal care it works just fine - all you really need is
	* cope with failing copy_to_... / iov_iter_get_pages().
Short read if we'd already gotten something, -EFAULT otherwise.
That goes for pipe-backed same as for iovec-backed - any ->read_iter()
that fails to handle that is already in trouble.
	* make sure that iov_iter_get_pages()/iov_iter_get_pages_alloc()
is followed by iov_iter_advance() for the amount you've actually filled,
before any subsequent copy_to_iter()/copy_page_to_iter() or return
from ->read_iter(), whichever comes first.  That includes the situation
when you actually hadn't filled anything at all - just remember to
do iov_iter_advance(to, 0) in that case.  That's about the only
extra requirement imposed by pipes and it's not hard to satisfy.
Combination of iov_iter_advance() with iov_iter_revert() works as
usual.

Normally a filesystem doesn't need to care about splice at all -
just use generic_file_splice_read() and be done with that.
It will use the normal ->read_iter(), with whatever locking, etc.,
your filesystem would do on a normal read.
