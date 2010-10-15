Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9FMS31J158223 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 17:28:03 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 239D81C02D54
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 15:29:13 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id vZh4qVItsEdRsDhS for
	<xfs@oss.sgi.com>; Fri, 15 Oct 2010 15:29:13 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P6sm1-0000zN-QS
	for xfs@oss.sgi.com; Fri, 15 Oct 2010 22:29:13 +0000
Date: Fri, 15 Oct 2010 18:29:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] xfstests: fix quota detection
Message-ID: <20101015222913.GC3781@infradead.org>
References: <20101015222820.GA3655@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101015222820.GA3655@infradead.org>
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

Even if the kernel has quota support built in most filesystems still
don't support it.  As there's no good way to find out if a filesystem
supports quotas hardcode the list of filesystems that do support
quotas.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/common.quota
===================================================================
--- xfstests-dev.orig/common.quota	2010-10-14 19:28:41.000000000 +0000
+++ xfstests-dev/common.quota	2010-10-14 19:33:45.000000000 +0000
@@ -27,11 +27,24 @@
 _require_quota()
 {
     [ -n $QUOTA_PROG ] || _notrun "Quota user tools not installed"
-    if [ $FSTYP = "xfs" ]; then
-	[ -f /proc/fs/xfs/xqmstat ] || _notrun "Installed kernel does not support XFS quota"
-    elif [ $FSTYP != "gfs2" ]; then
-	[ -d /proc/sys/fs/quota ] || _notrun "Installed kernel does not support quota"
-    fi
+
+    case $FSTYP in
+    ext2|ext3|ext4|reiserfs)
+	if [ ! -d /proc/sys/fs/quota ]; then
+	    _notrun "Installed kernel does not support quotas"
+	fi
+	;;
+    gfs2)
+	;;
+    xfs)
+	if [ ! -f /proc/fs/xfs/xqmstat ]; then
+	    _notrun "Installed kernel does not support XFS quotas"
+        fi
+	;;
+    *)
+	_notrun "disk quotas not supported by this filesystem type: $FSTYP"
+	;;
+    esac
 }
 
 #

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
