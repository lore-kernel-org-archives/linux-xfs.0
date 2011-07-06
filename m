Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663vRSS065009 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:57:28 -0500
Subject: Re: [PATCH 25/27] xfs: return the buffer locked from
	xfs_buf_get_uncached
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094607.356791525@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094607.356791525@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 22:57:25 -0500
Message-ID: <1309924645.3381.50.camel@doink>
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

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> All other xfs_buf_get/read-like helpers return the buffer locked, make sure
> xfs_buf_get_uncached isn't different for no reason.  Half of the callers
> already lock it directly after, and the others probably should also keep
> it locked if only for consistency and beeing able to use xfs_buf_rele,
> but I'll leave that for later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
