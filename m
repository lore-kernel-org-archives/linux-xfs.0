Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:59140 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751020AbdLGWWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 17:22:21 -0500
Date: Fri, 8 Dec 2017 09:22:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Message-ID: <20171207222216.GH4094@dastard>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
 <20171206084404.GF4094@dastard>
 <20171206140648.GB32044@bombadil.infradead.org>
 <20171207160634.il3vt5d6a4v5qesi@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171207160634.il3vt5d6a4v5qesi@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <willy@infradead.org>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 07, 2017 at 11:06:34AM -0500, Theodore Ts'o wrote:
> On Wed, Dec 06, 2017 at 06:06:48AM -0800, Matthew Wilcox wrote:
> > > Unfortunately for you, I don't find arguments along the lines of
> > > "lockdep will save us" at all convincing.  lockdep already throws
> > > too many false positives to be useful as a tool that reliably and
> > > accurately points out rare, exciting, complex, intricate locking
> > > problems.
> > 
> > But it does reliably and accurately point out "dude, you forgot to take
> > the lock".  It's caught a number of real problems in my own testing that
> > you never got to see.
> 
> The problem is that if it has too many false positives --- and it's
> gotten *way* worse with the completion callback "feature", people will
> just stop using Lockdep as being too annyoing and a waste of developer
> time when trying to figure what is a legitimate locking bug versus
> lockdep getting confused.
> 
> <Rant>I can't even disable the new Lockdep feature which is throwing
> lots of new false positives --- it's just all or nothing.</Rant>
> 
> Dave has just said he's already stopped using Lockdep, as a result.

This is compeltely OT, but FYI I stopped using lockdep a long time
ago.  We've spend orders of magnitude more time and effort to shut
up lockdep false positives in the XFS code than we ever have on
locking problems that lockdep has uncovered. And still lockdep
throws too many false positives on XFS workloads to be useful to me.

But it's more than that: I understand just how much lockdep *doesn't
check* and that means *I know I can't rely on lockdep* for potential
deadlock detection. e.g.  it doesn't cover semaphores, which means
it has zero coverage of the entire XFS metadata buffer subsystem and
the complex locking orders we have for metadata updates.

Put simply: lockdep doesn't provide me with any benefit, so I don't
use it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
