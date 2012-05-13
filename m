Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4DKpZ2c033905 for <xfs@oss.sgi.com>; Sun, 13 May 2012 15:51:35 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id qm7NFiwGUVgkAo3O
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 13 May 2012 13:51:34 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so6408942pbb.26
	for <xfs@oss.sgi.com>; Sun, 13 May 2012 13:51:34 -0700 (PDT)
Date: Sun, 13 May 2012 13:51:18 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
Subject: [PATCH 2/2] xfs: hole-punch retaining cache beyond
In-Reply-To: <alpine.LSU.2.00.1205131347120.1547@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1205131350150.1547@eggly.anvils>
References: <alpine.LSU.2.00.1205131347120.1547@eggly.anvils>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

xfs has a very inefficient hole-punch implementation, invalidating all
the cache beyond the hole (after flushing dirty back to disk, from which
all must be read back if wanted again).  So if you punch a hole in a
file mlock()ed into userspace, pages beyond the hole are inadvertently
munlock()ed until they are touched again.

Is there a strong internal reason why that has to be so on xfs?
Or is it just a relic from xfs supporting XFS_IOC_UNRESVSP long
before Linux 2.6.16 provided truncate_inode_pages_range()?

If the latter, then this patch mostly fixes it, by passing the proper
range to xfs_flushinval_pages().  But a little more should be done to
get it just right: a partial page on either side of the hole is still
written back to disk, invalidated and munlocked.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 fs/xfs/xfs_vnodeops.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- next-20120511/fs/xfs/xfs_vnodeops.c	2012-05-11 00:22:26.095158149 -0700
+++ linux/fs/xfs/xfs_vnodeops.c	2012-05-12 18:01:14.988654723 -0700
@@ -2040,7 +2040,8 @@ xfs_free_file_space(
 	xfs_fsblock_t		firstfsb;
 	xfs_bmap_free_t		free_list;
 	xfs_bmbt_irec_t		imap;
-	xfs_off_t		ioffset;
+	xfs_off_t		startoffset;
+	xfs_off_t		endoffset;
 	xfs_extlen_t		mod=0;
 	xfs_mount_t		*mp;
 	int			nimap;
@@ -2074,11 +2075,18 @@ xfs_free_file_space(
 		inode_dio_wait(VFS_I(ip));
 	}
 
+	/*
+	 * Round startoffset down and endoffset up: we write out any dirty
+	 * blocks in between before truncating, so we can read partial blocks
+	 * back from disk afterwards (but that may munlock the partial pages).
+	 */
 	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
-	ioffset = offset & ~(rounding - 1);
+	startoffset = round_down(offset, rounding);
+	endoffset = round_up(offset + len, rounding) - 1;
 
 	if (VN_CACHED(VFS_I(ip)) != 0) {
-		error = xfs_flushinval_pages(ip, ioffset, -1, FI_REMAPF_LOCKED);
+		error = xfs_flushinval_pages(ip, startoffset, endoffset,
+							FI_REMAPF_LOCKED);
 		if (error)
 			goto out_unlock_iolock;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
