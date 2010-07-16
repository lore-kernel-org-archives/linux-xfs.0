Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6G5JUkY246062 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 00:19:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A6F01D690B9
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 22:22:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id A4I9DaC4JidGEKFe for
	<xfs@oss.sgi.com>; Thu, 15 Jul 2010 22:22:27 -0700 (PDT)
Date: Fri, 16 Jul 2010 01:22:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: fix memory reclaim recursion deadlock on locked
	inode buffer
Message-ID: <20100716052227.GE29915@infradead.org>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279154300-2018-6-git-send-email-david@fromorbit.com>
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

On Thu, Jul 15, 2010 at 10:38:20AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Calling into memory reclaim with a locked inode buffer can deadlock
> if memory reclaim tries to lock the inode buffer during inode
> teardown. Convert the relevant memory allocations to use KM_NOFS to
> avoid this deadlock condition.

Looks good, although the same style nitpicks as for patch 3 apply.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
