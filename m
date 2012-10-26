Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9Q8r21U216222 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 03:53:02 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vMmJzGy53i467c8y (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Oct 2012 01:54:48 -0700 (PDT)
Date: Fri, 26 Oct 2012 04:54:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/25] xfs: add write verifiers to log recovery
Message-ID: <20121026085448.GD3035@infradead.org>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-26-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-26-git-send-email-david@fromorbit.com>
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

> +	 * during log recovery, we don't have a quotainfo structure to
> +	 * pull the number of dquots per buffer out of, so we have to calculate
> +	 * it directly.
> +	 */
> +	if (mp->m_log->l_flags & XLOG_ACTIVE_RECOVERY) {
> +		dquots_per_buf = BBTOB(bp->b_length);
> +		do_div(dquots_per_buf, sizeof(xfs_dqblk_t));

No need for do_div when dividing a 32-bit value by a constant.

I'd be almost tempted to do the calculation unconditionally to make the
code cleaner, too.

> + * There is no easy way to do this except for trying a bunch of magic
> + * number matches....

How do we make sure buffers used for the symlink or attr payload don't
match this?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
