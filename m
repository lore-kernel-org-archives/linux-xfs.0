Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p36IBAgI047720 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 13:11:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20C9315B6E43
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 11:14:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vy06lGqxDP6F2jmE for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2011 11:14:26 -0700 (PDT)
Date: Wed, 6 Apr 2011 14:14:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] xfs: introduce background inode reclaim work
Message-ID: <20110406181426.GB4356@infradead.org>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302070758-17312-5-git-send-email-david@fromorbit.com>
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

> + * We can have inodes enter reclaim after we've shut down the syncd workqueue
> + * during unmount, so don't allow reclaim work to be queued during unmount.

Nipick: this part of the comment would be better just above the
MS_ACTIVE check.  I just tried to figure out what it was for, and it
took me a while to realize the explanation was in the block comment
above the function.

> +static void
> +xfs_syncd_queue_reclaim(
> +	struct xfs_mount        *mp)
> +{
> +	if (!(mp->m_super->s_flags & MS_ACTIVE))
> +		return;

Otherwise looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
