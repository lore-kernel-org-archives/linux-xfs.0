Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13BGkVA224701 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 05:16:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD8541C9CA36
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 03:17:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Y2vrSR7SDlID0GuE for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 03:17:55 -0800 (PST)
Date: Wed, 3 Feb 2010 06:17:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/10] xfs: kill the unused XFS_QMOPT_* flush flags V2
Message-ID: <20100203111755.GB22957@infradead.org>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1265153104-29680-7-git-send-email-david@fromorbit.com>
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

On Wed, Feb 03, 2010 at 10:25:00AM +1100, Dave Chinner wrote:
> dquots are never flushed asynchronously. Remove the flag and the
> async write support from the flush function. Make the default flush
> a delwri flush to make the inode flush code, which leaves the
> XFS_QMOPT_SYNC the only flag remaining.  Convert that to use
> SYNC_WAIT instead, just like the inode flush code.
> 
> V2:
> - just pass flush flags straight through

Still looks good with that minor change,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
