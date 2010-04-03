Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o339NaOK033875 for <xfs@oss.sgi.com>; Sat, 3 Apr 2010 04:23:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB5CCF9A25D
	for <xfs@oss.sgi.com>; Sat,  3 Apr 2010 02:25:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bdNC3unno7XfI5qz for
	<xfs@oss.sgi.com>; Sat, 03 Apr 2010 02:25:24 -0700 (PDT)
Date: Sat, 3 Apr 2010 05:25:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] xfs: don't warn on EAGAIN in inode reclaim
Message-ID: <20100403092523.GC20166@infradead.org>
References: <1270125691-29266-1-git-send-email-david@fromorbit.com>
	<1270125691-29266-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270125691-29266-3-git-send-email-david@fromorbit.com>
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

On Thu, Apr 01, 2010 at 11:41:25PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Any inode reclaim flush that returns EAGAIN will result in the inode
> reclaim being attempted again later. There is no need to issue a
> warning into the logs about this situation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
