Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p81JMmZX035231 for <xfs@oss.sgi.com>; Thu, 1 Sep 2011 14:22:48 -0500
Subject: Re: [PATCH 09/11] xfs: reduce ioend latency
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110823082913.453050111@bombadil.infradead.org>
References: <20110823082802.335389799@bombadil.infradead.org>
	<20110823082913.453050111@bombadil.infradead.org>
Date: Thu, 1 Sep 2011 14:22:44 -0500
Message-ID: <1314904964.2903.68.camel@doink>
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
> There is no reason to queue up ioends for processing in user context
> unless we actually need it.  Just complete ioends that do not convert
> unwritten extents or need a size update from the end_io context.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
