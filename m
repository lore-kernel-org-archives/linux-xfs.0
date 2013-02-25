Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A1517F6B
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 16:14:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1838304032
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:14:14 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	12V18UZG9XqggRAp for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 14:14:13 -0800 (PST)
Date: Tue, 26 Feb 2013 09:14:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 5/6] xfs: add quota-driven speculative preallocation
	throttling
Message-ID: <20130225221412.GI5551@dastard>
References: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
	<1361373019-30891-6-git-send-email-bfoster@redhat.com>
	<512BDB2A.8080103@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <512BDB2A.8080103@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Feb 25, 2013 at 03:44:10PM -0600, Mark Tinguely wrote:
> On 02/20/13 09:10, Brian Foster wrote:
> >Introduce the need_throttle() and calc_throttle() functions to
> >independently check whether throttling is required for a particular
> >dquot and if so, calculate the associated throttling metrics based
> >on the state of the quota. We use the same general algorithm to
> >calculate the throttle shift as for global free space with the
> >exception of using three stages rather than five.
> >
> >Update xfs_iomap_prealloc_size() to use the smallest available
> >prealloc size based on each of the constraints and apply the
> >maximum shift to obtain the throttled preallocation size.
> >
> >Signed-off-by: Brian Foster<bfoster@redhat.com>
> >---
> 
> >  	/*
> >  	 * MAXEXTLEN is not a power of two value but we round the prealloc down
> >@@ -412,6 +472,28 @@ xfs_iomap_prealloc_size(
> >  		if (freesp<  mp->m_low_space[XFS_LOWSP_1_PCNT])
> >  			shift++;
> >  	}
> >+
> >+	/*
> >+	 * Check each quota to cap the prealloc size and provide a shift
> >+	 * value to throttle with.
> >+	 */
> >+	if (xfs_quota_need_throttle(ip, XFS_DQ_USER, alloc_blocks))
> >+		xfs_quota_calc_throttle(ip, XFS_DQ_USER,&qblocks,&qshift);
> >+	if (xfs_quota_need_throttle(ip, XFS_DQ_GROUP, alloc_blocks))
> >+		xfs_quota_calc_throttle(ip, XFS_DQ_GROUP,&qblocks,&qshift);
> >+	if (xfs_quota_need_throttle(ip, XFS_DQ_PROJ, alloc_blocks))
> >+		xfs_quota_calc_throttle(ip, XFS_DQ_PROJ,&qblocks,&qshift);
> >+
> >+	/*
> >+	 * The final prealloc size is set to the minimum of free space available
> >+	 * in each of the quotas and the overall filesystem.
> >+	 *
> >+	 * The shift throttle value is set to the maximum value as determined by
> >+	 * the global low free space values and per-quota low free space values.
> >+	 */
> >+	alloc_blocks = MIN(alloc_blocks, qblocks);
> >+	shift = MAX(shift, qshift);
> >+
> >  	if (shift)
> >  		alloc_blocks>>= shift;
> >  	/*
> 
> All the limits are applied from previous extents, quota and then the
> code from commit 055388a3 is applied:
> 	if (alloc_blocks < mp->m_writeio_blocks)
> 		alloc_blocks = mp->m_writeio_blocks;
> 
>                        ^^^^
> we may not have mp->m_writeio_blocks left in the filesytem.
> Doesn't the following make more sense?:
> 
> 	if (alloc_blocks < mp->m_writeio_blocks)
> 		alloc_blocks = 0;

No. This is for prealloc, and we alwys try to prealloc the minimum
configured. If we can't prealloc that amount, then preallocation
fails and we'll try a single block.

Remember, the freesp calculation is done unlocked and hence freesp
is only an estimate. It may change between the reading of it and the
actual allocation attempt, and so the only real determination of
ENOSPC is the failure ot the allocation attempt.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
