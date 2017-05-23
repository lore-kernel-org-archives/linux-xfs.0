Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965749AbdEWLaC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 07:30:02 -0400
Date: Tue, 23 May 2017 07:29:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: use atomic to provide buffer I/O accounting
 serialization
Message-ID: <20170523112952.GA6543@bfoster.bfoster>
References: <1495477751-3742-1-git-send-email-bfoster@redhat.com>
 <20170522190510.GA17100@infradead.org>
 <20170522220424.GA4456@bfoster.bfoster>
 <20170523031134.GO4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170523031134.GO4519@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Mon, May 22, 2017 at 08:11:34PM -0700, Darrick J. Wong wrote:
> On Mon, May 22, 2017 at 06:04:24PM -0400, Brian Foster wrote:
> > On Mon, May 22, 2017 at 12:05:10PM -0700, Christoph Hellwig wrote:
> > > On Mon, May 22, 2017 at 02:29:11PM -0400, Brian Foster wrote:
> > > > We've had user reports of unmount hangs in xfs_wait_buftarg() that
> > > > analysis shows is due to btp->bt_io_count == -1. bt_io_count
> > > > represents the count of in-flight asynchronous buffers and thus
> > > > should always be >= 0. xfs_wait_buftarg() waits for this value to
> > > > stabilize to zero in order to ensure that all untracked (with
> > > > respect to the lru) buffers have completed I/O processing before
> > > > unmount proceeds to tear down in-core data structures.
> > > > 
> > > > The value of -1 implies an I/O accounting decrement race. Indeed,
> > > > the fact that xfs_buf_ioacct_dec() is called from xfs_buf_rele()
> > > > (where the buffer lock is no longer held) means that bp->b_flags can
> > > > be updated from an unsafe context. While a user-level reproducer is
> > > > currently not available, some intrusive hacks to run racing buffer
> > > > lookups/ioacct/releases from multiple threads was used to
> > > > successfully manufacture this problem.
> > > > 
> > > > Existing callers do not expect to acquire the buffer lock from
> > > > xfs_buf_rele(). Therefore, we can not safely update ->b_flags from
> > > > this context. To close the race, replace the in-flight buffer flag
> > > > with a per-buffer atomic for tracking accounting against the
> > > > buftarg. This field resides in a hole in the existing data structure
> > > > and thus does not increase the size of xfs_buf.
> 
> There's only a hole on 64-bit systems, btw.
> 
> > > I hate these uses of atomic_t as binary flags.  Can you use
> > > test_and_set_bit and friends wit a bitop?  This would require
> > > an unsigned long which an actually be larger than an atomic_t,
> > > but it's both cleaner and provides headroom for additional atomic flags
> > > in the future.
> > 
> > I thought it may be a little confusing to have multiple sets of flags
> > for a buffer, hence the counter (even though it is logically a flag).
> 
> It /is/ confusing.  If you stick with a flags variable of some sort, I
> think at a bare minimum there ought to be a comment explaining what this
> unlocked flags field is for, and why we didn't just make b_flags an
> atomicly updated flags field.  (TBH I'm wondering why not do that?  Is
> it to avoid making a larger change?)
> 

Sort of... As it is, b_flags has 20+ flags that are modified all over
the place in all sorts of combinations, checked in assert contexts,
etc.. On a quick pass, all of those cases appear to be protected via
buffer lock. I don't think the I/O accounting optimization flag being an
outlier (in that it tracks buffers past unlock through release to the
lru) and broken justifies converting all of the rest over to something
else.

But yes, clear documentation would be required and probably a different
flag naming scheme to makes things as clear as possible.

> > But I'm fine with it for now if we don't mind wasting the extra space.
> > 
> > Though I suppose we could also add a smaller field and use cmpxchg() to
> > set and clear it... thoughts?
> 
> None in particular.  I don't know that we're adding flag bits all that
> quickly, and we can always change to unsigned long if we have to.
> 

Indeed. I'm not a fan of making changes to support future unknown
changes. Ideally, the whole b_atomic_flags thing can wait until there's
a legitimate use case.

In fact, I think there is a much more simple option here: define 'bool
b_in_flight' and protect it with the existing ->b_lock spinlock. The
lock is already used in half the places the accounting is modified, I
don't think it's harmful to acquire in or outside of the buffer lock,
and this could always be condensed to an "atomic flag" if we ever truly
have the need to do so.

Actually, looking again at xfs_buf it occurs to me that we already have
->b_state, which is protected by the spinlock (presumably to deal with
lru operations outside of buf lock) and only has a single flag defined.
Perhaps I'll just define XFS_BSTATE_IN_FLIGHT and avoid the need for a
new field entirely.

Brian

> --D
> 
> > 
> > Brian
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
