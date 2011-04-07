Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p37LDUXF130780 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 16:13:30 -0500
Subject: Re: [PATCH 7/9] xfs: push the AIL from memory reclaim and periodic
	sync
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1302141445-27457-8-git-send-email-david@fromorbit.com>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
	<1302141445-27457-8-git-send-email-david@fromorbit.com>
Date: Thu, 07 Apr 2011 16:16:40 -0500
Message-ID: <1302211000.2576.607.camel@doink>
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

On Thu, 2011-04-07 at 11:57 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we are short on memory, we want to expedite the cleaning of
> dirty objects.  Hence when we run short on memory, we need to kick
> the AIL flushing into action to clean as many dirty objects as
> quickly as possible.  To implement this, sample the lsn of the log
> item at the head of the AIL and use that as the push target for the
> AIL flush.
> 
> Further, we keep items in the AIL that are dirty that are not
> tracked any other way, so we can get objects sitting in the AIL that
> don't get written back until the AIL is pushed. Hence to get the
> filesystem to the idle state, we might need to push the AIL to flush
> out any remaining dirty objects sitting in the AIL. This requires
> the same push mechanism as the reclaim push.
> 
> This patch also renames xfs_trans_ail_tail() to xfs_ail_min_lsn() to
> match the new xfs_ail_max_lsn() function introduced in this patch.
> Similarly for xfs_trans_ail_push -> xfs_ail_push.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks OK to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
