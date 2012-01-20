Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0K5DAQU077595 for <xfs@oss.sgi.com>; Thu, 19 Jan 2012 23:13:11 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Yr3f4RvaSoAmyZ4U for <xfs@oss.sgi.com>;
	Thu, 19 Jan 2012 21:13:07 -0800 (PST)
Date: Fri, 20 Jan 2012 16:13:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: The question about parallel direct IO in xfs
Message-ID: <20120120051304.GB15102@dastard>
References: <20120120035508.GA12703@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120120035508.GA12703@gmail.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 20, 2012 at 11:55:08AM +0800, Zheng Liu wrote:
> Hi all,
> 
> Recently we encounter an issue in ext4. The issue is that, when we do a direct
> IO, ext4 will acquire inode->i_mutex in generic_file_aio_write(). It declines
> the performance. Here is the detailed conversation.
> http://www.spinics.net/lists/linux-ext4/msg30058.html
> 
> I know that in xfs it uses i_iolock, which is a rw_semaphore, to make parallel
> operations in direct IO. But I have a question. As we do some read/write
> operations in direct IO, it seems that there has a window to cause data
> inconsistency.

Yes, there is. That's a feature, not a bug.

> For example, One thread does a write operation to overlay some
> data at a offset. Meanwhile another thread does a read operation at the same
> offset. We assume that write is earlier than read.

Your assumption is wrong.

> Hence, we should read new
> data. Although it is diffculty to occur, it is possible that read is issued to
> the disk firstly and we read old data. I don't know whether it exists or not in
> xfs. Thank you.

Fundamentally, the result of concurrent read and write direct IO
operations to the same offset is undefined because the filesystem
has no control of IO reordering in lower layers of the storage
stack. IOWs, we give no guarantees for IO ordering or coherency of
concurrent direct IO to the same offset.

If your application requires this sort of coherency, then you either
need to use buffered IO or provide these coherency guarantees
yourself because direct IO doesn't provide them. File range locking
is an example of how your application can coordinate it's IO to
avoid this problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
