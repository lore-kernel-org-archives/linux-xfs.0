Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84G9KqZ121113 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 11:09:20 -0500
Message-ID: <504627E6.4000208@sgi.com>
Date: Tue, 04 Sep 2012 11:10:14 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/13] xfs: xfs_syncd_stop must die
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-2-git-send-email-david@fromorbit.com>
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
> xfs_syncd_start and xfs_syncd_stop tie a bunch of unrelated
> functionailty together that actually have different start and stop
> requirements. Kill these functions and open code the start/stop
> methods for each of the background functions.
>
> Subsequent patches will move the start/stop functions around to the
> correct places to avoid races and shutdown issues.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
