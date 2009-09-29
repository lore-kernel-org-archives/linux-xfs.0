Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8T505F0182698 for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 00:00:06 -0500
From: Joe Perches <joe@perches.com>
Subject: [PATCH 9/9] fs/xfs/xfs_log_recover.c: Use %pU to print UUIDs
Date: Mon, 28 Sep 2009 22:01:11 -0700
Message-Id: <a1ef34a30fa69b35db003f2e68445c4eb0a03a93.1254193019.git.joe@perches.com>
In-Reply-To: <cover.1254193019.git.joe@perches.com>
References: <cover.1254193019.git.joe@perches.com>
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
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com, Steven Whitehouse <swhiteho@redhat.com>, Artem Bityutskiy <dedekind@infradead.org>, Matt Mackall <mpm@selenic.com>, Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, Jeff Garzik <jgarzik@redhat.com>, Neil Brown <neilb@suse.de>, Laurent Pinchart <laurent.pinchart@skynet.be>, Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>, Adrian Hunter <adrian.hunter@nokia.com>, Christoph Hellwig <hch@lst.de>, Mauro Carvalho Chehab <mchehab@infradead.org>, Harvey Harrison <harvey.harrison@gmail.com>

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
