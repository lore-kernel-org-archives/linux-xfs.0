Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUKdfi7029057 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 14:39:41 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE5F6AC011
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 12:41:45 -0800 (PST)
Subject: [PATCH 08/12] xfsprogs: ensure dup table always has entry for
	obfuscated name
From: Alex Elder <aelder@sgi.com>
Date: Thu, 30 Dec 2010 14:41:45 -0600
Message-ID: <1293741705.2294.367.camel@doink>
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

We need to ensure the name table has a copy of all the names in
a directory in order to avoid creating duplicate entries when
obfuscating names.  Currently there is an (unlikely) case where
the name is passed back without such an entry being created.
Reorder things so that won't happen.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -519,18 +519,22 @@ generate_obfuscated_name(
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
