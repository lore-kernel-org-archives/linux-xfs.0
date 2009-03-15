Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FFGGBZ020591 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 10:16:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D9FA1C43CDF
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 08:15:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id RarymU3SQx36uHqo for
	<xfs@oss.sgi.com>; Sun, 15 Mar 2009 08:15:53 -0700 (PDT)
Date: Sun, 15 Mar 2009 11:15:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] [XFS] Validate log feature fields correctly
Message-ID: <20090315151546.GB7145@infradead.org>
References: <1237116342-25701-1-git-send-email-david@fromorbit.com>
	<1237116342-25701-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237116342-25701-2-git-send-email-david@fromorbit.com>
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

On Sun, Mar 15, 2009 at 10:25:41PM +1100, Dave Chinner wrote:
> If the large log sector size feature bit is set in the
> superblock by accident (say disk corruption), the then
> fields that are now considered valid are not checked on
> production kernels. The checks are present as ASSERT
> statements so cause a panic on a debug kernel.
> 
> Change this so that the fields are validity checked if
> the feature bit is set and abort the log mount if the
> fields do not contain valid values.
> 
> Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Looks good to me, but wouldn't be easier to rad if the various sizes
in the error messages were reported decimal instead of in hex?


Reviewed-by: Christoph Hellwig <hch@lst.de>

>  }	/* xlog_alloc_log */

any maybe remove this comment while you're at it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
