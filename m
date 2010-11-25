Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAP4qpln218829 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 22:52:51 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C3BC1C6C650
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 20:54:28 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	udJufTI6fBA47eV9 for <xfs@oss.sgi.com>;
	Wed, 24 Nov 2010 20:54:28 -0800 (PST)
Date: Thu, 25 Nov 2010 15:54:24 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH] Re: XFS performance oddity
Message-ID: <20101125045424.GA3532@amd>
References: <20101123122449.GA4812@amd> <20101123205804.GX22876@dastard>
	<20101124005003.GB3168@amd> <20101124031524.GC22876@dastard>
	<20101124052823.GD22876@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101124052823.GD22876@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, xfs@oss.sgi.com

On Wed, Nov 24, 2010 at 04:28:23PM +1100, Dave Chinner wrote:
> xfs: push stale, pinned buffers on trylock failures
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> As reported by Nick Piggin, XFS is suffering from long pauses under
> highly concurrent workloads when hosted on ramdisks. The problem is
> that an inode buffer is stuck in the pinned state in memory and as a
> result either the inode buffer or one of the inodes within the
> buffer is stopping the tail of the log from being moved forward.
> 
> The system remains in this state until a periodic log force issued
> by xfssyncd causes the buffer to be unpinned. The main problem is
> that these are stale buffers, and are hence held locked until the
> transaction/checkpoint that marked them state has been committed to
> disk. When the filesystem gets into this state, only the xfssyncd
> can cause the async transactions to be committed to disk and hence
> unpin the inode buffer.
> 
> This problem was encountered when scaling the busy extent list, but
> only the blocking lock interface was fixed to solve the problem.
> Extend the same fix to the buffer trylock operations - if we fail to
> lock a pinned, stale buffer, then force the log immediately so that
> when the next attempt to lock it comes around, it will have been
> unpinned.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

No more stalls, thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
