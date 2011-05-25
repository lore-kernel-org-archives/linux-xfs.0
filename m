Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P0X83t106051 for <xfs@oss.sgi.com>; Tue, 24 May 2011 19:33:08 -0500
Subject: Re: [PATCH 4/9] xfs: do not use unchecked extent indices in
	xfs_bmap_add_extent_*
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110511150711.989383617@bombadil.infradead.org>
References: <20110511150402.258164661@bombadil.infradead.org>
	<20110511150711.989383617@bombadil.infradead.org>
Date: Tue, 24 May 2011 19:30:49 -0500
Message-ID: <1306283449.2823.93.camel@doink>
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
> in the various xfs_bmap_add_extent_* helpers.
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
