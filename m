Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3B49F7CBF
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 12:00:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2B25C304032
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 10:00:21 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id EDF7xQC42aIkSUrH for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 10:00:20 -0700 (PDT)
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A2D30A51F6
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 18:00:19 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xfstests: check: set up config variables before using them
Date: Thu, 28 Mar 2013 18:00:18 +0100
Message-Id: <1364490018-30520-1-git-send-email-dsterba@suse.cz>
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
Cc: David Sterba <dsterba@suse.cz>

HOSTOS was used in a test before being initialized and this led to
failed filesystem type detection.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

Sidenote, FSTYP has been exported properly, I've accidentally deleted it during
debugging. The patch "xfstests: remove unconditional setting of FSTYP" is now
obsolete.

 check | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/check b/check
index 18cae75..3b48402 100755
--- a/check
+++ b/check
@@ -50,12 +50,6 @@ timestamp=${TIMESTAMP:=false}
 
 rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.xlist
 
-# Autodetect fs type based on what's on $TEST_DEV
-if [ "$HOSTOS" == "Linux" ]; then
-    FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
-fi
-export FSTYP
-
 # we need common.config
 if ! . ./common/config
 then
@@ -63,6 +57,12 @@ then
     exit 1
 fi
 
+# Autodetect fs type based on what's on $TEST_DEV
+if [ "$HOSTOS" == "Linux" ]; then
+    FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
+fi
+export FSTYP
+
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
 SRC_GROUPS="generic shared"
 export SRC_DIR="tests"
-- 
1.8.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
