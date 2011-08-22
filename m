Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M6Jsvl035219 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 01:19:55 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 611CF1DA2900
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 23:19:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LNPM2o5AXGLnuYlN for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 23:19:29 -0700 (PDT)
Date: Mon, 22 Aug 2011 16:19:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: move more delwri setup into xfs_buf_delwri_queue
Message-ID: <20110822061927.GG3162@dastard>
References: <20110814171517.174040686@bombadil.infradead.org>
	<20110814171652.104038879@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110814171652.104038879@bombadil.infradead.org>
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

On Sun, Aug 14, 2011 at 01:15:20PM -0400, Christoph Hellwig wrote:
> Do not transfer a reference held by the caller to the buffer on the list,
> or decrement it in xfs_buf_delwri_queue, but instead grab a new reference
> if needed, and let the caller drop its own reference.  Also move setting
> of the XBF_DELWRI and XBF_ASYNC flags into xfs_buf_delwri_queue, and
> only do it if needed.  Note that for now xfs_buf_unlock already has
> XBF_DELWRI, but that will change in the following patches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yup, the transfer of refcounts was messy. Much better to have the
delwri queue manage it's own refcount.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
