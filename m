Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pATJMfcD092917 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 13:22:41 -0600
Date: Tue, 29 Nov 2011 13:23:00 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/4] xfs fixes for Linux 3.2-rc3
Message-ID: <20111129192300.GW29840@sgi.com>
References: <20111128081732.350228200@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128081732.350228200@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:17:32AM -0500, Christoph Hellwig wrote:
> These are the patches that I think should still go into Linux 3.2.
> 
> The first two are fairly trivial fixes for crashes that can be reproduced
> by users action or filesystem corruption.  The third is a a fix for the
> hang reported by Simon, and although he hasn't tested the final variant
> yet I'm fairly confident it should fix it given we use the same pattern
> for dquots.

Yep.

> The last one is the biggest and fixes the log space hang
> first reported by Alex and then debugged by Chandra.

This last one is pretty big.  Could it wait for 3.3?

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
