Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6J1wF7q245110 for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 20:58:16 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JaHVKmz1CqsxCFJQ for <xfs@oss.sgi.com>;
	Wed, 18 Jul 2012 18:58:13 -0700 (PDT)
Date: Thu, 19 Jul 2012 11:58:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] xfs: wait for the write of the superblock on unmount
Message-ID: <20120719015809.GC23387@dastard>
References: <20120717215957.855744999@tinguelysgi.com>
	<20120718220003.396849822@tinguelysgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120718220003.396849822@tinguelysgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

On Wed, Jul 18, 2012 at 12:33:58PM -0500, tinguely@sgi.com wrote:
> Sorry, I have been distracted away from this regression. This was previously
> titled "xfs: synchronously write the superblock on unmount".
> 
> xfs_wait_buftarg() does not wait for the completion of the write of the
> uncached superblock. This write can race with the shutdown of the log and
> causes a panic if the write does not win the race.
> 
> The log write of the superblock is important for possible recovery, but a
> second syncronous write of the same superblock seems redundant. Would just
> waiting for the iodone() of the log write before tearing down the log be
> enough?

Yes. i.e. something like:

	/*
	 * The superblock buffer is uncached, so xfs_wait_buftarg()
	 * will not wait for it. Hence we need to explicitly wait
	 * for IO completion on the superblock to occur here.
	 */
	error = xfs_buf_iowait(mp->m_sb_bp);
	if (error)
		AAAAIEEEE!

This fix is also needed in xfs_quiesce_attr() for the freeze and
ro,remount cases as well.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
