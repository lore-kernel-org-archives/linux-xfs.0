Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4FHDGJi048061 for <xfs@oss.sgi.com>; Fri, 15 May 2009 12:13:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D880328C53B
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 10:13:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MXkYceTDMm7E1Pk9 for
	<xfs@oss.sgi.com>; Fri, 15 May 2009 10:13:24 -0700 (PDT)
Date: Fri, 15 May 2009 13:13:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs:  add fallocate command to xfs_io
Message-ID: <20090515171324.GA14804@infradead.org>
References: <4A077195.3070708@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A077195.3070708@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, May 10, 2009 at 07:30:13PM -0500, Eric Sandeen wrote:
> Based on Dave's earlier patch, but now we have an fallocate
> glibc call... this also adds autoconf magic and a manpage 
> update.
> 
> (hopefully not too #ifdef-heavy....)

Looks good to me and seems to work.

> +#if defined(HAVE_FALLOCATE)
> +#include <linux/falloc.h>
> +#endif

What about just using #ifdef HAVE_FALLOCATE everywhere?


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
