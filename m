Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8HiFVE155968 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 11:44:15 -0600
Date: Thu, 8 Dec 2011 11:44:38 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 02/19] xfs: cleanup the transaction commit path a bit
Message-ID: <20111208174438.GS29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215852.919749164@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215852.919749164@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:08PM -0500, Christoph Hellwig wrote:
> Now that the nodelaylog mode is gone we can simplify the transaction commit
> path a bit by removing the xfs_trans_commit_cil routine.  Restoring the
> process flags is merged into xfs_trans_commit which already does it for
> the error path, and allocating the log vectors is merged into
> xlog_cil_format_items, which already fills them with data, thus avoiding
> one loop over all log items.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
