Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM9XJpp132404 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 03:33:20 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53492162CE04
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 01:33:18 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	16o0WhpCdgWiGEOU for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 01:33:18 -0800 (PST)
Date: Tue, 22 Nov 2011 20:33:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] 198, 240: check presence of aiodio_sparce2
Message-ID: <20111122093316.GB8098@dastard>
References: <4ECB3DCA.5000509@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ECB3DCA.5000509@jp.fujitsu.com>
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
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Nov 22, 2011 at 03:14:34PM +0900, Hidetoshi Seto wrote:
> Use same trick with:
>   commit 4e9072472fbc56b9d4c8ee8094cc62ce793df9b7
>   Gracefully fail aio tests if they weren't built

Good idea, but given this check is now repeated in multiple places,
wrapping it in a "_require_aiodio" helper function is probably in
order.

It might also be useful to define AIODIO_SPARSE and AIODIO_SPARSE2
variables (similar to, say, XFS_IO_PROG) so that it doesn't have to
be open coded in all the tests....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
