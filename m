Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4ADN5Lm067459 for <xfs@oss.sgi.com>; Tue, 10 May 2011 08:23:05 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79B344415D4
	for <xfs@oss.sgi.com>; Tue, 10 May 2011 06:23:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vCmu4Y1PBp4cbYTb for <xfs@oss.sgi.com>;
	Tue, 10 May 2011 06:23:03 -0700 (PDT)
Date: Tue, 10 May 2011 23:23:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: direct IO question
Message-ID: <20110510132300.GF19446@dastard>
References: <4DC8D01F.5060704@wm.jp.nec.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DC8D01F.5060704@wm.jp.nec.com>
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
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Cc: xfs <xfs@oss.sgi.com>

On Tue, May 10, 2011 at 02:41:51PM +0900, Utako Kusaka wrote:
> Hi,
> 
> When I tested concurrent mmap write and direct IO to the same file,
> it was corrupted. Kernel version is 2.6.39-rc4.

Long time problem of the mmap_sem being held while .page_mkwrite is
called, which means we can't use the i_mutex or xfs inode iolock for
serialisation against reads and writes because the mmap_sem can be
taken on page faults during read or write. Hence we've got the
choice of deadlocks or no serialisation between direct Io and
mmap...

> I have two questions concerning xfs direct IO.
> 
> The first is dirty pages are released in direct read. xfs direct IO uses
> xfs_flushinval_pages(), which writes out and releases dirty pages.

Yup - once you bypass the page cache, it is stale and needs to be
removed from memory so it can be reread from disk when the next
buffered IO occurs.

> If pages are marked as dirty after filemap_write_and_wait_range(),
> they will be released in truncate_inode_pages_range() without writing out.

If .page_mkwrite could take either the iolock or the i_mutex, it
would be protected against this like all other operations are.

> 
> sys_read()
>   vfs_read()
>     do_sync_read()
>       xfs_file_aio_read()
>         xfs_flushinval_pages()
>           filemap_write_and_wait_range()
>           truncate_inode_pages_range()      <---
>         generic_file_aio_read()
>           filemap_write_and_wait_range()
>           xfs_vm_direct_IO()
> 
> ext3 calls generic_file_aio_read() only and does not call
> truncate_inode_pages_range().
> 
> sys_read()
>   vfs_read()
>     do_sync_read()
>       generic_file_aio_read()
>         filemap_write_and_wait_range()
>         ext3_direct_IO()

ext3 is vastly different w.r.t. direct IO functionality, and so
can't be directly compared against XFS behaviour.

> xfs_file_aio_read() and xfs_file_dio_aio_write() call generic function. And
> both xfs functions and generic functions call filemap_write_and_wait_range().
> So I wonder whether xfs_flushinval_pages() is necessary.

The data corruption it fixed long ago woul dprobably return in some
form...

> Then, the write range in xfs_flushinval_pages() called from direct IO is
> from start pos to -1, or LLONG_MAX, and is not IO range. Is there any reason?
> In generic_file_aio_read and generic_file_direct_write(), it is from start pos
> to (pos + len - 1).
> I think xfs_flushinval_pages() should be called with same range.

Probably should be, but it will need significant testing to ensure
that it doesn't intorduce a new coherency/corruption corner case...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
