Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52432 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbfCTApn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:45:43 -0400
Subject: [PATCH 08/12] common/populate: support multiple cached images
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:45:35 -0700
Message-ID: <155304273502.31707.11442947133103113710.stgit@magnolia>
In-Reply-To: <155304267647.31707.14180452399822113095.stgit@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enhance the populated fs metadump image cache to support multiple
configurations per filesystem so that we reduce the image creation
overhead even further.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/common/populate b/common/populate
index 1f921ac5..4fa118f0 100644
--- a/common/populate
+++ b/common/populate
@@ -805,10 +805,12 @@ _scratch_populate_restore_cached() {
 # Populate a scratch FS from scratch or from a cached image.
 _scratch_populate_cached() {
 	local meta_descr="$(_scratch_populate_cache_tag "$@")"
+	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
+	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
 
 	# These variables are shared outside this function
-	POPULATE_METADUMP="${TEST_DIR}/__populate.${FSTYP}"
-	POPULATE_METADUMP_DESCR="${TEST_DIR}/__populate.${FSTYP}.txt"
+	POPULATE_METADUMP="${metadump_stem}.metadump"
+	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
 
 	# Don't keep metadata images cached for more 48 hours...
 	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
