Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932552AbdDGR6Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Apr 2017 13:58:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 821C67F7C5
        for <linux-xfs@vger.kernel.org>; Fri,  7 Apr 2017 17:58:15 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-123-0.rdu2.redhat.com [10.10.123.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E3251710B
        for <linux-xfs@vger.kernel.org>; Fri,  7 Apr 2017 17:58:15 +0000 (UTC)
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH] xfsprogs: ensure growfs rejects non-existent mount point
Date: Fri,  7 Apr 2017 12:58:09 -0500
Message-Id: <20170407175809.8540-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_growfs manpage clearly states that the filesystem must
be mounted to be grown. Current behavior allows xfs_growfs
to proceed if the filesystem /containing/ the path
of the desired target is mounted. This is not the specified
behavior. Instead, also check the targeted fs argument against
the entry found in the fstable lookup. Unless the targeted
fs is actually mounted, reject the command.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 growfs/xfs_growfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index a294e14..05630b8 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -203,7 +203,7 @@ main(int argc, char **argv)
 
 	fs_table_initialise(0, NULL, 0, NULL);
 	fs = fs_table_lookup(argv[optind], FS_MOUNT_POINT);
-	if (!fs) {
+	if (!fs || (strcmp(argv[optind], fs->fs_dir) != 0)) {
 		fprintf(stderr, _("%s: %s is not a mounted XFS filesystem\n"),
 			progname, argv[optind]);
 		return 1;
-- 
2.9.3

