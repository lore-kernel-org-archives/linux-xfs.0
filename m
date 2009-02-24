Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OK8CCF163505 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 14:08:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A225514C836
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 12:07:42 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id pvE49J4h6UCBMl6h for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 12:07:42 -0800 (PST)
Date: Tue, 24 Feb 2009 15:07:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: next-20090220: XFS: inconsistent lock state
Message-ID: <20090224200740.GA9266@infradead.org>
References: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com>
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
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Feb 20, 2009 at 08:52:59PM +0300, Alexander Beregalov wrote:
> Hi
> 
> [ INFO: inconsistent lock state ]
> 2.6.29-rc5-next-20090220 #2
> ---------------------------------
> inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
> kswapd0/324 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&(&ip->i_lock)->mr_lock){+++++?}, at: [<ffffffff803ca60a>]
> xfs_ilock+0xaa/0x120
> {RECLAIM_FS-ON-W} state was registered at:

That's a false positive.  While the ilock can be taken in reclaim the
allocation here is done before the inode is added to the inode cache.

The patch below should help avoiding the warning:


Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2009-02-24 20:56:00.716027739 +0100
+++ xfs/fs/xfs/xfs_iget.c	2009-02-24 20:56:46.089031360 +0100
@@ -246,9 +246,6 @@ xfs_iget_cache_miss(
 		goto out_destroy;
 	}
 
-	if (lock_flags)
-		xfs_ilock(ip, lock_flags);
-
 	/*
 	 * Preload the radix tree so we can insert safely under the
 	 * write spinlock. Note that we cannot sleep inside the preload
@@ -259,6 +256,15 @@ xfs_iget_cache_miss(
 		goto out_unlock;
 	}
 
+	/*
+	 * Because the inode hasn't been added to the radix-tree yet it can't
+	 * be found by another thread, so we can do the non-sleeping lock here.
+	 */
+	if (lock_flags) {
+		if (!xfs_ilock_nowait(ip, lock_flags))
+			BUG();
+	}
+
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = agino & mask;
 	write_lock(&pag->pag_ici_lock);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
