Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 01:52:32 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l548qTWt032585
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 01:52:30 -0700
Date: Mon, 4 Jun 2007 09:52:29 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 965636 - xfs_setfilesize panics on null xfs_inode
Message-ID: <20070604085229.GA17635@infradead.org>
References: <20070604082812.49AF658C38C1@chook.melbourne.sgi.com> <20070604083222.GA16922@infradead.org> <20070604084608.GW85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604084608.GW85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jun 04, 2007 at 06:46:08PM +1000, David Chinner wrote:
> On Mon, Jun 04, 2007 at 09:32:22AM +0100, Christoph Hellwig wrote:
> > On Mon, Jun 04, 2007 at 06:28:12PM +1000, David Chinner wrote:
> > > Handle null returned from xfs_vtoi() in xfs_setfilesize().
> > 
> > This doesn't make any sense at all.  xfs_inodes always live longer than
> > vnodes.  What's the backtrace of the problem you're seeing?
> 
> The I/O completion handlers are used by CXFS clients as well.
> Hence we can't assume that the vnode is backed by a xfs_inode....

Please switch them over to something different instead of crapping up
the code like this
