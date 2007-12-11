Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 00:11:17 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBB8B906007037
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 00:11:12 -0800
Date: Tue, 11 Dec 2007 08:11:17 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 964002 - Don't wait for pending I/Os when purging blocks
	beyond eof.
Message-ID: <20071211081117.GB19213@infradead.org>
References: <20071210055955.0F96358C4C34@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210055955.0F96358C4C34@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Mon, Dec 10, 2007 at 04:59:55PM +1100, Lachlan McIlroy wrote:
> Don't wait for pending I/Os when purging blocks beyond eof.
> 
> On last close of a file we purge blocks beyond eof.  The same
> code is used when we truncate the file size down.  In this case
> we need to wait for any pending I/Os for dirty pages beyond the
> new eof.  For the last close case we are not changing the file
> size and therefore do not need to wait for any I/Os to complete.
> This fixes a performance bottleneck where writes into the page
> cache and cache flushes can become mutually exclusive.

I think I shortened from of this should be in the comment above
the conditional vn_iowait intead of the current

	/* wait for the completion of any pending DIOs */

which is wrong given that we don't wait for all pending direct I/O
requests..  (and vn_iowait doesn't wait for direct I/O anyway)
