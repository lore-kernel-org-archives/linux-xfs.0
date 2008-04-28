Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 15:22:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3SMMFd5011457
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 15:22:17 -0700
Date: Tue, 29 Apr 2008 08:22:37 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Message-ID: <20080428222237.GE108924158@sgi.com>
References: <200804270246.58828.vda.linux@googlemail.com> <20080427232317.GB103491721@sgi.com> <20080428035023.GA14275@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428035023.GA14275@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Denys Vlasenko <vda.linux@googlemail.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 11:50:23PM -0400, Christoph Hellwig wrote:
> On Mon, Apr 28, 2008 at 09:23:17AM +1000, David Chinner wrote:
> > No. That code is complex enough with only one copy of it around. I don't
> > want two copies that differ subtly and hence have two different sets
> > of nasty, rarely hit corner cases in them.
> 
> Actually the split makes some sense.  I had a ready patch to split out
> releasepage which makes the whole code a lot nicer.  I didn't go forward
> with it because I had this idea that it would get replaced by Chris
> extent_map stuff ASAP..

I think we need to move forward on this, Christoph - I've just found
the cause of a long standing assert failure (test 083 failing on
inode teardown with outstanding delayed allocation extents) and it
appears to me that the way XFS handles page invalidation (i.e.
->invalidate_page/->release_page) is completely broken w.r.t.
standalone calls to vmtruncate() and state being held on
buggerheads. i.e.  we're leaving delalloc turds lying around when
get_blocks returns an error in __block_prepare_write() and the write
is beyond EOF.

The problem is that block_invalidate_page() calls discard_buffer()
on every buffer head on the page, thereby stripping all the state
that xfs_vm_releasepage needs to convert delalloc extents to real
extents to avoid the assert failures that occur in different places.

Even if we had the state, xfs_vm_releasepage does the wrong thing.
We don't want to allocate those extents in this case; we want to
remove those extents because we've just truncated them away.

The unfortunate part here is that the design appears to have
carefully optimised the invalidate page path so we don't need to
call xfs_bunmapi in this case, as all normal truncates run through
xfs_setattr() and the vmtruncate call is followed by a transaction
to free all extents in the range being truncated (see the
xfs_itruncate_data() call). The only other place vmtruncate() is
called from is block_begin_write(), which assumes that de-allocation
is done by the filesystem which is not the case for XFS.

This is a bug that has been around for years. Christoph - I think
we really need to kill buffer heads as soon as possible and clean
up the ugly, ugly mess that makes up the I/O path. I'll talk
off-line with you about this....

In the mean time, I'm going to do a nasty hack that picks on
!uptodate pages with delalloc extents and xfs_free_file_space()
them and see if that works.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
