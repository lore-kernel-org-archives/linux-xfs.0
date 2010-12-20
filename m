Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKBnThx117784 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 05:49:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DF79146D126
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:51:26 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TxklfkZ3LxtcIKHE for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:51:26 -0800 (PST)
Date: Mon, 20 Dec 2010 06:51:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12] xfs: fact out common grant head/log tail
	verification code
Message-ID: <20101220115125.GH12806@infradead.org>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
	<1292215483-18224-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292215483-18224-3-git-send-email-david@fromorbit.com>
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

On Mon, Dec 13, 2010 at 03:44:33PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Factor repeated debug code out of grant head manipulation functions into a
> separate function. This removes ifdef DEBUG spagetti from the code and makes
> the code easier to follow.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
