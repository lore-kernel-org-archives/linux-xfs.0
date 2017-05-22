Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35113 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbdEVTFL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2017 15:05:11 -0400
Date: Mon, 22 May 2017 12:05:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: use atomic to provide buffer I/O accounting
 serialization
Message-ID: <20170522190510.GA17100@infradead.org>
References: <1495477751-3742-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495477751-3742-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 22, 2017 at 02:29:11PM -0400, Brian Foster wrote:
> We've had user reports of unmount hangs in xfs_wait_buftarg() that
> analysis shows is due to btp->bt_io_count == -1. bt_io_count
> represents the count of in-flight asynchronous buffers and thus
> should always be >= 0. xfs_wait_buftarg() waits for this value to
> stabilize to zero in order to ensure that all untracked (with
> respect to the lru) buffers have completed I/O processing before
> unmount proceeds to tear down in-core data structures.
> 
> The value of -1 implies an I/O accounting decrement race. Indeed,
> the fact that xfs_buf_ioacct_dec() is called from xfs_buf_rele()
> (where the buffer lock is no longer held) means that bp->b_flags can
> be updated from an unsafe context. While a user-level reproducer is
> currently not available, some intrusive hacks to run racing buffer
> lookups/ioacct/releases from multiple threads was used to
> successfully manufacture this problem.
> 
> Existing callers do not expect to acquire the buffer lock from
> xfs_buf_rele(). Therefore, we can not safely update ->b_flags from
> this context. To close the race, replace the in-flight buffer flag
> with a per-buffer atomic for tracking accounting against the
> buftarg. This field resides in a hole in the existing data structure
> and thus does not increase the size of xfs_buf.

I hate these uses of atomic_t as binary flags.  Can you use
test_and_set_bit and friends wit a bitop?  This would require
an unsigned long which an actually be larger than an atomic_t,
but it's both cleaner and provides headroom for additional atomic flags
in the future.
