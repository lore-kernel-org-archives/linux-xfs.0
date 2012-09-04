Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84L35jq161542 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 16:03:05 -0500
Message-ID: <50466CBE.9080207@sgi.com>
Date: Tue, 04 Sep 2012 16:03:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 09/13] xfs: move xfs_quiesce_attr() into xfs_super.c
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-10-git-send-email-david@fromorbit.com>
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
> Both callers of xfs_quiesce_attr() are in xfs_super.c, and there's
> nothing really sync-specific about this functionality so it doesn't
> really matter where it lives. Move it to benext to it's callers, so
> all the remount/sync_fs code is in the one place.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
