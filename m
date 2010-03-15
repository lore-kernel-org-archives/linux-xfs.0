Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FGO10W064038 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 11:24:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C9B91D337A2
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 09:08:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DBGgqkMCVrLiKLlY for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 09:08:02 -0700 (PDT)
Date: Mon, 15 Mar 2010 12:08:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Delayed logging
Message-ID: <20100315160801.GB10406@infradead.org>
References: <20100315043000.GK4732@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315043000.GK4732@dastard>
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

Some comments on the patches:

 - "xfs: cluster fsync transaction" seems like something that can stand
   on it's own and go into the tree now.  Despite the comments it
   currently only clusters in fsync and not write_inode which might
   lead to higher benefits, btw.

 - the busy extent tracking might be worth to be reordered before the
   delayed logging series.  In itself it might also want some reordering
   as there's a lot churn in the patches there.  Making
   "XFS: Simplify transaction busy extent tracking" first in that
   subseries might help quite a bit to reduce that churn

 - The actual CIL implementation seems to be split into too small
   patches IMHO.  E.g. "xfs: extend the log item to support delayed
   logging" and "xfs: Introduce the Committed Item List" are two
   sides of the same coin and splitting it might not make too much
   sense.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
