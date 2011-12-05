Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB55BxxD112156 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 23:11:59 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CA991F4144C
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 21:11:57 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aOtNPxK9eOodas3W for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 21:11:57 -0800 (PST)
Date: Mon, 5 Dec 2011 16:10:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/16] xfs: nest qm_dqfrlist_lock insise the dquot qlock
Message-ID: <20111205051055.GQ7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.977396280@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082837.977396280@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Nov 28, 2011 at 03:27:32AM -0500, Christoph Hellwig wrote:
> Allow xfs_qm_dqput to work without trylock loops by nesting the freelist lock
> inside the dquot qlock.  In turn that requires trylocks in the reclaim path
> instead, but given it's a classic tradeoff between fast and slow path, and
> we follow the model of the inode and dentry caches.

Funny how that keeps coming up ;)

> Document our new lock order now that it has settled.

Excellent.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Subject line has a type (insise).

> 
> ---
>  fs/xfs/xfs_dquot.c |   98 +++++++++++++++++++++--------------------------------
>  fs/xfs/xfs_qm.c    |    4 +-
>  2 files changed, 42 insertions(+), 60 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dquot.c	2011-11-25 11:45:53.348630228 +0100
> +++ xfs/fs/xfs/xfs_dquot.c	2011-11-25 11:56:08.655296826 +0100
> @@ -39,20 +39,19 @@
>  #include "xfs_qm.h"
>  #include "xfs_trace.h"
>  
> -
>  /*
> -   LOCK ORDER
> -
> -   inode lock		    (ilock)
> -   dquot hash-chain lock    (hashlock)
> -   xqm dquot freelist lock  (freelistlock
> -   mount's dquot list lock  (mplistlock)
> -   user dquot lock - lock ordering among dquots is based on the uid or gid
> -   group dquot lock - similar to udquots. Between the two dquots, the udquot
> -		      has to be locked first.
> -   pin lock - the dquot lock must be held to take this lock.
> -   flush lock - ditto.
> -*/
> + * Lock order:
> + *
> + * ip->i_lock
> + *   qh->qh_lock
> + *     qi->qi_dqlist_lock
> + *       dquot->q_qlock
> + *         dquot->q_flush
> + *         xfs_Gqm->qm_dqfrlist_lock
> + *
> + * If two dquots need to be locked the order is user before group/project,
> + * otherwise by the lowest id first, see xfs_dqlock2.

For the dquot->q_* locks, it might be worth adding the name of the
locking functions here so it is obvious when reading the code as
q_qlock and q_flush aren't used anywhere outside the locking
wrappers...

Otherwise looks sane.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
