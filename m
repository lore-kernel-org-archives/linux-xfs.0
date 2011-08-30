Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U6UijW117611 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 01:30:44 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACA3113AD4FE
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 23:34:02 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vIyWEZbMDzds3Wtm for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2011 23:34:02 -0700 (PDT)
Date: Tue, 30 Aug 2011 16:30:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid synchronous transactions when deleting attr
	blocks
Message-ID: <20110830063035.GQ3162@dastard>
References: <20110827144511.GB16381@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110827144511.GB16381@infradead.org>
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

On Sat, Aug 27, 2011 at 10:45:11AM -0400, Christoph Hellwig wrote:
> Currently xfs_attr_inactive causes a synchronous transactions if we are
> removing a file that has any extents allocated to the attribute fork, and
> thus makes XFS extremely slow at removing files with out of line extended
> attributes. The code looks a like a relict from the days before the busy
> extent list, but with the busy extent list we avoid reusing data and attr
> extents that have been freed but not commited yet, so this code is just
> as superflous as the synchronous transactions for data blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
