Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33906 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbdALRRX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 12:17:23 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8A2595CCE4A
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2017 11:15:07 -0600 (CST)
Subject: [PATCH 3/3] libxfs-apply: minor improvements
References: <056383cb-cf7e-3880-aecf-d97d5516a60f@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7f6aba51-3b6d-0ba2-57b8-344bc7fc32b7@sandeen.net>
Date: Thu, 12 Jan 2017 11:15:52 -0600
MIME-Version: 1.0
In-Reply-To: <056383cb-cf7e-3880-aecf-d97d5516a60f@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Three quick improvements to libxfs-apply:

- Skip already-cross-merged commits, based on the
  "Source XXX commit" line in the commitlog.

- Be clearer about which patch failed if it does

- Clean up guilt better after a failed application

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 tools/libxfs-apply | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 5cf0879..e7d7e0a 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -288,6 +288,7 @@ apply_patch()
 	local _current_commit=$3
 	local _new_patch=`mktemp`
 	local _source="kernel"
+	local _target="xfsprogs"
 
 	# filter just the libxfs parts of the patch
 	if [ $SOURCE == "xfsprogs" ]; then
@@ -301,6 +302,7 @@ apply_patch()
 
 		filter_kernel_patch $_patch > $_new_patch
 		_source="xfsprogs"
+		_target="kernel"
 	elif [ $SOURCE == "kernel" ]; then
 
 		[ -n "$VERBOSE" ] || lsdiff $_patch | grep -q "[ab]/fs/xfs/libxfs/"
@@ -315,6 +317,13 @@ apply_patch()
 		fail "Unknown source repo type: $SOURCE"
 	fi
 
+	grep -q "Source $_target commit: " $_patch
+	if [ "$?" -eq "0" ]; then
+		echo "$_patch_name already synced up"
+		echo "$_skipping commit $_current_commit"
+		return
+	fi
+
 	# now munge the header to be in the correct format.
 	fixup_header_format $_source $_new_patch > $_new_patch.2
 
@@ -338,14 +347,15 @@ apply_patch()
 		if [ $? -eq 0 ]; then
 			guilt refresh
 		else
-			echo "Guilt push failed!"
+			echo "Guilt push of $_current_commit $_patch_name failed!"
 			read -r -p "Skip or Fail [s|F]? " response
 			if [ -z "$response" -o "$response" != "s" ]; then
 				echo "Force push patch, fix and refresh."
 				echo "Restart from commit $_current_commit"
 				fail "Manual cleanup required!"
 			else
-				echo "Skipping. Manual series file cleanup needed!"
+				echo "Skipping."
+				guilt delete -f $_patch_name
 			fi
 		fi
 	elif [ $STGIT -eq 1 ]; then
-- 
1.8.3.1


