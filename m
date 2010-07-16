Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6G5DETj245762 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 00:13:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56993BD367B
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 22:22:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Qxy9uonhFHrGCsCB for
	<xfs@oss.sgi.com>; Thu, 15 Jul 2010 22:22:29 -0700 (PDT)
Date: Fri, 16 Jul 2010 01:16:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: simplify and remove xfs_ireclaim
Message-ID: <20100716051608.GA29915@infradead.org>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279154300-2018-3-git-send-email-david@fromorbit.com>
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

On Thu, Jul 15, 2010 at 10:38:17AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_ireclaim has to get and put te pag structure because it is only
> called with the inode to reclaim. The one caller of this function
> already has a reference on the pag and a pointer to is, so move the
> radix tree delete to the caller and remove xfs_ireclaim completely.
> This avoids a xfs_perag_get/put on every inode being reclaimed.
> 
> The overhead was noticed in a bug report at:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16348

Looks good, I had looked into this earlier but never finished it.

There's also some opportunity to optimize roundtrips on the ilock in
this path.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
