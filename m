Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D67B8809D
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 10:43:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5EC29AC014
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 08:43:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vQtC1UPI0hUfnkAI for
	<xfs@oss.sgi.com>; Tue, 08 Apr 2014 08:43:02 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3] xfstests: Unset SCRATCH_DEV when deduced from
	SCRATCH_DEV_POOL
Date: Tue,  8 Apr 2014 17:42:49 +0200
Message-Id: <1396971770-23553-2-git-send-email-lczerner@redhat.com>
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

In the case that we already have sections in the config file we
have to make sure that we unset SCRATCH_DEV if it has been deduced from
the SCRATCH_DEV_POOL so that it does not complain about SCRATCH_DEV in
this case.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/config | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/common/config b/common/config
index 6fa18e2..3163801 100644
--- a/common/config
+++ b/common/config
@@ -372,10 +372,15 @@ get_next_config() {
 	unset MOUNT_OPTIONS
 	unset MKFS_OPTIONS
 	unset FSCK_OPTIONS
+	# We might have deduced SCRATCH_DEV from the SCRATCH_DEV_POOL in the previous
+	# run, so we have to unset it now.
+	if [ "$SCRATCH_DEV_NOT_SET" == "true" ]; then
+		unset SCRATCH_DEV
+	fi
 
 	parse_config_section $1
 
-	if [ -n "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
+	if [ ! -z "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
 		[ -z "$MOUNT_OPTIONS" ] && _mount_opts
 		[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 		[ -z "$FSCK_OPTIONS" ] && _fsck_opts
@@ -423,6 +428,7 @@ get_next_config() {
 		fi
 		SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
 		export SCRATCH_DEV
+		export SCRATCH_DEV_NOT_SET=true
 	fi
 
 	echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
