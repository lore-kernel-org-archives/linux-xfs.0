Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BJ4cYN017945 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 14:04:38 -0500
Subject: Re: [PATCH 11/11] xfs: do not flush data workqueues in
	xfs_flush_buftarg
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111010165328.386947740@bombadil.infradead.org>
References: <20111010165242.656850411@bombadil.infradead.org>
	<20111010165328.386947740@bombadil.infradead.org>
Date: Tue, 11 Oct 2011 14:04:31 -0500
Message-ID: <1318359871.2824.3.camel@doink>
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

On Mon, 2011-10-10 at 12:52 -0400, Christoph Hellwig wrote:
> When we call xfs_flush_buftarg (generally from sync or umount) it already
> is too late to flush the data workqueues, as I/O completion is signalled
> for them and we are thus already done with the data we would flush here.
> 
> There are places where flushing them might be useful, but the current
> sync interface doesn't give us that opportunity.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
