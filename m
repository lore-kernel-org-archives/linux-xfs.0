Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46Kd6jW130380 for <xfs@oss.sgi.com>; Thu, 6 May 2010 15:39:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8DD83177F5
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 13:41:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xiWjZZHr1HVNzcn8 for
	<xfs@oss.sgi.com>; Thu, 06 May 2010 13:41:16 -0700 (PDT)
Date: Thu, 6 May 2010 16:41:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] xfs: Don't reuse the same transaciton ID for
	duplicated transactions.
Message-ID: <20100506204115.GA14309@infradead.org>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
	<1273110351-2333-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273110351-2333-2-git-send-email-david@fromorbit.com>
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

On Thu, May 06, 2010 at 11:45:41AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The transaction ID is written into the log as the unique identifier
> for transactions during recover. When duplicating a transaction, we
> reuse the log ticket, which means it has the same transaction ID as
> the previous transaction.
> 
> Rather than regenerating a random transaction ID for the duplicated
> transaction, just add one to the current ID so that duplicated
> transaction can be easily spotted in the log and during recovery
> during problem diagnosis.

Oh well, more fun with transaction ids.  I'm still not happy with
the not guarnateed unique schemes we have here, but for now this should
do it.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
