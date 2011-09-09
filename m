Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89NwTUr066686 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 18:58:29 -0500
Subject: Re: [PATCH 22/25] xfs: pass bmalloca to xfs_bmap_add_extent_delay_real
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060645.290805402@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060645.290805402@bombadil.infradead.org>
Date: Fri, 9 Sep 2011 18:56:31 -0500
Message-ID: <1315612591.1999.138.camel@doink>
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

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> All the parameters passed to xfs_bmap_add_extent_delay_real() are in the
> xfs_bmalloca structure now. Just pass the bmalloca parameter to the
> function instead of 8 separate parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  Maybe xfs_bmalloca field "got" could be renamed
but I can't think of a good one.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
