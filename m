Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN1se90070584 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:54:40 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD6AE1CEE045
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 17:56:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	Ws5waSIBIkGrDuhy for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 17:56:37 -0800 (PST)
Date: Thu, 23 Dec 2010 12:56:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: refactor xlog_recover_commit_trans
Message-ID: <20101223015633.GC18264@dastard>
References: <20101201220620.340188389@bombadil.infradead.org>
	<20101201220710.454838485@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101201220710.454838485@bombadil.infradead.org>
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

On Wed, Dec 01, 2010 at 05:06:23PM -0500, Christoph Hellwig wrote:
> Merge the call to xlog_recover_reorder_trans and the loop over the
> recovery items from xlog_recover_do_trans into xlog_recover_commit_trans,
> and keep the switch statement over the log item types as a separate helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much nicer. With the small "break" fix Alex commented on, it looks
good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
