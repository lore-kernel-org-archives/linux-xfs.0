Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6979F7F3F
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 19:52:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4971C8F807A
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 17:52:52 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4NsWfmgGCsJbwzSy (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 17:52:51 -0800 (PST)
Date: Tue, 25 Feb 2014 17:52:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/10] repair: prefetch runs too far ahead
Message-ID: <20140226015250.GB3616@infradead.org>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393223369-4696-8-git-send-email-david@fromorbit.com>
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

On Mon, Feb 24, 2014 at 05:29:26PM +1100, Dave Chinner wrote:
> @@ -842,7 +842,7 @@ start_inode_prefetch(
>  	 * and not any other associated metadata like directories
>  	 */
>  
> -	max_queue = libxfs_bcache->c_maxcount / thread_count / 8;
> +	max_queue = libxfs_bcache->c_maxcount / thread_count / 32;

I can't correlate this to anything mentioned in the changelog.
Also if you're touching it anyway it might be a good idea to document
the magic number here.

> +void
> +prefetch_ag_range(
> +	struct work_queue	*work,
> +	xfs_agnumber_t		start_ag,
> +	xfs_agnumber_t		end_ag,
> +	bool			dirs_only,
> +	void			(*func)(struct work_queue *,
> +					xfs_agnumber_t, void *))
> +{
> +	int			i;
> +	struct prefetch_args	*pf_args[2];
> +
> +	pf_args[start_ag & 1] = start_inode_prefetch(start_ag, dirs_only, NULL);
> +	for (i = start_ag; i < end_ag; i++) {
> +		/* Don't prefetch end_ag */
> +		if (i + 1 < end_ag)
> +			pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
> +						dirs_only, pf_args[i & 1]);
> +		func(work, i, pf_args[i & 1]);
> +	}
> +}

This seems to largely duplicate the common code added in patch 5.
Having _range variants of those that the non-range ones wrap with 0 and
mp->m_sb.sb_agcount as default parameters would avoid that duplication.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
