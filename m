Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 566E97F5A
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:12 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx7007465 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 10/18] xfstests: Add generic tests to tests/generic/group
MIME-Version: 1.0
Message-Id: <20130314130611.8C56653DEAF7@polaris-admin.engr.sgi.com>
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
And into tests/generic.  Tests were found simply by grepping for the
__supported_fs field in the tests.

Output starts to look like:

$ sudo ./check -g quick -r
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-1 3.5.0-rc5-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

./242    1s
./183    2s
generic/236      1s
generic/014      1s
generic/258      0s
./096    1s
generic/245      0s
^C
Ran: ./242 ./183 generic/236 generic/014 generic/258 ./096 generic/245
Passed all 7 tests
-----------------

Signed-off-by: Phil White <pwhite@sgi.com>
---
 group               |   98 ---------------------------------------------------
 tests/generic/group |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+), 98 deletions(-)

diff --git a/group b/group
index 484bed5..dd0b622 100644
--- a/group
+++ b/group
@@ -116,26 +116,15 @@ stress
 
 # test-group association ... one line per test
 #
-001 rw dir udf auto quick
-002 metadata udf auto quick
 003 db auto quick
 004 db auto quick
-005 dir udf auto quick
-006 dir udf auto quick
-007 dir udf auto quick
 008 rw ioctl auto quick
 009 rw ioctl auto prealloc quick
-010 other udf auto
-011 dir udf auto quick
 012 rw auto quick
-013 other ioctl udf auto quick
-014 rw udf auto quick
-015 other auto quick
 016 rw auto quick
 017 mount auto quick stress
 018 deprecated # log logprint v2log
 019 mkfs auto quick
-020 metadata attr udf auto quick
 021 db attr auto quick
 022 dump ioctl tape
 023 dump ioctl tape
@@ -168,7 +157,6 @@ stress
 050 quota auto quick
 051 acl udf auto quick
 052 quota db auto quick
-053 acl repair auto quick
 054 quota auto quick
 055 dump ioctl remote tape
 056 dump ioctl auto quick
@@ -177,86 +165,52 @@ stress
 059 dump ioctl auto quick
 060 dump ioctl auto quick
 061 dump ioctl auto quick
-062 attr udf auto quick
 063 dump attr auto quick
 064 dump auto
 065 dump auto
 066 dump ioctl auto quick
 067 acl attr auto quick
 068 other auto freeze dangerous stress
-069 rw udf auto quick
-070 attr udf auto quick stress
 071 rw auto
 072 rw auto prealloc quick
 073 copy auto
-074 rw udf auto
-075 rw udf auto quick
-076 metadata rw udf auto quick stress
-077 acl attr auto enospc
 078 growfs auto quick
-079 acl attr ioctl metadata auto quick
 080 rw ioctl
 081 deprecated # log logprint quota
 082 deprecated # log logprint v2log
-083 rw auto enospc stress
 084 ioctl rw auto
 085 log auto quick
 086 log v2log auto
 087 log v2log auto quota stress
-088 perms auto quick
-089 metadata auto
 090 rw auto
-091 rw auto quick
 092 other auto quick
-093 attr cap udf auto
 094 metadata dir ioctl auto
 095 log v2log auto
 096 mkfs v2log auto quick
-097 udf auto
 098 udf auto
-099 udf auto
-100 udf auto
 101 udf
 102 udf
 103 metadata dir ioctl auto quick
 104 growfs ioctl prealloc auto stress
-105 acl auto quick
 106 quota
 107 quota
 108 quota auto quick
 109 metadata auto
 110 repair auto
 111 ioctl
-112 rw aio auto quick
-113 rw aio auto quick
 114 parent attr stress
 115 parent attr
 116 quota auto quick
-117 attr auto quick
 118 quota auto quick
 119 log v2log auto freeze dangerous
-120 other auto quick
 121 log auto quick
 122 other auto quick
-123 perms auto quick
-124 pattern auto quick
-125 other auto
-126 perms auto quick
-127 rw auto
-128 perms auto quick
-129 rw auto quick
-130 pattern auto quick
-131 perms auto quick
-132 pattern auto
-133 rw auto
 134 quota auto quick
-135 metadata auto quick
 136 attr2
 137 metadata log auto
 138 metadata log auto
 139 metadata log auto
 140 metadata log auto
-141 rw auto quick
 142 dmapi auto
 143 dmapi auto
 144 dmapi auto
@@ -284,7 +238,6 @@ stress
 166 rw metadata auto quick
 167 rw metadata auto stress
 168 dmapi auto
-169 rw metadata auto quick
 170 rw filestreams auto quick
 # the next three tests are not deterministic enough to get the
 # "right" result on all platforms/configuration, so don't run
@@ -302,7 +255,6 @@ stress
 181 log auto quick
 182 metadata rw auto
 183 rw other auto quick
-184 metadata auto quick
 185 dmapi auto
 186 attr auto quick
 187 attr auto quick
@@ -310,95 +262,45 @@ stress
 189 mount auto quick
 190 rw auto quick
 191 nfs4acl auto
-192 atime auto
-193 metadata auto quick
 194 rw auto
 195 ioctl dump auto quick
 196 quota auto quick
 197 dir auto quick
-198 auto aio quick
 199 mount auto quick
 200 mount auto quick
 201 metadata auto quick
 202 repair auto quick
 203 ioctl auto
-204 metadata rw auto
 205 metadata rw auto
 206 growfs auto quick
-207 auto aio quick
-208 auto aio
-209 auto aio
-210 auto aio quick
-211 auto aio quick
-212 auto aio quick
-213 rw auto prealloc quick enospc
-214 rw auto prealloc quick
-215 auto metadata quick
 216 log metadata auto quick
 217 log metadata auto
 218 auto fsr quick
-219 auto quota quick
 220 auto quota quick
-221 auto metadata quick
 222 auto fsr ioctl quick
-223 auto quick
-224 auto
-225 auto quick
-226 auto enospc
 227 auto fsr
-228 rw auto prealloc quick
 229 auto rw
-230 auto quota quick
-231 auto quota
-232 auto quota stress
-233 auto quota stress
-234 auto quota
-235 auto quota quick
-236 auto quick metadata
-237 auto quick acl
 238 auto quick metadata ioctl
-239 auto aio rw
-240 auto aio quick rw
-241 auto
 242 auto quick prealloc
 243 auto quick prealloc
 244 auto quota quick
-245 auto quick dir
-246 auto quick rw
-247 auto quick rw
-248 auto quick rw
-249 auto quick rw 
 250 auto quick rw prealloc metadata
-251 ioctl trim
 252 auto quick prealloc
 253 auto quick
 254 auto quick
-255 auto quick prealloc
-256 auto quick
-257 dir auto quick
-258 auto quick
 259 auto quick
-260 auto quick trim
 261 auto quick quota
 262 auto quick quota
-263 rw auto quick
 264 auto
 265 auto
 266 dump ioctl auto quick
 267 dump ioctl tape
 268 dump ioctl tape
-269 auto rw prealloc ioctl enospc stress
-270 auto quota rw prealloc ioctl enospc stress
 271 auto rw quick
 272 auto enospc rw
-273 auto rw
-274 auto rw
-275 auto rw
 276 auto rw metadata
-277 auto ioctl quick metadata
 278 repair auto
 279 auto mkfs
-280 auto quota freeze dangerous
 281 dump ioctl auto quick
 282 dump ioctl auto quick
 283 dump ioctl auto quick
diff --git a/tests/generic/group b/tests/generic/group
index 4e01f0c..14d275c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -3,3 +3,101 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
+001 rw dir udf auto quick
+002 metadata udf auto quick
+005 dir udf auto quick
+006 dir udf auto quick
+007 dir udf auto quick
+010 other udf auto
+011 dir udf auto quick
+013 other ioctl udf auto quick
+014 rw udf auto quick
+015 other auto quick
+020 metadata attr udf auto quick
+053 acl repair auto quick
+062 attr udf auto quick
+069 rw udf auto quick
+070 attr udf auto quick
+074 rw udf auto
+075 rw udf auto quick
+076 metadata rw udf auto quick
+077 acl attr auto enospc
+079 acl attr ioctl metadata auto quick
+083 rw auto
+088 perms auto quick
+089 metadata auto
+091 rw auto quick
+093 attr cap udf auto
+097 udf auto
+099 udf auto
+100 udf auto
+105 acl auto quick
+112 rw aio auto quick
+113 rw aio auto quick
+117 attr auto quick
+120 other auto quick
+123 perms auto quick
+124 pattern auto quick
+125 other auto
+126 perms auto quick
+127 rw auto
+128 perms auto quick
+129 rw auto quick
+130 pattern auto quick
+131 perms auto quick
+132 pattern auto
+133 rw auto
+135 metadata auto quick
+141 rw auto quick
+169 rw metadata auto quick
+184 metadata auto quick
+192 atime auto
+193 metadata auto quick
+198 auto aio quick
+204 metadata rw auto
+207 auto aio quick
+208 auto aio
+209 auto aio
+210 auto aio quick
+211 auto aio quick
+212 auto aio quick
+213 rw auto prealloc quick enospc
+214 rw auto prealloc quick
+215 auto metadata quick
+219 auto quota quick
+221 auto metadata quick
+223 auto quick
+224 auto
+225 auto quick
+226 auto enospc
+228 rw auto prealloc quick
+230 auto quota quick
+231 auto quota
+232 auto quota
+233 auto quota
+234 auto quota
+235 auto quota quick
+236 auto quick metadata
+237 auto quick acl
+239 auto aio rw
+240 auto aio quick rw
+241 auto
+245 auto quick dir
+246 auto quick rw
+247 auto quick rw
+248 auto quick rw
+249 auto quick rw
+251 ioctl trim
+255 auto quick prealloc
+256 auto quick
+257 dir auto quick
+258 auto quick
+260 auto quick trim
+263 rw auto quick
+269 auto rw prealloc ioctl enospc
+270 auto quota rw prealloc ioctl enospc
+273 auto rw
+274 auto rw
+275 auto rw
+277 auto ioctl quick metadata
+280 auto quota freeze dangerous
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
