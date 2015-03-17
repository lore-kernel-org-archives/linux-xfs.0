Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B53AF7F5F
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5EDAEAC001
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:33:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GJeu7DcAyJ19KAZ5 for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 13:33:20 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 12/13] xfs_repair: don't clear . or .. in process_dir2_data
Date: Tue, 17 Mar 2015 15:33:14 -0500
Message-Id: <1426624395-8258-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

process_dir2_data() has special . and .. processing; it is able
to correct these inodes, so there is no reason to clear them.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/dir2.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index 9e6c67d..3acf71c 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1331,6 +1331,18 @@ _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64
 				dep->namelen = 1;
 			clearino = 1;
 		}
+
+		/*
+		 * We have a special dot & dotdot fixer-upper below which can
+		 * sort out the proper inode number, so don't clear it.
+		 */
+		if ((dep->namelen == 1 && dep->name[0] == '.') ||
+		    (dep->namelen == 2 &&
+		     dep->name[0] == '.' && dep->name[1] == '.')) {
+			clearino = 0;
+			clearreason = NULL;
+		}
+		    
 		/*
 		 * If needed to clear the inode number, do it now.
 		 */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
