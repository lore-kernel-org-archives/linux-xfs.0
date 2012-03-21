Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2L4MIV8047031
	for <linux-xfs@oss.sgi.com>; Tue, 20 Mar 2012 23:22:19 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IPEM5LbXj5n6uCm5 for <linux-xfs@oss.sgi.com>;
	Tue, 20 Mar 2012 21:22:16 -0700 (PDT)
Date: Wed, 21 Mar 2012 15:22:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ftruncate() Writes Last Block of File
Message-ID: <20120321042203.GV5091@dastard>
References: <loom.20120319T153420-855@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <loom.20120319T153420-855@post.gmane.org>
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
To: Alan Cook <acook@visionpointsystems.com>
Cc: linux-xfs@oss.sgi.com

On Mon, Mar 19, 2012 at 02:44:33PM +0000, Alan Cook wrote:
> I have three questions regarding the XFS implementation of ftruncate().  In the
> block device driver, I can see that writes are being performed to the last block
> of previously written file when ftruncate() is called.  I believe that I found
> ftruncate() in the XFS sources, but all I see is the filesize being updated in
> the inode.  So if ftruncate() is writing to the last block, it appears to be a
> triggered event.

Sure, you're triggering a flush-on-truncate heuristic because the
on-disk size does not match what is about to be logged from the
in-memory size.

Say for example, I write 1MB to a file, then truncate it back to 8k.
In memory before the truncate, you have this data:

   0    4k    8k    12k 1020k  1M
   +----+-----+-----+.....+-----+
                                ^ inode size = 1048576

And on disk you have this:

  0
  +
  ^ inode size = 0

because no data has been written back yet and the on disk inode size
does not get updated until after the data IO completes.

Hence if you now run a truncate, we have this in memory:

   0    4k    8k
   +----+-----+
              ^ inode size = 8192

And we have this on disk:

  0
  +
  ^ inode size = 0

And we have this in the log:

   0    4k    8k
   +          +
              ^ inode size = 8192

So if we crash at this point, log recovery will set the inode size
to 8192 but there is no data in the file because it never got
written by the kernel. Hence reading the file after recovery would
expose stale data in the file (bad!).

Therefore, before the truncate is done, we write the dirty data that
is between the current on-disk EOF and the new EOF that will be
logged to disk, so we have this state on disk:

   0    4k    8k
   +----+-----+
   ^ inode size = 0

where the blocks on disk are allocated and the data on disk. hence
when the truncate transaction is completed, the state in the log:

   0    4k    8k
   +          +
              ^ inode size = 8192

overlayed with the state on disk gives the correct result if a crash
occurs and log recovery is run.

> To test, I added printk() statements in the block device driver that outputs
> jiffies for write operations.  A file is created and written (~1 MiB), and then
> truncated to 8192 via ftruncate().  The original write to file happens about 20
> jiffies before the call to ftruncate().  When looking at the output, there is an
> additional write to what is the last block of the truncated file, which reports
> the same jiffies as the call to ftruncate().

That's what I'd expect from the above code.

> Does ftruncate() actually write to the last block of the file?  If not, any
> thoughts on what would be?  It only happens when ftruncate() is called.

It depends on the state of the file. if you do
write/fsync/ftruncate, then you won't see ftruncate write any data
because the state on disk is consistent with what is in memory.

> Where in the XFS kernel code is ftruncate() implemented?

xfs_setattr_size().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
