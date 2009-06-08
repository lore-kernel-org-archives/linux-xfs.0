Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n58GGQlI237151 for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 11:16:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A25241234F94
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2009 09:16:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ERtewA31sILQHLJb for
	<xfs@oss.sgi.com>; Mon, 08 Jun 2009 09:16:46 -0700 (PDT)
Date: Mon, 8 Jun 2009 12:16:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: Allow fsx tests to run on generic filesystems
Message-ID: <20090608161646.GA14861@infradead.org>
References: <4A2D31E3.3090108@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A2D31E3.3090108@sandeen.net>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Mon, Jun 08, 2009 at 10:44:35AM -0500, Eric Sandeen wrote:
> There is already logic in 075 to gracefully skip nfs for fsx
> invocations with -x (xfs-specific preallocation) - just extend
> this to any non-xfs filesystem, and add to test 112 as well.
> 
> Later we can change this behavior to use fallocate and include
> more filesystems but this gets some fsx coverage for now.
> 
> Test 127 doesn't seem to have anything xfs-specific, so mark
> that as generic too.

Good bandaid for now, but it would be even better to get a fsx
version using the generic prealloc calls one day :)


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
