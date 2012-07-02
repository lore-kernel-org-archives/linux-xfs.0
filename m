Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6207G8i139731 for <xfs@oss.sgi.com>; Sun, 1 Jul 2012 19:07:16 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sdSAcW9AUerZDvyY for <xfs@oss.sgi.com>;
	Sun, 01 Jul 2012 17:07:15 -0700 (PDT)
Date: Mon, 2 Jul 2012 10:07:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: re-enable xfsaild idle mode and fix associated
	races
Message-ID: <20120702000712.GN19223@dastard>
References: <1340880776-45730-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1340880776-45730-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 28, 2012 at 06:52:56AM -0400, Brian Foster wrote:
> xfsaild idle mode logic currently leads to a couple hangs:
> 
> 1.) If xfsaild is rescheduled in during an incremental scan
>     (i.e., tout != 0) and the target has been updated since
>     the previous run, we can hit the new target and go into
>     idle mode with a still populated ail.
> 2.) A wake up is only issued when the target is pushed forward.
>     The wake up can race with xfsaild if it is currently in the
>     process of entering idle mode, causing future wake up
>     events to be lost.
> 
> These hangs have been reproduced and verified as fixed by
> running xfstests 273 in a loop on a slightly modified upstream
> kernel. The kernel is modified to re-enable idle mode as
> previously implemented (when count == 0) and with a revert of
> commit 670ce93f, which includes performance improvements that
> make this harder to reproduce.
> 
> The solution, the algorithm for which has been outlined by
> Dave Chinner, is to modify xfsaild to enter idle mode only when
> the ail is empty and the push target has not been moved forward
> since the last push.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks OK to me, and hasn't caused any problems here.

Final question - did you confirm with powertop that the xfsaild is
no longer causing wakeups a minute or two after you stop writing to
the filesystem? (I haven't yet)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
