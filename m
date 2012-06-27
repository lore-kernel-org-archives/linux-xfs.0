Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5RA9Zc1197088 for <xfs@oss.sgi.com>; Wed, 27 Jun 2012 05:09:35 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ie3gFyhQae2OZ8dd for <xfs@oss.sgi.com>;
	Wed, 27 Jun 2012 03:09:33 -0700 (PDT)
Date: Wed, 27 Jun 2012 20:08:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: synchronously write the superblock on unmount
Message-ID: <20120627100838.GH19223@dastard>
References: <20120626160051.364635296@sgi.com>
	<20120626160102.898671754@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120626160102.898671754@sgi.com>
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

On Tue, Jun 26, 2012 at 11:00:52AM -0500, tinguely@sgi.com wrote:
> xfs_wait_buftarg() does not wait for the completion of the write of the uncached
> superblock. This write can race with the shutdown of the log and cause a panic if the
> write does not win the race. Per Dave's suggestion, turn the final write of the
> superblock into a syncronous write.

Not quite what I suggested. You removed the transaction that logs
the changes first. That needs to stay, otherwise we are writing
unlogged changes to the superblock, and have the possibility of a
crash before the unmount record is written causing log recovery to
modify the superblock and not have all the correct changes in the
log.

So it first needs to log the changes (synchronously), then write the
changes (synchronously).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
