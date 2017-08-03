Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751134AbdHCOhp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Aug 2017 10:37:45 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A53F676A13
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2017 14:37:45 +0000 (UTC)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfs: Fix per-inode DAX flag inheritance
Date: Thu,  3 Aug 2017 16:37:18 +0200
Message-Id: <1501771038-17216-1-git-send-email-lczerner@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>

According to the commit that implemented per-inode DAX flag:
commit 58f88ca2df72 ("xfs: introduce per-inode DAX enablement")
the flag is supposed to act as "inherit flag".

Currently this only works in the situations where parent directory
already has a flag in di_flags set, otherwise inheritance does not
work. This is because setting the XFS_DIFLAG2_DAX flag is done in a
wrong branch designated for di_flags, not di_flags2.

Fix this by moving the code to branch designated for setting di_flags2,
which does test for flags in di_flags2.

Fixes: 58f88ca2df72 ("xfs: introduce per-inode DAX enablement")
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/xfs/xfs_inode.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ceef77c..ff48f00 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -874,7 +874,6 @@ xfs_ialloc(
 	case S_IFREG:
 	case S_IFDIR:
 		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
-			uint64_t	di_flags2 = 0;
 			uint		di_flags = 0;
 
 			if (S_ISDIR(mode)) {
@@ -911,20 +910,23 @@ xfs_ialloc(
 				di_flags |= XFS_DIFLAG_NODEFRAG;
 			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
 				di_flags |= XFS_DIFLAG_FILESTREAM;
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
-				di_flags2 |= XFS_DIFLAG2_DAX;
 
 			ip->i_d.di_flags |= di_flags;
-			ip->i_d.di_flags2 |= di_flags2;
 		}
 		if (pip &&
 		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
 		    pip->i_d.di_version == 3 &&
 		    ip->i_d.di_version == 3) {
+			uint64_t	di_flags2 = 0;
+
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
-				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
 			}
+			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
+				di_flags2 |= XFS_DIFLAG2_DAX;
+
+			ip->i_d.di_flags2 |= di_flags2;
 		}
 		/* FALLTHROUGH */
 	case S_IFLNK:
-- 
2.7.5

