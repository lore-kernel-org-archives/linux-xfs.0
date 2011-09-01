Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p81JMVS6035168 for <xfs@oss.sgi.com>; Thu, 1 Sep 2011 14:22:31 -0500
Subject: Re: [PATCH 05/11] xfs: let xfs_bwrite callers handle the xfs_buf_relse
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110823082912.696841224@bombadil.infradead.org>
References: <20110823082802.335389799@bombadil.infradead.org>
	<20110823082912.696841224@bombadil.infradead.org>
Date: Thu, 1 Sep 2011 14:22:27 -0500
Message-ID: <1314904947.2903.63.camel@doink>
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

On Tue, 2011-08-23 at 04:28 -0400, Christoph Hellwig wrote:
> Remove the xfs_buf_relse from xfs_bwrite and let the caller handle it to
> mirror the delwri and read paths.
> 
> Also remove the mount pointer passed to xfs_bwrite, which is superflous now
> that we have a mount pointer in the buftarg.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.  In once case you may have fixed a bug
where the buffer pointer was used despite its last
reference being dropped.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
