Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7E567CA4
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 04:25:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B09B304032
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 02:25:04 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id MOMYxw77KfOatMT3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 02:25:02 -0700 (PDT)
Date: Wed, 3 Aug 2016 02:25:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't invalidate whole file on DAX read/write
Message-ID: <20160803092502.GA17891@infradead.org>
References: <1470181226-20935-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470181226-20935-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 09:40:26AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we do DAX IO, we try to invalidate the entire page cache held
> on the file. This is incorrect as it will trash the entire mapping
> tree that now tracks dirty state in exceptional entries in the radix
> tree slots.
> 
> What we are trying to do is remove cached pages (e.g from reads
> into holes) that sit in the radix tree over the range we are about
> to write to. Hence we should just limit the invalidation to the
> range we are about to overwrite.

Looks fine (for a broad defintion of "fine"):


Reviewed-by: Christoph Hellwig <hch@lst.de>

> +	 * XXX: This is racy against mmap, and there's nothing we can do about
> +	 * it. dax_do_io() should really do this invalidation internally as
> +	 * it will know if we've allocated over a holei for this specific IO and
> +	 * if so it needs to update the mapping tree and invalidate existing
> +	 * PTEs over the newly allocated range. Remove this invalidation when
> +	 * dax_do_io() is fixed up.

FYI, I've got a basically working version of an iomap based DAX I/O path
(still fails a few corner cases), and I'll see if I can add that to it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
