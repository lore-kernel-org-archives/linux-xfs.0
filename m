Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19384 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759362AbdEWDMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2017 23:12:07 -0400
Date: Mon, 22 May 2017 20:11:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: use atomic to provide buffer I/O accounting
 serialization
Message-ID: <20170523031134.GO4519@birch.djwong.org>
References: <1495477751-3742-1-git-send-email-bfoster@redhat.com>
 <20170522190510.GA17100@infradead.org>
 <20170522220424.GA4456@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170522220424.GA4456@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Mon, May 22, 2017 at 06:04:24PM -0400, Brian Foster wrote:
> On Mon, May 22, 2017 at 12:05:10PM -0700, Christoph Hellwig wrote:
> > On Mon, May 22, 2017 at 02:29:11PM -0400, Brian Foster wrote:
> > > We've had user reports of unmount hangs in xfs_wait_buftarg() that
> > > analysis shows is due to btp->bt_io_count == -1. bt_io_count
> > > represents the count of in-flight asynchronous buffers and thus
> > > should always be >= 0. xfs_wait_buftarg() waits for this value to
> > > stabilize to zero in order to ensure that all untracked (with
> > > respect to the lru) buffers have completed I/O processing before
> > > unmount proceeds to tear down in-core data structures.
> > > 
> > > The value of -1 implies an I/O accounting decrement race. Indeed,
> > > the fact that xfs_buf_ioacct_dec() is called from xfs_buf_rele()
> > > (where the buffer lock is no longer held) means that bp->b_flags can
> > > be updated from an unsafe context. While a user-level reproducer is
> > > currently not available, some intrusive hacks to run racing buffer
> > > lookups/ioacct/releases from multiple threads was used to
> > > successfully manufacture this problem.
> > > 
> > > Existing callers do not expect to acquire the buffer lock from
> > > xfs_buf_rele(). Therefore, we can not safely update ->b_flags from
> > > this context. To close the race, replace the in-flight buffer flag
> > > with a per-buffer atomic for tracking accounting against the
> > > buftarg. This field resides in a hole in the existing data structure
> > > and thus does not increase the size of xfs_buf.

There's only a hole on 64-bit systems, btw.

> > I hate these uses of atomic_t as binary flags.  Can you use
> > test_and_set_bit and friends wit a bitop?  This would require
> > an unsigned long which an actually be larger than an atomic_t,
> > but it's both cleaner and provides headroom for additional atomic flags
> > in the future.
> 
> I thought it may be a little confusing to have multiple sets of flags
> for a buffer, hence the counter (even though it is logically a flag).

It /is/ confusing.  If you stick with a flags variable of some sort, I
think at a bare minimum there ought to be a comment explaining what this
unlocked flags field is for, and why we didn't just make b_flags an
atomicly updated flags field.  (TBH I'm wondering why not do that?  Is
it to avoid making a larger change?)

> But I'm fine with it for now if we don't mind wasting the extra space.
> 
> Though I suppose we could also add a smaller field and use cmpxchg() to
> set and clear it... thoughts?

None in particular.  I don't know that we're adding flag bits all that
quickly, and we can always change to unsigned long if we have to.

--D

> 
> Brian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
