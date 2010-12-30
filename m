Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUKetDR029375 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 14:40:55 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1BE6AC012
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 12:42:59 -0800 (PST)
Subject: [PATCH 12/12] xfsprogs: Drop a typedef in db/metadump.c
From: Alex Elder <aelder@sgi.com>
Date: Thu, 30 Dec 2010 14:42:59 -0600
Message-ID: <1293741779.2294.374.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

---
 db/metadump.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -337,12 +337,12 @@ copy_free_cnt_btree(
 
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
 
@@ -352,7 +352,7 @@ static void
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
