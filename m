Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3D9gVnd019122 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 04:42:31 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	O7y1gCxbIE6CNPUA for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 02:42:29 -0700 (PDT)
Date: Fri, 13 Apr 2012 19:42:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/10] xfs: allow assigning the tail lsn with the AIL
	lock held
Message-ID: <20120413094227.GG6734@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164644.597749707@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327164644.597749707@bombadil.infradead.org>
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

On Tue, Mar 27, 2012 at 12:44:03PM -0400, Christoph Hellwig wrote:
> Provide a variant of xlog_assign_tail_lsn that has the AIL lock already
> held.  By doing so we do an additional atomic_read + atomic_set under
> the lock, which comes down to two instructions.
> 
> Switch xfs_trans_ail_update_bulk and xfs_trans_ail_delete_bulk to the
> new version to reduce the number of lock roundtrips, and prepare for
> a new addition that would require a third lock roundtrip in
> xfs_trans_ail_delete_bulk.  This addition is also the reason for
> slightly rearranging the conditionals and relying on xfs_log_space_wake
> for checking that the filesystem has been shut down internally.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, and will be slightly more efficient, too.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
