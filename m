Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D27E809D
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 10:43:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6740AC012
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 08:43:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EyyfBvnoUMUqQQkS for
	<xfs@oss.sgi.com>; Tue, 08 Apr 2014 08:43:01 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3] xfstests: Fix setting FSTYP automatically
Date: Tue,  8 Apr 2014 17:42:50 +0200
Message-Id: <1396971770-23553-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1396971770-23553-1-git-send-email-lczerner@redhat.com>
References: <20140404211224.GX17603@dastard>
	<1396971770-23553-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>, fdmanana@gmail.com, linux-btrfs@vger.kernel.org

Currently if the FSTYP is not set, the code to get FSTYP using blikd
would not work. This is because we're using HOSTOS environment variable
which might not be set (at least not on my system) and because it's
already late in the code path.

Fix this by using OSTYP environment variable as a fallback in the case
that HOSTOS does not work and move the check to common/config.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check         |  8 --------
 common/config | 18 +++++++++++++-----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/check b/check
index 8f1a6e1..ed1834d 100755
--- a/check
+++ b/check
@@ -58,14 +58,6 @@ then
     exit 1
 fi
 
-# Autodetect fs type based on what's on $TEST_DEV unless it's been set
-# externally
-if [ -z "$FSTYP" -a "$HOSTOS" == "Linux" ]; then
-    FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
-fi
-FSTYP=${FSTYP:=xfs}
-export FSTYP
-
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
 SRC_GROUPS="generic shared"
 export SRC_DIR="tests"
diff --git a/common/config b/common/config
index 3163801..00249e6 100644
--- a/common/config
+++ b/common/config
@@ -297,11 +297,6 @@ _fsck_opts()
 	esac
 }
 
-[ -z "$FSTYP" ] && export FSTYP=xfs
-[ -z "$MOUNT_OPTIONS" ] && _mount_opts
-[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
-[ -z "$FSCK_OPTIONS" ] && _fsck_opts
-
 known_hosts()
 {
 	[ "$HOST_CONFIG_DIR" ] || HOST_CONFIG_DIR=`pwd`/configs
@@ -446,6 +441,19 @@ get_next_config() {
 if [ -z "$CONFIG_INCLUDED" ]; then
 	get_next_config `echo $HOST_OPTIONS_SECTIONS | cut -f1 -d" "`
 	export CONFIG_INCLUDED=true
+
+	# Autodetect fs type based on what's on $TEST_DEV unless it's been set
+	# externally
+	if [ -z "$FSTYP" ] && \
+	   [ "$HOSTOS" == "Linux" -o "$OSTYPE" == "linux-gnu" ] && \
+	   [ ! -z "$TEST_DEV" ]; then
+		FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
+	fi
+	FSTYP=${FSTYP:=xfs}
+	export FSTYP
+	[ -z "$MOUNT_OPTIONS" ] && _mount_opts
+	[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
+	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
 fi
 
 # make sure this script returns success
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
