Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OH6KIe068543 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 12:06:20 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	SfQ4CrKNlywnfzpH (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 10:06:19 -0700 (PDT)
Date: Sat, 24 Mar 2012 13:06:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: implement freezing by emptying the AIL
Message-ID: <20120324170618.GD21708@infradead.org>
References: <20120316175541.258282540@bombadil.infradead.org>
	<20120316175636.554421689@bombadil.infradead.org>
	<20120321235738.GB5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120321235738.GB5091@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Mar 22, 2012 at 10:57:38AM +1100, Dave Chinner wrote:
> > +	 * threshold.
> > +	 */
> > +	if (atomic_read(&ailp->xa_wait_empty))
> > +		target = xfs_ail_max(ailp)->li_lsn;
> 
> I don't think this is safe - we may have finished pushing the AIL to
> empty, but the waiter that decrements xa_wait_empty may not have run
> yet and we can race with that. In that case, xfs_ail_max() will
> return NULL as the AIL is empty.

True - I'll add a check for that.

> > +{
> > +	DEFINE_WAIT(wait);
> > +
> > +	/*
> > +	 * We use a counter instead of a flag here to support multiple
> > +	 * processes calling into sync at the same time.
> > +	 */
> > +	atomic_inc(&ailp->xa_wait_empty);
> > +	do {
> > +		prepare_to_wait(&ailp->xa_empty, &wait, TASK_KILLABLE);
> 
> Why a killable wait? We need to wait until the push is complete
> before returning because we can't return an error and we don't want
> ctrl-c to break out of this loop while writeback it still taking
> place on a non-shutdown based unmount (e.g. got thousands of inodes
> to write on a slow RAID5 device doing RMW cycles for every inode).

The idea was to ease debugging if we couldn't empty the AIL.  But given
that we'd leak tons of structures that probably is not a good idea.
I'll change it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
