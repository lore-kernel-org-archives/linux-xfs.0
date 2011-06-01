Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p51Nb65v155287 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 18:37:06 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D63C015DA73D
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 16:37:04 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	TD04AxuFan6eYecZ for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2011 16:37:04 -0700 (PDT)
Date: Thu, 2 Jun 2011 09:37:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20110601233702.GJ561@dastard>
References: <20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
	<20110120100143.GA2007@peter.simplex.ro>
	<20110120234310.GV16267@dastard>
	<20110210204254.GA10451@peter.simplex.ro>
	<20110210221851.GG2559@dastard>
	<loom.20110214T185310-606@post.gmane.org>
	<loom.20110531T163459-953@post.gmane.org>
	<4DE5064D.1010203@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DE5064D.1010203@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Tue, May 31, 2011 at 05:16:29PM +0200, Michael Weissenbacher wrote:
> Brian wrote:
> > 
> > Can anyone please comment if this bug was ever fixed?
> > 
> > I have searched and see no further talk about this.
> > 
> > echo 720000 > /proc/sys/fs/xfs/xfssyncd_centisecs allows a drive to sleep more
> > often, but still is impacted by this. 
> > 
> > Thanks!
> > 
> AFAICT nothing has changed in this regard. I sill see the same behavior
> with kernel 2.6.39. Thanks to this thread i found out about the problems
> related to accumulating head unloads which i was able to mitigate by
> setting xfssyncd_centisecs to a higher value.

commit fd074841cfe01b006465fb9388091012585e8dfb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Apr 8 12:45:07 2011 +1000

    xfs: push the AIL from memory reclaim and periodic sync

    When we are short on memory, we want to expedite the cleaning of
    dirty objects.  Hence when we run short on memory, we need to kick
    the AIL flushing into action to clean as many dirty objects as
    quickly as possible.  To implement this, sample the lsn of the log
    item at the head of the AIL and use that as the push target for the
    AIL flush.

    Further, we keep items in the AIL that are dirty that are not
    tracked any other way, so we can get objects sitting in the AIL that
    don't get written back until the AIL is pushed. Hence to get the
    filesystem to the idle state, we might need to push the AIL to flush
    out any remaining dirty objects sitting in the AIL. This requires
    the same push mechanism as the reclaim push.

    This patch also renames xfs_trans_ail_tail() to xfs_ail_min_lsn() to
    match the new xfs_ail_max_lsn() function introduced in this patch.
    Similarly for xfs_trans_ail_push -> xfs_ail_push.

    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Alex Elder <aelder@sgi.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
