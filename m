Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FBE87CB4
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:39:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A4101AC009
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:39:50 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id z75hRXfgp4B74vNe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:39:46 -0800 (PST)
Subject: [PATCH 04/32] reflink: remove redundant filesystem checks from the
	end of the tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:39:42 -0800
Message-ID: <20160211233942.2202.55344.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Turns out that check already runs _check_filesystems after each test,
so we don't need to do this at the end of each test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/157 |    1 -
 tests/generic/158 |    1 -
 tests/generic/161 |    1 -
 tests/generic/162 |    1 -
 tests/generic/163 |    1 -
 tests/generic/164 |    1 -
 tests/generic/165 |    1 -
 tests/generic/166 |    1 -
 tests/generic/167 |    1 -
 tests/generic/168 |    1 -
 tests/generic/170 |    1 -
 tests/generic/171 |    1 -
 tests/generic/172 |    1 -
 tests/generic/173 |    1 -
 tests/generic/174 |    1 -
 tests/generic/175 |    1 -
 tests/generic/176 |    1 -
 tests/generic/183 |    1 -
 tests/generic/185 |    1 -
 tests/generic/186 |    1 -
 tests/generic/187 |    1 -
 tests/generic/188 |    1 -
 tests/generic/189 |    1 -
 tests/generic/190 |    1 -
 tests/generic/191 |    1 -
 tests/generic/194 |    1 -
 tests/generic/195 |    1 -
 tests/generic/196 |    1 -
 tests/generic/197 |    1 -
 tests/generic/199 |    1 -
 tests/generic/200 |    1 -
 tests/generic/201 |    1 -
 tests/generic/202 |    1 -
 tests/generic/203 |    1 -
 tests/generic/205 |    1 -
 tests/generic/206 |    1 -
 tests/generic/216 |    1 -
 tests/generic/217 |    1 -
 tests/generic/218 |    1 -
 tests/generic/220 |    1 -
 tests/generic/222 |    1 -
 tests/generic/227 |    1 -
 tests/generic/229 |    1 -
 tests/generic/238 |    1 -
 tests/generic/242 |    1 -
 tests/generic/243 |    1 -
 tests/xfs/127     |    1 -
 tests/xfs/128     |    1 -
 tests/xfs/131     |    1 -
 tests/xfs/139     |    1 -
 tests/xfs/140     |    1 -
 51 files changed, 51 deletions(-)


diff --git a/tests/generic/157 b/tests/generic/157
index 0150866..74314d8 100755
--- a/tests/generic/157
+++ b/tests/generic/157
@@ -123,7 +123,6 @@ _reflink_range "$testdir2/file1" 0 "$testdir2/file2" 0 $blksz >> "$seqres.full"
 
 echo "Check scratch fs"
 _scratch_unmount
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/158 b/tests/generic/158
index 807c247..779d55e 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -124,7 +124,6 @@ _dedupe_range "$testdir2/file1" 0 "$testdir2/file2" 0 $blksz >> "$seqres.full"
 
 echo "Check scratch fs"
 _scratch_unmount
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/161 b/tests/generic/161
index 7fb8963..b271936 100755
--- a/tests/generic/161
+++ b/tests/generic/161
@@ -71,7 +71,6 @@ wait
 
 echo "Check fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 echo "Done"
 # success, all done
diff --git a/tests/generic/162 b/tests/generic/162
index 2fb947a..30c761b 100755
--- a/tests/generic/162
+++ b/tests/generic/162
@@ -87,7 +87,6 @@ wait
 
 echo "Check fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 echo "Done"
 # success, all done
diff --git a/tests/generic/163 b/tests/generic/163
index 0186443..f2ea334 100755
--- a/tests/generic/163
+++ b/tests/generic/163
@@ -87,7 +87,6 @@ wait
 
 echo "Check fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 echo "Done"
 # success, all done
diff --git a/tests/generic/164 b/tests/generic/164
index 087c6ba..e97ac13 100755
--- a/tests/generic/164
+++ b/tests/generic/164
@@ -97,7 +97,6 @@ wait
 
 echo "Check fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 echo "Done"
 # success, all done
diff --git a/tests/generic/165 b/tests/generic/165
index 6bd15e1..b305079 100755
--- a/tests/generic/165
+++ b/tests/generic/165
@@ -97,7 +97,6 @@ wait
 
 echo "Check fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 echo "Done"
 # success, all done
diff --git a/tests/generic/166 b/tests/generic/166
index 6cfb821..2c2ff4e 100755
--- a/tests/generic/166
+++ b/tests/generic/166
@@ -84,7 +84,6 @@ wait
 
 echo "Check for damage"
 _scratch_unmount
-_check_scratch_fs
 
 echo "Done"
 
diff --git a/tests/generic/167 b/tests/generic/167
index fc5a86c..b80b481 100755
--- a/tests/generic/167
+++ b/tests/generic/167
@@ -84,7 +84,6 @@ wait
 
 echo "Check for damage"
 _scratch_unmount
-_check_scratch_fs
 
 echo "Done"
 
diff --git a/tests/generic/168 b/tests/generic/168
index ee3848d..0d620da 100755
--- a/tests/generic/168
+++ b/tests/generic/168
@@ -88,7 +88,6 @@ wait
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 echo "Done"
 
diff --git a/tests/generic/170 b/tests/generic/170
index 6d27810..78ed63d 100755
--- a/tests/generic/170
+++ b/tests/generic/170
@@ -88,7 +88,6 @@ wait
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 echo "Done"
 
diff --git a/tests/generic/171 b/tests/generic/171
index ec3729d..4b4f141 100755
--- a/tests/generic/171
+++ b/tests/generic/171
@@ -100,7 +100,6 @@ echo "${out}"
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/172 b/tests/generic/172
index 1988c8d..98eb97f 100755
--- a/tests/generic/172
+++ b/tests/generic/172
@@ -100,7 +100,6 @@ echo "${out}"
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/173 b/tests/generic/173
index 5bb9ce6..e26f5a9 100755
--- a/tests/generic/173
+++ b/tests/generic/173
@@ -102,7 +102,6 @@ fi
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/174 b/tests/generic/174
index a8e0bb5..1749a1c 100755
--- a/tests/generic/174
+++ b/tests/generic/174
@@ -100,7 +100,6 @@ echo "${out}"
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/175 b/tests/generic/175
index b37ff66..ac2f54f 100755
--- a/tests/generic/175
+++ b/tests/generic/175
@@ -92,7 +92,6 @@ _check_scratch_fs
 echo "Remove all files and recheck"
 _scratch_mount >> "$seqres.full" 2>&1
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/176 b/tests/generic/176
index 0ca0b17..e32f94f 100755
--- a/tests/generic/176
+++ b/tests/generic/176
@@ -74,7 +74,6 @@ done
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/183 b/tests/generic/183
index 8141f38..27179fd 100755
--- a/tests/generic/183
+++ b/tests/generic/183
@@ -94,7 +94,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/185 b/tests/generic/185
index 1d6dff2..368260d 100755
--- a/tests/generic/185
+++ b/tests/generic/185
@@ -94,7 +94,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/186 b/tests/generic/186
index 9aac966..67e52b5 100755
--- a/tests/generic/186
+++ b/tests/generic/186
@@ -139,7 +139,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/187 b/tests/generic/187
index b3f1542..c993394 100755
--- a/tests/generic/187
+++ b/tests/generic/187
@@ -139,7 +139,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/188 b/tests/generic/188
index c67b847..9e63388 100755
--- a/tests/generic/188
+++ b/tests/generic/188
@@ -89,7 +89,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/189 b/tests/generic/189
index 1954235..661129c 100755
--- a/tests/generic/189
+++ b/tests/generic/189
@@ -89,7 +89,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/190 b/tests/generic/190
index d3d573b..4e272c2 100755
--- a/tests/generic/190
+++ b/tests/generic/190
@@ -89,7 +89,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/191 b/tests/generic/191
index 8b19084..5aadded 100755
--- a/tests/generic/191
+++ b/tests/generic/191
@@ -89,7 +89,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/194 b/tests/generic/194
index 1fc2cd7..a17debc 100755
--- a/tests/generic/194
+++ b/tests/generic/194
@@ -94,7 +94,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/195 b/tests/generic/195
index 087275c..f49d0c2 100755
--- a/tests/generic/195
+++ b/tests/generic/195
@@ -94,7 +94,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/196 b/tests/generic/196
index d815232..4da9c76 100755
--- a/tests/generic/196
+++ b/tests/generic/196
@@ -89,7 +89,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/197 b/tests/generic/197
index 54005ae..54ee5ab 100755
--- a/tests/generic/197
+++ b/tests/generic/197
@@ -89,7 +89,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/199 b/tests/generic/199
index eb567e4..5e4bca8 100755
--- a/tests/generic/199
+++ b/tests/generic/199
@@ -118,7 +118,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/200 b/tests/generic/200
index 991fed0..f0521ae 100755
--- a/tests/generic/200
+++ b/tests/generic/200
@@ -118,7 +118,6 @@ md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/201 b/tests/generic/201
index ffc1ce4..db77a5e 100755
--- a/tests/generic/201
+++ b/tests/generic/201
@@ -79,7 +79,6 @@ rm "$testdir/file3"
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/202 b/tests/generic/202
index 375b65f..91f2d9b 100755
--- a/tests/generic/202
+++ b/tests/generic/202
@@ -79,7 +79,6 @@ md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/203 b/tests/generic/203
index 549f2ba..86a672b 100755
--- a/tests/generic/203
+++ b/tests/generic/203
@@ -79,7 +79,6 @@ md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/205 b/tests/generic/205
index 8f0ec45..8fed955 100755
--- a/tests/generic/205
+++ b/tests/generic/205
@@ -95,7 +95,6 @@ cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/206 b/tests/generic/206
index f2c4ecc..10b5285 100755
--- a/tests/generic/206
+++ b/tests/generic/206
@@ -95,7 +95,6 @@ cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/216 b/tests/generic/216
index 3789cb0..671f0c1 100755
--- a/tests/generic/216
+++ b/tests/generic/216
@@ -96,7 +96,6 @@ cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/217 b/tests/generic/217
index 4ae603f..e4d40c7 100755
--- a/tests/generic/217
+++ b/tests/generic/217
@@ -96,7 +96,6 @@ cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/218 b/tests/generic/218
index d63c06f..eb52fea 100755
--- a/tests/generic/218
+++ b/tests/generic/218
@@ -90,7 +90,6 @@ cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/220 b/tests/generic/220
index ccdb32e..fb5ecda 100755
--- a/tests/generic/220
+++ b/tests/generic/220
@@ -90,7 +90,6 @@ cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/222 b/tests/generic/222
index cb5a788..ab3f65f 100755
--- a/tests/generic/222
+++ b/tests/generic/222
@@ -96,7 +96,6 @@ cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/227 b/tests/generic/227
index d200424..387c714 100755
--- a/tests/generic/227
+++ b/tests/generic/227
@@ -96,7 +96,6 @@ cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/229 b/tests/generic/229
index cdaddaf..eb105a3 100755
--- a/tests/generic/229
+++ b/tests/generic/229
@@ -156,7 +156,6 @@ runtest delalloc regular "$testdir/d-r"
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/238 b/tests/generic/238
index 98530e0..02057ad 100755
--- a/tests/generic/238
+++ b/tests/generic/238
@@ -156,7 +156,6 @@ runtest delalloc regular "$testdir/d-r"
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/242 b/tests/generic/242
index a5a17c3..3023ac7 100755
--- a/tests/generic/242
+++ b/tests/generic/242
@@ -92,7 +92,6 @@ md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/generic/243 b/tests/generic/243
index b7ca466..e65347f 100755
--- a/tests/generic/243
+++ b/tests/generic/243
@@ -92,7 +92,6 @@ md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/xfs/127 b/tests/xfs/127
index c31cd17..63d5890 100755
--- a/tests/xfs/127
+++ b/tests/xfs/127
@@ -72,7 +72,6 @@ xfs_info "$SCRATCH_MNT" >> "$seqres.full"
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/xfs/128 b/tests/xfs/128
index c9547fb..2e1da3f 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -142,7 +142,6 @@ _within_tolerance "free blocks after all tests" $free_blocks3 $((free_blocks0 -
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/xfs/131 b/tests/xfs/131
index 8442821..adab31f 100755
--- a/tests/xfs/131
+++ b/tests/xfs/131
@@ -69,7 +69,6 @@ test -s "$testdir/file2" && _fail "Should not be able to reflink a realtime file
 
 echo "Check restored fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/xfs/139 b/tests/xfs/139
index 51c903e..feb55bd 100755
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -75,7 +75,6 @@ md5sum "$testdir/file2" | _filter_scratch
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/xfs/140 b/tests/xfs/140
index 133bb72..309b284 100644
--- a/tests/xfs/140
+++ b/tests/xfs/140
@@ -82,7 +82,6 @@ cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
-_check_scratch_fs
 
 # success, all done
 status=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
