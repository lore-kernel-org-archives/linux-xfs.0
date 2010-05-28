Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4SIl8eK236729 for <xfs@oss.sgi.com>; Fri, 28 May 2010 13:47:09 -0500
Subject: Re: [PATCH] xfs: fix access to upper inodes without inode64
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100527190515.GA16102@infradead.org>
References: <20100527190515.GA16102@infradead.org>
Date: Fri, 28 May 2010 13:49:00 -0500
Message-ID: <1275072540.2302.21.camel@doink>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 2010-05-27 at 15:05 -0400, Christoph Hellwig wrote:
> If a filesystem is mounted without the inode64 mount option we should still
> be able to access inodes not fitting into 32 bits, just not created new
> ones.  For this to work we need to make sure the inode cache radix tree
> is initialized for all allocation groups, not just those we plan to allocate
> inodes from.  This patch makes sure we initialize the inode cache radix
> tree for all allocation groups, and also cleans xfs_initialize_perag up
> a bit to separate the inode32 logical from the general perag structure
> setup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

One other thing:

> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c	2010-05-27 20:59:09.000000000 +0200
> +++ xfs/fs/xfs/xfs_inode.c	2010-05-27 20:59:43.315004399 +0200
> @@ -2624,7 +2624,6 @@ xfs_iflush_cluster(
>  	int			i;
>  
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> -	ASSERT(pag->pag_ici_init);

This doesn't apply in my tree, because it's missing this:
        ASSERT(pag->pagi_inodeok);

I believe that this missing assertion should be deleted
also, to go along with the purpose of this patch.

Again, I'll make this change myself before I commit;
let me know if you would like me not to.

					-Alex

>  
>  	inodes_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
>  	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
> 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
