Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 16:30:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k95NUaaG032271
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 16:30:39 -0700
Date: Fri, 6 Oct 2006 09:29:35 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: several messages
Message-ID: <20061005232935.GE19345@melbourne.sgi.com>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal> <451A618B.5080901@agami.com> <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal> <20061002223056.GN4695059@melbourne.sgi.com> <Pine.LNX.4.64.0610030917060.31738@madrid.max-t.internal> <20061005083015.GC19345@melbourne.sgi.com> <Pine.LNX.4.64.0610051139540.31641@madrid.max-t.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0610051139540.31641@madrid.max-t.internal>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: David Chinner <dgc@sgi.com>, Trond Myklebust <trond.myklebust@fys.uio.no>, xfs@oss.sgi.com, nfs@lists.sourceforge.net, Shailendra Tripathi <stripathi@agami.com>

On Thu, Oct 05, 2006 at 12:33:05PM -0400, Stephane Doyon wrote:
> retrying, just plowing on...
> 
> >this would trigger a 500ms sleep on every write.  That's the right
> >sort of ballpark for the slowness you were seeing - 5GB / 32k * 0.5s
> >= ~22 hours....
> >
> >This got fixed in 2.6.18-rc6 -
> 
> You mean commit 4be536debe3f7b0c right? (Actually -rc7 I believe...) I do 
> have that one in my kernel. My kernel is 2.6.17 plus assorted XFS fixes.
> 
> >can you retry with a 2.6.18 server
> >and see if your problem goes away?
> 
> Unfortunately it will be several days before I have a chance to do that.
> 
> The backtrace looked like this:
> 
> ... nfsd_write nfsd_vfs_write vfs_writev do_readv_writev xfs_file_writev 
> xfs_write generic_file_buffered_write xfs_get_blocks __xfs_get_blocks 
> xfs_bmap xfs_iomap xfs_iomap_write_delay xfs_flush_space xfs_flush_device 
> schedule_timeout_uninterruptible.

Ahhh, this gets hit on the ->prepare_write path (xfs_iomap_write_delay()),
not the allocate path (xfs_iomap_write_allocate()). Sorry - I got myself
(and probably everyone else) confused there which why I suspected sync
writes - they trigger the allocate path in the write call. I don't think
2.6.18 will change anything.

FWIW, I don't think we can avoid this sleep when we first hit ENOSPC
conditions, but perhaps once we are certain of the ENOSPC status
we can tag the filesystem with this state (say an xfs_mount flag)
and only clear that tag when something is freed. We could then
use the tag to avoid continually trying extremely hard to allocate
space when we know there is none available....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
