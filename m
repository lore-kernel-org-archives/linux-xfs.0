Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CIhiX9011481 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 13:43:44 -0500
Subject: Re: [PATCH] xfs: avoid synchronous transactions when deleting attr
	blocks
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110827144511.GB16381@infradead.org>
References: <20110827144511.GB16381@infradead.org>
Date: Mon, 12 Sep 2011 13:43:36 -0500
Message-ID: <1315853016.2898.65.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sat, 2011-08-27 at 10:45 -0400, Christoph Hellwig wrote:
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

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
