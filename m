Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8A3SXlw128882 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 22:28:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 863B317C9579
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 20:29:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	E6eTJ3aymwcPsKtj for <xfs@oss.sgi.com>;
	Thu, 09 Sep 2010 20:29:18 -0700 (PDT)
Date: Fri, 10 Sep 2010 13:29:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: single thread inode cache shrinking.
Message-ID: <20100910032915.GE24409@dastard>
References: <1283959243-29176-1-git-send-email-david@fromorbit.com>
	<20100909030057.GA32472@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100909030057.GA32472@infradead.org>
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

On Wed, Sep 08, 2010 at 11:00:57PM -0400, Christoph Hellwig wrote:
> On Thu, Sep 09, 2010 at 01:20:43AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Having multiple CPUs trying to do the same cache shrinking work can
> > be actively harmful to perforamnce when the shrinkers land in the
> > same AGs.  They then lockstep on perag locks, causing contention and
> > slowing each other down. Reclaim walking is sufficiently efficient
> > that we do no need parallelism to make significant progress, so stop
> > parallel access at the door.
> > 
> > Instead, keep track of the number of objects the shrinkers want
> > cleaned and make sure the single running shrinker does not stop
> > until it has hit the threshold that the other shrinker calls have
> > built up.
> > 
> > This increases the cold-cache unlink rate of a 8-way parallel unlink
> > workload from about 15,000 unlinks/s to 60-70,000 unlinks/s for the
> > same CPU usage (~700%), resulting in the runtime for a 200M inode
> > unlink workload dropping from 4h50m to just under 1 hour.
> 
> The code looks good, but long term I think this needs to be fixed
> in the caller, not in every shrinker instance.

Agreed.

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > +		nr_to_scan += atomic64_read(&mp->m_ino_shrink_nr);
> > +		atomic64_set(&mp->m_ino_shrink_nr, 0);
> 
> To be totally race free this should use atomic64_cmpxchg.

Oh, I didn't realise that existed. I'll fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
