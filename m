Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DCE527FE5
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 10:48:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB713304053
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 08:48:49 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id IUqxgceC3AdCFSi4 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 08:48:48 -0800 (PST)
Date: Mon, 2 Feb 2015 08:48:47 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: use generic percpu counters for free block
	counter
Message-ID: <20150202164847.GB695@infradead.org>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422826983-29570-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  	case XFS_SBS_FDBLOCKS:
>  
>  		if (delta > 0) {		/* Putting blocks back */
> +			if (mp->m_resblks == mp->m_resblks_avail) {
> +				percpu_counter_add(&mp->m_sb.sb_fdblocks, delta);
> +				return 0;
> +			}
> +
> +			/* put blocks back into reserve pool first */
> +			spin_lock(&mp->m_sb_lock);
> +			res_used = (long long)
> +					(mp->m_resblks - mp->m_resblks_avail);
> +
>  			if (res_used > delta) {
>  				mp->m_resblks_avail += delta;
>  			} else {
> +				delta -= res_used;
>  				mp->m_resblks_avail = mp->m_resblks;
> +				percpu_counter_add(&mp->m_sb.sb_fdblocks, delta);
>  			}
> +			spin_unlock(&mp->m_sb_lock);
> +			return 0;
>  
> +		}

>  
> +		/*
> +		 * Taking blocks away, need to be more accurate the closer we
> +		 * are to zero.
> +		 *
> +		 * batch size is set to a maximum of 1024 blocks - if we are
> +		 * allocating of freeing extents larger than this then we aren't
> +		 * going to be hammering the counter lock so a lock per update
> +		 * is not a problem.
> +		 *
> +		 * If the counter has a value of less than 2 * max batch size,
> +		 * then make everything serialise as we are real close to
> +		 * ENOSPC.
> +		 */
> +#define __BATCH	1024
> +		if (percpu_counter_compare(&mp->m_sb.sb_fdblocks,
> +					   2 * __BATCH) < 0)
> +			batch = 1;
> +		else
> +			batch = __BATCH;
> +
> +		__percpu_counter_add(&mp->m_sb.sb_fdblocks, delta, batch);
> +		if (percpu_counter_compare(&mp->m_sb.sb_fdblocks,
> +					   XFS_ALLOC_SET_ASIDE(mp)) >= 0) {
> +			/* we had space! */
> +			return 0;
>  		}
>  
> +		/*
> +		 * lock up the sb for dipping into reserves before releasing
> +		 * the space that took us to ENOSPC.
> +		 */
> +		spin_lock(&mp->m_sb_lock);
> +		percpu_counter_add(&mp->m_sb.sb_fdblocks, -delta);
> +		if (!rsvd)
> +			goto fdblocks_enospc;
> +
> +		lcounter = (long long)mp->m_resblks_avail + delta;
> +		if (lcounter >= 0) {
> +			mp->m_resblks_avail = lcounter;
> +			spin_unlock(&mp->m_sb_lock);
> +			return 0;
> +		}
> +		printk_once(KERN_WARNING
> +			"Filesystem \"%s\": reserve blocks depleted! "
> +			"Consider increasing reserve pool size.",
> +			mp->m_fsname);
> +fdblocks_enospc:
> +		spin_unlock(&mp->m_sb_lock);
> +		return -ENOSPC;
> +

This screams for having two different helpers for removing vs adding back
reserved blocks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
