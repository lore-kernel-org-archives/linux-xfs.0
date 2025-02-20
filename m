Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BEC1FE45B
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 16:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740070173; cv=none; b=mRnenzAGrlPcqTX5oVt/w8k7lHd2RdbaSoIMiqP1nG7aNwvfvUpjXSbijUfInv6q8pbS+0zJ2c401Lng4OXnMAlmLiaNbP4iwUwA4ppvEyls5d6rYP7ckYVMfLHZL6Ekr/9G01OXblCm+U+iIl7q2WNk3h51eu9BSeN0WpE4sXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740070173; c=relaxed/simple;
	bh=6b0qVpQmLm+Znh7shZWATZnMKrgXaMSIkpfvGrHF+L0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rAn4JLJr3yRDXjQ5FSc3x0NQQ7sxCOAUyvRePGcvr49PK157XPBTuw7GTCXDT2QbG2RnmfFjcIguZ54kirj6ZX3PyrZfC6knLRKKci6cRqbKVxhw3vr7j65G1cnrxekdbIai4AG4B39C7kFh7Yw0LfkPyxpD3OvTkjHHVaQbnLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccn/WPIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccn/WPIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961D3C4CED1;
	Thu, 20 Feb 2025 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740070173;
	bh=6b0qVpQmLm+Znh7shZWATZnMKrgXaMSIkpfvGrHF+L0=;
	h=Date:From:To:Cc:Subject:From;
	b=ccn/WPIy5zuWcJG41P/ZIC1dyXb9LXNBBZjNG57UEJHC1ewNtQPJYYptZNhBSp38e
	 17y+CBc4Jwu59qohg/QQBQJ8fTlTV+ON5VGSPyV6egkPuqHVqgnGSPU5+zkAo5l4dc
	 cNa5SHRmpCPq9x0kxZnR1Tt8ztfrx9JyF88N2qvk0vev9z8Oyy1W3Bo2RHdVK+2cJx
	 ErDepRZbj+hJqeHBC96HiiR3Xm07wtsI9Yh3Q6sjTGR6Yo3LQ4jMxZdgtA/81AKi2z
	 v6zvxXKF1CDjcusHBz//akDFKEYpYwVvH0EOj0mr1JDV0AugwT9W4ghGnQSZkxBoZg
	 IHq33ekLLPUqw==
Date: Thu, 20 Feb 2025 08:49:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libxfs-apply: allow stgit users to force-apply a patch
Message-ID: <20250220164933.GP21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
per maintainer request
---
 tools/libxfs-apply |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 2 deletions(-)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 097a695f942bb8..9fb31f74d5c9af 100755
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
+	local patch_name="$1"
+	local patch="$2"
+
+	# Import patch to get the metadata even though the diff application
+	# might fail due to stg import being very picky.  If the patch applies
+	# cleanly, we're done.
+	stg import --reject -n "${patch_name}" "${patch}" && return 0
+
+	local tmpfile="${patch}.stgit"
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
-			if [ -z "$response" -o "$response" != "s" ]; then
+			read -r -p "Skip, force Apply, or Fail [s|a|F]? " response
+			if [ -z "$response" -o "$response" = "F" -o "$response" = "f" ]; then
 				echo "Force push patch, fix and refresh."
 				echo "Restart from commit $_current_commit"
 				fail "Manual cleanup required!"
+			elif [ "$response" = "a" -o "$response" = "A" ]; then
+				stg_force_import "$_patch_name" "$_new_patch.2"
 			else
 				echo "Skipping. Manual series file cleanup needed!"
 			fi
