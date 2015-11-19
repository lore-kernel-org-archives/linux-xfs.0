Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C92F829DF5
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 17:29:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BAC0E304039
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 15:29:05 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	97oVWISQAIqvuCRd for <xfs@oss.sgi.com>;
	Thu, 19 Nov 2015 15:28:59 -0800 (PST)
Date: Fri, 20 Nov 2015 10:24:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
Message-ID: <20151119232455.GM14311@dastard>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
> Naive implementation for non-mmu architectures: allocate physically
> contiguous xfs buffers with alloc_pages. Terribly inefficient with
> memory and fragmentation on high I/O loads but it may be good enough
> for basic usage (which most non-mmu architectures will need).

Can you please explain why you want to use XFS on low end, basic
non-MMU devices? XFS is a high performance, enterprise/HPC level
filesystem - it's not a filesystem designed for small IoT level
devices - so I'm struggling to see why we'd want to expend any
effort to make XFS work on such devices....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
