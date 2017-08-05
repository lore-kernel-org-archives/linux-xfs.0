Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49140 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdHEQKT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Aug 2017 12:10:19 -0400
Date: Sat, 5 Aug 2017 09:10:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: reset metadump output flag
Message-ID: <20170805161013.GJ24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On the off chance that someone runs metadump more than once with the
metadump file going to stdout and then not stdout, the stdout_metadump
variable will not be reset before the second invocation.  Clear the
status variable when we undo the stdout redirection.

Fixes-coverity-id: 1416140
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/db/metadump.c b/db/metadump.c
index b242548..c179480 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3058,6 +3058,7 @@ metadump_f(
 		ret = dup2(outfd, STDOUT_FILENO);
 		if (ret < 0)
 			perror("un-redirecting stdout");
+		stdout_metadump = false;
 	}
 	fclose(outf);
 
