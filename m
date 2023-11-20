Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4A1C197A0
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 19:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjKTTu0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 14:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjKTTu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 14:50:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CF591
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 11:50:22 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502DAC433C7;
        Mon, 20 Nov 2023 19:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700509822;
        bh=YYVpen+a2GepNc5psoJxPN6Myq2VXyCuR5Xq/H+0cgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jGlPrlRQ6c1zWFg5z/aheEPttSdFyfxATySAJbWiGCg478IHN0Qz93hJYFiGYNCCi
         vDVaTaiBc4As2LV34hl1g1NUknN+bQZzj7OPrWGS+ZR0K31PyQfftR8P7yeW1qTtOp
         B89EgnwryuRW77aJGEqXGUHaqiNR7F/agD7R1/+nu+DRwXZ59SDxY6esMoLP5O/7MW
         oVbamnI02V2sRI4wh//T7WC+U/EwJ0+um8absK8nXrdwXad9hMmv2EK4n2aarly3gK
         o3H77BrhUT06XGS2Ha3NhIwQR8bh78XWfDQy7xcd6VV9kcz5iXcMFWsIrNBcECHkzn
         /FIwPmavCZTGQ==
Date:   Mon, 20 Nov 2023 11:50:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Subject: [RFC PATCH 3/2] libxfs-apply: allow stgit users to force-apply a
 patch
Message-ID: <20231120195021.GF36190@frogsfrogsfrogs>
References: <20231120151056.710510-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120151056.710510-1-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, libxfs-apply handles merge conflicts in the auto-backported
patches in a somewhat unfriendly way -- either it applies completely
cleanly, or the user has to ^Z, find the raw diff file in /tmp, apply it
by hand, resume the process, and then tell it to skip the patch.

This is annoying, and I've long worked around that by using my handy
stg-force-import script that imports the patch with --reject, undoes the
partially-complete diff, uses patch(1) to import as much of the diff as
possible, and then starts an editor so the caller can clean up the rest.

When patches are fuzzy, patch(1) is /much/ less strict about applying
changes than stg-import.  Since Carlos sent in his own workaround for
guilt, I figured I might as well port stg-force-import into libxfs-apply
and contribute that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tools/libxfs-apply |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 097a695f942..3ff46a8cd2b 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -297,6 +297,64 @@ fixup_header_format()
 
 }
 
+editor() {
+	if [ -n "${EDITOR}" ]; then
+		${EDITOR} "$@"
+	elif [ -n "${VISUAL}" ]; then
+		${VISUAL} "$@"
+	elif command -v editor &>/dev/null; then
+		editor "$@"
+	elif command -v nano &>/dev/null; then
+		nano "$@"
+	else
+		echo "No editor available, aborting messily."
+		exit 1
+	fi
+}
+
+stg_force_import()
+{
+	local _patch="$1"
+	local _patch_name="$2"
+
+	# Import patch to get the metadata even though the diff application
+	# might fail due to stg import being very picky.  If the patch applies
+	# cleanly, we're done.
+	stg import --reject -n "${_patch_name}" "${_patch}" && return 0
+
+	local tmpfile="${_patch}.stgit"
+	rm -f "${tmpfile}"
+
+	# Erase whatever stgit managed to apply, then use patch(1)'s more
+	# flexible heuristics.  Capture the output for later use.
+	stg diff | patch -p1 -R
+	patch -p1 < "${patch}" &> "${tmpfile}"
+	cat "${tmpfile}"
+
+	# Attach any new files created by the patch
+	grep 'create mode' "${patch}" | sed -e 's/^.* mode [0-7]* //g' | while read -r f; do
+		git add "$f"
+	done
+
+	# Remove any existing files deleted by the patch
+	grep 'delete mode' "${patch}" | sed -e 's/^.* mode [0-7]* //g' | while read -r f; do
+		git rm "$f"
+	done
+
+	# Open an editor so the user can clean up the rejects.  Use readarray
+	# instead of "<<<" because the latter picks up empty output as a single
+	# line and does variable expansion...  stupid bash.
+	readarray -t rej_files < <(grep 'saving rejects to' "${tmpfile}" | \
+				   sed -e 's/^.*saving rejects to file //g')
+	rm -f "${tmpfile}"
+	if [ "${#rej_files[@]}" -gt 0 ]; then
+		echo "Opening editor to deal with rejects.  Changes commit when you close the editor."
+		editor "${rej_files[@]}"
+	fi
+
+	stg refresh
+}
+
 apply_patch()
 {
 	local _patch=$1
@@ -385,11 +443,13 @@ apply_patch()
 		stg import -n $_patch_name $_new_patch.2
 		if [ $? -ne 0 ]; then
 			echo "stgit push failed!"
-			read -r -p "Skip or Fail [s|F]? " response
+			read -r -p "Skip, force Apply, or Fail [s|a|F]? " response
 			if [ -z "$response" -o "$response" != "s" ]; then
 				echo "Force push patch, fix and refresh."
 				echo "Restart from commit $_current_commit"
 				fail "Manual cleanup required!"
+			elif [ "$response" = "a" ]; then
+				stg_force_import "$_patch_name" "$_new_patch.2"
 			else
 				echo "Skipping. Manual series file cleanup needed!"
 			fi
