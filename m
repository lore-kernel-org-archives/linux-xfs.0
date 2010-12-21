Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBLFEHJt044411 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 09:14:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 989921465B27
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 07:16:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rpRQXZl6rODbE3VJ for
	<xfs@oss.sgi.com>; Tue, 21 Dec 2010 07:16:15 -0800 (PST)
Date: Tue, 21 Dec 2010 10:16:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/34] xfs: use KM_NOFS for allocations during attribute
	list operations
Message-ID: <20101221151614.GC26127@infradead.org>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
	<1292916570-25015-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292916570-25015-3-git-send-email-david@fromorbit.com>
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

On Tue, Dec 21, 2010 at 06:28:58PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When listing attributes, we are doiing memory allocations under the
> inode ilock using only KM_SLEEP. This allows memory allocation to
> recurse back into the filesystem and do writeback, which may the
> ilock we already hold on the current inode. THis will deadlock.
> Hence use KM_NOFS for such allocations outside of transaction
> context to ensure that reclaim recursion does not occur.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
