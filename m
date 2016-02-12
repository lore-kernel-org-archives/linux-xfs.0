Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B7FFA7CBA
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 13:10:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8F70304051
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:10:49 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id vUbQcxC1CY7PhGXU (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:10:47 -0800 (PST)
Date: Fri, 12 Feb 2016 11:10:46 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160212191046.GA28421@infradead.org>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210214058.GN14668@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com

On Thu, Feb 11, 2016 at 08:40:58AM +1100, Dave Chinner wrote:
> I run into that from time to time (maybe once a month) on a vanilla
> kernel.
> 
> IIRC, the problem is the delayed allocation extent split runs out of
> it's reserved block count if you split it enough times. The case
> I've seen is that  the indlen calculated in xfs_bmap_worst_indlen()
> ends up too small for a subsequent allocation after we've called
> xfs_bmap_del_extent() to delete the middle of a delalloc extent too
> many times.
> 
> Brian had some patches that attempted to solve it - we may have
> simply dropped the ball on this (again).
> 
> http://oss.sgi.com/archives/xfs/2014-09/msg00337.html

I'm pretty sure that is a separate issue.  With the refcount btree we may
allocate an extent (or rather just a single block) in xfs_alloc_ag_vextent
as called from xfs_refcountbt_alloc_block.  The reservation helps us to
ensure this block is always available, but we still need to account for
that in xfs_trans_reserve(), which we currently don't do for itruncate
transactions.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
