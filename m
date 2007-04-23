Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 16:17:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3NNHBfB022721
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 16:17:13 -0700
Date: Tue, 24 Apr 2007 09:17:06 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: don't hold ilock when calling vn_iowait
Message-ID: <20070423231706.GO32602149@melbourne.sgi.com>
References: <20070422230303.GX32602149@melbourne.sgi.com> <20070423214338.GA17561@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423214338.GA17561@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 23, 2007 at 10:43:38PM +0100, Christoph Hellwig wrote:
> On Mon, Apr 23, 2007 at 09:03:03AM +1000, David Chinner wrote:
> > 
> > Regression introduced by recent freezing fixes - we should
> > not hold the ilock while waiting for I/O completion.
> 
> Looks good, and actually simplies the twisted maze the xfs_sync_inodes is
> a little bit.  And the missing IPOINTER_INSERT in the SYNC_CLOSE case
> looks like an actual bugfix.

I had to look closely at that IPOINTER_INSERT case with SYNC_CLOSE;
it was actaully working properly because you'd always end up in
the SYNC_CLOSE case having inserted a pointer earlier on in the flow
of the function. It certainly wasn't obvious that it was doing the
right thing, though.

> Of course in the end I'd still like to see all pagecache-writeout to
> be driven by sync_sb_inodes() instead of the fs code, but it'll probably
> take a little longer until that is done.

Agreed on both counts.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
