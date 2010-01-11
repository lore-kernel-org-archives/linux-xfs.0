Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BAIKVW129715 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 04:18:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D4E01357D4F
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 02:19:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9bL63aD9D2DQQeHv for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 02:19:14 -0800 (PST)
Date: Mon, 11 Jan 2010 05:19:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: Avoid inodes in reclaim when flushing from
	inode cache
Message-ID: <20100111101914.GB26465@infradead.org>
References: <1263167508-9346-1-git-send-email-david@fromorbit.com>
	<1263167508-9346-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263167508-9346-3-git-send-email-david@fromorbit.com>
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

On Mon, Jan 11, 2010 at 10:51:46AM +1100, Dave Chinner wrote:
> THe reclaim code will handle flushing of dirty inodes before
> reclaim occurs, so avoid them when determining whether an inode is
> a candidate for flushing to disk when walking the radix trees.
> This is based on a test patch from Christoph Hellwig.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
