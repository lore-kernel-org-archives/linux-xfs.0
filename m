Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q81NGR8x195828 for <xfs@oss.sgi.com>; Sat, 1 Sep 2012 18:16:27 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	KDyjU1LUSM4IayVz (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 01 Sep 2012 16:17:22 -0700 (PDT)
Date: Sat, 1 Sep 2012 19:17:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/13] xfs: rename the xfs_syncd workqueue
Message-ID: <20120901231722.GB27456@infradead.org>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1346328017-2795-3-git-send-email-david@fromorbit.com>
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

On Thu, Aug 30, 2012 at 10:00:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is nothing "sync" realted to this work queue any more. It is a general
> purpose per-filesystem work queue. Rename it appropriately, and remove the
> "syncd" naming from various functions.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

With the current leight-weight workqueues I don't see why we'd even want
a shared one for the different callers.  Let's move the patch until
after killing xfs_flush_worker & co, and then add a workqueue for
background and the log sync individually.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
