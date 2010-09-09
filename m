Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8930DWK079366 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 22:00:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E78DB56EB0
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 20:00:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GcsqA6vCy84HfLmP for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 20:00:58 -0700 (PDT)
Date: Wed, 8 Sep 2010 23:00:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: single thread inode cache shrinking.
Message-ID: <20100909030057.GA32472@infradead.org>
References: <1283959243-29176-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1283959243-29176-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 09, 2010 at 01:20:43AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Having multiple CPUs trying to do the same cache shrinking work can
> be actively harmful to perforamnce when the shrinkers land in the
> same AGs.  They then lockstep on perag locks, causing contention and
> slowing each other down. Reclaim walking is sufficiently efficient
> that we do no need parallelism to make significant progress, so stop
> parallel access at the door.
> 
> Instead, keep track of the number of objects the shrinkers want
> cleaned and make sure the single running shrinker does not stop
> until it has hit the threshold that the other shrinker calls have
> built up.
> 
> This increases the cold-cache unlink rate of a 8-way parallel unlink
> workload from about 15,000 unlinks/s to 60-70,000 unlinks/s for the
> same CPU usage (~700%), resulting in the runtime for a 200M inode
> unlink workload dropping from 4h50m to just under 1 hour.

The code looks good, but long term I think this needs to be fixed
in the caller, not in every shrinker instance.


Reviewed-by: Christoph Hellwig <hch@lst.de>

> +		nr_to_scan += atomic64_read(&mp->m_ino_shrink_nr);
> +		atomic64_set(&mp->m_ino_shrink_nr, 0);

To be totally race free this should use atomic64_cmpxchg.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
