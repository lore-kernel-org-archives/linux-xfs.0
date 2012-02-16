Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GLahsU021213 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 15:36:43 -0600
Date: Thu, 16 Feb 2012 15:36:46 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 12/12] xfs: split and cleanup xfs_log_reserve
Message-ID: <20120216213646.GA7762@sgi.com>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141435.692631989@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212141435.692631989@bombadil.infradead.org>
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

On Mon, Dec 12, 2011 at 09:13:59AM -0500, Christoph Hellwig wrote:
> Split the log regrant case out of xfs_log_reserve into a separate function,
> and merge xlog_grant_log_space and xlog_regrant_write_log_space into their
> respective callers.  Also replace the XFS_LOG_PERM_RESERV flag, which easily
> got misused before the previous cleanups with a simple boolean parameter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

old:
 xfs_trans_reserve
   xfs_log_reserve
     if (*ticket != NULL) {
       xlog_regrant_write_log_space
     } else {
       allocate a ticket;
       xlog_grant_log_space
     }

new:
 xfs_trans_reserve
   if (tp->t_ticket != NULL) {
     xfs_log_regrant
   } else {
     xfs_log_reserve
   }

I've gone over this and it seems ok to me.  There are minor changes in
the names of the trace points, the change to use a boolean instead of
flags for a permanent reservation looks fine, the main structural change
looks good.  A nice change.

This has me wondering if it is possible to get rid of
XFS_LOG_REL_PERM_RESERV too...

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
