Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 01F757CBA
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 15:41:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DAAAE8F8040
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 13:41:02 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CyhHLtkBnVzTR37R for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 13:41:00 -0800 (PST)
Date: Thu, 11 Feb 2016 08:40:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160210214058.GN14668@dastard>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210190738.GA13051@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Feb 10, 2016 at 11:07:38AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 10, 2016 at 01:50:10AM -0800, Darrick J. Wong wrote:
> > That's odd... I'd have thought that the AG reservation would always be able
> > to handle a refcount btree expansion, since it calculates how many blocks
> > are needed to handle the worst case of 1 record per extent.  There's also
> > a bug where we undercount the number of blocks already used, so it should
> > have an extra big reservation.
> > 
> > OTOH I've seen occasional ENOSPCs in generic/186 and generic/168 too, so I
> > guess something's going wrong.  Maybe the xfs_ag_resv* tracepoints can help?
> 
> I'm not seeing an ENOSPC, I run into:
> 
> [  640.924891] XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 315

I run into that from time to time (maybe once a month) on a vanilla
kernel.

IIRC, the problem is the delayed allocation extent split runs out of
it's reserved block count if you split it enough times. The case
I've seen is that  the indlen calculated in xfs_bmap_worst_indlen()
ends up too small for a subsequent allocation after we've called
xfs_bmap_del_extent() to delete the middle of a delalloc extent too
many times.

Brian had some patches that attempted to solve it - we may have
simply dropped the ball on this (again).

http://oss.sgi.com/archives/xfs/2014-09/msg00337.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
