Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7RIBKVA105962 for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 13:11:20 -0500
Subject: Re: [PATCH 2/2] xfs: improve buffer cache hash scalability
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1282522546-7892-3-git-send-email-david@fromorbit.com>
References: <1282522546-7892-1-git-send-email-david@fromorbit.com>
	<1282522546-7892-3-git-send-email-david@fromorbit.com>
Date: Fri, 27 Aug 2010 13:11:53 -0500
Message-ID: <1282932713.2450.75.camel@doink>
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

On Mon, 2010-08-23 at 10:15 +1000, Dave Chinner wrote:
> When doing large parallel file creates on a 16p machines, large amounts of
> time is being spent in _xfs_buf_find(). A system wide profile with perf top
> shows this:
> 
>           1134740.00 19.3% _xfs_buf_find
>            733142.00 12.5% __ticket_spin_lock
> 
> The problem is that the hash contains 45,000 buffers, and the hash table width
> is only 256 buffers. That means we've got around 200 buffers per chain, and
> searching it is quite expensive. The hash table size needs to increase.

My only comment on this is that 4096 buckets is
good now but someday that may not be right either.
Is there any better way (based on size of underlying
block_device and maybe taking into account other things
like page size or CPU count) to decide this hash size?

Either way it looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
