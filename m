Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILILIS238228 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:21 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL22a029207@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:02 -0600
Subject: [PATCH v3, 16/16] xfsprogs: metadump: drop a typedef in db/metadump.c
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

Use struct name_ent rather than its typedef, and just drop the
typedef entirely.

Signed-off-by: Alex Elder <aelder@sgi.com>

No significant changes in this version from the last version posted.

---
 db/metadump.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -341,12 +341,12 @@ copy_free_cnt_btree(
 
 /* filename and extended attribute obfuscation routines */
 
-typedef struct name_ent {
+struct name_ent {
 	struct name_ent		*next;
 	xfs_dahash_t		hash;
 	int	  	    	namelen;
 	uchar_t    	    	name[1];
-} name_ent_t;
+};
 
 #define NAME_TABLE_SIZE		4096
 
@@ -356,7 +356,7 @@ static void
 nametable_clear(void)
 {
 	int		i;
-	name_ent_t	*ent;
+	struct name_ent	*ent;
 
 	for (i = 0; i < NAME_TABLE_SIZE; i++) {
 		while ((ent = nametable[i])) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
