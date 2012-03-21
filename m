Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2LNU0jX141789 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 18:30:00 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3eF7S1hi15S4y7tH for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2012 16:29:58 -0700 (PDT)
Date: Thu, 22 Mar 2012 10:29:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: allow assigning the tail lsn with the AIL lock
	held
Message-ID: <20120321232956.GA5091@dastard>
References: <20120316175541.258282540@bombadil.infradead.org>
	<20120316175636.373605151@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120316175636.373605151@bombadil.infradead.org>
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

On Fri, Mar 16, 2012 at 01:55:44PM -0400, Christoph Hellwig wrote:
> Provide a variant of xlog_assign_tail_lsn that has the AIL lock already
> held.  By doing so we do an additional atomic_read + atomic_set under
> the lock, which comes down to two instructions.
> 
> Switch xfs_trans_ail_update_bulk and xfs_trans_ail_delete_bulk to the
> new version to reduce the number of lock roundtrips, and prepare for
> a new addition that would require a third lock roundtrip in
> xfs_trans_ail_delete_bulk.

What new addition is that? I don't see it in this patchset (maybe
I'm just blind), so maybe this isn't necessary in the commit
message?


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
