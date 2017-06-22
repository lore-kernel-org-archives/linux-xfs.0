Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36777 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbdFVG1A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2017 02:27:00 -0400
Date: Wed, 21 Jun 2017 23:26:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 9/8] common/populate: remember multi-device configurations
Message-ID: <20170622062653.GF3787@birch.djwong.org>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Record the external log and realtime device configurations when we
create a sample filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/common/populate b/common/populate
index e99ce68..b59ed02 100644
--- a/common/populate
+++ b/common/populate
@@ -713,7 +713,15 @@ _scratch_populate_cached() {
 	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
 
 	# Throw away cached image if it doesn't match our spec.
-	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} SIZE $(blockdev --getsz "${SCRATCH_DEV}") ARGS $@"
+	case "${FSTYP}" in
+	"ext4")
+		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL}";;
+	"xfs")
+		extra_descr="LOGDEV ${SCRATCH_LOGDEV} USE_EXTERNAL ${USE_EXTERNAL} RTDEV ${SCRATCH_RTDEV}";;
+	*)
+		extra_descr="";;
+	esac
+	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} SIZE $(blockdev --getsz "${SCRATCH_DEV}") ${extra_descr} ARGS $@"
 	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || rm -rf "${POPULATE_METADUMP}"
 
 	# Do we have a cached image?
