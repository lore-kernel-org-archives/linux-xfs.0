Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EACZwT250414 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 04:12:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8A3D1DB112A
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 02:13:30 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	jyZydto1gq2bzPJB for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 02:13:30 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11435813-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 20:43:29 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVMhk-0007rb-04
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:13:28 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVMdg-0001LY-Ic
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:09:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/9] xfsprogs: fix build warnings in repair
Date: Thu, 14 Jan 2010 21:09:12 +1100
Message-Id: <1263463752-5052-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1263463752-5052-1-git-send-email-david@fromorbit.com>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
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

Rewrite the loop in btree_get_prev() so that the compiler
can see that it returns if the cur->index is zero so it
doesn't complain about possible array bound underflows
when getting the key out of the buffer.

Fix the directory name sign warnings by casting to (uchar_t *)
appropriately.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 repair/btree.c  |    9 +++++----
 repair/phase6.c |   10 +++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/repair/btree.c b/repair/btree.c
index 3141388..b53b4e4 100644
--- a/repair/btree.c
+++ b/repair/btree.c
@@ -194,12 +194,13 @@ btree_get_prev(
 	}
 
 	/* else need to go up and back down the tree to find the previous */
-
-	while (cur->index == 0) {
-		if (++level == root->height)
-			return NULL;
+	while (++level < root->height) {
+		if (cur->index)
+			break;
 		cur++;
 	}
+	if (cur->index == 0)
+		return NULL;
 
 	/* the key is in the current level */
 	if (key)
diff --git a/repair/phase6.c b/repair/phase6.c
index d056063..884ad62 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -35,7 +35,7 @@ static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
 static xfs_ino_t		orphanage_ino;
 
-static struct xfs_name 		xfs_name_dot = {".", 1};
+static struct xfs_name 		xfs_name_dot = {(uchar_t *)".", 1};
 
 /*
  * Data structures used to keep track of directories where the ".."
@@ -145,7 +145,7 @@ dir_hash_add(
 
 	ASSERT(!hashtab->names_duped);
 
-	xname.name = name;
+	xname.name = (uchar_t *)name;
 	xname.len = namelen;
 
 	junk = name[0] == '/';
@@ -355,7 +355,7 @@ dir_hash_dup_names(dir_hash_tab_t *hashtab)
 	for (p = hashtab->first; p; p = p->nextbyorder) {
 		name = malloc(p->name.len);
 		memcpy(name, p->name.name, p->name.len);
-		p->name.name = name;
+		p->name.name = (uchar_t *)name;
 	}
 	hashtab->names_duped = 1;
 }
@@ -843,7 +843,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%d - couldn't iget root inode to obtain %s\n"),
 			i, ORPHANAGE);
 
-	xname.name = ORPHANAGE;
+	xname.name = (uchar_t *)ORPHANAGE;
 	xname.len = strlen(ORPHANAGE);
 	if (libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL) == 0)
 		return ino;
@@ -944,7 +944,7 @@ mv_orphanage(
 
 	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
 
-	xname.name = fname;
+	xname.name = (uchar_t *)fname;
 	xname.len = snprintf(fname, sizeof(fname), "%llu",
 				(unsigned long long)ino);
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
