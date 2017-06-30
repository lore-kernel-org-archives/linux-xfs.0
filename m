Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39099 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdF3EMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 00:12:08 -0400
Date: Thu, 29 Jun 2017 21:12:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 9/8] common/populate: remember multi-device configurations
Message-ID: <20170630041204.GD5871@birch.djwong.org>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
 <20170622062653.GF3787@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170622062653.GF3787@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Record the external log and realtime device configurations when we
create a sample filesystem.  ext4 tightly binds to external logs,
so we have to preserve that too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/common/populate b/common/populate
index e99ce68..498151f 100644
--- a/common/populate
+++ b/common/populate
@@ -713,7 +713,18 @@ _scratch_populate_cached() {
 	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
 
 	# Throw away cached image if it doesn't match our spec.
-	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} SIZE $(blockdev --getsz "${SCRATCH_DEV}") ARGS $@"
+	case "${FSTYP}" in
+	"ext4")
+		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL}"
+		# ext4 cannot e2image external logs, so we cannot restore
+		test -n "${SCRATCH_LOGDEV}" && rm -f "${POPULATE_METADUMP}"
+		;;
+	"xfs")
+		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}";;
+	*)
+		extra_descr="";;
+	esac
+	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} SIZE $(blockdev --getsz "${SCRATCH_DEV}") ${extra_descr} ARGS $@"
 	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || rm -rf "${POPULATE_METADUMP}"
 
 	# Do we have a cached image?
