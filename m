Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q61Nt2n4138818 for <xfs@oss.sgi.com>; Sun, 1 Jul 2012 18:55:02 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zmxyQsbTijf9yZIm for <xfs@oss.sgi.com>;
	Sun, 01 Jul 2012 16:55:01 -0700 (PDT)
Date: Mon, 2 Jul 2012 09:54:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120701235458.GM19223@dastard>
References: <20120620113252.GE4011@suse.de> <20120629111932.GA14154@suse.de>
	<20120629112505.GF14154@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120629112505.GF14154@suse.de>
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
To: Mel Gorman <mgorman@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jun 29, 2012 at 12:25:06PM +0100, Mel Gorman wrote:
> Configuration:	global-dhp__io-metadata-xfs
> Benchmarks:	dbench3, fsmark-single, fsmark-threaded
> 
> Summary
> =======
> Most of the figures look good and in general there has been consistent good
> performance from XFS. However, fsmark-single is showing a severe performance
> dip in a few cases somewhere between 3.1 and 3.4. fs-mark running a single
> thread took a particularly bad dive in 3.4 for two machines that is worth
> examining closer.

That will be caused by the fact we changed all the metadata updates
to be logged, which means a transaction every time .dirty_inode is
called.

This should mostly go away when XFS is converted to use .update_time
rather than .dirty_inode to only issue transactions when the VFS
updates the atime rather than every .dirty_inode call...

> Unfortunately it is harder to easy conclusions as the
> gains/losses are not consistent between machines which may be related to
> the available number of CPU threads.

It increases the CPU overhead (dirty_inode can be called up to 4
times per write(2) call, IIRC), so with limited numbers of
threads/limited CPU power it will result in lower performance. Where
you have lots of CPU power, there will be little difference in
performance...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
