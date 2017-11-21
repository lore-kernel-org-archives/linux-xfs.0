Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33379 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752330AbdKUEcl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2017 23:32:41 -0500
Date: Mon, 20 Nov 2017 20:32:40 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] iomap: report collisions between directio and
 buffered writes to userspace
Message-ID: <20171121043240.GB8774@bombadil.infradead.org>
References: <20171117193925.GM5119@magnolia>
 <20171120161829.GA25991@bombadil.infradead.org>
 <20171120202606.GN5858@dastard>
 <20171120215100.GB8933@bombadil.infradead.org>
 <20171120222749.GO5858@dastard>
 <20171121013753.GA12441@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171121013753.GA12441@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, holger@applied-asynchrony.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Mon, Nov 20, 2017 at 05:37:53PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 21, 2017 at 09:27:49AM +1100, Dave Chinner wrote:
> > First thing I noticed was that "xa" as a prefix is already quite
> > widely used in XFS - it's shorthand for "XFS AIL". Indeed, xa_lock
> > already exists and is quite widely used, so having a generic
> > interface using the same prefixes and lock names is going to be
> > quite confusing in the XFS code. Especially considering there's
> > fair bit of radix tree use in XFS (e.g. the internal inode and
> > dquot caches).
> > 
> > FYI, from fs/xfs/xfs_trans_priv.h:
> > 
> > /*
> >  * Private AIL structures.
> >  *
> >  * Eventually we need to drive the locking in here as well.
> >  */
> > struct xfs_ail {
> >         struct xfs_mount        *xa_mount;
> >         struct task_struct      *xa_task;
> >         struct list_head        xa_ail;
> >         xfs_lsn_t               xa_target;
> >         xfs_lsn_t               xa_target_prev;
> >         struct list_head        xa_cursors;
> >         spinlock_t              xa_lock;
> >         xfs_lsn_t               xa_last_pushed_lsn;
> >         int                     xa_log_flush;
> >         struct list_head        xa_buf_list;
> >         wait_queue_head_t       xa_empty;
> > };
> > 
> > FWIW, why is it named "XArray"?  "X" stands for what?  It still
> > looks like a tree structure to me, but without a design doc I'm a
> > bit lost to how it differs to the radix tree (apart from the API)
> > and why it's considered an "array".
> 
> /me nominates 'xarr' for the prefix because pirates. :P

The X stands for 'eXpandable' or 'eXtending'.  I really don't want to
use more than a two-letter acronym for whatever the XArray ends up being
called.  One of the problems with the radix tree is that everything has
that 11-character 'radix_tree_' prefix; just replacing that with 'xa_'
makes a huge improvement to readability.

I'm open to renaming it, but I want a good name.  I think it needs to
be *something* array, so we're looking for a prefix used nowhere in the
kernel.  Running 'git grep' in turn for '\<[a-z]a_' really only allows
for ja, ya and za.  'ja_' and 'ya_' only have one user, while 'za_'
has none.  So ... anyone got a good retcon for JArray, YArray or ZArray?

It's considered an array because it behaves "as if" it's an infinite
array.  The fact that we chop it up into chunks of 64 entries, and then
arrange those chunks into a tree is not something the average user needs
to concern themselves with.  We have a lot of places in the kernel that
fuss around with "allocate N entries, whoops, we exceeded N, kmalloc some
more, oh no kmalloc failed, vmalloc it instead".  So the idea is to give
these places an interface that acts like an automatically-resizing array.

One of the ways the radix tree fails to act like an array is returning
EEXIST on an insert operation.  Most users don't want that.  Arrays don't
behave like that; you just overwrite whatever's there.  A few users do
want to know whether something was already there (eg the brd example
I showed), but those users generally want to know what was already
there, not just 'something was'.  So this is why we have xa_store()
and xa_cmpxchg() as our higher-level primitives.
