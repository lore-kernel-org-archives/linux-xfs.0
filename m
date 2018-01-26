Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45512 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbeAZSO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 13:14:56 -0500
Date: Fri, 26 Jan 2018 10:14:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/2] misc: ubsan fixes
Message-ID: <20180126181448.GU9068@magnolia>
References: <151692412532.32390.5360363880930671862.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151692412532.32390.5360363880930671862.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix a few things the undefined behavior sanitizer complained about.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/bit.c    |    4 ++--
 repair/sb.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/db/bit.c b/db/bit.c
index a20b6ba..bf8d80e 100644
--- a/db/bit.c
+++ b/db/bit.c
@@ -112,11 +112,11 @@ getbitval(
 #if __BYTE_ORDER == LITTLE_ENDIAN
 			if (i == 0 && signext && nbits < 64)
 				rval = -1LL << nbits;
-			rval |= 1LL << (nbits - i - 1);
+			rval |= 1ULL << (nbits - i - 1);
 #else
 			if ((i == (nbits - 1)) && signext && nbits < 64)
 				rval |= (-1LL << nbits);
-			rval |= 1LL << (nbits - i - 1);
+			rval |= 1ULL << (nbits - i - 1);
 #endif
 		}
 	}
diff --git a/repair/sb.c b/repair/sb.c
index f40cdea..3dc6538 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -89,11 +89,11 @@ verify_sb_blocksize(xfs_sb_t *sb)
 	/* check to make sure blocksize is legal 2^N, 9 <= N <= 16 */
 	if (sb->sb_blocksize == 0)
 		return XR_BAD_BLOCKSIZE;
-	if (sb->sb_blocksize != (1 << sb->sb_blocklog))
-		return XR_BAD_BLOCKLOG;
 	if (sb->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG ||
 	    sb->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG)
 		return XR_BAD_BLOCKLOG;
+	if (sb->sb_blocksize != (1 << sb->sb_blocklog))
+		return XR_BAD_BLOCKLOG;
 
 	return 0;
 }
