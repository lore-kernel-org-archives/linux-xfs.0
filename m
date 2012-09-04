Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84Iuj8t143963 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 13:56:45 -0500
Message-ID: <50464F22.2030308@sgi.com>
Date: Tue, 04 Sep 2012 13:57:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 05/13] xfs: sync work is now only periodic log work
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-6-git-send-email-david@fromorbit.com>
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
> The only thing the periodic sync work does now is flush the AIL and
> idle the log. These are really functions of the log code, so move
> the work to xfs_log.c and rename it appropriately.
>
> The only wart that this leaves behind is the xfssyncd_centisecs
> sysctl, otherwise the xfssyncd is dead. Clean up any comments that
> related to xfssyncd to reflect it's passing.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

...

>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7f4f937..598f279 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -34,6 +34,7 @@
>   #include "xfs_dinode.h"
>   #include "xfs_inode.h"
>   #include "xfs_trace.h"
> +#include "xfs_fsops.h"
>
>   kmem_zone_t	*xfs_log_ticket_zone;
>
> @@ -698,6 +699,8 @@ xfs_log_mount_finish(xfs_mount_t *mp)
>   		ASSERT(mp->m_flags&  XFS_MOUNT_RDONLY);
>   	}
>

Looking at this closer, shouldn't there be a check for recovery failure. 
If it did, the mount will stop:

	if (!error)

> +	xfs_log_work_queue(mp);
> +
>   	return error;
>   }

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
