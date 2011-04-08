Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p380G67b140670 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 19:16:07 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FD60BA0C36
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2011 17:19:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZPClyLwEItrXgHgC for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2011 17:19:21 -0700 (PDT)
Date: Fri, 8 Apr 2011 10:19:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/9] xfs: introduce background inode reclaim work
Message-ID: <20110408001918.GH30279@dastard>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
	<1302141445-27457-5-git-send-email-david@fromorbit.com>
	<1302210982.2576.600.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302210982.2576.600.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 07, 2011 at 04:16:22PM -0500, Alex Elder wrote:
> On Thu, 2011-04-07 at 11:57 +1000, Dave Chinner wrote:
> > +	if (!(mp->m_super->s_flags & MS_ACTIVE))
> > +		return;
> > +
> > +	rcu_read_lock();
> > +	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
> > +		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
> > +			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
> 
> Probably better to do the multiply before the divide here.
> (But whatever... it's heuristic.)

I always tend to divide before multiply to prevent the multiple from
overflowing before the divide is done. In this case the granularity
of xfs_syncd_centisecs is sufficient that the rounding error of the
divide is meaningless. ie. 30s = 3000.

FWIW, I changed this from:

	xfs_syncd_centisecs / 6 * msecs_to_jiffies(10)

because msecs_to_jiffies() has larger rounding problems. e.g. @
CONFIG_HZ=250, msecs_to_jiffies(10) = 3 which is actually 12ms. That
is, we want to sleep for 5s at a time, and the two different
calculations give:

New:
	msecs_to_jiffies(3000 / 6 * 10) = 5000 / 4 jiffies
					= 1250 jiffies
					= 5s
Old:
	3000 / 6 * msecs_to_jiffies(10) = 500 * 3 jiffies
					= 1500 jiffies
					= 6s

This 20% rounding error is the reason we've recently noticed xfssyncd
running every 36s rather than every 30s....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
