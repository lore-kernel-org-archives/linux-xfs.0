Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1MItQ4W042099 for <xfs@oss.sgi.com>; Wed, 22 Feb 2012 12:55:26 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: dirs being created in list-only restore
Date: Wed, 22 Feb 2012 12:55:06 -0600
Message-Id: <1329936906-12470-1-git-send-email-wkendall@sgi.com>
In-Reply-To: <CAGdb-8fC4-3swyyfP3xO=camgzDjR5GYV3qoaB1w+xAfiNeYPw@mail.gmail.com>
References: <CAGdb-8fC4-3swyyfP3xO=camgzDjR5GYV3qoaB1w+xAfiNeYPw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

When xfsrestore is run with the -t option, it lists the files contained
in the dump but does not restore anything. This patch fixes code that
creates an orphaned file's parent directories without checking to see if
this is a list-only (table-of-contents) restore.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 restore/tree.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/restore/tree.c b/restore/tree.c
index 05e0628..a61fd16 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -1867,12 +1867,16 @@ tree_cb_links( xfs_ino_t ino,
 					return RV_NOTOK;
 				}
 			} else {
-				char *dir;
-				char tmp[PATH_MAX];
 
-				strcpy(tmp, path);
-				dir = dirname(tmp);
-				mkdir_r(dir);
+				if ( ! tranp->t_toconlypr ) {
+					char *dir;
+					char tmp[PATH_MAX];
+
+					strcpy(tmp, path);
+					dir = dirname(tmp);
+					mkdir_r(dir);
+				}
+
 				mlog (MLOG_VERBOSE | MLOG_NOTE | MLOG_TREE, _(
 				      "ino %llu salvaging file,"
 				      " placing in %s\n"), ino, path1);
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
