Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 281D07F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 15:49:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 15DE68F8033
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 13:48:57 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5Q3BNJnKPSJTs6ga for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 13:30:16 -0800 (PST)
Date: Sat, 14 Dec 2013 08:30:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/3] xfs: xfs_qm_dqrele mostly doesn't need locking
Message-ID: <20131213213006.GU10988@dastard>
References: <1386841258-22183-1-git-send-email-david@fromorbit.com>
	<20131212102507.GX10988@dastard>
	<20131213132807.GB13689@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213132807.GB13689@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 05:28:07AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2013 at 09:25:07PM +1100, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we have an atomic variable for the reference count, we
> > don't need to take the dquot lock if we are not removing the last
> > reference count. The dquot lock is a mutex, so we can't use
> > atomic_dec_and_lock(), but we can open code it in xfs_qm_dqrele and
> > hence avoid the dquot lock for most of the cases where we drop a
> > reference count.
> > 
> > The result is that concurrent file creates jump from 24,000/s to
> > 28,000/s, and the entire workload is now serialised on the dquot
> > being locked during transaction commit. Another significant win,
> > even though it's not the big one...
> 
> Maybe I'm missing something, but shou;dn't the following be enough to
> be a valid dqput (plus asserts & tracing):
> 
> 
> 	if (atomic_dec_and_test(&dqp->q_nrefs)) {
> 		if (list_lru_add(&mp->m_quotainfo->qi_lru, &dqp->q_lru))
> 			XFS_STATS_INC(xs_qm_dquot_unused);
> 	}
> 
> given that the only locking we need is the internal lru lock?

Yes, I think it is.

However, that involves changing all the callers of dqput to not hold
the dqlock when they call, which is a bigger change than was
necessary to avoid the lock contention problem. i.e. it doesn't seem
to be in a fast path that needed immediate fixing, so I didn't touch
it.

> > 
> > While there, rename xfs_qm_dqrele to xfs_dqrele - the "qm" part of
> > the name means nothing and just makes the code harder to read.
> 
> Please keep that out of the patch.  I don't mind dropping the
> qm_ part, but there's a lot of functions that have it, and it should
> be done for all of them at the same time.

OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
