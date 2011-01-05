Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p051r7Hq074519 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 19:53:08 -0600
Subject: Re: [PATCH 8/8] xfs: serialise unaligned direct IOs
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294116518-14908-9-git-send-email-david@fromorbit.com>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-9-git-send-email-david@fromorbit.com>
Date: Tue, 04 Jan 2011 19:55:15 -0600
Message-ID: <1294192515.2485.729.camel@doink>
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

On Tue, 2011-01-04 at 15:48 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When two concurrent unaligned, non-overlapping direct IOs are issued
> to the same block, the direct Io layer will race to zero the block.
> The result is that one of the concurrent IOs will overwrite data
> written by the other IO with zeros. This is demonstrated by the
> xfsqa test 240.
> 
> To avoid this problem, serialise all unaligned direct IOs to an
> inode with a big hammer. We need a big hammer approach as we need to
> serialise AIO as well, so we can't just block writes on locks.
> Hence, the big hammer is calling xfs_ioend_wait() while holding out
> other unaligned direct IOs from starting.
> 
> We don't bother trying to serialised aligned vs unaligned IOs as
> they are overlapping IO and the result of concurrent overlapping IOs
> is undefined - the result of either IO is a valid result so we let
> them race. Hence we only penalise unaligned IO, which already has a
> major overhead compared to aligned IO so this isn't a major problem.

Wow, after the rest of this series it gets easy!
Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_file.c |   28 ++++++++++++++++++++++++----
>  1 files changed, 24 insertions(+), 4 deletions(-)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
