Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13BI69M224769 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 05:18:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E9A91A8440
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 03:19:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id B8kAajtIShrFOHFg for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 03:19:16 -0800 (PST)
Date: Wed, 3 Feb 2010 06:19:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/10] xfs: kill xfs_bawrite
Message-ID: <20100203111916.GC22957@infradead.org>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1265153104-29680-11-git-send-email-david@fromorbit.com>
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

On Wed, Feb 03, 2010 at 10:25:04AM +1100, Dave Chinner wrote:
> There are no more users of this function left in the XFS code
> now that we've switched everything to delayed write flushing.
> Remove it.

Actually we still write the superblock async using xfs_bwrite, but
getting rid of that is a separate project, so


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
