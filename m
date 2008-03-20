Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 23:32:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2K6WLm6028367
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 23:32:23 -0700
Date: Thu, 20 Mar 2008 17:32:45 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] XFSQA 103: filter ln output
Message-ID: <20080320063245.GA103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Move recent versions of ln (i.e. debian unstable) have
a different error output. update the filter to handle this.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/103 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: xfs-cmds/xfstests/103
===================================================================
--- xfs-cmds.orig/xfstests/103	2006-11-14 19:57:41.000000000 +1100
+++ xfs-cmds/xfstests/103	2008-03-19 10:02:14.393358705 +1100
@@ -47,7 +47,8 @@ _filter_scratch()
 
 _filter_ln()
 {
-    sed -e "s,SCRATCH_MNT/nosymlink/target - Operation not permitted,ln: creating symbolic link \`SCRATCH_MNT/nosymlink/target\' to \`SCRATCH_MNT/nosymlink/source\': Operation not permitted,g"
+    sed -e "s,SCRATCH_MNT/nosymlink/target - Operation not permitted,ln: creating symbolic link \`SCRATCH_MNT/nosymlink/target\' to \`SCRATCH_MNT/nosymlink/source\': Operation not permitted,g" \
+        -e "s,: Operation not permitted, to \`SCRATCH_MNT/nosymlink/source\': Operation not permitted,g"
 }
 
 _filter_noymlinks_flag()
