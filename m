Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0CAAA7F54
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 06:23:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9E727AC001
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 04:23:31 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id xxLpkQROohe9IoOb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 04:23:27 -0700 (PDT)
Message-ID: <51824CA8.9000209@oracle.com>
Date: Thu, 02 May 2013 19:23:20 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfs: Remove struct xfs_chash from xfs_mount
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: Dave Chinner <dchinner@redhat.com>

v2->v1:
Fix a typo at comments, i.e. s/xfs_krash/xfs_chash/.


From: Jie Liu <jeff.liu@oracle.com>

Remove struct xfs_chash from struct xfs_mount as there is no user of
it nowadays.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bc90706..b68e56b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -192,8 +192,6 @@ typedef struct xfs_mount {
        xfs_dablk_t             m_dirleafblk;   /* blockno of dir non-data v2 */
        xfs_dablk_t             m_dirfreeblk;   /* blockno of dirfreeindex v2 */
        uint                    m_chsize;       /* size of next field */
-       struct xfs_chash        *m_chash;       /* fs private inode per-cluster
-                                                * hash table */
        atomic_t                m_active_trans; /* number trans frozen */
 #ifdef HAVE_PERCPU_SB
        xfs_icsb_cnts_t __percpu *m_sb_cnts;    /* per-cpu superblock counters */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
