Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFDA17FB5
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 20:05:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E696AC003
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 18:05:50 -0800 (PST)
Received: from mail-we0-f171.google.com (mail-we0-f171.google.com
	[74.125.82.171]) by cuda.sgi.com with ESMTP id ubsiWptZqepA4xyc
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 31 Jan 2014 18:05:45 -0800 (PST)
Received: by mail-we0-f171.google.com with SMTP id u56so286356wes.16
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 18:05:44 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: more tests for test case btrfs/030
Date: Sat,  1 Feb 2014 02:05:32 +0000
Message-Id: <1391220332-22118-1-git-send-email-fdmanana@gmail.com>
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
Cc: jbacik@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

This change adds some new tests for btrfs' incremental send feature.
These are all related with inverting the parent-child relationship
of directories, and cover the cases:

* when the new parent didn't get renamed (just moved)
* when a child file of the former parent gets renamed too

These new cases are fixed by the following btrfs linux kernel patches:

* "Btrfs: more send support for parent/child dir relationship inversion"
* "Btrfs: fix send dealing with file renames and directory moves"

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/030 |   86 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 21 deletions(-)

diff --git a/tests/btrfs/030 b/tests/btrfs/030
index 6678ed8..6b52a0d 100755
--- a/tests/btrfs/030
+++ b/tests/btrfs/030
@@ -73,22 +73,41 @@ mkdir $SCRATCH_MNT/a/b/www
 echo "hey" > $SCRATCH_MNT/a/b/foobar.txt
 mkdir -p $SCRATCH_MNT/a/b/c3/x/y
 
+mkdir -p $SCRATCH_MNT/a/b/foo1/foo2
+echo "hey" > $SCRATCH_MNT/a/b/foo1/foo2/f.txt
+mkdir $SCRATCH_MNT/a/b/foo3
+
+mkdir -p $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4
+echo "ola" > $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4/hello.txt
+
 # Directory tree looks like:
 #
-# .                         (ino 256)
-# |-- a/                    (ino 257)
-#     |-- b/                (ino 258)
-#         |-- c/            (ino 259)
-#         |   |-- file.txt  (ino 260)
-#         |   |-- d/        (ino 261)
+# .                                      (ino 256)
+# |-- a/                                 (ino 257)
+#     |-- b/                             (ino 258)
+#         |-- c/                         (ino 259)
+#         |   |-- file.txt               (ino 260)
+#         |   |-- d/                     (ino 261)
+#         |
+#         |-- c2/                        (ino 262)
+#         |-- www/                       (ino 263)
+#         |-- foobar.txt                 (ino 264)
+#         |
+#         |-- c3/                        (ino 265)
+#         |   |-- x/                     (ino 266)
+#         |       |-- y/                 (ino 267)
+#         |
+#         |-- foo1/                      (ino 268)
+#         |    |---foo2/                 (ino 269)
+#         |         |---f.txt            (ino 270)
 #         |
-#         |-- c2/           (ino 262)
-#         |-- www/          (ino 263)
-#         |-- foobar.txt    (ino 264)
+#         |-- foo3/                      (ino 271)
 #         |
-#         |-- c3/           (ino 265)
-#             |-- x/        (ino 266)
-#                 |-- y/    (ino 267)
+#         |-- bar1/                      (ino 272)
+#              |-- bar2/                 (ino 273)
+#                  |-- bar3/             (ino 274)
+#                      |-- bar4          (ino 275)
+#                           |--hello.txt (ino 276)
 
 run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
     $SCRATCH_MNT/mysnap1
@@ -104,21 +123,46 @@ mv $SCRATCH_MNT/a/b/foobar.txt $SCRATCH_MNT/a/b/c2/y2/x2/qwerty.txt
 ln $SCRATCH_MNT/a/b/c2/d2/cc/file.txt $SCRATCH_MNT/a/b/c2/y2/x2/Z/file_link.txt
 mv $SCRATCH_MNT/a/b/c2/d2/cc/file.txt $SCRATCH_MNT/a/b/c2/y2/x2
 
+mv $SCRATCH_MNT/a/b/foo3 $SCRATCH_MNT/a/b/foo1/foo33
+mv $SCRATCH_MNT/a/b/foo1/foo2 $SCRATCH_MNT/a/b/foo1/foo33/foo22
+mv $SCRATCH_MNT/a/b/foo1/foo33/foo22/f.txt \
+    $SCRATCH_MNT/a/b/foo1/foo33/foo22/fff.txt
+
+echo " hello" >> $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4/hello.txt
+mv $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4/hello.txt \
+    $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4/hello2.txt
+mv $SCRATCH_MNT/a/b/bar1/bar2/bar3/bar4 $SCRATCH_MNT/a/b/k44
+mv $SCRATCH_MNT/a/b/bar1/bar2/bar3 $SCRATCH_MNT/a/b/k44
+mv $SCRATCH_MNT/a/b/bar1/bar2 $SCRATCH_MNT/a/b/k44/bar3
+mv $SCRATCH_MNT/a/b/bar1 $SCRATCH_MNT/a/b/k44/bar3/bar2/k11
+
 # Directory tree now looks like:
 #
 # .                                         (ino 256)
 # |-- a/                                    (ino 257)
 #     |-- b/                                (ino 258)
 #         |-- c2/                           (ino 262)
-#             |-- d2/                       (ino 261)
-#             |   |-- cc/                   (ino 259)
-#             |        |-- file.txt         (ino 260)
-#             |-- y2/                       (ino 267)
-#                 |-- x2/                   (ino 266)
-#                     |-- qwerty.txt        (ino 264)
-#                     |-- WWW/              (ino 263)
-#                     |-- Z/                (ino 265)
-#                         |-- file_link.txt
+#         |   |-- d2/                       (ino 261)
+#         |   |   |-- cc/                   (ino 259)
+#         |   |
+#         |   |-- y2/                       (ino 267)
+#         |       |-- x2/                   (ino 266)
+#         |           |-- file.txt          (ino 260)
+#         |           |-- qwerty.txt        (ino 264)
+#         |           |-- WWW/              (ino 263)
+#         |           |-- Z/                (ino 265)
+#         |               |-- file_link.txt
+#         |
+#         |-- foo1/                         (ino 268)
+#         |    |---foo33/                   (ino 271)
+#         |          |---foo22/             (ino 269)
+#         |                |---fff.txt      (ino 270)
+#         |
+#         |-- k44/                          (ino 275)
+#              |-- hello2.txt               (ino 276)
+#              |-- bar3/                    (ino 274)
+#                   |-- bar2/               (ino 273)
+#                        |-- k11/           (ino 272)
 
 run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
     $SCRATCH_MNT/mysnap2
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
