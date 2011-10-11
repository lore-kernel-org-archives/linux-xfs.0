Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9B44Fwa226878 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 23:04:15 -0500
Subject: Re: [PATCH 11/11] xfs: do not flush data workqueues in
	xfs_flush_buftarg
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111010165328.386947740@bombadil.infradead.org>
References: <20111010165242.656850411@bombadil.infradead.org>
	<20111010165328.386947740@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 23:04:14 -0500
Message-ID: <1318305854.3804.4.camel@doink>
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
> plain text document attachment
> (xfs-stop-flushing-data-wqs-in-xfs_flush_buftarg)
> When we call xfs_flush_buftarg (generally from sync or umount) it already
> is too late to flush the data workqueues, as I/O completion is signalled
> for them and we are thus already done with the data we would flush here.
> 
> There are places where flushing them might be useful, but the current
> sync interface doesn't give us that opportunity.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks fine to me for now but I'm going to review it
again in the morning.  I'll be testing with it overnight
though.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
