Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P2IsfN109480 for <xfs@oss.sgi.com>; Tue, 24 May 2011 21:18:54 -0500
Subject: Re: [PATCH 1/4] xfs: PF_FSTRANS should never be set in ->writepage
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110428130514.146517168@bombadil.infradead.org>
References: <20110428125546.696493391@bombadil.infradead.org>
	<20110428130514.146517168@bombadil.infradead.org>
Date: Tue, 24 May 2011 21:18:49 -0500
Message-ID: <1306289929.2823.120.camel@doink>
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

On Thu, 2011-04-28 at 08:55 -0400, Christoph Hellwig wrote:
> Now that we reject direct reclaim in addition to always using GFP_NOFS
> allocation there's no chance we'll ever end up in ->writepage with
> PF_FSTRANS set.  Add a WARN_ON if we hit this case, and stop checking
> if we'd actually need to start a transaction.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Do the radix_tree_preload(GFP_KERNEL) calls in
xfs_iget_cache_miss() and xfs_mru_cache_insert()
pose any risk here?  (I haven't really looked
closely, I just noticed that these were cases we
did not use GFP_NOFS.)

Outside of that, this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
