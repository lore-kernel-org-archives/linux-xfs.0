Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UB6gZT184171 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 06:06:42 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2rEGyr1GTY9YY8OR for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 04:07:34 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1T72az-0003ku-G5
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 21:07:33 +1000
Date: Thu, 30 Aug 2012 21:07:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/13] xfs: remove xfs_iget.c
Message-ID: <20120830110733.GD15292@dastard>
References: <1346324262-32724-1-git-send-email-david@fromorbit.com>
	<1346324262-32724-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1346324262-32724-14-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Thu, Aug 30, 2012 at 08:57:42PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode cache functions remaining in xfs_iget.c can be moved to xfs_icache.c
> along with the other inode cache functions. This removes all functionality from
> xfs_iget.c, so the file can simply be removed.
> 
> This move results in various functions now only having the scope of a single
> file (e.g. xfs_inode_free()), so clean up all the definitions and exported
> prototypes in xfs_icache.[ch] and xfs_inode.h appropriately.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile     |    1 -
>  fs/xfs/xfs_icache.c |  421 ++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_icache.h |    6 +-
>  fs/xfs/xfs_iget.c   |  455 ---------------------------------------------------
>  fs/xfs/xfs_inode.h  |   10 +-
>  5 files changed, 423 insertions(+), 470 deletions(-)
>  delete mode 100644 fs/xfs/xfs_iget.c

Oh, it looks like I forgot to refresh this patch before sending it.
I'll resend the series in a short while with the smoke fix in it as
well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
