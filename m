Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MHWCOx074089 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 12:32:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 500FA926EC
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 10:33:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mu8vTu3gEVs8r7Bg for
	<xfs@oss.sgi.com>; Wed, 22 Sep 2010 10:33:07 -0700 (PDT)
Date: Wed, 22 Sep 2010 13:33:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/16] xfs: implement batched inode lookups for AG walking
Message-ID: <20100922173306.GE5697@infradead.org>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285137869-10310-13-git-send-email-david@fromorbit.com>
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

> +	int			(*grab)(struct xfs_inode *ip),

I think we can do without this callback.  The inode verification that
needs to be done is always the same.  The only difference is that the
dqrele code skips the quota inodes - but this can easily be done in
the execute callback, and given that it's a slow path the additional
two igrab calls won't hurt either.

To be symmetic with that the IRELE call should also be moved from the
execute callbacks into the caller.  All this is stuff enabled by
splitting out the reclaim code earlier which was pretty different in
this area.  In fact just moving the validation + igrab and IRELE into
common code might just be done in a separate patch between the last one
and this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
