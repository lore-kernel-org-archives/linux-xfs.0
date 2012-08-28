Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SHSemV126104 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 12:28:40 -0500
Received: from cxfsxe4.americas.sgi.com (cxfsxe4.americas.sgi.com
	[128.162.240.177])
	by estes.americas.sgi.com (Postfix) with ESMTP id 10D7B7001AAF;
	Tue, 28 Aug 2012 12:29:29 -0500 (CDT)
Received: by cxfsxe4.americas.sgi.com (Postfix, from userid 48222)
	id F1DBCCDA81; Tue, 28 Aug 2012 12:29:28 -0500 (CDT)
Message-Id: <20120828172928.785762590@sgi.com>
Date: Tue, 28 Aug 2012 12:26:06 -0500
From: Rich Johnston <rjohnston@sgi.com>
Subject: [PATCH 1/5] xfstests: Use libtool to install lstat64
References: <20120828172605.607853317@sgi.com>
Content-Disposition: inline;
	filename=1-5-xfstests-use-libtool-to-install-lstat64.patch
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

Use libtool to install lstat64 on $SCRATCH_MNT instead of cp.  Libtool will
install the binary from the proper location and display a warning if any
shared library dependancies are not properly installed.  This ensures that a
libtool wrapper shell script is not installed in place of lstat64 when libtool
wrappers are being used. 

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
 120 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/120
===================================================================
--- a/120
+++ b/120
@@ -68,7 +68,7 @@ fi
 
 #executable file
 echo "*** copying file ***"
-cp src/lstat64 $SCRATCH_MNT
+libtool --mode=install install src/lstat64 $SCRATCH_MNT/lstat64
 src/lstat64 $SCRATCH_MNT/lstat64 >$tmp.out
 sleep 5
 echo "*** executing file ***"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
