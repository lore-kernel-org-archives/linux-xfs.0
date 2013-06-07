Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46D647FD5
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 269D8304087
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	P5Ts5wpRFHPwxO1e for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkWT-0003wj-Fy
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:17 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkWO-0001Mz-D3
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 42/48] xfs_metadump: requires some object CRC recalculation
Date: Fri,  7 Jun 2013 10:26:05 +1000
Message-Id: <1370564771-4929-43-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

And we can't do that right now through xfs_db, so disable metadump
and restore for CRC enabled filesystems until the issues have been
sorted out.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c             |    5 +++++
 mdrestore/xfs_mdrestore.c |    3 +++
 2 files changed, 8 insertions(+)

diff --git a/db/metadump.c b/db/metadump.c
index bc1c7fa..1c8020b 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2050,6 +2050,11 @@ metadump_f(
 		return 0;
 	}
 
+	if (xfs_sb_version_hascrc(&mp->m_sb) && dont_obfuscate == 0) {
+		print_warning("Can't obfuscate CRC enabled filesystems yet.");
+		return 0;
+	}
+
 	metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
 	if (metablock == NULL) {
 		print_warning("memory allocation failure");
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index e57bdb2..fe61766 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -109,6 +109,9 @@ perform_restore(
 	if (sb.sb_magicnum != XFS_SB_MAGIC)
 		fatal("bad magic number for primary superblock\n");
 
+	if (xfs_sb_version_hascrc(&sb))
+		fatal("Can't restore CRC enabled filesystems yet.\n");
+
 	((xfs_dsb_t*)block_buffer)->sb_inprogress = 1;
 
 	if (is_target_file)  {
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
