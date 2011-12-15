Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBFGuScx015340 for <xfs@oss.sgi.com>; Thu, 15 Dec 2011 10:56:29 -0600
Date: Thu, 15 Dec 2011 10:56:53 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 16/19] xfs: add a xfs_dqhold helper
Message-ID: <20111215165653.GJ29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215855.483263030@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215855.483263030@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:22PM -0500, Christoph Hellwig wrote:
> Factor the common pattern of:
> 
> 	xfs_dqlock(dqp);
> 	XFS_DQHOLD(dqp);
> 	xfs_dqunlock(dqp);
> 
> into a new helper, and remove XFS_DQHOLD now that only one other caller
> is left.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
