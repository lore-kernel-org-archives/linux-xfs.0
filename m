Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1545E7F50
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 15:42:07 -0500 (CDT)
Date: Thu, 18 Sep 2014 15:42:06 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 12/13] xfsprogs: add utf8 support to xfs_repair
Message-ID: <20140918204206.GZ4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
 <20140918203114.GN4482@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918203114.GN4482@sgi.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

From: Mark Tinguely <tinguely@sgi.com>

Fix the duplicate filename detection to use the utf-8 normalization
routines.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 repair/phase6.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index f374fd0..eb3ea35 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -176,13 +176,15 @@ dir_hash_add(
 	unsigned char		*name,
 	__uint8_t		ftype)
 {
-	xfs_dahash_t		hash = 0;
 	int			byaddr;
 	int			byhash = 0;
 	dir_hash_ent_t		*p;
 	int			dup;
 	short			junk;
 	struct xfs_name		xname;
+	xfs_da_args_t		args;
+
+	memset(&args, 0, sizeof(xfs_da_args_t));
 
 	ASSERT(!hashtab->names_duped);
 
@@ -195,19 +197,30 @@ dir_hash_add(
 	dup = 0;
 
 	if (!junk) {
-		hash = mp->m_dirnameops->hashname(name, namelen);
-		byhash = DIR_HASH_FUNC(hashtab, hash);
+		int error;
+
+		args.name = name;
+		args.namelen = namelen;
+		args.inumber = inum;
+		args.whichfork = XFS_DATA_FORK;
+
+		error = mp->m_dirnameops->normhash(&args);
+		if (error)
+			do_error(_("normalize has failed %d)\n"), error);
+
+		byhash = DIR_HASH_FUNC(hashtab, args.hashval);
 
 		/*
 		 * search hash bucket for existing name.
 		 */
 		for (p = hashtab->byhash[byhash]; p; p = p->nextbyhash) {
-			if (p->hashval == hash && p->name.len == namelen) {
-				if (memcmp(p->name.name, name, namelen) == 0) {
-					dup = 1;
-					junk = 1;
-					break;
-				}
+			if (p->hashval == args.hashval &&
+			    mp->m_dirnameops->compname(&args, p->name.name,
+						       p->name.len) !=
+							 XFS_CMP_DIFFERENT) {
+				dup = 1;
+				junk = 1;
+				break;
 			}
 		}
 	}
@@ -226,7 +239,7 @@ dir_hash_add(
 	hashtab->last = p;
 
 	if (!(p->junkit = junk)) {
-		p->hashval = hash;
+		p->hashval = args.hashval;
 		p->nextbyhash = hashtab->byhash[byhash];
 		hashtab->byhash[byhash] = p;
 	}
@@ -235,6 +248,8 @@ dir_hash_add(
 	p->seen = 0;
 	p->name = xname;
 
+	if (args.norm)
+		kmem_free((void *) args.norm);
 	return !dup;
 }
 
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
