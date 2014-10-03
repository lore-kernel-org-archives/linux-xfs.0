Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 32BC87F37
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:16:47 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:16:46 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 34/35] xfsprogs: xfs_db support for sb_utf8version
Message-ID: <20141003221646.GH1865@sgi.com>
References: <20141003214758.GY1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003214758.GY1865@sgi.com>
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
Cc: olaf@sgi.com, xfs@oss.sgi.com

From: Ben Myers <bpm@sgi.com>

Add support for accessing and setting sb_utf8version to xfs_db.

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 db/hash.c | 1 +
 db/sb.c   | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/db/hash.c b/db/hash.c
index 02376e6..5196442 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -52,6 +52,7 @@ hash_f(
 {
 	xfs_dahash_t	hashval;
 
+	/* XXX utf8version? */
 	hashval = libxfs_da_hashname((uchar_t *)argv[1], (int)strlen(argv[1]));
 	dbprintf("0x%x\n", hashval);
 	return 0;
diff --git a/db/sb.c b/db/sb.c
index 6cb665d..e32790a 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -119,6 +119,7 @@ const field_t	sb_flds[] = {
 	{ "features_log_incompat", FLDT_UINT32X, OI(OFF(features_log_incompat)),
 		C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "utf8version", FLDT_UINT32D, OI(OFF(utf8version)), C1, 0, TYP_NONE },
 	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ NULL }
@@ -646,6 +647,8 @@ version_string(
 		strcat(s, ",CRC");
 	if (xfs_sb_version_hasftype(sbp))
 		strcat(s, ",FTYPE");
+	if (xfs_sb_version_hasutf8(sbp))
+		strcat(s, ",UTF8");
 	return s;
 }
 
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
