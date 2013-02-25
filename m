Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 139CF7F62
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 15:44:12 -0600 (CST)
Message-ID: <512BDB2A.8080103@sgi.com>
Date: Mon, 25 Feb 2013 15:44:10 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/6] xfs: add quota-driven speculative preallocation
	throttling
References: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
	<1361373019-30891-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1361373019-30891-6-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 02/20/13 09:10, Brian Foster wrote:
> Introduce the need_throttle() and calc_throttle() functions to
> independently check whether throttling is required for a particular
> dquot and if so, calculate the associated throttling metrics based
> on the state of the quota. We use the same general algorithm to
> calculate the throttle shift as for global free space with the
> exception of using three stages rather than five.
>
> Update xfs_iomap_prealloc_size() to use the smallest available
> prealloc size based on each of the constraints and apply the
> maximum shift to obtain the throttled preallocation size.
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> ---

>   	/*
>   	 * MAXEXTLEN is not a power of two value but we round the prealloc down
> @@ -412,6 +472,28 @@ xfs_iomap_prealloc_size(
>   		if (freesp<  mp->m_low_space[XFS_LOWSP_1_PCNT])
>   			shift++;
>   	}
> +
> +	/*
> +	 * Check each quota to cap the prealloc size and provide a shift
> +	 * value to throttle with.
> +	 */
> +	if (xfs_quota_need_throttle(ip, XFS_DQ_USER, alloc_blocks))
> +		xfs_quota_calc_throttle(ip, XFS_DQ_USER,&qblocks,&qshift);
> +	if (xfs_quota_need_throttle(ip, XFS_DQ_GROUP, alloc_blocks))
> +		xfs_quota_calc_throttle(ip, XFS_DQ_GROUP,&qblocks,&qshift);
> +	if (xfs_quota_need_throttle(ip, XFS_DQ_PROJ, alloc_blocks))
> +		xfs_quota_calc_throttle(ip, XFS_DQ_PROJ,&qblocks,&qshift);
> +
> +	/*
> +	 * The final prealloc size is set to the minimum of free space available
> +	 * in each of the quotas and the overall filesystem.
> +	 *
> +	 * The shift throttle value is set to the maximum value as determined by
> +	 * the global low free space values and per-quota low free space values.
> +	 */
> +	alloc_blocks = MIN(alloc_blocks, qblocks);
> +	shift = MAX(shift, qshift);
> +
>   	if (shift)
>   		alloc_blocks>>= shift;
>   	/*

All the limits are applied from previous extents, quota and then the 
code from commit 055388a3 is applied:
	if (alloc_blocks < mp->m_writeio_blocks)
		alloc_blocks = mp->m_writeio_blocks;

                        ^^^^
we may not have mp->m_writeio_blocks left in the filesytem.
Doesn't the following make more sense?:

	if (alloc_blocks < mp->m_writeio_blocks)
		alloc_blocks = 0;

Thank-you,

--Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
