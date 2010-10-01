Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o91DtqHf079848 for <xfs@oss.sgi.com>; Fri, 1 Oct 2010 08:55:52 -0500
Subject: Re: [PATCH 3/3] [PATCH 3/3] xfs: do not use
	xfs_mod_incore_sb_batch for per-cpu counters
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100930022601.566811585@bombadil.infradead.org>
References: <20100930022553.391390964@bombadil.infradead.org>
	<20100930022601.566811585@bombadil.infradead.org>
Date: Fri, 01 Oct 2010 08:56:51 -0500
Message-ID: <1285941411.5119.455.camel@doink>
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

On Wed, 2010-09-29 at 22:25 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-simplify-icsb-updates)
> Update the per-cpu counters manually in xfs_trans_unreserve_and_mod_sb and
> remove support for per-cpu counters from xfs_mod_incore_sb_batch to
> simplify it.  And added benefit is that we don't have to take m_sb_lock
> for transactions that only modify per-cpu counters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  I'll pull this series in today.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
