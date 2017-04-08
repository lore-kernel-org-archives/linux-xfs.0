Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18663 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdDHCxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 22:53:03 -0400
Date: Fri, 7 Apr 2017 19:52:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: fix xfs_extent_busy_flush macro definition
Message-ID: <20170408025255.GP4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

xfs_extent_busy_flush is a void function, so don't reduce it to zero.
This shuts up gcc warnings about do-nothing statements.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_priv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index c2d4494..167786e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -419,7 +419,7 @@ roundup_64(__uint64_t x, __uint32_t y)
 	*(busy_gen) = __foo;					\
 	false;							\
 })
-#define xfs_extent_busy_flush(mp,pag,busy_gen)		(0)
+#define xfs_extent_busy_flush(mp,pag,busy_gen)		do { } while(0)
 
 /* avoid unused variable warning */
 #define xfs_alloc_busy_insert(tp,ag,b,len)	({	\
