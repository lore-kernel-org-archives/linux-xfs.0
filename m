Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HJLEpI103983 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 13:21:14 -0600
Date: Fri, 17 Feb 2012 14:21:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/12] xfs: split tail_lsn assignments from log space
	wakeups
Message-ID: <20120217192112.GA17716@infradead.org>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141433.542846138@bombadil.infradead.org>
	<20120216182121.GQ7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120216182121.GQ7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> >  	if (!list_empty(&tmp))
> >  		xfs_ail_splice(ailp, cur, &tmp, lsn);
> > +	spin_unlock(&ailp->xa_lock);
> 
> Right.  I am uncomfortable with the idea of dropping the ail lock here
> and then retaking it below in xlog_assign_tail_lsn.  Your suggestion
> that a variant of xlog_assign_tail_lsn which expects the lock to be held
> seems reasonable.

There is no risk in dropping it in terms of correctness, the only
downside is doupling the amount of lock roundtrips.  The reason why
I didn't do the version that is called with the lock held is that it
would be fairly intrusive and ugly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
