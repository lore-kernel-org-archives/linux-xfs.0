Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 14:43:48 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NLhgfB011391
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 14:43:44 -0700
Date: Mon, 23 Apr 2007 22:43:38 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: don't hold ilock when calling vn_iowait
Message-ID: <20070423214338.GA17561@infradead.org>
References: <20070422230303.GX32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070422230303.GX32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 23, 2007 at 09:03:03AM +1000, David Chinner wrote:
> 
> Regression introduced by recent freezing fixes - we should
> not hold the ilock while waiting for I/O completion.

Looks good, and actually simplies the twisted maze the xfs_sync_inodes is
a little bit.  And the missing IPOINTER_INSERT in the SYNC_CLOSE case
looks like an actual bugfix.

Of course in the end I'd still like to see all pagecache-writeout to
be driven by sync_sb_inodes() instead of the fs code, but it'll probably
take a little longer until that is done.
