Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H3ZDJI201959 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 21:35:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 184DD1D7807
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 19:36:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	LLMKeRyushGDAj1P for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 19:36:29 -0800 (PST)
Date: Wed, 17 Feb 2010 14:36:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] [PATCH 1/4] xfs: merge xfs_lrw.c into xfs_file.c
Message-ID: <20100217033626.GI28392@discord.disaster>
References: <20100215094445.528696829@bombadil.infradead.org>
	<20100215094603.932254045@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100215094603.932254045@bombadil.infradead.org>
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

On Mon, Feb 15, 2010 at 04:44:46AM -0500, Christoph Hellwig wrote:
> Currently the code to implement the file operations is split over two small
> files.  Merge the content of xfs_lrw.c into xfs_file.c to have it in one
> place.  Note that I haven't done various cleanups that are possible after
> this yet, they will follow in the next patch.  Also the function 
> xfs_dev_is_read_only which was in xfs_lrw.c before really doesn't fit in
> here at all and was moved to xfs_mount.c.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me, so:

Reviewed-by: Dave Chinner <david@fromorbit.com>

As an additional step, perhaps it be a good idea to get rid of
xfs_lrw.h as well?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
