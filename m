Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ELR9MW148893 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 16:27:09 -0500
Subject: Re: [PATCH 06/18] xfs: convert pag_ici_lock to a spin lock
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-7-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-7-git-send-email-david@fromorbit.com>
Date: Tue, 14 Sep 2010 16:26:59 -0500
Message-ID: <1284499619.9701.71.camel@doink>
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
> now that we are using RCU protection for the inode cache lookups,
> the lock is only needed on the modification side. Hence it is not
> necessary for the lock to be a rwlock as there are no read side
> holders anymore. Convert it to a spin lock to reflect it's exclusive
> nature.

This is of course contingent on the correctness of
the RCU change before this.  But this one looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_sync.c |   16 ++++++++--------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
