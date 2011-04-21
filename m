Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LIoaj6170007 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 13:50:36 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH] xfstests: drop "Mount point match" from 028 and 047 golden
	output
Date: Thu, 21 Apr 2011 13:53:31 -0500
Message-Id: <4023dc38fede89959ba21dbec1fd57b82e9dcff4.1303412002.git.aelder@sgi.com>
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
Cc: Alex Elder <aelder@sgi.com>

Bill Kendall's latest update to xfsdump dropped a line of output
that served no real purpose.  This change updates the golden output
for the two tests that included that line of output.

Updated to filter out that line from dump output also, so old
versions of the code will still produce the same output (suggested
by Dave Chinner).

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 028.out     |    1 -
 047.out     |    1 -
 common.dump |    1 +
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/028.out b/028.out
index 2b562a7..6804733 100644
--- a/028.out
+++ b/028.out
@@ -225,7 +225,6 @@ Processing file /var/xfsdump/inventory/UUIDstab
        /var/xfsdump/inventory/UUID.InvIndex
          Checking access for
           /var/xfsdump/inventory/UUID.StObj
-          Mount point match
             Session 0: HOSTNAME:SCRATCH_MNT
 -------------------------------------------------
 Pruning this matching entry:
diff --git a/047.out b/047.out
index 7470329..31d9a34 100644
--- a/047.out
+++ b/047.out
@@ -225,7 +225,6 @@ Processing file /var/xfsdump/inventory/UUIDstab
        /var/xfsdump/inventory/UUID.InvIndex
          Checking access for
           /var/xfsdump/inventory/UUID.StObj
-          Mount point match
             Session 0: HOSTNAME:SCRATCH_MNT
 -------------------------------------------------
 An entry matching the mount point/time is :
diff --git a/common.dump b/common.dump
index f330daf..c1eb675 100644
--- a/common.dump
+++ b/common.dump
@@ -814,6 +814,7 @@ _dump_filter_main()
       -e '/\/dev\/tty/d'				\
       -e '/inventory session uuid/d'			\
       -e '/ - Running single-threaded/d'		\
+      -e '/Mount point match/d'				\
       -e '/^.*I\/O metrics: .*$/d'			\
       -e 's/1048576/BLOCKSZ/'				\
       -e 's/2097152/BLOCKSZ/'				\
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
