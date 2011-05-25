Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P1FCIM107343 for <xfs@oss.sgi.com>; Tue, 24 May 2011 20:15:12 -0500
Subject: Re: [PATCH 2/9 v2] xfs: remove if_lastex
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110523085253.GA15985@infradead.org>
References: <20110511150402.258164661@bombadil.infradead.org>
	<20110511150711.549194744@bombadil.infradead.org>
	<20110523085253.GA15985@infradead.org>
Date: Tue, 24 May 2011 20:14:27 -0500
Message-ID: <1306286067.2823.111.camel@doink>
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

On Mon, 2011-05-23 at 04:52 -0400, Christoph Hellwig wrote:
> The if_lastex field in struct xfs_ifork is only used as a temporary index
> during xfs_bmapi and xfs_bunmapi.  Instead of using the inode fork to store
> it keep it local in the callchain.  Fortunately this is very easy as
> we already pass a stack copy of it down the whole chain which can simplify
> be changed to be passed by reference.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
