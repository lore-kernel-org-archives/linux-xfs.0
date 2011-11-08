Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8NBLHB161944 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 17:11:22 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FCDC1CF6A6A
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 15:11:20 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Khkqihxizpy3ouiL for <xfs@oss.sgi.com>;
	Tue, 08 Nov 2011 15:11:20 -0800 (PST)
Date: Wed, 9 Nov 2011 10:11:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20111108231118.GP5534@dastard>
References: <20111108085614.478431403@bombadil.infradead.org>
	<20111108085846.291838677@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111108085846.291838677@bombadil.infradead.org>
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

On Tue, Nov 08, 2011 at 03:56:16AM -0500, Christoph Hellwig wrote:
> The new concurrency managed workqueues are cheap enough that we can create
> per-filesystem instead of global workqueues.  This allows us to remove the
> trylock or defer scheme on the ilock, which has the potential of delaying
> size updates, and is not helpful once we start to log the inode size.

So why does the per-mount workqueues allow removal of the trylock?

IOWs, it might be worthwhile pointing to the commit (77d7a0c "xfs:
Non-blocking inode locking in IO completion") to indicate that the
functionality being removed was introduced to avoid IO completion
deadlocks between dependent filesystems (e.g. XFS on loop device on
XFS) and that moving to per-mount completion queues removes that
dependency....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
