Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58510 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfAFK2P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Jan 2019 05:28:15 -0500
Date: Sun, 6 Jan 2019 15:58:07 +0530
From: Achilles Gaikwad <agaikwad@redhat.com>
Subject: [PATCH v2] xfs_quota: fix false error reporting of project
 inheritance flag is not set
Message-ID: <20190106102745.GA7347@nevermore.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, sgardner@redhat.com, darrick.wong@oracle.com

After kernel commit:

9336e3a7 "xfs: project id inheritance is a directory only flag"

xfs stopped setting the project inheritance flag on regular files, but
userspace quota code still checks for it and will now issue the error:

"project inheritance flag is not set"

for every regular file during quotacheck.  Fix this by only checking
for the flag on directories.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1663502
Reported-by: Steven Gardner <sgardner@redhat.com>
Signed-off-by: Achilles Gaikwad <agaikwad@redhat.com>
---
 quota/project.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/quota/project.c b/quota/project.c
index e4e7a012..11f3be04 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -126,7 +126,7 @@ check_project(
 			printf(_("%s - project identifier is not set"
 				 " (inode=%u, tree=%u)\n"),
 				path, fsx.fsx_projid, (unsigned int)prid);
-		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT))
+		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT) && S_ISDIR(stat->st_mode))
 			printf(_("%s - project inheritance flag is not set\n"),
 				path);
 	}
-- 
2.20.1
