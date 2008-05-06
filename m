Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 22:18:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m465IZ5V003474
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 22:18:36 -0700
Date: Tue, 6 May 2008 01:19:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix xfs_fsync() b0rkage
Message-ID: <20080506051916.GA7402@infradead.org>
References: <20080506022701.GN155679365@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506022701.GN155679365@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 06, 2008 at 12:27:01PM +1000, David Chinner wrote:
> Fix fsync() b0rkage.
> 
> xfs_fsync() fails to wait for data I/O completion before checking if
> the inode is dirty or clean to decide whether to log the inode or not.
> This misses inode size updates when the data flushed by the fsync()
> is extending the file. This results in xfsqa test 179 failures.
> 
> Hence, like fdatasync(), we need to wait for I/O completion first,
> then check the inode for cleanliness. Doing so makes the behaviour of
> xfs_fsync() identical for fsync and fdatasync and we *always* use
> synchronous semantics if the inode is dirty. Therefore also kill the
> differences and remove the unused flags from the xfs_fsync function
> and callers.

The change looks good from a quick look, but while you're at it you
can also remove the unused start/stop arguments.
