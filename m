Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3DJQZ9g210012 for <xfs@oss.sgi.com>; Wed, 13 Apr 2011 14:26:35 -0500
Subject: Re: [PATCH 1/2] bdi: mark the bdi flusher busy when being forked
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1302157196-1988-2-git-send-email-david@fromorbit.com>
References: <1302157196-1988-1-git-send-email-david@fromorbit.com>
	<1302157196-1988-2-git-send-email-david@fromorbit.com>
Date: Wed, 13 Apr 2011 14:29:23 -0500
Message-ID: <1302722963.2023.66.camel@doink>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2011-04-07 at 16:19 +1000, Dave Chinner wrote: 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Recetn attempts to use writeback_inode_sb_nr_if_idle() in XFs from
> memory reclaim context have caused deadlocks because memory reclaim
> call be called from a failed allocation during forking a flusher
> thread. The shrinker then attempts to trigger writeback and the bdi
> is considered idle because writeback is not in progress yet and then
> deadlocks because bdi_queue_work() blocks waiting for the
> BDI_Pending bit to clear which will never happen because it needs
> the fork to complete.
> 
> To avoid this deadlock, consider writeback to be in progress if the
> flusher thread is being created. This prevents reclaim from blocking
> waiting for it be forked and hence avoids the deadlock.

I don't believe it matters, but BDI_pending is also set
while a writeback flusher thread is being shut down.

In any case, a handy use of that flag bit.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
