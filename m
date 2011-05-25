Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P0XBog106072 for <xfs@oss.sgi.com>; Tue, 24 May 2011 19:33:11 -0500
Subject: Re: [PATCH 6/9] xfs: do not use unchecked extent indices in
	xfs_bunmapi
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110511150712.421348825@bombadil.infradead.org>
References: <20110511150402.258164661@bombadil.infradead.org>
	<20110511150712.421348825@bombadil.infradead.org>
Date: Tue, 24 May 2011 19:31:42 -0500
Message-ID: <1306283502.2823.95.camel@doink>
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
> Make sure to only call xfs_iext_get_ext after we've validate the extent index
> when moving on to the next index in xfs_bunmapi.  Also remove the old
> workaround for too large indices that has been superceeded by the proper
> fix in xfs_bmap_del_extent.
> 
> Based on an earlier patch from Lachlan McIlroy.

This looks good, but I'd like to see this patch and
patch 3/9 re-done to more cleanly separate their
purposes (as I mentioned in my comments on patch 3).

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
