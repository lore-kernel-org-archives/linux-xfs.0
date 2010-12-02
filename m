Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2BkNHF014979 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 05:46:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B5981405227
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 03:48:07 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id H6v1SpJnSIoNaLOG for
	<xfs@oss.sgi.com>; Thu, 02 Dec 2010 03:48:07 -0800 (PST)
Date: Thu, 2 Dec 2010 06:48:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/14] xfs: introduce new locks for the log grant ticket
	wait queues
Message-ID: <20101202114806.GD21365@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-10-git-send-email-david@fromorbit.com>
	<20101201131208.GA22455@infradead.org>
	<20101202021031.GT16922@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101202021031.GT16922@dastard>
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

On Thu, Dec 02, 2010 at 01:10:31PM +1100, Dave Chinner wrote:
> On Wed, Dec 01, 2010 at 08:12:08AM -0500, Christoph Hellwig wrote:
> > > +		/* co-ordinate with xfs_log_force_shutdown */
> > > +		if (XLOG_FORCED_SHUTDOWN(log)) {
> > > +			spin_unlock(&log->l_grant_reserve_lock);
> > > +			goto error_return;
> > > +		}
> > 
> > Where is this coming from?  Otherwise the patch looks good to me.
> 
> To handles the race condition between xfs_log_force_shutdown() clearing
> all the tickets off the queue and a racing log reserve that had
> already checked the shutdown flag and was spinning waiting for the
> reserve lock to add the ticket to the queue. The race condition is
> documented in xfs_log_force_shutdown()...

Ok.  Please add something like that to the patch description.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
