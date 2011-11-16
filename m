Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAGMQDcg229687 for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 16:26:13 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: obsolete excluding files by extended attr
Date: Wed, 16 Nov 2011 16:26:06 -0600
Message-Id: <1321482366-6161-1-git-send-email-wkendall@sgi.com>
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

xfsdump supports excluding files by setting the "no-dump" flag using
chattr, or by adding an extended attribute named "SGI_XFSDUMP_SKIP_FILE".
The former is the preferred method, and a deprecation warning has been
issued for 5+ years if the latter method is used. This patch removes
support for the "SGI_XFSDUMP_SKIP_FILE" attribute.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 dump/inomap.c      |   38 --------------------------------------
 man/man8/xfsdump.8 |    5 +----
 2 files changed, 1 insertions(+), 42 deletions(-)

diff --git a/dump/inomap.c b/dump/inomap.c
index a3b1220..aa4f59d 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -595,44 +595,6 @@ cb_add( void *arg1,
 					    MAP_NDR_NOCHNG );
 				inomap_exclude_skipattr++;
 				return 0;
-			} else if (allowexcludefiles_pr &&
-					(statp->bs_xflags & XFS_XFLAG_HASATTR)) {
-				int rval;
-				attr_multiop_t attrop;
-				static char *skip_attr_name = "SGI_XFSDUMP_SKIP_FILE";
-				static int deprecated_msg_issued = 0;
-
-				attrop.am_attrname  = skip_attr_name;
-				attrop.am_attrvalue = NULL;
-				attrop.am_length    = 0;
-				attrop.am_error     = 0;
-				attrop.am_flags     = 0;
-				attrop.am_opcode    = ATTR_OP_GET;
-                                
-				rval = jdm_attr_multi( fshandlep,
-						       statp,
-						       (char *)&attrop,
-						       1,
-						       0 );
-				if ( !rval && (!attrop.am_error || attrop.am_error == E2BIG || attrop.am_error == ERANGE) ) {
-					mlog( MLOG_DEBUG | MLOG_EXCLFILES,
-					      "pruned ino %llu, owner %u, estimated size %llu: skip attribute set\n",
-					      statp->bs_ino,
-					      statp->bs_uid,
-					      estimated_size );
-					if ( !deprecated_msg_issued ) {
-						deprecated_msg_issued = 1;
-						mlog( MLOG_SILENT | MLOG_WARNING,
-						      "excluding files using %s attribute is deprecated\n",
-						      skip_attr_name );
-					}
-					inomap_add( cb_inomap_contextp,
-						    ino,
-						    (gen_t)statp->bs_gen,
-						    MAP_NDR_NOCHNG );
-					inomap_exclude_skipattr++;
-					return 0;
-				}
 			}
 
 			inomap_add( cb_inomap_contextp,
diff --git a/man/man8/xfsdump.8 b/man/man8/xfsdump.8
index 5360378..fb47f7b 100644
--- a/man/man8/xfsdump.8
+++ b/man/man8/xfsdump.8
@@ -112,10 +112,7 @@ xfsdump cannot fit a media file onto a single tape.
 Allow files to be excluded from the dump.  This will cause xfsdump to 
 skip files which have the "no dump" file attribute set. See the
 "Excluding individual files" section below for details on setting
-this file attribute. Files with an extended attribute named
-"SGI_XFSDUMP_SKIP_FILE" will also be skipped, however this method
-is deprecated and xfsdump will stop checking for it in a future
-version.
+this file attribute.
 .TP 5
 \f3\-f\f1 \f2dest\f1 [ \f3\-f\f1 \f2dest\f1 ... ]
 Specifies a dump destination.
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
