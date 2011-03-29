Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2TJ1O00243772 for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 14:01:24 -0500
Subject: Re: [PATCH 1/5] xfs: optimize AGFL refills
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110328210914.594997356@bombadil.infradead.org>
References: <20110328210614.832613417@bombadil.infradead.org>
	<20110328210914.594997356@bombadil.infradead.org>
Date: Tue, 29 Mar 2011 14:04:11 -0500
Message-ID: <1301425451.3026.243.camel@doink>
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
> While we need to make sure we do not reuse busy extents, there is no need
> to force out busy extents when moving them between the AGFL and the
> freespace btree as we still take care of that when doing the real allocation.
> 
> To avoid the log force when just moving extents from the different free
> space tracking structures, move the busy search out of
> xfs_alloc_get_freelist into the callers that need it, and move the busy
> list insert from xfs_free_ag_extent which is used both by AGFL refills
> and real allocation to xfs_free_extent, which is only used by the latter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
