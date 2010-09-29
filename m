Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TBQQtt043463 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 06:26:26 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9EA4188503E
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 04:27:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	VA0vgINMhOX6NFYX for <xfs@oss.sgi.com>;
	Wed, 29 Sep 2010 04:27:23 -0700 (PDT)
Date: Wed, 29 Sep 2010 21:27:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] [PATCH 3/3] xfs: do not use
	xfs_mod_incore_sb_batch for per-cpu counters
Message-ID: <20100929112720.GN5665@dastard>
References: <20100929072221.583672974@bombadil.infradead.org>
	<20100929072238.456748707@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100929072238.456748707@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Sep 29, 2010 at 03:22:24AM -0400, Christoph Hellwig wrote:
> Update the per-cpu counters manually in xfs_trans_unreserve_and_mod_sb and
> remove support for per-cpu counters from xfs_mod_incore_sb_batch to
> simplify it.  And added benefit is that we don't have to take m_sb_lock
> for transactions that only modify per-cpu counters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
....

> +
> +	return;
> +
> +out_undo_ifreecount:
> +	if (ifreedelta)
> +		xfs_icsb_modify_counters(mp, XFS_SBS_IFREE, ifreedelta, rsvd);
> +out_undo_icount:
> +	if (idelta)
> +		xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT, idelta, rsvd);

These two should be -ifreedelta and -idelta, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
