Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 848697F60
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:12 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx9007456 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 11/18] xfstests: add tests into tests/xfs/group
MIME-Version: 1.0
Message-Id: <20130314130611.935D953DEAF8@polaris-admin.engr.sgi.com>
From: pwhite@sgi.com (Philip White)
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
To: xfs@oss.sgi.com

From: Phil White <pwhite@sgi.com>


This is a rebasing & resubmit of a dchinner patch.  His comments on the
original:
-----------------
And into tests/xfs. Tests found and moved via:

$ grep "supported_fs xfs$" [0-2]* | cut -d : -f 1 > xfs.tests
$ for i in `cat xfs.tests`; do
> git mv $i* tests/xfs/
> grep ^$i group >> tests/xfs/group
> sed -i -e "/^$i/d" group
> done

Output now looks like:

 sudo ./check -g quick -r
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-1 3.5.0-rc5-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

xfs/170  4s
generic/120      16s
generic/248      0s
generic/213      0s
generic/256      39s
xfs/121  6s
xfs/026  11s
generic/131      1s
xfs/187  1s
generic/135      0s
....
-----------------
For ease of reviewing, I put all the actual test movements into a separate
patch.

Signed-off-by: Phil White <pwhite@sgi.com>
---
 common          |    3 +-
 group           |  172 -------------------------------------------------------
 tests/xfs/group |  172 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+), 173 deletions(-)
 create mode 100644 tests/xfs/group

diff --git a/common b/common
index b41d4d0..57c3ac5 100644
--- a/common
+++ b/common
@@ -35,6 +35,7 @@ timestamp=${TIMESTAMP:=false}
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
 TEST_GROUP_DIR="tests"
 GENERIC_GROUP_DIR="$TEST_GROUP_DIR/generic"
+XFS_GROUP_DIR="$TEST_GROUP_DIR/xfs"
 
 _setenvironment()
 {
@@ -45,7 +46,7 @@ _setenvironment()
 get_group_list()
 {
 	grp=$1
-	dirs=". $GENERIC_GROUP_DIR"
+	dirs=". $GENERIC_GROUP_DIR $XFS_GROUP_DIR"
 
 	for d in $dirs; do
 		l=$(sed -n < $d/group \
diff --git a/group b/group
index dd0b622..9e8ee53 100644
--- a/group
+++ b/group
@@ -116,194 +116,22 @@ stress
 
 # test-group association ... one line per test
 #
-003 db auto quick
-004 db auto quick
-008 rw ioctl auto quick
-009 rw ioctl auto prealloc quick
-012 rw auto quick
-016 rw auto quick
-017 mount auto quick stress
-018 deprecated # log logprint v2log
-019 mkfs auto quick
-021 db attr auto quick
-022 dump ioctl tape
-023 dump ioctl tape
-024 dump ioctl tape
-025 dump ioctl tape
-026 dump ioctl auto quick
-027 dump ioctl auto quick
-028 dump ioctl auto quick
-029 mkfs logprint log auto quick
-030 repair auto quick
-031 repair mkfs auto quick
-032 mkfs auto quick
-033 repair auto quick
-034 other auto quick
-035 dump ioctl tape auto
-036 dump ioctl remote tape
-037 dump ioctl remote tape
-038 dump ioctl remote tape
-039 dump ioctl remote tape
 040 other auto
-041 growfs ioctl auto
-042 fsr ioctl auto
-043 dump ioctl tape
-044 other auto
-045 other auto quick
-046 dump ioctl auto quick
-047 dump ioctl auto
-048 other auto quick
-049 rw auto quick
-050 quota auto quick
 051 acl udf auto quick
-052 quota db auto quick
-054 quota auto quick
-055 dump ioctl remote tape
-056 dump ioctl auto quick
-057 acl auto
-058 acl auto
-059 dump ioctl auto quick
-060 dump ioctl auto quick
-061 dump ioctl auto quick
-063 dump attr auto quick
-064 dump auto
-065 dump auto
-066 dump ioctl auto quick
-067 acl attr auto quick
 068 other auto freeze dangerous stress
-071 rw auto
-072 rw auto prealloc quick
-073 copy auto
-078 growfs auto quick
-080 rw ioctl
-081 deprecated # log logprint quota
-082 deprecated # log logprint v2log
-084 ioctl rw auto
-085 log auto quick
-086 log v2log auto
-087 log v2log auto quota stress
-090 rw auto
-092 other auto quick
-094 metadata dir ioctl auto
-095 log v2log auto
-096 mkfs v2log auto quick
 098 udf auto
 101 udf
 102 udf
-103 metadata dir ioctl auto quick
-104 growfs ioctl prealloc auto stress
-106 quota
-107 quota
-108 quota auto quick
-109 metadata auto
-110 repair auto
-111 ioctl
-114 parent attr stress
-115 parent attr
-116 quota auto quick
-118 quota auto quick
-119 log v2log auto freeze dangerous
-121 log auto quick
-122 other auto quick
-134 quota auto quick
-136 attr2
-137 metadata log auto
-138 metadata log auto
-139 metadata log auto
-140 metadata log auto
-142 dmapi auto
-143 dmapi auto
-144 dmapi auto
-145 dmapi auto
-146 dmapi auto
-147 dmapi auto
-148 repair auto
-149 repair auto
-150 dmapi auto
-151 dmapi auto
-152 dmapi auto
-153 dmapi auto
-154 dmapi auto
-155 dmapi auto
-156 dmapi auto
-157 dmapi auto
-158 dmapi auto
-159 dmapi auto
-160 dmapi auto
-161 dmapi auto
-162 dmapi auto
-163 dmapi auto
-164 rw pattern auto prealloc quick
-165 rw pattern auto prealloc quick
-166 rw metadata auto quick
-167 rw metadata auto stress
-168 dmapi auto
-170 rw filestreams auto quick
-# the next three tests are not deterministic enough to get the
-# "right" result on all platforms/configuration, so don't run
-# them by default.
-171 rw filestreams
-172 rw filestreams
-173 rw filestreams
-174 rw filestreams auto
-175 dmapi auto
-176 dmapi auto
 177 rw other auto
-178 mkfs other auto
-179 metadata rw auto
-180 metadata rw auto
-181 log auto quick
-182 metadata rw auto
-183 rw other auto quick
-185 dmapi auto
-186 attr auto quick
-187 attr auto quick
-188 ci dir auto
-189 mount auto quick
-190 rw auto quick
-191 nfs4acl auto
-194 rw auto
-195 ioctl dump auto quick
-196 quota auto quick
-197 dir auto quick
-199 mount auto quick
-200 mount auto quick
-201 metadata auto quick
-202 repair auto quick
-203 ioctl auto
-205 metadata rw auto
-206 growfs auto quick
-216 log metadata auto quick
-217 log metadata auto
 218 auto fsr quick
-220 auto quota quick
-222 auto fsr ioctl quick
-227 auto fsr
-229 auto rw
-238 auto quick metadata ioctl
-242 auto quick prealloc
 243 auto quick prealloc
-244 auto quota quick
-250 auto quick rw prealloc metadata
 252 auto quick prealloc
-253 auto quick
 254 auto quick
-259 auto quick
-261 auto quick quota
-262 auto quick quota
 264 auto
 265 auto
-266 dump ioctl auto quick
-267 dump ioctl tape
-268 dump ioctl tape
 271 auto rw quick
 272 auto enospc rw
 276 auto rw metadata
-278 repair auto
-279 auto mkfs
-281 dump ioctl auto quick
-282 dump ioctl auto quick
-283 dump ioctl auto quick
 284 auto
 285 auto rw
 286 other
diff --git a/tests/xfs/group b/tests/xfs/group
new file mode 100644
index 0000000..0affcba
--- /dev/null
+++ b/tests/xfs/group
@@ -0,0 +1,172 @@
+003 db auto quick
+004 db auto quick
+008 rw ioctl auto quick
+009 rw ioctl auto prealloc quick
+012 rw auto quick
+016 rw auto quick
+017 mount auto quick stress
+018 deprecated # log logprint v2log
+019 mkfs auto quick
+021 db attr auto quick
+022 dump ioctl tape
+023 dump ioctl tape
+024 dump ioctl tape
+025 dump ioctl tape
+026 dump ioctl auto quick
+027 dump ioctl auto quick
+028 dump ioctl auto quick
+029 mkfs logprint log auto quick
+030 repair auto quick
+031 repair mkfs auto quick
+032 mkfs auto quick
+033 repair auto quick
+034 other auto quick
+035 dump ioctl tape auto
+036 dump ioctl remote tape
+037 dump ioctl remote tape
+038 dump ioctl remote tape
+039 dump ioctl remote tape
+041 growfs ioctl auto
+042 fsr ioctl auto
+043 dump ioctl tape
+044 other auto
+045 other auto quick
+046 dump ioctl auto quick
+047 dump ioctl auto
+048 other auto quick
+049 rw auto quick
+050 quota auto quick
+052 quota db auto quick
+054 quota auto quick
+055 dump ioctl remote tape
+056 dump ioctl auto quick
+057 acl auto
+058 acl auto
+059 dump ioctl auto quick
+060 dump ioctl auto quick
+061 dump ioctl auto quick
+063 dump attr auto quick
+064 dump auto
+065 dump auto
+066 dump ioctl auto quick
+067 acl attr auto quick
+071 rw auto
+072 rw auto prealloc quick
+073 copy auto
+078 growfs auto quick
+080 rw ioctl
+081 deprecated # log logprint quota
+082 deprecated # log logprint v2log
+084 ioctl rw auto
+085 log auto quick
+086 log v2log auto
+087 log v2log auto quota stress
+090 rw auto
+092 other auto quick
+094 metadata dir ioctl auto
+095 log v2log auto
+096 mkfs v2log auto quick
+103 metadata dir ioctl auto quick
+104 growfs ioctl prealloc auto stress
+106 quota
+107 quota
+108 quota auto quick
+109 metadata auto
+110 repair auto
+111 ioctl
+114 parent attr stress
+115 parent attr
+116 quota auto quick
+118 quota auto quick
+119 log v2log auto freeze dangerous
+121 log auto quick
+122 other auto quick
+134 quota auto quick
+136 attr2
+137 metadata log auto
+138 metadata log auto
+139 metadata log auto
+140 metadata log auto
+142 dmapi auto
+143 dmapi auto
+144 dmapi auto
+145 dmapi auto
+146 dmapi auto
+147 dmapi auto
+148 repair auto
+149 repair auto
+150 dmapi auto
+151 dmapi auto
+152 dmapi auto
+153 dmapi auto
+154 dmapi auto
+155 dmapi auto
+156 dmapi auto
+157 dmapi auto
+158 dmapi auto
+159 dmapi auto
+160 dmapi auto
+161 dmapi auto
+162 dmapi auto
+163 dmapi auto
+164 rw pattern auto prealloc quick
+165 rw pattern auto prealloc quick
+166 rw metadata auto quick
+167 rw metadata auto stress
+168 dmapi auto
+170 rw filestreams auto quick
+# the next three tests are not deterministic enough to get the
+# "right" result on all platforms/configuration, so don't run
+# them by default.
+171 rw filestreams
+172 rw filestreams
+173 rw filestreams
+174 rw filestreams auto
+175 dmapi auto
+176 dmapi auto
+178 mkfs other auto
+179 metadata rw auto
+180 metadata rw auto
+181 log auto quick
+182 metadata rw auto
+183 rw other auto quick
+185 dmapi auto
+186 attr auto quick
+187 attr auto quick
+188 ci dir auto
+189 mount auto quick
+190 rw auto quick
+191 nfs4acl auto
+194 rw auto
+195 ioctl dump auto quick
+196 quota auto quick
+197 dir auto quick
+199 mount auto quick
+200 mount auto quick
+201 metadata auto quick
+202 repair auto quick
+203 ioctl auto
+205 metadata rw auto
+206 growfs auto quick
+216 log metadata auto quick
+217 log metadata auto
+220 auto quota quick
+222 auto fsr ioctl quick
+227 auto fsr
+229 auto rw
+238 auto quick metadata ioctl
+242 auto quick prealloc
+244 auto quota quick
+250 auto quick rw prealloc metadata
+253 auto quick
+259 auto quick
+261 auto quick quota
+262 auto quick quota
+266 dump ioctl auto quick
+267 dump ioctl tape
+268 dump ioctl tape
+278 repair auto
+279 auto mkfs
+281 dump ioctl auto quick
+282 dump ioctl auto quick
+283 dump ioctl auto quick
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
