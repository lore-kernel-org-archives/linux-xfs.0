Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o41CuY2a252632 for <xfs@oss.sgi.com>; Sat, 1 May 2010 07:56:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E41F304F29
	for <xfs@oss.sgi.com>; Sat,  1 May 2010 05:58:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lNveYqkHpcHorCgE for
	<xfs@oss.sgi.com>; Sat, 01 May 2010 05:58:40 -0700 (PDT)
Date: Sat, 1 May 2010 08:58:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] [PATCH] xfs: simplify buffer to transaction matching
Message-ID: <20100501125839.GA26342@infradead.org>
References: <20100418001041.865247520@bombadil.infradead.org>
	<20100418001058.677429475@bombadil.infradead.org>
	<20100420064155.GH15130@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100420064155.GH15130@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Apr 20, 2010 at 04:41:55PM +1000, Dave Chinner wrote:
> Good start, but I think that it should use xfs_trans_first_item()
> and xfs_trans_next_item() rather than walking the descriptor
> table directly.

I tried implementing it, but it doesn't work.  We can call the buffer
matching routines on transactions that don't have any item linked to
it, which will cause xfs_trans_first_item to panic.  Compare this code
in xfs_trans_buf_item_match:

	for (licp = &tp->t_items; licp != NULL; licp = licp->lic_next) {
		if (xfs_lic_are_all_free(licp)) {
			ASSERT(licp == &tp->t_items);
			ASSERT(licp->lic_next == NULL);
			return NULL;
		}

		...
	}

to this in xfs_trans_first_item:

	licp = &tp->t_items;
        /*
	 * If it's not in the first chunk, skip to the second.
	 */
	if (xfs_lic_are_all_free(licp)) {
		licp = licp->lic_next;
	}

	/*
	 * Return the first non-free descriptor in the chunk.
	 */
	ASSERT(!xfs_lic_are_all_free(licp));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
