Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A680829E16
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 12:16:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E52E304066
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:13 -0800 (PST)
Received: from mail-ve0-f202.google.com (mail-ve0-f202.google.com
	[209.85.128.202]) by cuda.sgi.com with ESMTP id
	gImg3An068pxtCdx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 10:16:12 -0800 (PST)
Received: by mail-ve0-f202.google.com with SMTP id oz11so896veb.3
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:12 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v3 12/12] xfstests: check if filesystem supports chattr
Date: Wed, 18 Dec 2013 10:16:03 -0800
Message-Id: <1387390563-27064-12-git-send-email-jayr@google.com>
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

Add _require_chattr which verifies exit code of chattr command and call
it before running generic/277.

Signed-off-by: Junho Ryu <jayr@google.com>
---

v3: same as v2

v2: extracted from patch 9

 common/attr       | 13 +++++++++++++
 tests/generic/277 |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/common/attr b/common/attr
index 4a3ac9e..278633f 100644
--- a/common/attr
+++ b/common/attr
@@ -218,5 +218,18 @@ else # Assume max ~1 block of attrs
 fi
 
 export MAX_ATTRVAL_SIZE
+
+_require_chattr()
+{
+    touch $TEST_DIR/syscalltest
+    chattr +A $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
+    if [ $? -ne 0 ]; then
+      _notrun "chattr has failed to change attribute of a file in TEST_DIR"
+    fi
+    cat $TEST_DIR/syscalltest.out >> $seqres.full
+
+    rm -f $TEST_DIR/syscalltest.out
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/277 b/tests/generic/277
index 8461ad9..c31f7c4 100755
--- a/tests/generic/277
+++ b/tests/generic/277
@@ -38,11 +38,13 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/attr
 
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
 _require_scratch
+_require_chattr
 
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
