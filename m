Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D924B7F51
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 15:16:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBD21304039
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 13:16:54 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	24lbLq8HFyLutt8h for <xfs@oss.sgi.com>;
	Sun, 08 Nov 2015 13:16:51 -0800 (PST)
Date: Mon, 9 Nov 2015 08:16:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] use WQ_MEM_RECLAIM for m_log_workqueue
Message-ID: <20151108211648.GV10656@dastard>
References: <20151104185103.GC5458@ret.masoncoding.com>
	<20151105121059.GJ5458@ret.masoncoding.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151105121059.GJ5458@ret.masoncoding.com>
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
To: Chris Mason <clm@fb.com>
Cc: Tejun Heo <htejun@fb.com>, xfs@oss.sgi.com

On Thu, Nov 05, 2015 at 07:10:59AM -0500, Chris Mason wrote:
> On Wed, Nov 04, 2015 at 01:51:03PM -0500, Chris Mason wrote:
> > I think we should be using WQ_MEM_RECLAIM to make sure this thread pool
> > makes progress when we're not able to allocate new workers.
> 
> Thinking harder, it's probably best to just flag them all
> WQ_MEM_RECLAIM.  This is what btrfs does, and it saves you from painful
> discoveries about how different queues depend on each other.

Makes sense, we missed this one because the original use of the
workqueue was just for a periodic, non-critical function. Then we
move the log IO completion to it in 3.19 in commit b29c70f ("xfs:
split metadata and log buffer completion to separate workqueues").

> I'll start testing and send a v2.

Seems like a no-brainer to me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
