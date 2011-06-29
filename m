Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TMD4Mt145469 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 17:13:04 -0500
Subject: Re: [PATCH 04/27] xfs: cleanup xfs_add_to_ioend
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110629140337.137341800@bombadil.infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140337.137341800@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 17:13:00 -0500
Message-ID: <1309385580.8649.34.camel@doink>
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

On Wed, 2011-06-29 at 10:01 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-cleanup-xfs_add_to_ioend)
> Pass the writeback context to xfs_add_to_ioend to make the ioend
> chain manipulations self-contained in this function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  I much prefer what you've done to how
it was before.

Reviewed-by: Alex Elder <aelder@sgi.com>

PS  I still have to review patch 3 in this series.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
