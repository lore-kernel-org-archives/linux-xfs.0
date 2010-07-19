Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6J0M0Te174763 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 19:22:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B885145651E
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 17:24:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	6wym7v7VZAq1K9gZ for <xfs@oss.sgi.com>;
	Sun, 18 Jul 2010 17:24:58 -0700 (PDT)
Date: Mon, 19 Jul 2010 10:24:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: fix xfs_trans_add_item() lockdep warnings
Message-ID: <20100719002456.GF23223@dastard>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-4-git-send-email-david@fromorbit.com>
	<20100716051934.GC29915@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100716051934.GC29915@infradead.org>
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

On Fri, Jul 16, 2010 at 01:19:34AM -0400, Christoph Hellwig wrote:
> > -	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP);
> > +	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP|KM_NOFS);
> 
> KM_NOFS by itself actually is sufficiant.  If you want to keep the
> KM_SLEEP for documentation purposes at least add some spaces to make
> it more redable.
> 
> 	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);

Will do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
