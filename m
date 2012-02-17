Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HMpHB2115082 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 16:51:17 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id LAPyW23ZaJuhKXS6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 14:51:16 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1RyWe3-0001Yb-VL
	for xfs@oss.sgi.com; Fri, 17 Feb 2012 14:51:15 -0800
Message-ID: <33346009.post@talk.nabble.com>
Date: Fri, 17 Feb 2012 14:51:15 -0800 (PST)
From: kdasu <kdasu.kdev@gmail.com>
Subject: [PATCH 1/4] xfs: only lock the rt bitmap inode once per allocation
In-Reply-To: <33345988.post@talk.nabble.com>
MIME-Version: 1.0
References: <33345988.post@talk.nabble.com>
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


Currently both xfs_rtpick_extent and xfs_rtallocate_extent call
xfs_trans_iget to grab and lock the rt bitmap inode, which results in a
deadlock since the removal of the lock recursion counters in commit

        "xfs: simplify inode to transaction joining"

Fix this by acquiring and locking the inode in xfs_bmap_rtalloc before
calling into xfs_rtpick_extent and xfs_rtallocate_extent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
---
 fs/xfs/xfs_bmap.c    |   11 +++++++++++
 fs/xfs/xfs_rtalloc.c |   34 +++++++++++++---------------------
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 4111cd3..9d9970b 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2316,6 +2316,7 @@ xfs_bmap_rtalloc(
        xfs_extlen_t    prod = 0;       /* product factor for allocators */
        xfs_extlen_t    ralen = 0;      /* realtime allocation length */
        xfs_extlen_t    align;          /* minimum allocation alignment */
+       xfs_inode_t     *ip;            /* bitmap incore inode */
        xfs_rtblock_t   rtb;
kdasu@kdasu-VirtualBox:~/linux-2.6$ more
0001-xfs-only-lock-the-rt-bitmap-inode-once-per-allocatio.patch 
>From f59ab29cc191a5955c4d44c0b92a537f981184c2 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 25 Jan 2011 09:06:19 +0000
Subject: [PATCH 1/4] xfs: only lock the rt bitmap inode once per allocation

Currently both xfs_rtpick_extent and xfs_rtallocate_extent call
xfs_trans_iget to grab and lock the rt bitmap inode, which results in a
deadlock since the removal of the lock recursion counters in commit

        "xfs: simplify inode to transaction joining"

Fix this by acquiring and locking the inode in xfs_bmap_rtalloc before
calling into xfs_rtpick_extent and xfs_rtallocate_extent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
---
 fs/xfs/xfs_bmap.c    |   11 +++++++++++
 fs/xfs/xfs_rtalloc.c |   34 +++++++++++++---------------------
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 4111cd3..9d9970b 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2316,6 +2316,7 @@ xfs_bmap_rtalloc(
        xfs_extlen_t    prod = 0;       /* product factor for allocators */
        xfs_extlen_t    ralen = 0;      /* realtime allocation length */
        xfs_extlen_t    align;          /* minimum allocation alignment */
+       xfs_inode_t     *ip;            /* bitmap incore inode */
        xfs_rtblock_t   rtb;
 
        mp = ap->ip->i_mount;
@@ -2348,6 +2349,16 @@ xfs_bmap_rtalloc(
         */
        if (ralen * mp->m_sb.sb_rextsize >= MAXEXTLEN)
                ralen = MAXEXTLEN / mp->m_sb.sb_rextsize;
+
+       /*
+        * Lock out other modifications to the RT bitmap inode.
+        */
+       error = xfs_trans_iget(mp, ap->tp, mp->m_sb.sb_rbmino, 0,
+                              XFS_ILOCK_EXCL, &ip);
+       if (error)
+               return error;
+       ASSERT(ip == mp->m_rbmip);
+
        /*
         * If it's an allocation to an empty file at offset 0,
         * pick an extent that will space things out in the rt area.
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 12a1913..037fab1 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2075,15 +2075,15 @@ xfs_rtallocate_extent(
        xfs_extlen_t    prod,           /* extent product factor */
        xfs_rtblock_t   *rtblock)       /* out: start block allocated */
 {
+       xfs_mount_t     *mp = tp->t_mountp;
        int             error;          /* error value */
-       xfs_inode_t     *ip;            /* inode for bitmap file */
-       xfs_mount_t     *mp;            /* file system mount structure */
        xfs_rtblock_t   r;              /* result allocated block */
        xfs_fsblock_t   sb;             /* summary file block number */
        xfs_buf_t       *sumbp;         /* summary file block buffer */
 
+       ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
        ASSERT(minlen > 0 && minlen <= maxlen);
-       mp = tp->t_mountp;
+
        /*
         * If prod is set then figure out what to do to minlen and maxlen.
         */
@@ -2099,12 +2099,7 @@ xfs_rtallocate_extent(
                        return 0;
                }
        }
-       /*
-        * Lock out other callers by grabbing the bitmap inode lock.
-        */
-       if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
-                                       XFS_ILOCK_EXCL, &ip)))
-               return error;
+
        sumbp = NULL;
        /*
         * Allocate by size, or near another block, or exactly at some
block.
@@ -2123,11 +2118,12 @@ xfs_rtallocate_extent(
                                len, &sumbp, &sb, prod, &r);
                break;
        default:
+               error = EIO;
                ASSERT(0);
        }
-       if (error) {
+       if (error)
                return error;
-       }
+
        /*
         * If it worked, update the superblock.
         */
@@ -2306,20 +2302,16 @@ xfs_rtpick_extent(
        xfs_rtblock_t   *pick)          /* result rt extent */
 {
        xfs_rtblock_t   b;              /* result block */
-       int             error;          /* error return value */
-       xfs_inode_t     *ip;            /* bitmap incore inode */
        int             log2;           /* log of sequence number */
        __uint64_t      resid;          /* residual after log removed */
        __uint64_t      seq;            /* sequence number of file creation
*/
        __uint64_t      *seqp;          /* pointer to seqno in inode */
 
-       if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
-                                       XFS_ILOCK_EXCL, &ip)))
-               return error;
+
        sumbp = NULL;
        /*
         * Allocate by size, or near another block, or exactly at some
block.
@@ -2123,11 +2118,12 @@ xfs_rtallocate_extent(
                                len, &sumbp, &sb, prod, &r);
                break;
        default:
+               error = EIO;
                ASSERT(0);
        }
-       if (error) {
+       if (error)
                return error;
-       }
+
        /*
         * If it worked, update the superblock.
         */
@@ -2306,20 +2302,16 @@ xfs_rtpick_extent(
        xfs_rtblock_t   *pick)          /* result rt extent */
 {
        xfs_rtblock_t   b;              /* result block */
-       int             error;          /* error return value */
-       xfs_inode_t     *ip;            /* bitmap incore inode */
        int             log2;           /* log of sequence number */
        __uint64_t      resid;          /* residual after log removed */
        __uint64_t      seq;            /* sequence number of file creation
*/
        __uint64_t      *seqp;          /* pointer to seqno in inode */
 
-       if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
-                                       XFS_ILOCK_EXCL, &ip)))
-               return error;
-       ASSERT(ip == mp->m_rbmip);
-       seqp = (__uint64_t *)&ip->i_d.di_atime;
-       if (!(ip->i_d.di_flags & XFS_DIFLAG_NEWRTBM)) {
-               ip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+       ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
+
+       seqp = (__uint64_t *)&mp->m_rbmip->i_d.di_atime;
+       if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM)) {
+               mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
                *seqp = 0;
        }
        seq = *seqp;
@@ -2335,7 +2327,7 @@ xfs_rtpick_extent(
                        b = mp->m_sb.sb_rextents - len;
        }
        *seqp = seq + 1;
-       xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+       xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
        *pick = b;
        return 0;
 }
-- 
1.7.5.4
-- 
View this message in context: http://old.nabble.com/-PATCH-0-4--xfs%3A-resurrect-realtime-subvolume-support-on-kernel-2.6.37-tp33345988p33346009.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
