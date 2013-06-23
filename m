Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4827F7F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 18:15:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D99ECAC002
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 16:14:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JDW57fnZaHvTS7mz for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 16:14:58 -0700 (PDT)
Date: Mon, 24 Jun 2013 09:14:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Remove dead function prototype xfs_sync_inode_grab()
Message-ID: <20130623231457.GE29376@dastard>
References: <51C4577B.2080208@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C4577B.2080208@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jun 21, 2013 at 09:39:07PM +0800, Jeff Liu wrote:
> rom: Jie Liu <jeff.liu@oracle.com>

From?

> 
> Remove dead function prototype xfs_sync_inode_grab() from
> xfs_icache.h.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_icache.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index e0f138c..a01afbb 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -40,7 +40,6 @@ void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
>  int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
>  void xfs_eofblocks_worker(struct work_struct *);
>  
> -int xfs_sync_inode_grab(struct xfs_inode *ip);
>  int xfs_inode_ag_iterator(struct xfs_mount *mp,
>  	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag,
>  		int flags, void *args),

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
