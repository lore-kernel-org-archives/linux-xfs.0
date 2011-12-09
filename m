Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB97MJIA193343 for <xfs@oss.sgi.com>; Fri, 9 Dec 2011 01:22:20 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A317B1D38B6A
	for <xfs@oss.sgi.com>; Thu,  8 Dec 2011 23:17:03 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9MfACu1I6i5mx455 for <xfs@oss.sgi.com>;
	Thu, 08 Dec 2011 23:17:03 -0800 (PST)
Date: Fri, 9 Dec 2011 18:17:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: 277 new test to check freeze/unfreeze works
	well or not under heavy load.
Message-ID: <20111209071700.GD14273@dastard>
References: <20111209145231.5A5F.61FB500B@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111209145231.5A5F.61FB500B@jp.fujitsu.com>
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
To: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Fri, Dec 09, 2011 at 02:52:31PM +0900, Masayoshi MIZUMA wrote:
> Hi,
> 
> unfreeze function, thaw_super(), sometimes hangs up if flush kernel
> thread does writeback to the same filesystem concurrently.
> (the problem is reported at
>  http://marc.info/?l=linux-ext4&m=132339590004560&w=2)
> 
> This test runs freeze/unfreeze under heavy load. If the problem is
> reproduced, this test will hang up...

This is effectively a duplicate of test 068, which is currently
described as an XFS only test. It is actually generic now that
xfs_freeze works on other filesytsems, so please update 068
appropriately rather that introducing a new test.

Cheers,

Dave

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
