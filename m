Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M6NGfA035568 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 01:23:16 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC1301DA2B53
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 23:23:12 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YK6FuTsQQXlJMG1v for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 23:23:12 -0700 (PDT)
Date: Mon, 22 Aug 2011 16:22:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: call xfs_buf_delwri_queue directly
Message-ID: <20110822062211.GH3162@dastard>
References: <20110814171517.174040686@bombadil.infradead.org>
	<20110814171652.350395176@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110814171652.350395176@bombadil.infradead.org>
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

On Sun, Aug 14, 2011 at 01:15:21PM -0400, Christoph Hellwig wrote:
> Unify the ways we add buffers to the delwri queue by always calling
> xfs_buf_delwri_queue directly.  The xfs_bdwrite functions is removed and
> opencoded in its callers, and the two places setting XBF_DELWRI while a
> buffer is locked and expecting xfs_buf_unlock to pick it up are converted
> to call xfs_buf_delwri_queue directly, too.  Also replace the
> XFS_BUF_UNDELAYWRITE macro with direct calls to xfs_buf_delwri_dequeue
> to make the explicit queuing/dequeuing more obvious.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
