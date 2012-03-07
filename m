Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q27L2o42158211 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 15:02:50 -0600
Date: Wed, 7 Mar 2012 15:02:53 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 6/8] xfs: make xfs_inode_item_size idempotent
Message-ID: <20120307210253.GQ7762@sgi.com>
References: <20120229095347.009884687@bombadil.infradead.org>
	<20120229095509.185485494@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120229095509.185485494@bombadil.infradead.org>
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

On Wed, Feb 29, 2012 at 04:53:53AM -0500, Christoph Hellwig wrote:
> Move all code messing with the inode log item flags into xfs_inode_item_format
> to make sure xfs_inode_item_size really only calculates the the number of
> vectors, but doesn't modify any state of the inode item.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
