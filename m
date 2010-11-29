Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT9Hc3h136577 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 03:17:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D05211B0AE5
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 01:19:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LsAK8etCje9yDmOJ for
	<xfs@oss.sgi.com>; Mon, 29 Nov 2010 01:19:20 -0800 (PST)
Date: Mon, 29 Nov 2010 04:19:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: demultiplex xfs_icsb_modify_counters()
Message-ID: <20101129091920.GB13902@infradead.org>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
	<1290991002-18680-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290991002-18680-4-git-send-email-david@fromorbit.com>
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
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 11:36:41AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the conversion to percpu counters, xfs_icsb_modify_counters() really does
> not need to exist. Convert the inode counter modifications to use a common
> helper function for the one place that calls them, and add another function for
> the free block modification and convert all the callers to use that.

> +xfs_icsb_modify_inodes(
> +	xfs_mount_t	*mp,

struct xfs_mount, please.

> +	int		cntr,
> +	int64_t		delta,
> +	int		rsvd)

the rsvd argument isn't used at all.

> +{
> +	int		ret = 0;
> +
> +	ASSERT(cntr == XFS_ICSB_ICOUNT || cntr == XFS_ICSB_IFREE);
> +
> +	ret = xfs_icsb_add(mp, cntr, delta, 0);
> +	if (ret < 0) {
> +		ASSERT(0);
> +		return XFS_ERROR(EINVAL);
> +	}
> +	return 0;

You could get rdif of the ret argument as we don't care about the
value.  I also don't think we need the assert here - the caller already
does one for us.

> +xfs_icsb_modify_free_blocks(
> +	xfs_mount_t	*mp,

same here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
