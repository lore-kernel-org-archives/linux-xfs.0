Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:45248 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751360AbdIJUdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Sep 2017 16:33:55 -0400
Date: Sun, 10 Sep 2017 21:33:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170910203351.GE5426@ZenIV.linux.org.uk>
References: <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
 <20170908010441.GZ5426@ZenIV.linux.org.uk>
 <20170910010756.hnmb233ch7pmnrlx@codemonkey.org.uk>
 <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910160710.7myz4iel2mnvya3b@codemonkey.org.uk>
 <20170910200547.GD5426@ZenIV.linux.org.uk>
 <20170910200724.let6gkxhkvlg6nkr@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170910200724.let6gkxhkvlg6nkr@codemonkey.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jones <davej@codemonkey.org.uk>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Sun, Sep 10, 2017 at 04:07:24PM -0400, Dave Jones wrote:
> On Sun, Sep 10, 2017 at 09:05:48PM +0100, Al Viro wrote:
>  > On Sun, Sep 10, 2017 at 12:07:10PM -0400, Dave Jones wrote:
>  > > On Sun, Sep 10, 2017 at 03:57:21AM +0100, Al Viro wrote:
>  > >  > On Sat, Sep 09, 2017 at 09:07:56PM -0400, Dave Jones wrote:
>  > >  > 
>  > >  > > With this in place, I'm still seeing -EBUSY from invalidate_inode_pages2_range
>  > >  > > which doesn't end well...
>  > >  > 
>  > >  > Different issue, and I'm not sure why that WARN_ON() is there in the
>  > >  > first place.  Note that in a similar situation generic_file_direct_write()
>  > >  > simply buggers off and lets the caller do buffered write...
>  > >  > 
>  > >  > iov_iter_pipe() warning is a sign of ->read_iter() on pipe-backed iov_iter
>  > >  > putting into the pipe more than it claims to have done.
>  > > 
>  > > (from a rerun after hitting that EBUSY warn; hence the taint)
>  > > 
>  > > WARNING: CPU: 0 PID: 14154 at fs/iomap.c:1055 iomap_dio_rw+0x78e/0x840
>  > 
>  > ... and that's another invalidate_inode_pages2_range() in the same
>  > sucker.  Again, compare with generic_file_direct_write()...
>  > 
>  > I don't believe that this one has anything splice-specific to do with it.
>  > And its only relation to iov_iter_pipe() splat is that it's in the same
>  > fs/iomap.c...
> 
> The interesting part is that I'm hitting these two over and over now
> rather than the iov_iter_pipe warning.  Could just be unlucky
> randomness though..

Well, if you are still running the same reproducer and it used to hit the "read
from hole longer than the amount of space left in pipe" case, fixing the other
bug would have led to a lot more data shoved through the pipe without choking.
So the write side would be exercised more than before...

Hell knows; the question I have right now is what the devil are those WARN_ON_ONCE()
doing there.  Again, the same conditions are possible on other filesystems, only
there we don't yell; invalidation failure before starting O_DIRECT write is
handled by quiet fallback to buffered IO, the one after the write is simply
ignored.

Doing those WARN_ON_ONCE() is an explicit choice in "iomap: implement direct I/O",
so it's a question to Christoph, AFAICS...
