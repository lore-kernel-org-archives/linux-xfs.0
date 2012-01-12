Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CMcq1r036788 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 16:38:52 -0600
Message-ID: <4F0F60FA.6050605@sgi.com>
Date: Thu, 12 Jan 2012 16:38:50 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/12] repair: allocate and free inode records individually
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174741.284403190@bombadil.infradead.org>
In-Reply-To: <20111202174741.284403190@bombadil.infradead.org>
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
> which never gets released to the system memory allocator use plain malloc
> and free for them.  The freelist just means adding a global lock instead
> of relying on malloc and free which could be implemented lockless, and the
> freelist is almost completely worthless as we are done allocating new
> inode records once we start freeing them in major quantities.
>

Looks good. Has been running without issues.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
