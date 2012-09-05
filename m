Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q854YKLO232829 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 23:34:20 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2ONEihmrw5JHvvTx for <xfs@oss.sgi.com>;
	Tue, 04 Sep 2012 21:35:17 -0700 (PDT)
Date: Wed, 5 Sep 2012 14:35:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/13] xfs: sync work is now only periodic log work
Message-ID: <20120905043516.GF15292@dastard>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-6-git-send-email-david@fromorbit.com>
	<50464F22.2030308@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50464F22.2030308@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 04, 2012 at 01:57:38PM -0500, Mark Tinguely wrote:
> On 08/30/12 07:00, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >The only thing the periodic sync work does now is flush the AIL and
> >idle the log. These are really functions of the log code, so move
> >the work to xfs_log.c and rename it appropriately.
> >
> >The only wart that this leaves behind is the xfssyncd_centisecs
> >sysctl, otherwise the xfssyncd is dead. Clean up any comments that
> >related to xfssyncd to reflect it's passing.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> ...
> 
> >
> >diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> >index 7f4f937..598f279 100644
> >--- a/fs/xfs/xfs_log.c
> >+++ b/fs/xfs/xfs_log.c
> >@@ -34,6 +34,7 @@
> >  #include "xfs_dinode.h"
> >  #include "xfs_inode.h"
> >  #include "xfs_trace.h"
> >+#include "xfs_fsops.h"
> >
> >  kmem_zone_t	*xfs_log_ticket_zone;
> >
> >@@ -698,6 +699,8 @@ xfs_log_mount_finish(xfs_mount_t *mp)
> >  		ASSERT(mp->m_flags&  XFS_MOUNT_RDONLY);
> >  	}
> >
> 
> Looking at this closer, shouldn't there be a check for recovery
> failure. If it did, the mount will stop:
> 
> 	if (!error)
> 
> >+	xfs_log_work_queue(mp);
> >+
> >  	return error;

Probably should, but the error handling for a xfs_log_mount_finish()
failure calls xfs_log_unmount() and that shuts down the worker
correctly even if this failure occurs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
