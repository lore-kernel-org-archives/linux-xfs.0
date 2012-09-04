Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84GD2tF121598 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 11:13:02 -0500
Message-ID: <504628C6.8020106@sgi.com>
Date: Tue, 04 Sep 2012 11:13:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/13] xfs: don't run the sync work if the filesyste is
	read-only
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-5-git-send-email-david@fromorbit.com>
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
> If the filesytem is mounted or remounted read-only, stop the sync
> worker that tries to flush or cover the log if the filesystem is
> dirty. It's read-only, so it isn't dirty. Restart it on a remount,rw
> as necessary. This avoids the need for RO checks in the work.
>
> Similarly, stop the sync work when the filesystem is frozen, and
> start it again when the filesysetm is thawed. This avoids the need
> for special freeze checks in the work.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
