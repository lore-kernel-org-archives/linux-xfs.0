Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 19:14:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9J2E7lQ010975
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 19:14:11 -0700
Date: Fri, 19 Oct 2007 12:14:03 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: use correct buffer flags when reading superblock
Message-ID: <20071019021403.GQ995458@sgi.com>
References: <470C8F5B.90705@sgi.com> <20071010093451.GA7655@infradead.org> <20071010112505.GH23367404@sgi.com> <20071018154649.GA16837@infradead.org> <47180922.4040709@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47180922.4040709@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 19, 2007 at 11:32:18AM +1000, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
> >On Wed, Oct 10, 2007 at 09:25:06PM +1000, David Chinner wrote:
> >>Because the superblock buffer is XBF_FS_MANAGED, it does not get
> >>torn down when it is clean and has no references, so the XBF_ASYNC
> >>flag never gets cleared unless the fs specifically clears it. If the
> >>superblock is then not recovered out of any further transactions
> >>during recovery after xfsbufd flushed it, the XBF_ASYNC flag remains
> >>set for the re-read that is issued in xlog_do_recover() and we
> >>hang.....
> >
> >Makes sense as an explanation.  I still don't really like patch, maybe
> >we should always clear the ASYNC flag in the b_iodone callback?
> 
> That sounds like a good idea. 

<shrug> 

Makes no real difference - you just have to be careful where the
ASYNC flag is cleared because it is used throughout the io
completion code....

> Or get rid of the XBF_FS_MANAGED special
> case and get a new fresh buffer each time.

I don't think we want to do that. It will add substantial overhead
because the superblock is the single most used buffer in the
filesysem. It's typically gained during transaction commit, at which
time we really, really want to get it quickly and this is known to
be a performance limiting bottleneck.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
