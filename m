Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LIjX6L166723 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 13:45:34 -0500
Subject: Re: [PATCH 4/4] libxfs: add b_error
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110920220030.771822970@bombadil.infradead.org>
References: <20110920215917.508421839@bombadil.infradead.org>
	<20110920220030.771822970@bombadil.infradead.org>
Date: Wed, 21 Sep 2011 13:45:15 -0500
Message-ID: <1316630715.5872.16.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Tue, 2011-09-20 at 17:59 -0400, Christoph Hellwig wrote:
> Add a b_error field to struct xfs_buf so that we can return the exact error
> fro libxfs_readbuf.  And explicit error return would be nice, but this
> requires large changes to common code that should be done on the kernel
> side first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
