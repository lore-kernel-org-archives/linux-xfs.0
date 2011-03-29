Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2TJ1OQ5243774 for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 14:01:25 -0500
Subject: Re: [PATCH 3/5] xfs: exact busy extent tracking
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110328210914.996696705@bombadil.infradead.org>
References: <20110328210614.832613417@bombadil.infradead.org>
	<20110328210914.996696705@bombadil.infradead.org>
Date: Tue, 29 Mar 2011 14:04:22 -0500
Message-ID: <1301425462.3026.245.camel@doink>
Mime-Version: 1.0
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

On Mon, 2011-03-28 at 17:06 -0400, Christoph Hellwig wrote:
> Update the extent tree in case we have to reuse a busy extent, so that it
> always is kept uptodate.  This is done by replacing the busy list searches
> with a new xfs_alloc_busy_reuse helper, which updates the busy extent tree
> in case of a reuse.   Also replace setting transactions to sync with forcing
> the log out in case we found a busy extent to reuse.  This makes the code a
> lot more simple, and is required for discard support later on.  While it
> will cause performance regressios with just this patch applied, the impact
> is more than mitigated by the next patch in the series.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  xfs_alloc_busy_update_extent() is a better name
than xfs_alloc_buisy_try_reuse() was.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
