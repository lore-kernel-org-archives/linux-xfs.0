Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68AKh6d233422 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 05:20:43 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41C7914FFA7C
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2011 03:20:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vrlDybB3aLFvFLpN for <xfs@oss.sgi.com>;
	Fri, 08 Jul 2011 03:20:41 -0700 (PDT)
Date: Fri, 8 Jul 2011 20:20:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/28] xfs: kill struct xfs_dir2_block
Message-ID: <20110708102039.GM1026@dastard>
References: <20110707110535.205001532@bombadil.infradead.org>
	<20110707110643.885126908@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110707110643.885126908@bombadil.infradead.org>
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

On Thu, Jul 07, 2011 at 07:05:52AM -0400, Christoph Hellwig wrote:
> Remove the confusing xfs_dir2_block structure.  It is supposed to describe
> an XFS dir2 block format btree block, but due to the variable sized nature
> of almost all elements in it it can't actuall do anything close to that
> job.  In addition to accessing the fixed offset header structure it was
> only used to get a pointer to the first dir or unused entry after it,
> which can be trivially replaced by pointer arithmetics on the header
> pointer.  For most users that is actually more natural anyway, as they
> don't use a typed pointer but rather a character pointer for further
> arithmetics.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
