Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SBFhRt104242 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 06:15:43 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH] xfsprogs: xfs_quota: don't print invalid quota file inode
	number
Date: Wed, 28 Sep 2011 06:15:37 -0500
Message-Id: <43b1c14570decac4b102616fb8e9b14d101edc39.1317208532.git.aelder@sgi.com>
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
To: xfs@oss.sgi.com
Cc: Alex Elder <aelder@sgi.com>

When the state of quota files is dumped, xfs_quota blindly shows
whatever inode number is returned by the kernel.  If one of the
quota types is not enabled or enforced, the inode number provided
is an invalid value ((__u64) -1).  Rather than print a meaningless
large integer, print "N/A" in its place to make interpreting the
result it a little more obvious.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 quota/state.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/quota/state.c b/quota/state.c
index 3862e67..42bffc0 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -122,10 +122,13 @@ state_qfilestat(
 		mount->fs_dir, mount->fs_name);
 	fprintf(fp, _("  Accounting: %s\n"), accounting ? _("ON") : _("OFF"));
 	fprintf(fp, _("  Enforcement: %s\n"), enforcing ? _("ON") : _("OFF"));
-	fprintf(fp, _("  Inode: #%llu (%llu blocks, %lu extents)\n"),
-		(unsigned long long)qfs->qfs_ino,
-		(unsigned long long)qfs->qfs_nblks,
-		(unsigned long)qfs->qfs_nextents);
+	if (qfs->qfs_ino != (__u64) -1)
+		fprintf(fp, _("  Inode: #%llu (%llu blocks, %lu extents)\n"),
+			(unsigned long long)qfs->qfs_ino,
+			(unsigned long long)qfs->qfs_nblks,
+			(unsigned long)qfs->qfs_nextents);
+	else
+		fprintf(fp, _("  Inode: N/A\n"));
 }
 
 static void
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
