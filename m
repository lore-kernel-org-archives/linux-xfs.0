Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649F2C5AE5B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 15:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbjKTPLL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 10:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbjKTPLK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 10:11:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E34D98
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 07:11:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CA7C433D9;
        Mon, 20 Nov 2023 15:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700493066;
        bh=cPS4+82FHMmqOTnYmj3Ip+PC++kHfglYKoGc65LDrHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOYQbBwu/vEsmfj5mD+GNVgmGEt5NrErknLrzjxvDRtz+ZuadaDLw0d+AYK7HWZ38
         HOc2Xuw3x8/GPfrYpXK0DW7gwv7E5uXV26NjdMNSXA3L70SPdz3ggj2icCuZWvveJv
         RoxBp2+JFuzc9AvX8Vef4Y73yN/ZsjqWMjI+eHoIvjZRbBTUWX9fsVBMhf12NyYDy9
         0/oNMXuxQe65B/VibTXzCFfE87PtL131M5HLqXFuqAcWn5sIbKRpFxsxI8b+vw7Nnr
         L1gW0sRHzPpAnr3bda5+Q1fZ75cKBlV8gKQKk0H6ojUsqXjTaBymcr/JEoZgREux69
         wJtbHU3CZFXZw==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Subject: [PATCH 2/2] libxfs-apply: Add option to only import patches into guilt stack
Date:   Mon, 20 Nov 2023 16:10:47 +0100
Message-ID: <20231120151056.710510-2-cem@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231120151056.710510-1-cem@kernel.org>
References: <20231120151056.710510-1-cem@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cem@kernel.org>

The script automatically detects the existence of a guilt stack, but
only conflict resolution mechanisms so far are either skip the patch or
fail the process.

It's easier to fix conflicts if all the patches are stacked in guilt, so
add an option to stack all the patches into guilt, without applying them,
for post-processing and conflict resolution in case automatic import fails.

stgit doesn't seem to have a way to import patches into its stack, so,
there is no similar patch aiming stgit.

The order of commits added to $commit_list also needs to be reversed
when only importing patches to the guilt stack.

Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 tools/libxfs-apply | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index aa2530f4d..2b65684ec 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -9,7 +9,7 @@ usage()
 	echo $*
 	echo
 	echo "Usage:"
-	echo "	libxfs-apply [--verbose] --sob <name/email> --source <repodir> --commit <commit_id>"
+	echo "	libxfs-apply [--import-only] [--verbose] --sob <name/email> --source <repodir> --commit <commit_id>"
 	echo "	libxfs-apply --patch <patchfile>"
 	echo
 	echo "libxfs-apply should be run in the destination git repository."
@@ -67,6 +67,7 @@ REPO=
 PATCH=
 COMMIT_ID=
 VERBOSE=
+IMPORT_ONLY=
 GUILT=0
 STGIT=0
 
@@ -76,6 +77,7 @@ while [ $# -gt 0 ]; do
 	--patch)	PATCH=$2; shift ;;
 	--commit)	COMMIT_ID=$2 ; shift ;;
 	--sob)		SIGNED_OFF_BY=$2 ; shift ;;
+	--import-only)	IMPORT_ONLY=true ;;
 	--verbose)	VERBOSE=true ;;
 	*)		usage ;;
 	esac
@@ -99,6 +101,10 @@ if [ $? -eq 0 ]; then
 	GUILT=1
 fi
 
+if [ -n $IMPORT_ONLY -a $GUILT -ne 1 ]; then
+	usage "--import_only can only be used with a guilt stack"
+fi
+
 # Are we using stgit? This works even if no patch is applied.
 stg top &> /dev/null
 if [ $? -eq 0 ]; then
@@ -359,6 +365,11 @@ apply_patch()
 		fi
 
 		guilt import -P $_patch_name $_new_patch.2
+
+		if [ -n "$IMPORT_ONLY" ]; then
+			return;
+		fi
+
 		guilt push
 		if [ $? -eq 0 ]; then
 			guilt refresh
@@ -443,10 +454,17 @@ else
 	hashr="$hashr -- libxfs"
 fi
 
+# When using --import-only, the commit list should be in reverse order.
+if [ "$GUILT" -eq 1 -a -n "$IMPORT_ONLY" ]; then
+	commit_list=`git rev-list --no-merges $hashr`
+else
+	commit_list=`git rev-list --no-merges $hashr | tac`
+fi
+
 # grab and echo the list of commits for confirmation
 echo "Commits to apply:"
-commit_list=`git rev-list --no-merges $hashr | tac`
 git log --oneline --no-merges $hashr |tac
+
 read -r -p "Proceed [y|N]? " response
 if [ -z "$response" -o "$response" != "y" ]; then
 	fail "Aborted!"
-- 
2.41.0

