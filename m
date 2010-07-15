Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FI4XQW216224 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 13:04:33 -0500
Subject: Re: [PATCH 2/5] xfs: simplify and remove xfs_ireclaim
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1279154300-2018-3-git-send-email-david@fromorbit.com>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-3-git-send-email-david@fromorbit.com>
Date: Thu, 15 Jul 2010 13:07:27 -0500
Message-ID: <1279217247.2054.32.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2010-07-15 at 10:38 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_ireclaim has to get and put te pag structure because it is only
> called with the inode to reclaim. The one caller of this function
> already has a reference on the pag and a pointer to is, so move the
> radix tree delete to the caller and remove xfs_ireclaim completely.
> This avoids a xfs_perag_get/put on every inode being reclaimed.
> 
> The overhead was noticed in a bug report at:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16348

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_sync.c |   31 ++++++++++++++++++++++++-
>  fs/xfs/xfs_iget.c           |   53 +------------------------------------------
>  fs/xfs/xfs_inode.h          |    2 +-
>  3 files changed, 32 insertions(+), 54 deletions(-)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
