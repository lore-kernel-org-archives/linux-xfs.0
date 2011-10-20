Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KFc01J009891 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 10:38:00 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C252FF6DC86
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:46:06 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id h5lJtKdzaItag9gx for
	<xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:46:06 -0700 (PDT)
From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 1/5] fill files with random data
Date: Thu, 20 Oct 2011 23:41:18 +0800
Message-Id: <1319125282-17062-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
References: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
	<1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
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
To: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: Anand Jain <Anand.Jain@oracle.com>

snapshot data integrity test-case needs filesystem with random data.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 common.rc |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/common.rc b/common.rc
index e948169..37379a5 100644
--- a/common.rc
+++ b/common.rc
@@ -1490,6 +1490,7 @@ _die()
         exit 1
 }
 
+#takes files, randomdata
 _nfiles()
 {
         f=0
@@ -1498,20 +1499,24 @@ _nfiles()
                 file=f$f
                 echo > $file
                 if [ $size -gt 0 ]; then
-                    dd if=/dev/zero of=$file bs=1024 count=$size
+                    if [ $2 == false ]; then
+                        dd if=/dev/zero of=$file bs=1024 count=$size 2>&1 | _filter_dd
+                    else
+                        dd if=/dev/urandom of=$file bs=1024 count=$size 2>&1 | _filter_dd
+                    fi
                 fi
 		let f=$f+1
         done
 }
 
-# takes dirname, depth
+# takes dirname, depth, randomdata
 _descend()
 {
-        dirname=$1; depth=$2
+        dirname=$1; depth=$2; randomdata=$3
         mkdir $dirname  || die "mkdir $dirname failed"
         cd $dirname
 
-        _nfiles $files           # files for this dir
+        _nfiles $files $randomdata          # files for this dir and data type
 
         [ $depth -eq 0 ] && return
 	let deep=$depth-1 # go 1 down
@@ -1529,7 +1534,7 @@ _descend()
 
 # Populate a filesystem with inodes for performance experiments
 #
-# usage: populate [-v] [-n ndirs] [-f nfiles] [-d depth] [-r root] [-s size]
+# usage: populate [-v] [-n ndirs] [-f nfiles] [-d depth] [-r root] [-s size] [-x]
 #
 _populate_fs()
 {
@@ -1540,8 +1545,9 @@ _populate_fs()
     depth=2         # depth of tree from root to leaves
     verbose=false
     root=root       # path of initial root of directory tree
+    randomdata=false # -x data type urandom or zero
 
-    while getopts "d:f:n:r:s:v" c
+    while getopts "d:f:n:r:s:v:x" c
     do
         case $c in
         d)      depth=$OPTARG;;
@@ -1550,10 +1556,11 @@ _populate_fs()
         s)      size=$OPTARG;;
         v)      verbose=true;;
         r)      root=$OPTARG;;
+        x)      randomdata=true;;
         esac
     done
 
-    _descend $root $depth
+    _descend $root $depth $randomdata
     wait
 
     cd $here
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
