Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755829AbdDEReR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 13:34:17 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0343764D8E
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2017 17:34:17 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-89.pek2.redhat.com [10.72.8.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 194B584FE3
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2017 17:34:15 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2] repair: handle reading superblock from image on larger sector size filesystem
Date: Thu,  6 Apr 2017 01:33:58 +0800
Message-Id: <1491413638-9590-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Due to xfs_repair uses direct IO, sometimes it can't read superblock
from an image file has smaller sector size than host filesystem.
Especially that superblock doesn't align with host filesystem's
sector size.

Fortunately, xfsprogs already has code to do "isa_file" check in
xfs_repair.c, it turns off O_DIRECT after phase1 if the sector
size is less than the host filesystem's geometry. So move it upward
phase1 directly.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V2 did below changes:
1) remove all changes in V1.
2) move "isa_file" double check over than phase1.

Thanks,
Zorro

 repair/xfs_repair.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index b07567b..0525c6d 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -657,24 +657,6 @@ main(int argc, char **argv)
 	timestamp(PHASE_START, 0, NULL);
 	timestamp(PHASE_END, 0, NULL);
 
-	/* do phase1 to make sure we have a superblock */
-	phase1(temp_mp);
-	timestamp(PHASE_END, 1, NULL);
-
-	if (no_modify && primary_sb_modified)  {
-		do_warn(_("Primary superblock would have been modified.\n"
-			  "Cannot proceed further in no_modify mode.\n"
-			  "Exiting now.\n"));
-		exit(1);
-	}
-
-	rval = get_sb(&psb, 0, XFS_MAX_SECTORSIZE, 0);
-	if (rval != XR_OK) {
-		do_warn(_("Primary superblock bad after phase 1!\n"
-			  "Exiting now.\n"));
-		exit(1);
-	}
-
 	/* -f forces this, but let's be nice and autodetect it, as well. */
 	if (!isa_file) {
 		int		fd = libxfs_device_to_fd(x.ddev);
@@ -717,6 +699,24 @@ main(int argc, char **argv)
 		}
 	}
 
+	/* do phase1 to make sure we have a superblock */
+	phase1(temp_mp);
+	timestamp(PHASE_END, 1, NULL);
+
+	if (no_modify && primary_sb_modified)  {
+		do_warn(_("Primary superblock would have been modified.\n"
+			  "Cannot proceed further in no_modify mode.\n"
+			  "Exiting now.\n"));
+		exit(1);
+	}
+
+	rval = get_sb(&psb, 0, XFS_MAX_SECTORSIZE, 0);
+	if (rval != XR_OK) {
+		do_warn(_("Primary superblock bad after phase 1!\n"
+			  "Exiting now.\n"));
+		exit(1);
+	}
+
 	/*
 	 * Prepare the mount structure. Point the log reference to our local
 	 * copy so it's available to the various phases. The log bits are
-- 
2.7.4

