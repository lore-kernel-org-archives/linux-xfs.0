Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8MC2ZLw188996 for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 07:02:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEF52470485
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 05:03:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ReqmBbUZcCfePwPL for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2009 05:03:53 -0700 (PDT)
Date: Tue, 22 Sep 2009 08:03:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_fsr: fix test for short write
Message-ID: <20090922120353.GC8143@infradead.org>
References: <4AB307AD.9010904@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AB307AD.9010904@sandeen.net>
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

On Thu, Sep 17, 2009 at 11:08:13PM -0500, Eric Sandeen wrote:
> Clang found this one too, as a dead nested assignment.
>
> The point is to see if we write all the bytes; but the initial
> assignment is backwards.  It's safe in the end, because if they
> weren't already equal anyway, we'd have exited prior to this, but
> it's worth fixing up for clarity.
>
> Signed-of-by: Eric Sandeen <sandeen@sandeen.net>

Looks good to me, 


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
