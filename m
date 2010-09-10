Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8AJnSXG162567 for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 14:49:28 -0500
Subject: Re: [PATCH] xfs: stop using xfs_qm_dqtobp in xfs_qm_dqflush
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100906014445.GB1587@infradead.org>
References: <20100906014445.GB1587@infradead.org>
Date: Fri, 10 Sep 2010 14:49:22 -0500
Message-ID: <1284148162.2468.12.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sun, 2010-09-05 at 21:44 -0400, Christoph Hellwig wrote:
> In xfs_qm_dqflush we know that q_blkno must be initialized already from a
> previous xfs_qm_dqread.  So instead of calling xfs_qm_dqtobp we can
> simply read the quota buffer directly.  This also saves us from a duplicate
> xfs_qm_dqcheck call check and allows xfs_qm_dqtobp to be simplified now
> that it is always called for a newly initialized inode.  In addition to
> that properly unwind all locks in xfs_qm_dqflush when xfs_qm_dqcheck
> fails.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> This mirrors a similar cleanup in the inode lookup done earlier.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
