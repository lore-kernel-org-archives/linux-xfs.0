Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32797 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932664AbcKVS0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 13:26:50 -0500
Date: Tue, 22 Nov 2016 10:26:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/16] libxfs-apply: port to stgit
Message-ID: <20161122182644.GP16813@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org

Teach libxfs-apply how to talk to a stgit repository
and fix a minor typo in the guilt hunk of apply_patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/libxfs-apply |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 8df1a49..5cf0879 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -66,6 +66,7 @@ PATCH=
 COMMIT_ID=
 VERBOSE=
 GUILT=0
+STGIT=0
 
 while [ $# -gt 0 ]; do
 	case "$1" in
@@ -95,6 +96,12 @@ if [ $? -eq 0 ]; then
 	GUILT=1
 fi
 
+# Are we using stgit? This works even if no patch is applied.
+stg top &> /dev/null
+if [ $? -eq 0 ]; then
+	STGIT=1
+fi
+
 #this is pulled from the guilt code to handle commit ids sanely.
 # usage: munge_hash_range <hash range>
 #
@@ -332,7 +339,27 @@ apply_patch()
 			guilt refresh
 		else
 			echo "Guilt push failed!"
-			read -r -p "Skip of Fail [s|F]? " response
+			read -r -p "Skip or Fail [s|F]? " response
+			if [ -z "$response" -o "$response" != "s" ]; then
+				echo "Force push patch, fix and refresh."
+				echo "Restart from commit $_current_commit"
+				fail "Manual cleanup required!"
+			else
+				echo "Skipping. Manual series file cleanup needed!"
+			fi
+		fi
+	elif [ $STGIT -eq 1 ]; then
+		[ -n "$VERBOSE" ] || echo "$REPO looks like a stgit directory."
+		PATCHES=`stg series | wc -l`
+		if [ -n "$VERBOSE" -a $PATCHES -gt 0 ]; then
+			echo -n "Top patch is: "
+			stg top
+		fi
+
+		stg import -n $_patch_name $_new_patch.2
+		if [ $? -ne 0 ]; then
+			echo "stgit push failed!"
+			read -r -p "Skip or Fail [s|F]? " response
 			if [ -z "$response" -o "$response" != "s" ]; then
 				echo "Force push patch, fix and refresh."
 				echo "Restart from commit $_current_commit"
