Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49484 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfCTTfu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 15:35:50 -0400
Date: Wed, 20 Mar 2019 12:35:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 39/36] misc: fix strncpy length complaints
Message-ID: <20190320193542.GC1183@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix a number of complaints about feeding sizeof(dest) directly to
strncpy.  We do this by declaring the char arrays to be one larger
than necessary and subtracting one, to ensure that we never overfill
the buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   13 +++++++++++--
 quota/edit.c    |    9 ++++++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9e1c6ec5..e87c692c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3251,8 +3251,17 @@ finish_superblock_setup(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
-	if (cfg->label)
-		strncpy(sbp->sb_fname, cfg->label, sizeof(sbp->sb_fname));
+	if (cfg->label) {
+		size_t		label_len;
+
+		/*
+		 * Labels are null terminated unless the string fits exactly
+		 * in the label field, so assume sb_fname is zeroed and then
+		 * do a memcpy because the destination isn't a normal C string.
+		 */
+		label_len = min(sizeof(sbp->sb_fname), strlen(cfg->label));
+		memcpy(sbp->sb_fname, cfg->label, label_len);
+	}
 
 	sbp->sb_dblocks = cfg->dblocks;
 	sbp->sb_rblocks = cfg->rtblocks;
diff --git a/quota/edit.c b/quota/edit.c
index b10a5b34..f9938b8a 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -368,8 +368,7 @@ restore_file(
 	uint		type)
 {
 	char		buffer[512];
-	char		devbuffer[512];
-	char		*dev = NULL;
+	char		dev[512];
 	uint		mask;
 	int		cnt;
 	uint32_t	id;
@@ -377,7 +376,11 @@ restore_file(
 
 	while (fgets(buffer, sizeof(buffer), fp) != NULL) {
 		if (strncmp("fs = ", buffer, 5) == 0) {
-			dev = strncpy(devbuffer, buffer+5, sizeof(devbuffer));
+			/*
+			 * Copy the device name to dev, strip off the trailing
+			 * newline, and move on to the next line.
+			 */
+			strncpy(dev, buffer + 5, sizeof(dev) - 1);
 			dev[strlen(dev) - 1] = '\0';
 			continue;
 		}
