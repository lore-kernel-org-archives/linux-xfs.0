Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 21:14:21 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBC5DuYQ019860
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 21:14:00 -0800
Date: Wed, 12 Dec 2007 05:13:51 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 964002 - Don't wait for pending I/Os when purging blocks
	beyond eof.
Message-ID: <20071212051351.GA7291@infradead.org>
References: <20071210055955.0F96358C4C34@chook.melbourne.sgi.com> <20071211081117.GB19213@infradead.org> <20071211232517.GE4612@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211232517.GE4612@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Wed, Dec 12, 2007 at 10:25:17AM +1100, David Chinner wrote:
> > which is wrong given that we don't wait for all pending direct I/O
> > requests..  (and vn_iowait doesn't wait for direct I/O anyway)
> 
> vn_iowait() does wait for direct I/O. That was it's entire purpose - to be
> able to prevent truncate vs direct I/O write races by tracking direct I/Os.
> We increment ip->i_iocount in xfs_alloc_ioend() which is called from both the
> buffered write and direct I/O write path, so vn_iowait() does wait for both
> buffered and direct writes to complete.

Sorry, forgot a little important word above - it should read
'and vn_iowait doesn't wait _just_ for direct I/O anyway), because it
waits for completion of regular I/O aswell.  Not that it should actually
matter in that caller.forgot a little important word above - it should
read
'and vn_iowait doesn't wait _just_ for direct I/O anyway), because it
waits for completion of regular I/O aswell.  Not that it should actually
matter in that caller.
