Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FFIuYv058941 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 10:18:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4420D142E4DE
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:20:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7P819q6fyFq5GG6d for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:20:32 -0700 (PDT)
Date: Mon, 15 Mar 2010 11:20:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] xfs: Clean up xfs_trans_committed code after factoring
Message-ID: <20100315152031.GB6974@infradead.org>
References: <1268620506-10799-1-git-send-email-david@fromorbit.com>
	<1268620506-10799-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1268620506-10799-9-git-send-email-david@fromorbit.com>
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

On Mon, Mar 15, 2010 at 01:35:05PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the code has been factored, clean up all the remaining
> style cruft, simplify the code and re-order functions so that it
> doesn't need forward declarations.
> 
> Also move the remaining functions that require forward declarations
> (xfs_trans_uncommit, xfs_trans_free) so that all the forward
> declarations can be removed from the file.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
