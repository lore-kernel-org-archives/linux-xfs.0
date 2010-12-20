Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKBcOWw116186 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 05:38:24 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 271E31CDF29A
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:40:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Kn3sgmHsuhTDLB8y for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:40:21 -0800 (PST)
Date: Mon, 20 Dec 2010 06:40:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/12] xfs: combine grant heads into a single 64 bit
	integer
Message-ID: <20101220114020.GC12806@infradead.org>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
	<1292215483-18224-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292215483-18224-5-git-send-email-david@fromorbit.com>
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

On Mon, Dec 13, 2010 at 03:44:35PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Prepare for switching the grant heads to atomic variables by
> combining the two 32 bit values that make up the grant head into a
> single 64 bit variable.  Provide wrapper functions to combine and
> split the grant heads appropriately for calculations and use them as
> necessary.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Minor nitpick:

> +	if ((tail_cycle == head_cycle) && (head_bytes >= tail_bytes)) {
> +		free_bytes = log->l_logsize - (head_bytes - tail_bytes);
> +	} else if ((tail_cycle + 1) < head_cycle) {

Lots of superflous braces in the if statements.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
