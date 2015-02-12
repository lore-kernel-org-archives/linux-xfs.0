Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 843927F51
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 15:05:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F5188F8054
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:05:00 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GC8XphPj0vnNGCcZ for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 13:04:58 -0800 (PST)
Date: Fri, 13 Feb 2015 08:04:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS buffer IO performance is very poor
Message-ID: <20150212210413.GC12722@dastard>
References: <tencent_DC5F3895075B325335C1DFA7@qq.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <tencent_DC5F3895075B325335C1DFA7@qq.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: yy <yy@xspring.net>
Cc: bfoster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs <xfs@oss.sgi.com>

On Thu, Feb 12, 2015 at 02:59:52PM +0800, yy wrote:
> In functionxfs_file_aio_read, will requestXFS_IOLOCK_SHARED lock
> for both direct IO and buffered IO:

> so write will prevent read in XFS.
> 
> However, in function generic_file_aio_read for ext3, will not
> lockinode-i_mutex, so write will not prevent read in ext3.
> 
> I think this maybe the reason of poor performance for XFS. I do
> not know if this is a bug, or design flaws of XFS.

This is a bug and design flaw in ext3, and most other Linux
filesystems. Posix states that write() must execute atomically and
so no concurrent operation that reads or modifies data should should
see a partial write. The linux page cache doesn't enforce this - a
read to the same range as a write can return partially written data
on page granularity, as read/write only serialise on page locks in
the page cache.

XFS is the only Linux filesystem that actually follows POSIX
requirements here - the shared/exclusive locking guarantees that a
buffer write completes wholly before a read is allowed to access the
data. There is a down side - you can't run concurrent buffered reads
and writes to the same file - if you need to do that then that's
what direct IO is for, and coherency between overlapping reads and
writes is then the application's problem, not the filesystem...

Maybe at some point in the future we might address this with ranged
IO locks, but there really aren't many multithreaded programs that
hit this issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
