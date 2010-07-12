Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6CF2cak034399 for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 10:02:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A88115BCDD2
	for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 08:11:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hjEsw2WznO3PSuhQ for
	<xfs@oss.sgi.com>; Mon, 12 Jul 2010 08:11:33 -0700 (PDT)
Date: Mon, 12 Jul 2010 11:05:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: unregister inode shrinker before freeing filesystem
	structures V2
Message-ID: <20100712150531.GA11776@infradead.org>
References: <1278916858-24903-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1278916858-24903-1-git-send-email-david@fromorbit.com>
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

On Mon, Jul 12, 2010 at 04:40:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently we don't remove the XFS mount from the shrinker list until late in
> the unmount path. By this time, we have already torn down the internals of the
> filesystem (e.g. the per-ag structures), and hence if the shrinker is executed
> between the teardown and the unregistering, the shrinker will get NULL per-ag
> structure pointers and panic trying to dereference them.
> 
> Fix this by removing the xfs mount from the shrinker list before tearing down
> it's internal structures.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
