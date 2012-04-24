Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3OJbhW1105138 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 14:37:43 -0500
Message-ID: <4F970107.6090801@sgi.com>
Date: Tue, 24 Apr 2012 14:37:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 33/37] xfs: move xfs_do_force_shutdown() and kill xfs_rw.c
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-34-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-34-git-send-email-david@fromorbit.com>
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

On 04/23/12 00:59, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> xfs-do-force_shutdown now is the only thing in xfs_rw.c. There is no
> need to keep it in it's own file anymore, so move it to xfs_fsops.c
> next to xfs_fs_goingdown() and kill xfs_rw.c.
>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
