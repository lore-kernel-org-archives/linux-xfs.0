Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 342517F50
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:57:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 123BF8F8035
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:57:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YIB3sFqKVqTauxZm for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:57:22 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/9] xfsdump: remove some unreachable code
Date: Wed, 12 Nov 2014 12:57:14 -0600
Message-Id: <1415818638-32700-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
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

in create_windows() we assign INFO_SIZE (which is defined to 4)
to the infosize variable, then test whether it is <= 0.  Remove
the pointless test.

in tsi_cmd_ls(), inside a if ( ! isdirpr ) block, we test whether
isdirpr might be true... remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 invutil/cmenu.c |    2 --
 restore/tree.c  |    5 ++---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/invutil/cmenu.c b/invutil/cmenu.c
index ff4abef..c4747b0 100644
--- a/invutil/cmenu.c
+++ b/invutil/cmenu.c
@@ -555,8 +555,6 @@ create_windows()
 	     menusize, COLS - 1);
 
     infosize = INFO_SIZE;
-    if(infosize <= 0)
-	infosize = 1;
 
     infowin = newwin(infosize, COLS, menusize + 1, 0);
     keypad(infowin, TRUE);
diff --git a/restore/tree.c b/restore/tree.c
index fda4fc5..21d3880 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -2905,11 +2905,10 @@ tsi_cmd_ls( void *ctxp,
 	 */
 	if ( ! isdirpr ) {
 		( * pcb )( pctxp,
-			   "    %s %10llu %s%s\n",
+			   "    %s %10llu %s\n",
 			   isselpr ? "*" : " ",
 			   ino,
-			   tranp->t_inter.i_name,
-			   isdirpr ? "/" : " " );
+			   tranp->t_inter.i_name);
 
 		return;
 	}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
