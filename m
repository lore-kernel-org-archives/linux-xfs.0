Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p971jfeV212195 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 20:45:41 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 920551B3B0B
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 18:45:39 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zXBkoLBwjyQiYWWI for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 18:45:39 -0700 (PDT)
Date: Fri, 7 Oct 2011 12:45:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] xfs: remove buffers from the delwri list in
	xfs_buf_stale
Message-ID: <20111007014536.GB3159@dastard>
References: <20111006210607.175284390@bombadil.infradead.org>
	<20111006210639.352441913@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111006210639.352441913@bombadil.infradead.org>
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

On Thu, Oct 06, 2011 at 05:06:12PM -0400, Christoph Hellwig wrote:
> For each call to xfs_buf_stale we call xfs_buf_delwri_dequeue either
> directly before or after it, or are guaranteed by the surrounding
> conditionals that we are never called on delwri buffers.  Simply
> this situation by moving the call to xfs_buf_delwri_dequeue into
> xfs_buf_stale.

Makes sense, and delwri-dequeue is safe to call on non-delwri
buffers.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
