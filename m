Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n974iLq8161245 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 23:44:21 -0500
From: Joe Perches <joe@perches.com>
Subject: [PATCH 8/8] fs/xfs/xfs_log_recover.c: Use %pU to print UUIDs
Date: Tue,  6 Oct 2009 21:45:41 -0700
Message-Id: <d3ce3dab424deedd43322990503af8944f751a73.1254884776.git.joe@perches.com>
In-Reply-To: <1254890742-28245-1-git-send-email-joe@perches.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
In-Reply-To: <cover.1254884776.git.joe@perches.com>
References: <cover.1254884776.git.joe@perches.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/xfs_log_recover.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1099395..3b8e3df 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -225,16 +225,10 @@ xlog_header_check_dump(
 	xfs_mount_t		*mp,
 	xlog_rec_header_t	*head)
 {
-	int			b;
-
-	cmn_err(CE_DEBUG, "%s:  SB : uuid = ", __func__);
-	for (b = 0; b < 16; b++)
-		cmn_err(CE_DEBUG, "%02x", ((__uint8_t *)&mp->m_sb.sb_uuid)[b]);
-	cmn_err(CE_DEBUG, ", fmt = %d\n", XLOG_FMT);
-	cmn_err(CE_DEBUG, "    log : uuid = ");
-	for (b = 0; b < 16; b++)
-		cmn_err(CE_DEBUG, "%02x", ((__uint8_t *)&head->h_fs_uuid)[b]);
-	cmn_err(CE_DEBUG, ", fmt = %d\n", be32_to_cpu(head->h_fmt));
+	cmn_err(CE_DEBUG, "%s:  SB : uuid = %pU, fmt = %d\n",
+		__func__, &mp->m_sb.sb_uuid, XLOG_FMT);
+	cmn_err(CE_DEBUG, "    log : uuid = %pU, fmt = %d\n",
+		&head->h_fs_uuid, be32_to_cpu(head->h_fmt));
 }
 #else
 #define xlog_header_check_dump(mp, head)
-- 
1.6.3.1.10.g659a0.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
