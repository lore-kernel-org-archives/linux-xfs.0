Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030394AbeEYWL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 18:11:58 -0400
Subject: [PATCH 1/7] xfs_repair: fix integer handling issues
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 May 2018 15:11:43 -0700
Message-ID: <152728630312.22515.18006873991572258759.stgit@magnolia>
In-Reply-To: <152728629694.22515.17699396814561914788.stgit@magnolia>
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we shift sb_logblocks to the right we need to ensure that we have
enough storage space to shift correctly.  Cast logblocks to a 64-bit
type so that we don't screw up the check.

Coverity-id: 1435810
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/sb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/repair/sb.c b/repair/sb.c
index ef44e39c..543200f7 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -313,7 +313,8 @@ verify_sb_loginfo(
 	if (xfs_sb_version_hascrc(sb) &&
 	    (sb->sb_logblocks == 0 ||
 	     sb->sb_logblocks > XFS_MAX_LOG_BLOCKS ||
-	     (sb->sb_logblocks << sb->sb_blocklog) > XFS_MAX_LOG_BYTES))
+	     ((unsigned long long)sb->sb_logblocks << sb->sb_blocklog) >
+	     XFS_MAX_LOG_BYTES))
 		return false;
 
 	if (sb->sb_logsunit > 1 && sb->sb_logsunit % sb->sb_blocksize)

