Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 15:25:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBBNPDQu009047
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 15:25:22 -0800
Date: Wed, 12 Dec 2007 10:25:17 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: TAKE 964002 - Don't wait for pending I/Os when purging blocks beyond eof.
Message-ID: <20071211232517.GE4612@sgi.com>
References: <20071210055955.0F96358C4C34@chook.melbourne.sgi.com> <20071211081117.GB19213@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211081117.GB19213@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Tue, Dec 11, 2007 at 08:11:17AM +0000, Christoph Hellwig wrote:
> On Mon, Dec 10, 2007 at 04:59:55PM +1100, Lachlan McIlroy wrote:
> > Don't wait for pending I/Os when purging blocks beyond eof.
> > 
> > On last close of a file we purge blocks beyond eof.  The same
> > code is used when we truncate the file size down.  In this case
> > we need to wait for any pending I/Os for dirty pages beyond the
> > new eof.  For the last close case we are not changing the file
> > size and therefore do not need to wait for any I/Os to complete.
> > This fixes a performance bottleneck where writes into the page
> > cache and cache flushes can become mutually exclusive.
> 
> I think I shortened from of this should be in the comment above
> the conditional vn_iowait intead of the current
> 
> 	/* wait for the completion of any pending DIOs */
> 
> which is wrong given that we don't wait for all pending direct I/O
> requests..  (and vn_iowait doesn't wait for direct I/O anyway)

vn_iowait() does wait for direct I/O. That was it's entire purpose - to be
able to prevent truncate vs direct I/O write races by tracking direct I/Os.
We increment ip->i_iocount in xfs_alloc_ioend() which is called from both the
buffered write and direct I/O write path, so vn_iowait() does wait for both
buffered and direct writes to complete.

FWIW, the freeze code makes use of this functionality (SYNC_IOWAIT) to ensure
all pending data writes are complete complete before the freeze is completed....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
