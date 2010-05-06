Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46Kmiju130822 for <xfs@oss.sgi.com>; Thu, 6 May 2010 15:48:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB328155BF26
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 13:50:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id b9kHhq5cxLfv93ES for
	<xfs@oss.sgi.com>; Thu, 06 May 2010 13:50:54 -0700 (PDT)
Date: Thu, 6 May 2010 16:50:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/11] xfs: clean up log ticket overrun debug output
Message-ID: <20100506205054.GA24110@infradead.org>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
	<1273110351-2333-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273110351-2333-7-git-send-email-david@fromorbit.com>
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

On Thu, May 06, 2010 at 11:45:46AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Push the error message output when a ticket overrun is detected
> into the ticket printing functions. Also remove the debug version
> of the code as the production version will still panic just as
> effectively on a debug kernel via the panic mask being set.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
