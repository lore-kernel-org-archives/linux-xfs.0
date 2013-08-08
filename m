Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05E237F7B
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 16:08:54 -0500 (CDT)
Date: Thu, 8 Aug 2013 16:08:50 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 2/14] xfsprogs: XFS_AGF_NUM_BITS should be 13
Message-ID: <20130808210850.GP3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130808210600.GN3111@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

commit 4e0e6040c4052aff15a494ac05778f4086d24c33 changed XFS_AGF_NUM_BITS
to be 13, however when this commit was applied to userspace the change
was not pulled over.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 include/xfs_ag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/include/xfs_ag.h
===================================================================
--- a/include/xfs_ag.h	2013-08-06 10:41:02.850817460 -0500
+++ b/include/xfs_ag.h	2013-08-06 10:41:07.360857099 -0500
@@ -102,7 +102,7 @@ typedef struct xfs_agf {
 #define	XFS_AGF_LONGEST		0x00000400
 #define	XFS_AGF_BTREEBLKS	0x00000800
 #define	XFS_AGF_UUID		0x00001000
-#define	XFS_AGF_NUM_BITS	12
+#define	XFS_AGF_NUM_BITS	13
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 #define XFS_AGF_FLAGS \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
