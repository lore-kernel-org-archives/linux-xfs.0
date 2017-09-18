Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:47249 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751391AbdIRVxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 17:53:33 -0400
Date: Tue, 19 Sep 2017 07:53:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [linux-next][XFS][trinity] WARNING: CPU: 32 PID: 31369 at
 fs/iomap.c:993
Message-ID: <20170918215329.GK10621@dastard>
References: <1505746565.6990.18.camel@abdul.in.ibm.com>
 <20170918152706.GA11482@lst.de>
 <8abed401-1634-760f-6543-4652fa495315@kernel.dk>
 <20170918153947.GA12635@lst.de>
 <20170918154328.GA32076@ZenIV.linux.org.uk>
 <955c9c41-1941-5cf4-751c-14a3efa9d0ce@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <955c9c41-1941-5cf4-751c-14a3efa9d0ce@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, chandan <chandan@linux.vnet.ibm.com>

On Mon, Sep 18, 2017 at 09:51:29AM -0600, Jens Axboe wrote:
> On 09/18/2017 09:43 AM, Al Viro wrote:
> > On Mon, Sep 18, 2017 at 05:39:47PM +0200, Christoph Hellwig wrote:
> >> On Mon, Sep 18, 2017 at 09:28:55AM -0600, Jens Axboe wrote:
> >>> If it's expected, why don't we kill the WARN_ON_ONCE()? I get it all
> >>> the time running xfstests as well.
> >>
> >> Dave insisted on it to decourage users/applications from mixing
> >> mmap and direct I/O.
> >>
> >> In many ways a tracepoint might be the better way to diagnose these.
> > 
> > sysctl suppressing those two, perhaps?
> 
> I'd rather just make it a trace point, but don't care too much.
> 
> The code doesn't even have a comment as to why that WARN_ON() is
> there or expected.

The big comment about how bad cache invalidation failures are is on
the second, post-io invocation of the page cache flush. That's the
failure that exposes the data coherency problem to userspace:

        /*
         * Try again to invalidate clean pages which might have been cached by
         * non-direct readahead, or faulted in by get_user_pages() if the source
         * of the write was an mmap'ed region of the file we're writing.  Either
         * one is a pretty crazy thing to do, so we don't support it 100%.  If
         * this invalidation fails, tough, the write still worked...
         */
        if (iov_iter_rw(iter) == WRITE) {
                int err = invalidate_inode_pages2_range(mapping,
                                start >> PAGE_SHIFT, end >> PAGE_SHIFT);
                WARN_ON_ONCE(err);
        }

IOWs, the first warning is a "bad things might be about to
happen" warning, the second is "bad things have happened".

> Seems pretty sloppy to me, not a great way
> to "discourage" users to mix mmap/dio.

Again, it has nothing to do with "discouraging users" and everything
about post-bug report problem triage.

Yes, the first invalidation should also have a comment like the post
IO invalidation - the comment probably got dropped and not noticed
when the changeover from internal XFS code to generic iomap code was
made...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
