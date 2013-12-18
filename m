Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C15487F3F
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 12:16:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ABBF7304066
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:08 -0800 (PST)
Received: from mail-ob0-f202.google.com (mail-ob0-f202.google.com
	[209.85.214.202]) by cuda.sgi.com with ESMTP id
	WsR6v7Ut4g9vWjL4 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 10:16:07 -0800 (PST)
Received: by mail-ob0-f202.google.com with SMTP id gq1so1769obb.5
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:07 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v3 04/12] xfstests: rename _require_xfs_io_fiemap to
	_require_fiemap
Date: Wed, 18 Dec 2013 10:15:55 -0800
Message-Id: <1387390563-27064-4-git-send-email-jayr@google.com>
In-Reply-To: <1387390563-27064-1-git-send-email-jayr@google.com>
References: <1387390563-27064-1-git-send-email-jayr@google.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

Rename the function because we need both xfs_io and kernel support for
the check, and we need xfs_io support to check for kernel support.

Signed-off-by: Junho Ryu <jayr@google.com>
---

v3: same as v2

v2: new patch

 common/defrag     | 2 +-
 common/rc         | 2 +-
 tests/generic/255 | 2 +-
 tests/generic/316 | 2 +-
 tests/shared/298  | 2 +-
 tests/xfs/252     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/common/defrag b/common/defrag
index a4bc976..81b58e7 100644
--- a/common/defrag
+++ b/common/defrag
@@ -38,7 +38,7 @@ _require_defrag()
     esac
 
     _require_command $DEFRAG_PROG
-    _require_xfs_io_fiemap
+    _require_fiemap
 }
 
 _extent_count()
diff --git a/common/rc b/common/rc
index 73e9f34..81baa1d 100644
--- a/common/rc
+++ b/common/rc
@@ -1281,7 +1281,7 @@ _require_xfs_io_falloc_punch()
 }
 
 # check that xfs_io, kernel and filesystem support fiemap
-_require_xfs_io_fiemap()
+_require_fiemap()
 {
 	testfile=$TEST_DIR/$$.fiemap
 	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
diff --git a/tests/generic/255 b/tests/generic/255
index dd329b4..739629c 100755
--- a/tests/generic/255
+++ b/tests/generic/255
@@ -48,7 +48,7 @@ _supported_os Linux
 
 _require_xfs_io_falloc_punch
 _require_xfs_io_falloc
-_require_xfs_io_fiemap
+_require_fiemap
 
 testfile=$TEST_DIR/255.$$
 
diff --git a/tests/generic/316 b/tests/generic/316
index 8cb2975..4bb6c4a 100755
--- a/tests/generic/316
+++ b/tests/generic/316
@@ -46,7 +46,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_xfs_io_falloc_punch
-_require_xfs_io_fiemap
+_require_fiemap
 
 testfile=$TEST_DIR/$seq.$$
 
diff --git a/tests/shared/298 b/tests/shared/298
index 4541798..e8c3d48 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs ext4 xfs
 _supported_os Linux
 _require_fstrim
-_require_xfs_io_fiemap
+_require_fiemap
 _require_fs_space $TEST_DIR 307200
 [ "$FSTYP" = "ext4" ] && _require_dumpe2fs
 
diff --git a/tests/xfs/252 b/tests/xfs/252
index 00be41a..1a5133e 100755
--- a/tests/xfs/252
+++ b/tests/xfs/252
@@ -47,7 +47,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_xfs_io_falloc_punch
-_require_xfs_io_fiemap
+_require_fiemap
 
 testfile=$TEST_DIR/252.$$
 
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
