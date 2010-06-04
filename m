Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o547mwip209627 for <xfs@oss.sgi.com>; Fri, 4 Jun 2010 02:48:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4676814803B0
	for <xfs@oss.sgi.com>; Fri,  4 Jun 2010 00:51:28 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id eEH9TSEbKAEcmjNU for <xfs@oss.sgi.com>;
	Fri, 04 Jun 2010 00:51:28 -0700 (PDT)
Date: Fri, 4 Jun 2010 03:51:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] writeback: Add tracing to write_cache_pages
Message-ID: <20100604075127.GA7317@infradead.org>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
	<1275609328-12514-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1275609328-12514-4-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jun 04, 2010 at 09:55:25AM +1000, Dave Chinner wrote:
> Add a trace event to the ->writepage loop in write_cache_pages to give
> visibility into how the ->writepage call is changing variables within the
> writeback control structure. Of most interest is how wbc->nr_to_write changes
> from call to call, especially with filesystems that write multiple pages
> in ->writepage.

Looks good, it might be worth to add another tracepoint for ->writepage
from reclaim context so that we can start investigating the cases where
that happens far too often.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
