Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46KnmE4130867 for <xfs@oss.sgi.com>; Thu, 6 May 2010 15:49:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 401C93178D4
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 13:51:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PHcOyQzCYFwwwkKZ for
	<xfs@oss.sgi.com>; Thu, 06 May 2010 13:51:59 -0700 (PDT)
Date: Thu, 6 May 2010 16:51:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] xfs: Clean up XFS_BLI_* flag namespace
Message-ID: <20100506205158.GB24110@infradead.org>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
	<1273110351-2333-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273110351-2333-6-git-send-email-david@fromorbit.com>
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

On Thu, May 06, 2010 at 11:45:45AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean up the buffer log format (XFS_BLI_*) flags because they have a
> polluted namespace. They XFS_BLI_ prefix is used for both in-memory
> and on-disk flag feilds, but have overlapping values for different
> flags. Rename the buffer log format flags to use the XFS_BLF_*
> prefix to avoid confusing them with the in-memory XFS_BLI_* prefixed
> flags.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
