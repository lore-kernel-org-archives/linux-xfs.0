Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46KwMa9131264 for <xfs@oss.sgi.com>; Thu, 6 May 2010 15:58:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DA48155C494
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 14:00:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wjqI5KUYvLCvOomc for
	<xfs@oss.sgi.com>; Thu, 06 May 2010 14:00:27 -0700 (PDT)
Date: Thu, 6 May 2010 17:00:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/11] xfs: modify buffer item reference counting V2
Message-ID: <20100506210026.GA30264@infradead.org>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
	<1273110351-2333-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273110351-2333-5-git-send-email-david@fromorbit.com>
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

On Thu, May 06, 2010 at 11:45:44AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The buffer log item reference counts used to take reference?? for every
> transaction, similar to the pin counting. This is symmetric (like the
> pin/unpin) with respect to transaction completion, but with dleayed logging
> becomes assymetric as the pinning becomes assymetric w.r.t. transaction
> completion.
> 
> To make both cases the same, allow the buffer pinning to take a reference to
> the buffer log item and always drop the reference the transaction has on it
> when being unlocked. This is balanced correctly because the unpin operation
> always drops a reference to the log item. Hence reference counting becomes
> symmetric w.r.t. item pinning as well as w.r.t active transactions and as a
> result the reference counting model remain consistent between normal and
> delayed logging.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good and makes the buffer refconting model a lot more sensible.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
