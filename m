Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FFeJAi060740 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 10:40:19 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E98E319D69EF
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:41:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nfaecbnyuzKM5pYA for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:41:54 -0700 (PDT)
Date: Mon, 15 Mar 2010 11:41:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] xfs: log ticket reservation underestimates the
	number of iclogs
Message-ID: <20100315154154.GA20155@infradead.org>
References: <1268620506-10799-1-git-send-email-david@fromorbit.com>
	<1268620506-10799-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1268620506-10799-10-git-send-email-david@fromorbit.com>
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

On Mon, Mar 15, 2010 at 01:35:06PM +1100, Dave Chinner wrote:
> +	 * for LR headers - the space for data in an iclog is the size minus
> +	 * the space used for the headers. If we use the iclog size, then we
> +	 * undercalculate the number of headers required.
> +	 *
> +	 * Furthermore - the addition of op headers for split-recs might
> +	 * increase the space required enough to require more log and op
> +	 * headers, so take that into account too.
> +	 *
> +	 * IMPORTANT: This reservation makes the assumption that if this
> +	 * transaction is the first in an iclog and hence has the LR headers
> +	 * accounted to it, then the remaining space in the iclog is
> +	 * exclusively for this transaction.  i.e. if the transaction is larger
> +	 * than the iclog, it will be the only thing in that iclog.
> +	 * Fundamentally, this means we must pass the entire log vector to
> +	 * xlog_write to guarantee this.
> +	 */
> +	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> +	num_headers = (unit_bytes + iclog_space - 1) / iclog_space;
> +
> +	/* for split-recs - ophdrs added when data split over LRs */
> +	unit_bytes += sizeof(xlog_op_header_t) * num_headers;
> +
> +	/* add extra header reservations if we overrun */
> +	while (!num_headers ||
> +	       ((unit_bytes + iclog_space - 1) / iclog_space) > num_headers) {
> +		unit_bytes += sizeof(xlog_op_header_t);
> +		num_headers++;
> +	}

Looks good, but why do you check for a zero num_headers here?  The only way
this could happen after the roundup above is if unit_bytes is zero, which
can't ever happen - one caller has it hardcoded to 1, and the the other
has a conditional for it beeing bigger than 0 around the call.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
