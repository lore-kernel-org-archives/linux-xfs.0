Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A1dWtx137743 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 20:39:33 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F017A152E999
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 18:46:39 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QyQQ3KFPZ3iFTXvO for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 18:46:39 -0700 (PDT)
Date: Mon, 10 Oct 2011 12:39:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: force the log if we encounter pinned buffers in
	.iop_pushbuf
Message-ID: <20111010013929.GS3159@dastard>
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.598050900@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111006183549.598050900@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Priebe <s.priebe@profihost.ag>, xfs@oss.sgi.com

On Thu, Oct 06, 2011 at 02:32:59PM -0400, Christoph Hellwig wrote:
> We need to check for pinned buffers even in .iop_pushbuf given that inode
> items flush into the same buffers that may be pinned directly due operations
> on the unlinked inode list operating directly on buffers.  To do this add a
> return value to .iop_pushbuf that tells the AIL push about this and use
> the existing log force mechanisms to unpin it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Stefan Priebe <s.priebe@profihost.ag>
> Tested-by: Stefan Priebe <s.priebe@profihost.ag>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
