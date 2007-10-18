Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 09:07:35 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9IG7Sah006782
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 09:07:30 -0700
Date: Thu, 18 Oct 2007 16:46:49 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: use correct buffer flags when reading superblock
Message-ID: <20071018154649.GA16837@infradead.org>
References: <470C8F5B.90705@sgi.com> <20071010093451.GA7655@infradead.org> <20071010112505.GH23367404@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010112505.GH23367404@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 10, 2007 at 09:25:06PM +1000, David Chinner wrote:
> > Where are these set up in the first time?  AFAICS the buffer only written
> > out by xfs_unmountfs_writesb, xfs_syncsub and xfs_trans_log_buf, and all
> > these should only ever happen after log recovery has finished.
> 
> It can also be written by xfsbufd when it has been bdwrite()
> or as a result of log tail pushing.

Hmm, true.

> Because the superblock buffer is XBF_FS_MANAGED, it does not get
> torn down when it is clean and has no references, so the XBF_ASYNC
> flag never gets cleared unless the fs specifically clears it. If the
> superblock is then not recovered out of any further transactions
> during recovery after xfsbufd flushed it, the XBF_ASYNC flag remains
> set for the re-read that is issued in xlog_do_recover() and we
> hang.....

Makes sense as an explanation.  I still don't really like patch, maybe
we should always clear the ASYNC flag in the b_iodone callback?
