Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49055 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932650AbdKPBWa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 20:22:30 -0500
Subject: [PATCH 1/5] common/fuzzy: if the fuzz verb is random,
 keep fuzzing until we get a new value
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 15 Nov 2017 17:22:25 -0800
Message-ID: <151079534548.25590.4625031168242667972.stgit@magnolia>
In-Reply-To: <151079533937.25590.1037061486182471724.stgit@magnolia>
References: <151079533937.25590.1037061486182471724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the fuzz verb is 'random', keep generating new random values until
we get one that is distinct from the previous value.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/fuzzy |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index b9c7399..390f91f 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -179,9 +179,14 @@ _scratch_xfs_fuzz_metadata_field() {
 	for arg in "$@"; do
 		cmds+=("-c" "${arg}")
 	done
-	_scratch_xfs_db -x "${cmds[@]}" -c "fuzz ${fuzz_arg} ${key} ${value}"
-	echo
-	newval="$(_scratch_xfs_get_metadata_field "${key}" "$@" 2> /dev/null)"
+	while true; do
+		_scratch_xfs_db -x "${cmds[@]}" -c "fuzz ${fuzz_arg} ${key} ${value}"
+		echo
+		newval="$(_scratch_xfs_get_metadata_field "${key}" "$@" 2> /dev/null)"
+		if [ "${key}" != "random" ] || [ "${oldval}" != "${newval}" ]; then
+			break;
+		fi
+	done
 	if [ "${oldval}" = "${newval}" ]; then
 		echo "Field ${key} already set to ${newval}, skipping test."
 		return 1

