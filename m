Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BMYdVa256371 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 17:34:39 -0500
Subject: Re: [PATCH 09/11] xfs: remove the dead QUOTADEBUG debug
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110710205018.525481665@bombadil.infradead.org>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205018.525481665@bombadil.infradead.org>
Date: Mon, 11 Jul 2011 17:33:22 -0500
Message-ID: <1310423602.7019.62.camel@doink>
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

On Sun, 2011-07-10 at 16:49 -0400, Christoph Hellwig wrote:
> Remove the dead hash table test rid which has been rotting away under
> QUOTADEBUG, including some code that was compiled for normal debug
> builds, but not actually called without QUOTADEBUG, and enable a few
> cheap debug checks that were hidden under QUOTADEBUG for normal
> debug builds.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I've never used it and I don't suppose anyone else has
been (or will any time soon).  So I guess it might as
well go.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
