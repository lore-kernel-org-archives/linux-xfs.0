Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3JKSGQw116402 for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 15:28:16 -0500
Date: Thu, 19 Apr 2012 15:30:16 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/5] xfs: reduce ilock hold times in
	xfs_file_aio_write_checks
Message-ID: <20120419203016.GE16881@sgi.com>
References: <20120327143445.196524266@bombadil.infradead.org>
	<20120327143826.433267717@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327143826.433267717@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Mar 27, 2012 at 10:34:47AM -0400, Christoph Hellwig wrote:
> We do not need the ilock for generic_write_checks and the i_size read,
> which are protected by i_mutex and/or iolock, so reduce the ilock
> critical section to just the call to xfs_zero_eof.

So.. I agree that it looks like the only thing we need to protect in
generic_write_checks is the i_size_read.

For buffered io i_size_write is done in generic_write_end, and protected
XFS_IOLOCK_EXCL in xfs_file_buffered_write.  

For direct io i_size_write is done in generic_file_direct_write and also
protected by the iolock in xfs_file_dio_aio_write.  It's not as clear here
whether that lock is taken exclusive at that time.  However, this is handled in
xfs_file_aio_write_checks, where we go io exclusive for xfs_zero_eof.  Maybe it
would be best for this to be done more explicitly with respect to the inode
size in xfs_file_dio_aio_write.

Just wanting to show why generic_write_checks is ok protected with just the
iolock...

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
