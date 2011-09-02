Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82MN76p092458 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 17:23:07 -0500
Subject: Re: [PATCH 03/25] xfs: remove the nextents variable in xfs_bmapi
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060640.860409169@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060640.860409169@bombadil.infradead.org>
Date: Fri, 2 Sep 2011 17:23:06 -0500
Message-ID: <1315002186.2069.83.camel@doink>
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
> Instead of using a local variable that needs to updated when we modify
> the extent map just check ifp->if_bytes directly where we use it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
