Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KHbvKd128159 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 12:37:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 496EE1492A9F
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:46:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rFOUocLO0Wzx8ZyE for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:46:28 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MI4WA-0006zV-91
	for xfs@oss.sgi.com; Sat, 20 Jun 2009 17:38:18 +0000
Date: Sat, 20 Jun 2009 13:38:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: small common.config cleanup
Message-ID: <20090620173818.GA26809@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

Don't list various non-mandatory options near the check for the
mandatory ones, and make the test for the mandatory ones a proper if
statements.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/common.config
===================================================================
--- xfstests-dev.orig/common.config	2009-06-20 19:15:14.576805079 +0200
+++ xfstests-dev/common.config	2009-06-20 19:16:48.956930262 +0200
@@ -191,27 +191,18 @@ known_hosts()
   [ -f $HOST_CONFIG_DIR/$HOST ]        && . $HOST_CONFIG_DIR/$HOST
   [ -f $HOST_CONFIG_DIR/$HOST.config ] && . $HOST_CONFIG_DIR/$HOST.config
 
+  #  Mandatory Config values.
   MC=""
-#  Non-Mandatory Config values.
-#  [ -z "$MODULAR" ]        && MC="$MC MODULAR"
-#  [ -z "$TEST_LOGDEV" ]    && MC="$MC TEST_LOGDEV"
-#  [ -z "$SCRATCH_LOGDEV" ] && MC="$MC SCRATCH_LOGDEV"
-#  [ -z "$SCRATCH_RTDEV" ]  && MC="$MC SCRATCH_RTDEV"
-#  [ -z "$SCRATCH_MNT" ]    && MC="$MC SCRATCH_MNT"
-#  [ -z "$SCRATCH_DEV" ]    && MC="$MC SCRATCH_DEV"
-
   [ -z "$EMAIL" ]          && MC="$MC EMAIL"
   [ -z "$TEST_DIR" ]       && MC="$MC TEST_DIR"
   [ -z "$TEST_DEV" ]       && MC="$MC TEST_DEV"
 
-  [ "$MC" ] && (echo "Warning: need to define parameters for host $HOST";\
-	        echo "       or set variables:"; \
-		echo "       $MC")
-#  if [ -e configs/$HOST.config ]
-#     then echo "Not carring, we have a configfile ($HOST_CONFIG_DIR/$HOST)"
-#  else
-     [ "$MC" ] &&  exit 1
-#  fi
+  if [ -n "$MC" ]; then
+    echo "Warning: need to define parameters for host $HOST"
+    echo "       or set variables:"
+    echo "       $MC"
+    exit 1
+  fi
 }
 
 if [ -f "$HOST_OPTIONS" ]; then

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
