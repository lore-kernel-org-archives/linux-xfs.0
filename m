Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 480127F3F
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 23:06:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2AE53304039
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 21:06:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	1m2WDIdAuat6U8wF for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2015 21:06:07 -0700 (PDT)
Date: Fri, 17 Apr 2015 14:06:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use percpu_counter_compare instead of naive comparing
Message-ID: <20150417040605.GE15810@dastard>
References: <1429237344-5668-1-git-send-email-xuw2015@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1429237344-5668-1-git-send-email-xuw2015@gmail.com>
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
To: xuw2015@gmail.com
Cc: xfs@oss.sgi.com

On Fri, Apr 17, 2015 at 10:22:24AM +0800, xuw2015@gmail.com wrote:
> From: George Wang <xuw2015@gmail.com>
> 
> Function percpu_counter_read just return the current counter, regardless of
> every cpu's count. This counter can be negative value, which will cause the
> checking of "allocated inode counts <= m_maxicount" false positive.

Have you actually seen this, or is it just theoretical?

> Commit 501ab3238753 "xfs: use generic percpu counters for inode counter
> " introduced this problem.
> Use the percpu_counter_compare, which will first do stuff in current cpu for
> performance; if can not get the result, it will get the exactly counter
> based on the count of every cpu.

That defeats the purpose of using percpu_counter_read() for this
check. We most definitely do not want to lock up the counter twice
for every allocation where we are close to the threshold. We don't
care if we aren't perfectly accurate at the threshold, but we do
care about the overhead of accurately summing the counter as it can
be read hundreds of thousands of times a second.

The correct fix is to use percpu_counter_read_positive(), because in
the majority of cases args.mp->m_maxicount is orders of magnitude
larger (20 million inodes per 100GB of fs space for small filesystems)
than the unaggregated per-cpu counts can cause the sum to go
negative. Hence if it is negative, it may as well be zero because it
makes no difference to the default threshold configurations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
