Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CMvW8V042478 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 16:57:32 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201002122258.o1CMwjrG020023@stout.americas.sgi.com>
Date: Fri, 12 Feb 2010 16:58:44 -0600
Subject: [PATCH v2] xfsprogs: eliminate some build warnings
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

A few minor changes to get rid of some build warnings.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/check.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/db/check.c
===================================================================
--- a/db/check.c
+++ b/db/check.c
@@ -3059,7 +3059,7 @@ process_leaf_node_dir_v2(
 	xfs_ino_t		lino;
 	int			nex;
 	xfs_ino_t		parent;
-	int			t;
+	int			t = 0;
 	int			v;
 	int			v2;
 	int			x;
@@ -3403,7 +3403,7 @@ process_quota(
 	xfs_fileoff_t	qbno;
 	char		*s = NULL;
 	int		scicb;
-	int		t;
+	int		t = 0;
 
 	switch (qtype) {
 	case IS_USER_QUOTA:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
