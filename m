Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84JAa20146418 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 14:10:36 -0500
Message-ID: <50465261.8010207@sgi.com>
Date: Tue, 04 Sep 2012 14:11:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/13] xfs: Bring some sanity to log unmounting
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-7-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/30/12 07:00, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> When unmounting the filesystem, there are lots of operations that
> need to be done in a specific order, and they are spread across
> across a couple of functions. We have to drain the AIL before we
> write the unmount record, and we have to shut down the background
> log work before we do either of them.
>
> But this is all split haphazardly across xfs_unmountfs() and
> xfs_log_unmount(). Move all the AIL flushing and log manipulations
> to xfs_log_unmount() so that the responisbilities of each function
> is clear and the operations they perform obvious.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
