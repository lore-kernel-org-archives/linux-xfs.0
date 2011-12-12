Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCNLij8127418 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 17:21:44 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63714156EE98
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 15:21:42 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	l5tUcGpU7FBty0ZJ for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 15:21:42 -0800 (PST)
Date: Tue, 13 Dec 2011 10:21:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/12] repair: allocate and free extent records
	individually
Message-ID: <20111212232140.GW14273@dastard>
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174741.504430987@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202174741.504430987@bombadil.infradead.org>
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

On Fri, Dec 02, 2011 at 12:46:22PM -0500, Christoph Hellwig wrote:
> Instead of allocating inode records in chunks and keeping a freelist of them
> which gets released to the system memory allocator in one go use plain malloc
> and free for them.  The freelist just means adding a global lock instead
> of relying on malloc and free which could be implemented lockless.  In
> addition smart allocators like tcmalloc have far less overhead than our
> chunk and linked list.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Same context as the last patch - seems much better to rely on malloc
to get this right.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
