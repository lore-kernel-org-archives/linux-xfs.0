Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20409 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754991AbdGUWE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 18:04:58 -0400
Subject: [PATCH 4/5] common/populate: enable xfs quota accounting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jul 2017 15:04:52 -0700
Message-ID: <150067469221.30639.16711306489951233808.stgit@magnolia>
In-Reply-To: <150067465981.30639.14801416171688538711.stgit@magnolia>
References: <150067465981.30639.14801416171688538711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're creating a populated xfs image, turn on quotas so that we can
fuzz those fields too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index 498151f..b77c508 100644
--- a/common/populate
+++ b/common/populate
@@ -21,6 +21,7 @@
 #  Contact information: Silicon Graphics, Inc., 1500 Crittenden Lane,
 #  Mountain View, CA 94043, USA, or: http://www.sgi.com
 #-----------------------------------------------------------------------
+. ./common/quota
 
 _require_populate_commands() {
 	_require_xfs_io_command "falloc"
@@ -94,6 +95,47 @@ __populate_fill_fs() {
 	done
 }
 
+# For XFS, force on all the quota options if quota is enabled
+# and the user didn't feed us noquota.
+_populate_xfs_qmount_option()
+{
+	# User explicitly told us not to quota
+	if echo "${MOUNT_OPTIONS}" | grep -q 'noquota'; then
+		return
+	fi
+
+	# Don't bother if we can't turn on quotas
+	if [ ! -f /proc/fs/xfs/xqmstat ]; then
+		# No quota support
+		return
+	elif [ "${USE_EXTERNAL}" = "yes" ] && [ ! -z "${SCRATCH_RTDEV}" ]; then
+		# Quotas not supported on rt filesystems
+		return
+	elif [ -z "${XFS_QUOTA_PROG}" ]; then
+		# xfs quota tools not installed
+		return
+	fi
+
+	# Turn on all the quotas
+	if xfs_info "${TEST_DIR}" | grep -q 'crc=1'; then
+		# v5 filesystems can have group & project quotas
+		quota="usrquota,grpquota,prjquota"
+	else
+		# v4 filesystems cannot mix group & project quotas
+		quota="usrquota,grpquota"
+	fi
+
+	# Inject our quota mount options
+	if echo "${MOUNT_OPTIONS}" | grep -q "${quota}"; then
+		return
+	elif echo "${MOUNT_OPTIONS}" | egrep -q '(quota|noenforce)'; then
+		_qmount_option "${quota}"
+	else
+		export MOUNT_OPTIONS="$MOUNT_OPTIONS -o ${quota}"
+		echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
+	fi
+}
+
 # Populate an XFS on the scratch device with (we hope) all known
 # types of metadata block
 _scratch_xfs_populate() {
@@ -106,6 +148,7 @@ _scratch_xfs_populate() {
 		esac
 	done
 
+	_populate_xfs_qmount_option
 	_scratch_mount
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
@@ -720,7 +763,12 @@ _scratch_populate_cached() {
 		test -n "${SCRATCH_LOGDEV}" && rm -f "${POPULATE_METADUMP}"
 		;;
 	"xfs")
-		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}";;
+		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}"
+		_populate_xfs_qmount_option
+		if echo "${MOUNT_OPTIONS}" | grep -q 'usrquota'; then
+			extra_descr="${extra_descr} QUOTAS"
+		fi
+		;;
 	*)
 		extra_descr="";;
 	esac

