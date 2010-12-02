Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB228pYl245854 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 20:08:52 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 697681B9487
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 18:10:34 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	Aye7sVXZM3MCP7qG for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 18:10:34 -0800 (PST)
Date: Thu, 2 Dec 2010 13:10:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/14] xfs: introduce new locks for the log grant
	ticket wait queues
Message-ID: <20101202021031.GT16922@dastard>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-10-git-send-email-david@fromorbit.com>
	<20101201131208.GA22455@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101201131208.GA22455@infradead.org>
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

On Wed, Dec 01, 2010 at 08:12:08AM -0500, Christoph Hellwig wrote:
> > +		/* co-ordinate with xfs_log_force_shutdown */
> > +		if (XLOG_FORCED_SHUTDOWN(log)) {
> > +			spin_unlock(&log->l_grant_reserve_lock);
> > +			goto error_return;
> > +		}
> 
> Where is this coming from?  Otherwise the patch looks good to me.

To handles the race condition between xfs_log_force_shutdown() clearing
all the tickets off the queue and a racing log reserve that had
already checked the shutdown flag and was spinning waiting for the
reserve lock to add the ticket to the queue. The race condition is
documented in xfs_log_force_shutdown()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
