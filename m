Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50368 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1752077AbdLLPvi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Dec 2017 10:51:38 -0500
Date: Tue, 12 Dec 2017 10:51:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
In-Reply-To: <1513035963.3036.17.camel@perches.com>
Message-ID: <Pine.LNX.4.44L0.1712121041240.1358-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft <apw@shadowen.org>, Dave Chinner <david@fromorbit.com>, Byungchul Park <byungchul.park@lge.com>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@lge.com

On Mon, 11 Dec 2017, Joe Perches wrote:

> >  - I don't understand the error for xa_head here:
> > 
> > struct xarray {
> >         spinlock_t      xa_lock;
> >         gfp_t           xa_flags;
> >         void __rcu *    xa_head;
> > };
> > 
> >    Do people really think that:
> > 
> > struct xarray {
> >         spinlock_t      xa_lock;
> >         gfp_t           xa_flags;
> >         void __rcu	*xa_head;
> > };
> > 
> >    is more aesthetically pleasing?  And not just that, but it's an *error*
> >    so the former is *RIGHT* and this is *WRONG*.  And not just a matter

Not sure what was meant here.  Neither one is *WRONG* in the sense of 
being invalid C code.  In the sense of what checkpatch will accept, the 
former is *WRONG* and the latter is *RIGHT* -- the opposite of what 
was written.

> >    of taste?
> 
> No opinion really.
> That's from Andy Whitcroft's original implementation.

This one, at least, is easy to explain.  The original version tends to
lead to bugs, or easily misunderstood code.  Consider if another
variable was added to the declaration; it could easily turn into:

	void __rcu *	xa_head, xa_head2;

(The compiler will reject this, but it wouldn't if the underlying type
had been int instead of void.)

Doing it the other way makes the meaning a lot more clear:

	void __rcu	*xa_head, *xa_head2;

This is an idiom specifically intended to reduce the likelihood of 
errors.  Rather like avoiding assignments inside conditionals.

Alan Stern

