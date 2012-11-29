Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qATM6wwZ088862 for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 16:06:58 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	usCVbBijJChBMN2z for <xfs@oss.sgi.com>;
	Thu, 29 Nov 2012 14:09:15 -0800 (PST)
Date: Fri, 30 Nov 2012 09:09:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 00/19] Numa aware LRU lists and shrinkers
Message-ID: <20121129220914.GE6434@dastard>
References: <1354058086-27937-1-git-send-email-david@fromorbit.com>
	<m24nk8grlr.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <m24nk8grlr.fsf@firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, glommer@parallels.com

On Thu, Nov 29, 2012 at 11:02:24AM -0800, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> >
> > Comments, thoughts and flames all welcome.
> 
> Doing the reclaim per CPU sounds like a big change in the VM balance. 

It's per node, not per CPU. And AFAICT, it hasn't changed the
balance of page cache vs inode/dentry caches under general, global
workloads at all.

> Doesn't this invalidate some zone reclaim mode settings?

No, because zone reclaim is per-node and the shrinkers now can
reclaim just from a single node. i.e. the behaviour is now better
suited to the aims of zone reclaim which is to free memory from a
single, targetted node. Indeed, I removed a hack in the zone reclaim
code that sprayed slab reclaim across the entire machine until
sufficient objects had been freed from the target node....

> How did you validate all this?

fakenuma setups, various workloads that generate even dentry/slab
cache loadings across all nodes, adding page cache pressure on a
single node, watching slab reclaim from a single node. that sort of
thing.

I haven't really done any performance testing other than "not
obviously slower". There's no point optimising anything before
there's any sort of agreement as to whether this is the right
approach to take or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
