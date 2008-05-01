Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 18:19:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m411IdAJ014299
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 18:18:44 -0700
Date: Thu, 1 May 2008 11:19:12 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Remove l_flushsema
Message-ID: <20080501011912.GZ108924158@sgi.com>
References: <20080430090502.GH14976@parisc-linux.org> <20080430104125.GM108924158@sgi.com> <20080430105832.GA20442@infradead.org> <20080430111154.GO108924158@sgi.com> <20080430111521.GA16571@infradead.org> <20080430113418.GP108924158@sgi.com> <20080430113753.GA17871@infradead.org> <20080430151714.GM14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430151714.GM14976@parisc-linux.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Wed, Apr 30, 2008 at 09:17:14AM -0600, Matthew Wilcox wrote:
> On Wed, Apr 30, 2008 at 07:37:53AM -0400, Christoph Hellwig wrote:
> > On Wed, Apr 30, 2008 at 09:34:18PM +1000, David Chinner wrote:
> > > > probably loose some arguments).
> > > 
> > > Yep, much cleaner. Who's signoff goes on this?
> > 
> > You can have mine:
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > but I think it's till essentially willy's and he should be credited for
> > it.
> 
> I'm fine with adding my S-o-B to this version:
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> Here's a little twist on the idea to avoid the thundering herd.
> A vigorous review of this might not be a bad idea -- the idea is to only
> wake up sleeping processes when there seems to be enough space in the
> log to make it worthwhile.  So there's a few places where we unlock the
> l_icloglock and jump back to restart; I didn't add an sv_signal there.
> But there should be an sv_signal before each exit from the function,
> and I think I've done that.

That might work. I'll have to look at it more detail later and do
some performance testing when I'm not so busy with other stuff.

FWIW, in all the error or shutdown cases, it may as well be a broadcast
as every subsequent process through this code will get the same error.
i.e. once a log error occurs, the filesystem gets shut down....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
