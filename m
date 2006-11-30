Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 16:32:04 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAU0VraG008284
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 16:31:55 -0800
Date: Thu, 30 Nov 2006 11:30:50 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] remove v_number
Message-ID: <20061130003050.GG33919298@melbourne.sgi.com>
References: <20061129154729.GC6400@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061129154729.GC6400@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Nov 29, 2006 at 04:47:29PM +0100, Christoph Hellwig wrote:
> v_number is unused except for the naming some locks (which is a
> functionality totally unused by Linux), so remove it and assorted
> crap.  Besides saving two words in struct vnode this also gets rid
> of a spinlock per inode allocation.

Hmm - given that I've just used the v_number in post-mortem analysis
of a nasty bug to correlate the sequence of events during a series
of mkdir operations (i.e. transactions in the incore log buffers,
the resulting xfs_inodes and some screwed up dentries) that lead to
a BUG_ON being tripped in d_instantiate.

So, while it appears to be unused, it is _very_ useful for
determining the SOE that has occurred in certain types of problems.

FWIW, while analysing this crash dump a couple of days ago I was
wishing that dentries had an equivalent sequence number because
there is no way to tell what dentry was supposed to be related to
what inode after it got screwed up...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
