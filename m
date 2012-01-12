Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CMdkL1036918 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 16:39:46 -0600
Message-ID: <4F0F6133.3000103@sgi.com>
Date: Thu, 12 Jan 2012 16:39:47 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/12] repair: allocate and free extent records
	individually
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174741.504430987@bombadil.infradead.org>
In-Reply-To: <20111202174741.504430987@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Christoph Hellwig wrote:
> Instead of allocating inode records in chunks and keeping a freelist of them
> which gets released to the system memory allocator in one go use plain malloc
> and free for them.  The freelist just means adding a global lock instead
> of relying on malloc and free which could be implemented lockless.  In
> addition smart allocators like tcmalloc have far less overhead than our
> chunk and linked list.

Looks good. Has been running without issues.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
