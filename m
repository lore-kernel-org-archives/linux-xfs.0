Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILILKZ238239 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:22 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL23t029159@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:02 -0600
Subject: [PATCH v3, 12/16] xfsprogs: metadump: no need for local copy of
	name when obfuscating
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

The local "newname" buffer in obfuscate_name() is used to hold
an obfuscated name as it gets generated.  But it is always copied
back into the passed-in name buffer, so we might as well just use
the name buffer passed directly and avoid the copy.

Signed-off-by: Alex Elder <aelder@sgi.com>

This is a new change, not posted with this series previously.

---
 db/metadump.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -479,8 +479,7 @@ obfuscate_name(
 	size_t		name_len,
 	uchar_t		*name)
 {
-	uchar_t		newname[NAME_MAX];
-	uchar_t		*newp = newname;
+	uchar_t		*newp = name;
 	int		i;
 	xfs_dahash_t	new_hash = 0;
 	uchar_t		*first;
@@ -540,11 +539,7 @@ obfuscate_name(
 		*first ^= 0x10;
 		ASSERT(!is_invalid_char(*first));
 	}
-	ASSERT(libxfs_da_hashname(newname, name_len) == hash);
-
-	/* Copy the fully obfuscated name back to the caller's buffer */
-
-	memcpy(name, newname, name_len);
+	ASSERT(libxfs_da_hashname(name, name_len) == hash);
 }
 
 static void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
