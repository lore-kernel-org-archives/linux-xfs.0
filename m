Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9CLZvIV232532 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 16:35:57 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 49grYW5oqlTukx2L for <xfs@oss.sgi.com>;
	Fri, 12 Oct 2012 14:37:30 -0700 (PDT)
Message-ID: <50788D9A.8080302@sandeen.net>
Date: Fri, 12 Oct 2012 16:37:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/3] xfsdump: default to V3, use V4 if projid32bit is set
References: <50788C50.40600@redhat.com>
In-Reply-To: <50788C50.40600@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Because 32-bit project ID is not default and semi-rare,
default to version 3 dumps unless dumping a filesystem
with the 32-bit project ID feature flag set.

XFS_FSOP_GEOM_FLAGS_PROJID32 is a newish flag so I've
redefined it here just in caes as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/fs.h b/common/fs.h
index 878385b..7e63f8e 100644
--- a/common/fs.h
+++ b/common/fs.h
@@ -26,6 +26,10 @@
 #define FS_MAXNAMELEN_DEFAULT	256
 #define FS_MAXPATHLEN_DEFAULT	1024
 
+#ifndef XFS_FSOP_GEOM_FLAGS_PROJID32
+#define XFS_FSOP_GEOM_FLAGS_PROJID32 0x0800
+#endif
+
 /* fs_info - decides if a source name describes a file system, and if
  * so returns useful information about that file system.
  *
diff --git a/common/global.h b/common/global.h
index 5138ed8..a847c5d 100644
--- a/common/global.h
+++ b/common/global.h
@@ -29,14 +29,14 @@
 #define GLOBAL_HDR_VERSION_2	2
 #define GLOBAL_HDR_VERSION_3	3
 #define GLOBAL_HDR_VERSION_4	4
-	/* version 4 adds 32-bit projid (projid_hi)
+	/* version 4 adds 32-bit projid (projid_hi) only used if projid32 in place.
 	 * version 3 uses the full 32-bit inode generation number in direnthdr_t.
 	 * version 2 adds encoding of holes and a change to on-tape inventory format.
 	 * version 1 adds extended file attribute dumping.
 	 * version 0 xfsrestore can't handle media produced
 	 * by version 1 xfsdump. 
 	 */
-#define GLOBAL_HDR_VERSION	GLOBAL_HDR_VERSION_4
+#define GLOBAL_HDR_VERSION	GLOBAL_HDR_VERSION_3
 
 #define GLOBAL_HDR_STRING_SZ	0x100
 #define GLOBAL_HDR_TIME_SZ	4
diff --git a/dump/content.c b/dump/content.c
index 9ed8459..94ca787 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -791,6 +791,15 @@ content_init( intgen_t argc,
 		      srcname );
 		return BOOL_FALSE;
 	}
+
+	/* If 32 bit project IDs are in use, bump the header version */
+	if ((fsflags & XFS_FSOP_GEOM_FLAGS_PROJID32) &&
+	    gwhdrtemplatep->gh_version < GLOBAL_HDR_VERSION_4) {
+		mlog( MLOG_NORMAL | MLOG_NOTE, _(
+			"32bit project ids in use, bumping to dump version 4\n"));
+		gwhdrtemplatep->gh_version = GLOBAL_HDR_VERSION_4;
+	}
+
 	/* place the fs info in the write hdr template
 	 */
 	( void )strncpyterm( cwhdrtemplatep->ch_mntpnt,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
