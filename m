Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfAEK0J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Jan 2019 05:26:09 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2FBDBC0528C4
        for <linux-xfs@vger.kernel.org>; Sat,  5 Jan 2019 10:26:09 +0000 (UTC)
Date: Sat, 5 Jan 2019 15:56:01 +0530
From: Achilles Gaikwad <agaikwad@redhat.com>
Subject: [PATCH] xfs_quota: fix false error reporting of project inheritance
 flag is not set
Message-ID: <20190105102556.GA4200@nevermore.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sgardner@redhat.com, sandeen@redhat.com

xfs_quota project check results in "project inheritance flag is not set" error
https://bugzilla.redhat.com/show_bug.cgi?id=1663502

Reported-by: Steven Gardner <sgardner@redhat.com>
Signed-off-by: Achilles Gaikwad <agaikwad@redhat.com>
---
 quota/project.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/quota/project.c b/quota/project.c
index e4e7a012..8c9be08b 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -99,6 +99,7 @@ check_project(
 {
 	struct fsxattr		fsx;
 	int			fd;
+	int			isdir;
 
 	if (recurse_depth >= 0 && data->level > recurse_depth)
 		return -1;
@@ -126,7 +127,8 @@ check_project(
 			printf(_("%s - project identifier is not set"
 				 " (inode=%u, tree=%u)\n"),
 				path, fsx.fsx_projid, (unsigned int)prid);
-		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT))
+		isdir = S_ISDIR(stat->st_mode);
+		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && isdir)
 			printf(_("%s - project inheritance flag is not set\n"),
 				path);
 	}
-- 
2.20.1
