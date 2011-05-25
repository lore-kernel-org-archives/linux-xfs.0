Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P0X9oW106059 for <xfs@oss.sgi.com>; Tue, 24 May 2011 19:33:10 -0500
Subject: Re: [PATCH 5/9] xfs: do not use unchecked extent indices in xfs_bmapi
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110511150712.222802741@bombadil.infradead.org>
References: <20110511150402.258164661@bombadil.infradead.org>
	<20110511150712.222802741@bombadil.infradead.org>
Date: Tue, 24 May 2011 19:31:29 -0500
Message-ID: <1306283489.2823.94.camel@doink>
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

On Wed, 2011-05-11 at 11:04 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-fix-ep-access-2)
> Make sure to only call xfs_iext_get_ext after we've validate the extent index
> when moving on to the next index in xfs_bmapi.
> 
> Based on an earlier patch from Lachlan McIlroy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
