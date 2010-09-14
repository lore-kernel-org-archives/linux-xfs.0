Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EMFK4A150620 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:15:20 -0500
Subject: Re: [PATCH 08/18] xfs: rename xfs_buf_get_nodaddr to be more
	appropriate
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-9-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-9-git-send-email-david@fromorbit.com>
Date: Tue, 14 Sep 2010 17:14:18 -0500
Message-ID: <1284502458.9701.91.camel@doink>
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

On Tue, 2010-09-14 at 20:56 +1000, Dave Chinner wrote:
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

This could be spun into its own patch (#19 or more).  But
I don't think it's that important.

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c   |    6 +++---
>  fs/xfs/linux-2.6/xfs_buf.h   |    2 +-

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
