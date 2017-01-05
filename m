Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45715 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933960AbdAEBRp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 20:17:45 -0500
Subject: [PATCH 6/9] populate: cache scratch metadata images
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 04 Jan 2017 17:17:38 -0800
Message-ID: <148357905878.10436.1866572956612127885.stgit@birch.djwong.org>
In-Reply-To: <148357902056.10436.12795484251467155460.stgit@birch.djwong.org>
References: <148357902056.10436.12795484251467155460.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Create a helper function to create a populated FS image and dump the
metadata into a file on the test device, with the purpose of allowing
future (fuzzer) invocations of _populate_fs use the cached metadata to
save time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   44 ++++++++++++++++++++++++++++++++++++++++++++
 common/rc       |    3 ++-
 2 files changed, 46 insertions(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index f012173..91a7753 100644
--- a/common/populate
+++ b/common/populate
@@ -673,3 +673,47 @@ _fill_fs()
 		file_count=$((file_count + 1))
 	done
 }
+
+# Populate a scratch FS from scratch or from a cached image.
+_scratch_populate_cached() {
+	POPULATE_METADUMP="${TEST_DIR}/__populate.${FSTYP}"
+	POPULATE_METADUMP_DESCR="${TEST_DIR}/__populate.${FSTYP}.txt"
+
+	# Don't keep metadata images cached for more 48 hours...
+	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
+
+	# Throw away cached image if it doesn't match our spec.
+	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} ARGS $@"
+	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || rm -rf "${POPULATE_METADUMP}"
+
+	# Do we have a cached image?
+	if [ -r "${POPULATE_METADUMP}" ]; then
+		case "${FSTYP}" in
+		"xfs")
+			xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" && return
+			;;
+		"ext2"|"ext3"|"ext4")
+			e2image -r "${POPULATE_METADUMP}" "${SCRATCH_DEV}" && return
+			;;
+		esac
+	fi
+
+	# Oh well, just create one from scratch
+	_scratch_mkfs
+	echo "${meta_descr}" > "${POPULATE_METADUMP_DESCR}"
+	case "${FSTYP}" in
+	"xfs")
+		_scratch_xfs_populate $@
+		_scratch_xfs_populate_check
+		_scratch_metadump "${POPULATE_METADUMP}" -a -o
+		;;
+	"ext2"|"ext3"|"ext4")
+		_scratch_ext4_populate $@
+		_scratch_ext4_populate_check
+		e2image -Q "${SCRATCH_DEV}" "${POPULATE_METADUMP}"
+		;;
+	*)
+		_fail "Don't know how to populate a ${FSTYP} filesystem."
+		;;
+	esac
+}
diff --git a/common/rc b/common/rc
index 46bfb68..6323f54 100644
--- a/common/rc
+++ b/common/rc
@@ -471,12 +471,13 @@ _scratch_do_mkfs()
 _scratch_metadump()
 {
 	dumpfile=$1
+	shift
 	options=
 
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		options="-l $SCRATCH_LOGDEV"
 
-	xfs_metadump $options $SCRATCH_DEV $dumpfile
+	xfs_metadump $options "$@" $SCRATCH_DEV $dumpfile
 }
 
 _setup_large_ext4_fs()

