Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DB6nTd167999 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 06:06:49 -0500
Subject: Re: [PATCH 2/2] xfstests: split mapped writes vs direct I/O tests
	from 091
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111010182216.GA1335@infradead.org>
References: <20111010182156.GA1323@infradead.org>
	<20111010182216.GA1335@infradead.org>
Date: Thu, 13 Oct 2011 06:06:42 -0500
Message-ID: <1318504002.3172.28.camel@doink>
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

On Mon, 2011-10-10 at 14:22 -0400, Christoph Hellwig wrote:
> This effectively reverts
> 
> 	xfstests: add mapped write fsx operations to 091
> 
> and adds a new test case for it.  It tests something slightly different, and
> regressions in existing tests due to new features are pretty nasty in a
> test suite.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  I see no need to re-post just to delete
the "author" line.  Do that as a separate commit that
updates all the tests at once.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
