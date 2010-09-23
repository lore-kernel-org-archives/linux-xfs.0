Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NGLuhE135546 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 11:21:57 -0500
Subject: Re: [PATCH 05/16] xfs: rename xfs_buf_get_nodaddr to be more
	appropriate
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285137869-10310-6-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-6-git-send-email-david@fromorbit.com>
Date: Thu, 23 Sep 2010 11:22:50 -0500
Message-ID: <1285258970.1973.11.camel@doink>
Mime-Version: 1.0
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

On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_buf_get_nodaddr() is really used to allocate a buffer that is
> uncached. While it is not directly assigned a disk address, the fact
> that they are not cached is a more important distinction. With the
> upcoming uncached buffer read primitive, we should be consistent
> with this disctinction.
> 
> While there, make page allocation in xfs_buf_get_nodaddr() safe
> against memory reclaim re-entrancy into the filesystem by changing
> the allocation to GFP_NOFS.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
