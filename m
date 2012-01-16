Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0GNPrOO119274 for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 17:25:53 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YWvKUC34xO4vCQL6 for <xfs@oss.sgi.com>;
	Mon, 16 Jan 2012 15:25:51 -0800 (PST)
Date: Tue, 17 Jan 2012 10:25:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: concurrent direct IO write in xfs
Message-ID: <20120116232549.GC6922@dastard>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
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
To: Zheng Da <zhengda1936@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Jan 15, 2012 at 07:01:42PM -0500, Zheng Da wrote:
> Hello,
> 
> I surprisedly found that writing data to a file (no appending) with direct

I'm not so sure.

> And systemtap shows me that xfs_inode.i_lock is locked exclusively in the
> following functions.
> 0xffffffff81289235 : xfs_file_aio_write_checks+0x45/0x1d0 [kernel]

Always taken, short time period.

>  0xffffffff81288b6a : xfs_aio_write_newsize_update+0x3a/0x90 [kernel]

Only ever taken when doing appending writes. Are you -sure- you are
not doing appending writes?

>  0xffffffff812829f4 : __xfs_get_blocks+0x94/0x4a0 [kernel]

And for direct IO writes, this will be the block mapping lookup so
always hit.


What this says to me is that you are probably doing is lots of very
small concurrent write IOs, but I'm only guessing.  Can you provide
your test case and a description of your test hardware so we can try
to reproduce the problem?

>  0xffffffff8129590a : xfs_log_dirty_inode+0x7a/0xe0 [kernel]
> xfs_log_dirty_inode is only invoked 3 times when I write 4G data to the
> file, so we can completely ignore it. But I'm not sure which of them is the
> major cause of the bad write performance or whether they are the cause of
> the bad performance. But it seems none of them are the main operations in
> direct io write.
> 
> It seems to me that the lock might not be necessary for my case. It'll be

The locking is definitely necessary. We might be able to optimise it
to reduce the serialisation for the overwrite case if that really is
the problem, but there is a limit to how much concurrent IO you can
currently do to a single file. We really need a test case to be able
to make and test such optimisations, though.

> nice if I can disable the lock. Or is there any suggestion of achieving
> better write performance with multiple threads in XFS?
> I tried ext4 and it doesn't perform better than XFS. Does the problem exist
> in all FS?

I think you'll find XFS performs the best of the lot for this sort
of concurrent DIO write workload.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
