Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 04:34:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3UBXnOP008276
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:33:53 -0700
Date: Wed, 30 Apr 2008 21:34:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Remove l_flushsema
Message-ID: <20080430113418.GP108924158@sgi.com>
References: <20080430090502.GH14976@parisc-linux.org> <20080430104125.GM108924158@sgi.com> <20080430105832.GA20442@infradead.org> <20080430111154.GO108924158@sgi.com> <20080430111521.GA16571@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430111521.GA16571@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Matthew Wilcox <matthew@wil.cx>, xfs@oss.sgi.com

On Wed, Apr 30, 2008 at 07:15:21AM -0400, Christoph Hellwig wrote:
> On Wed, Apr 30, 2008 at 09:11:54PM +1000, David Chinner wrote:
> > > waitqueues are loked internally and don't need synchronization.  With
> > > a little bit of re-arranging the code the wake_up could probably be
> > > moved out of the critical section.
> > 
> > Yeah, I just realised that myself and was about to reply as such....
> > 
> > I'll move the wakeup outside the lock.
> 
> Below is the version I have now.  One of the rare cases where using
> sv_t actually cleans up the code (althoug the whole sv_ family should
> probably loose some arguments).

Yep, much cleaner. Who's signoff goes on this?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
