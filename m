Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55330 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934459AbeE2PPk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 May 2018 11:15:40 -0400
Date: Tue, 29 May 2018 08:15:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 1/7] xfs_repair: fix integer handling issues
Message-ID: <20180529151521.GD30110@magnolia>
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728630312.22515.18006873991572258759.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152728630312.22515.18006873991572258759.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we shift sb_logblocks to the left we need to ensure that we have
enough storage space to shift correctly.  Cast logblocks to a 64-bit
type so that we don't screw up the check.

Coverity-id: 1435810
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
v2: fix commit message
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
