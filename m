Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 07:41:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8OEfWhS029407
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 07:41:32 -0700
Date: Wed, 24 Sep 2008 10:43:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Wait for all I/O on truncate to zero file size
Message-ID: <20080924144306.GC349@infradead.org>
References: <48D87908.80408@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D87908.80408@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 23, 2008 at 03:05:12PM +1000, Lachlan McIlroy wrote:
> It's possible to have outstanding xfs_ioend_t's queued when the file
> size is zero.  This can happen in the direct I/O path when a direct
> I/O write fails due to ENOSPC.  In this case the xfs_ioend_t will still
> be queued (ie xfs_end_io_direct() does not know that the I/O failed so
> can't force the xfs_ioend_t to be flushed synchronously).
>
> When we truncate a file on unlink we don't know to wait for these
> xfs_ioend_ts and we can have a use-after-free situation if the inode
> is reclaimed before the xfs_ioend_t is finally processed.
>
> As was suggested by Dave Chinner lets wait for all I/Os to complete
> when truncating the file size to zero.

Looks good.
