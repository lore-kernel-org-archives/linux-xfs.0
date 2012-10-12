Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9CLesBg233785 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 16:40:54 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id lfSJOxXZtCIEp9TD for <xfs@oss.sgi.com>;
	Fri, 12 Oct 2012 14:42:28 -0700 (PDT)
Message-ID: <50788EC3.2060701@sandeen.net>
Date: Fri, 12 Oct 2012 16:42:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/3] xfsdump: refuse restore of V4 format unless FS has
	projid32bit set
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

Restoring a dump w/ the top 16 bits of a 32-bit project ID
set will fail to restore the full ID unless the projid32 feature
flag is set on the filesystem.

So if the target fs is xfs, fail the restore if we have a version
4 dump (only used currently if dumped from a projid32 fs) and
the target xfs filesystem does not have that feature set.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. i'd rather go by whether the contents of the dump have any
> 16 bit project ids than by the feature flag, but I don't see
a way to do that.

diff --git a/restore/content.c b/restore/content.c
index edd00ed..fb15779 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -36,6 +36,7 @@
 #include <pthread.h>
 
 #include "types.h"
+#include "fs.h"
 #include "timeutil.h"
 #include "util.h"
 #include "cldmgr.h"
@@ -2021,6 +2022,8 @@ content_stream_restore( ix_t thrdix )
 		bool_t resumepr;
 		ix_t level;
 		uuid_t *baseidp;
+		uuid_t fsuuid;
+		__u32 fsflags = 0;
 
 		rv = Media_mfile_next( Mediap,
 				       PURP_SEARCH,
@@ -2160,6 +2163,29 @@ content_stream_restore( ix_t thrdix )
 			Media_end( Mediap );
 			return mlog_exit(EXIT_ERROR, RV_COMPAT);
 		}
+
+		/* if dump format supports 32 bit project IDs and target fs
+		 * is XFS, make sure the target fs supports it as well
+		 */
+		if ( persp->a.dstdirisxfspr &&
+		     grhdrp->gh_version >= GLOBAL_HDR_VERSION_4) {
+			rval = fs_getinfo(persp->a.dstdir, &fsuuid, &fsflags);
+			if ( rval ) {
+				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					"could not query filesystem features "
+					"for %s\n"),
+					persp->a.dstdir);
+			}
+			if (!(fsflags & XFS_FSOP_GEOM_FLAGS_PROJID32)) {
+				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+					"dump version >= %d requires projid32 "
+					"feature on target filesystem\n"),
+					GLOBAL_HDR_VERSION_4);
+				Media_end( Mediap );
+				return mlog_exit(EXIT_ERROR, RV_COMPAT);
+			}
+		}
+
 		strncpyterm( persp->s.dumplab,
 			     grhdrp->gh_dumplabel,
 			     sizeof( persp->s.dumplab ));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
