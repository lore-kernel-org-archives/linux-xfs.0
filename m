Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A0F187F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 12:59:17 -0500 (CDT)
Message-ID: <513E1B76.2090808@sgi.com>
Date: Mon, 11 Mar 2013 12:59:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Remove obsoleted m_inode_shrink from xfs_mount
	structure
References: <513D7A26.3030401@oracle.com>
In-Reply-To: <513D7A26.3030401@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: dchinner@redhat.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 03/11/13 01:31, Jeff Liu wrote:
> Looks the old m_inode_shrink is obsoleted as we perform inodes reclaim per AG via
> m_reclaim_workqueue, this patch remove it from the xfs_mount structure if so.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Cc: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_mount.h |    1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index bc90706..687c171 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -207,7 +207,6 @@ typedef struct xfs_mount {
>   						     trimming */
>   	__int64_t		m_update_flags;	/* sb flags we need to update
>   						   on the next remount,rw */
> -	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
>   	int64_t			m_low_space[XFS_LOWSP_MAX];
>   						/* low free space thresholds */
>

Obsoleted in commit:

commit 8daaa83145ef1f0a146680618328dbbd0fa76939
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jul 8 14:14:46 2011 +1000

     xfs: make use of new shrinker callout for the inode cache

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
