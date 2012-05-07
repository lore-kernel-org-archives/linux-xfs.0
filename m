Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47NxxqQ225119 for <xfs@oss.sgi.com>; Mon, 7 May 2012 19:00:00 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QwmO1eC0WqBylKpg for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 16:59:57 -0700 (PDT)
Date: Tue, 8 May 2012 09:59:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fallocate bug?
Message-ID: <20120507235955.GE5091@dastard>
References: <CAF7KpS-r4zRXZxBU3U8ohxA85-rEvbAzCewYZDr44MNdP+YmFg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAF7KpS-r4zRXZxBU3U8ohxA85-rEvbAzCewYZDr44MNdP+YmFg@mail.gmail.com>
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
To: Zhu Han <schumi.han@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, May 07, 2012 at 08:44:17PM +0800, Zhu Han wrote:
> Seems like xfs of CentOS 6.X occupies much more storage space than desired
> if fallocate is used against the file. Here is the step to reproduce it:

You test case is not doing what you think it is doing.

> By the way, is it normal when the file is moved around after the
> preallocated region is filled with data?
> 
> $ uname -r
> 2.6.32-220.7.1.el6.x86_64
> 
> $fallocate -n --offset 0 -l 1G file    ---->Write a little more data than
> the preallocated size
> 
> $ xfs_bmap -p -vv file
> file:
>  EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET
> TOTAL FLAGS
>    0: [0..2097151]:    2593408088..2595505239 21 (29420144..31517295)
> 2097152 10000
> 
> $ dd if=/dev/zero of=/tmp/file bs=1M count=1026 conv=fsync

That does a truncate first, removing all the preallocated space. Use
conv=notrunc to avoid this. Hence the space allocated by this
new write is different to the space allocated by the above
preallocation. The file has not been moved, the filesystem just did
what you asked it to do.

> 
> $ xfs_bmap -p -vv file
> file:
>  EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET
> TOTAL FLAGS
>    0: [0..4194303]:    2709184016..2713378319 22 (23101408..27295711)
> 4194304 00000

And so now you've triggered the speculative delayed allocation
beyond EOF, which is normal behaviour. Hence there are currently
unused blocks beyond EOF which will get removed either when the next
close(fd) occurs on the file or the inode is removed from the cache.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
