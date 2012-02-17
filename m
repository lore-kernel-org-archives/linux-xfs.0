Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HMtp00115241 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 16:55:51 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id XmShsivNJpStUaiO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 14:55:50 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1RyWiT-0001u1-OL
	for xfs@oss.sgi.com; Fri, 17 Feb 2012 14:55:49 -0800
Message-ID: <33346035.post@talk.nabble.com>
Date: Fri, 17 Feb 2012 14:55:49 -0800 (PST)
From: kdasu <kdasu.kdev@gmail.com>
Subject: [PATCH 2/4] xfs: fix xfs_get_extsz_hint for a zero extent size hint
In-Reply-To: <33346009.post@talk.nabble.com>
MIME-Version: 1.0
References: <33345988.post@talk.nabble.com> <33346009.post@talk.nabble.com>
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


We can easily set the extsize flag without setting an extent size
hint, or one that evaluates to zero.  Historically the di_extsize
field was only used when it was non-zero, but the commit

        "Cleanup inode extent size hint extraction"

broke this.  Restore the old behaviour, thus fixing xfsqa 090 with
a debug kernel.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
---
 fs/xfs/xfs_rw.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index 56861d5..ccd3adf 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -173,17 +173,9 @@ xfs_extlen_t
 xfs_get_extsz_hint(
        struct xfs_inode        *ip)
 {
-       xfs_extlen_t            extsz;
-
-       if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
-               extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
-                               ? ip->i_d.di_extsize
-                               : ip->i_mount->m_sb.sb_rextsize;
-               ASSERT(extsz);
-       } else {
-               extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
-                               ? ip->i_d.di_extsize : 0;
-       }
-
-       return extsz;
+       if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
+               return ip->i_d.di_extsize;
+       if (XFS_IS_REALTIME_INODE(ip))
+               return ip->i_mount->m_sb.sb_rextsize;
+       return 0;
 }
-- 
1.7.5.4

-- 
View this message in context: http://old.nabble.com/-PATCH-0-4--xfs%3A-resurrect-realtime-subvolume-support-on-kernel-2.6.37-tp33345988p33346035.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
