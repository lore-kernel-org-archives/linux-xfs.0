Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SGMAiq000441 for <xfs@oss.sgi.com>; Thu, 28 May 2009 11:22:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D74112B7DE2
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 09:22:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gXv1Y4oYDWCXtQnb for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 09:22:24 -0700 (PDT)
Date: Thu, 28 May 2009 12:22:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9 V2] Use xfs.h rather than libxfs.h
Message-ID: <20090528162224.GA28218@infradead.org>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<1243450413-12681-2-git-send-email-sandeen@sandeen.net>
	<20090528095657.GA651@infradead.org> <4A1EB8DE.40108@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A1EB8DE.40108@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> +#ifndef XFS_SUPER_MAGIC
> +#define XFS_SUPER_MAGIC 0x58465342
> +#endif

This should eventually be replaced by just using platform_test_xfs_fd
from xfs.h


But for now the patch is fine,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
