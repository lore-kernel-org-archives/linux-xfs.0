Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82MN6Zp092450 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 17:23:06 -0500
Subject: Re: [PATCH 02/25] xfs: remove impossible to read code in
	xfs_bmap_add_extent_delay_real
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060640.625806258@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060640.625806258@bombadil.infradead.org>
Date: Fri, 2 Sep 2011 17:23:02 -0500
Message-ID: <1315002182.2069.82.camel@doink>
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
> We already have the worst case blocks reserved, so xfs_icsb_modify_counters
> won't fail in xfs_bmap_add_extent_delay_real.  In fact we've had an assert
> to catch this case since day and it never triggered.  So remove the code
> to try smaller reservations, and just return the error for that case in
> addition to keeping the assert.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It was a very weird block of code that I never did
really understand.  It appears to be trying to recover
from running out of space by reserving less and
retrying.  But that means you're not reserving enough
to cover worst case, which wouldn't be safe.

Anyway, given this function already has an error
return path that could handle it if we actually
had not pre-reserved enough blocks, this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
