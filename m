Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBEKLGVo147357 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 14:21:16 -0600
Received: from e1.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C40E4144EF8E
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 12:23:08 -0800 (PST)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141]) by
	cuda.sgi.com with ESMTP id DlaVZqnloncf2kMC for
	<xfs@oss.sgi.com>; Tue, 14 Dec 2010 12:23:08 -0800 (PST)
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id oBEKEPjT029168
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 15:14:51 -0500
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 298F04DE8047
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 15:21:02 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	oBEKN6YC2138202
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 15:23:06 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	oBEKN5eU032025 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 15:23:06 -0500
Date: Tue, 14 Dec 2010 12:23:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] xfs: rcu free inodes
Message-ID: <20101214202301.GG2161@linux.vnet.ibm.com>
References: <1292203957-15819-1-git-send-email-david@fromorbit.com>
	<1292203957-15819-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292203957-15819-2-git-send-email-david@fromorbit.com>
Reply-To: paulmck@linux.vnet.ibm.com
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
Cc: eric.dumazet@gmail.com, xfs@oss.sgi.com

On Mon, Dec 13, 2010 at 12:32:35PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce RCU freeing of XFS inodes so that we can convert lookup
> traversals to use rcu_read_lock() protection. This patch only
> introduces the RCU freeing to minimise the potential conflicts with
> mainline if this is merged into mainline via a VFS patchset. It
> abuses the i_dentry list for the RCU callback structure because the
> VFS patches make this a union so it is safe to use like this and
> simplifies and merge issues.
> 
> This patch uses basic RCU freeing rather than SLAB_DESTROY_BY_RCU.
> The later lookup patches need the same "found free inode" protection
> regardless of the RCU freeing method used, so once again the RCU
> freeing method can be dealt with apprpriately at merge time without
> affecting any other code.

There are only two call sites that free into xfs_inode_zone.  One of them
is initialization, before readers have access to the data strcuture,
and the other is covered by this patch.  So looks good to me!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iget.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> index cdb1c25..9fae475 100644
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -105,6 +105,18 @@ xfs_inode_alloc(
>  }
> 
>  void
> +__xfs_inode_free(
> +	struct rcu_head		*head)
> +{
> +	struct inode		*inode = container_of((void *)head,
> +							struct inode, i_dentry);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +
> +	INIT_LIST_HEAD(&inode->i_dentry);
> +	kmem_zone_free(xfs_inode_zone, ip);
> +}
> +
> +void
>  xfs_inode_free(
>  	struct xfs_inode	*ip)
>  {
> @@ -147,7 +159,7 @@ xfs_inode_free(
>  	ASSERT(!spin_is_locked(&ip->i_flags_lock));
>  	ASSERT(completion_done(&ip->i_flush));
> 
> -	kmem_zone_free(xfs_inode_zone, ip);
> +	call_rcu((struct rcu_head *)&VFS_I(ip)->i_dentry, __xfs_inode_free);
>  }
> 
>  /*
> -- 
> 1.7.2.3
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
