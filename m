Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9D9w4n5162852 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 04:58:04 -0500
Subject: Re: [PATCH 4/5] repair: don't cache large blkmap allocations
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1318208915-14975-5-git-send-email-david@fromorbit.com>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
	<1318208915-14975-5-git-send-email-david@fromorbit.com>
Date: Thu, 13 Oct 2011 04:57:57 -0500
Message-ID: <1318499877.3172.12.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-10-10 at 12:08 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently use thread local storage for storing blkmap allocations
> from one inode to another as a way of reducing the number of short
> term allocations we do. However, the stored allocations can only
> ever grow, so once we've done a large allocation we never free than
> memory even if we never need that much memory again. This can occur
> if we have corrupted extent counts in inodes, and can greatly
> increase the memory footprint of the repair process.
> 
> Hence if the cached blkmap array id greater than a reasonable number
> of extents (say 100,000), then don't store the blkmap in TLS and
> instead free it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
