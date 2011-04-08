Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p38DlYBv179125 for <xfs@oss.sgi.com>; Fri, 8 Apr 2011 08:47:34 -0500
Subject: Re: [PATCH 4/9] xfs: introduce background inode reclaim work
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110408001918.GH30279@dastard>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
	<1302141445-27457-5-git-send-email-david@fromorbit.com>
	<1302210982.2576.600.camel@doink>  <20110408001918.GH30279@dastard>
Date: Fri, 08 Apr 2011 08:49:56 -0500
Message-ID: <1302270596.2468.16.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Fri, 2011-04-08 at 10:19 +1000, Dave Chinner wrote:
> On Thu, Apr 07, 2011 at 04:16:22PM -0500, Alex Elder wrote:
> > On Thu, 2011-04-07 at 11:57 +1000, Dave Chinner wrote:
> > > +	if (!(mp->m_super->s_flags & MS_ACTIVE))
> > > +		return;
> > > +
> > > +	rcu_read_lock();
> > > +	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
> > > +		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
> > > +			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
> > 
> > Probably better to do the multiply before the divide here.
> > (But whatever... it's heuristic.)
> 
> I always tend to divide before multiply to prevent the multiple from
> overflowing before the divide is done. In this case the granularity
> of xfs_syncd_centisecs is sufficient that the rounding error of the
> divide is meaningless. ie. 30s = 3000.

Funny, I normally do the same, but in this case
I was thinking about getting better accuracy.
The numbers involved (msecs / jiffies and the
number of msec) are not likely to be even close
to sqrt(INT32_MAX) (let alone sqrt(UINT64_MAX)).
Putting the calculation inside the parenthesis
is much better though, and I did notice that
change.

					-Alex

> FWIW, I changed this from:
> 
> 	xfs_syncd_centisecs / 6 * msecs_to_jiffies(10)
> 
> because msecs_to_jiffies() has larger rounding problems. e.g. @
> CONFIG_HZ=250, msecs_to_jiffies(10) = 3 which is actually 12ms. That
> is, we want to sleep for 5s at a time, and the two different
> calculations give:
> 
> New:
> 	msecs_to_jiffies(3000 / 6 * 10) = 5000 / 4 jiffies
> 					= 1250 jiffies
> 					= 5s
> Old:
> 	3000 / 6 * msecs_to_jiffies(10) = 500 * 3 jiffies
> 					= 1500 jiffies
> 					= 6s
> 
> This 20% rounding error is the reason we've recently noticed xfssyncd
> running every 36s rather than every 30s....
> 
> Cheers,
> 
> Dave.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
