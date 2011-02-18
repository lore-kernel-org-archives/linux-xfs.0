Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILIKrH238181 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:21 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL103029109@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:01 -0600
Subject: [PATCH v3,
	08/16] xfsprogs: metadump: ensure dup table always has entry for
	obfuscated name
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

We need to ensure the nametable has a copy of all the names in a
directory (or attribute fork) in order to avoid creating duplicate
entries when obfuscating names.  Currently there is an (unlikely)
case where the name is passed back without such an entry being
created.  Reorder things so that won't happen.

Signed-off-by: Alex Elder <aelder@sgi.com>

No significant changes in this version from the last one posted.

---
 db/metadump.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -540,18 +540,22 @@ generate_obfuscated_name(
 		}
 	} while (dup);
 
-	memcpy(name, newname, namelen);
+	/* Create an entry for the name in the name table */
 
 	p = malloc(sizeof(name_ent_t) + namelen);
 	if (p == NULL)
 		return;
 
-	p->next = nametable[hash % NAME_TABLE_SIZE];
-	p->hash = hash;
 	p->namelen = namelen;
-	memcpy(p->name, name, namelen);
+	memcpy(p->name, newname, namelen);
+	p->hash = hash;
+	p->next = nametable[hash % NAME_TABLE_SIZE];
 
 	nametable[hash % NAME_TABLE_SIZE] = p;
+
+	/* Update the caller's copy with the obfuscated name */
+
+	memcpy(name, newname, namelen);
 }
 
 static void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
