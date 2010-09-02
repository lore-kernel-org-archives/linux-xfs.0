Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o82CFqNa203589 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 07:15:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7228644B67
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 05:16:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zgo6BNLx15A9IqoB for
	<xfs@oss.sgi.com>; Thu, 02 Sep 2010 05:16:33 -0700 (PDT)
Date: Thu, 2 Sep 2010 08:16:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: prevent 32bit overflow in space reservation
Message-ID: <20100902121631.GA7767@infradead.org>
References: <1283404663-28105-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1283404663-28105-1-git-send-email-david@fromorbit.com>
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

On Thu, Sep 02, 2010 at 03:17:43PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we attempt to preallocate more than 2^32 blocks of space in a
> single syscall, the transaction block reservation will overflow
> leading to a hangs in the superblock block accounting code. This
> is trivially reproduced with xfs_io. Fix the problem by capping the
> allocation reservation to the maximum number of blocks a single
> xfs_bmapi() call can allocate (2^21 blocks).
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
