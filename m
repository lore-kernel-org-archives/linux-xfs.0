Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753019AbdF2QZh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 12:25:37 -0400
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH] xfs_spaceman: close open file for error case in openfile()
Date: Thu, 29 Jun 2017 11:25:30 -0500
Message-Id: <20170629162530.6023-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net

openfile() fails to close the open file in one error case.
Add close(fd) to correct the condition.

Detected by CoverityScan, CID#1413770 (RESOURCE_LEAK)

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 spaceman/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/spaceman/file.c b/spaceman/file.c
index 4ab30900..4c13b4a8 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -79,6 +79,7 @@ openfile(
 		if (!fsp) {
 			fprintf(stderr, _("%s: cannot find mount point."),
 				path);
+			close(fd);
 			return -1;
 		}
 		memcpy(fs_path, fsp, sizeof(struct fs_path));
-- 
2.13.0

