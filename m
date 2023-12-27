Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BCF7EE;
	Mon,  1 Jan 2024 01:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJdwqIa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C581FC433C7;
	Mon,  1 Jan 2024 01:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070914;
	bh=jKlY8tEzhfFHB9ElAuOkFtT99EZtNEOcbHZvrOBYPJ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZJdwqIa0W9U+0cZOn0EQlFH7NjTNWDQgEilU662z8d5hCpnTzjyjsD3SKH01YeTAy
	 3+9ETiuSGL2g4TokYcy3UQQO5dq4JoUQ/gWCevUnHDV7uD/UkceKyP9XJ25DMbAoXt
	 DbNNj4s2xyL+VmDoUgsrDWbD2ooYcl8ajw428YVrOjvcHMbf0/Gj6sdWhb7A6Qr+Wl
	 Y5hEA0NHbLTvpTdxOAyA4JthKPpliUTol/J1F54FNWSSiPQJbMO7hYtYFgZiXAZ105
	 Vj9GS/UVdOJUsLZsb0IA1/2bGrUM1otucFwuB8vSZrB4CHeJN3r/cYqAutN4n7Ewih
	 rkOu5eAHf2p6A==
Date: Sun, 31 Dec 2023 17:01:54 +9900
Subject: [PATCH 2/9] common/populate: create realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032043.1827358.8872006071415407711.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
References: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Populate a realtime refcount btree when we're creating a sample fs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)


diff --git a/common/populate b/common/populate
index 84ff9304e3..1e51eedddc 100644
--- a/common/populate
+++ b/common/populate
@@ -438,16 +438,30 @@ _scratch_xfs_populate() {
 	local dir="${SCRATCH_MNT}/INOBT"
 	__populate_create_dir "${dir}" "${nr}" true --file-pct 100
 
-	# Reverse-mapping btree
+	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 	is_rmapbt="$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)"
+	is_reflink="$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)"
+
+	# Reverse-mapping btree
 	if [ $is_rmapbt -gt 0 ]; then
 		echo "+ rmapbt btree"
 		nr="$((blksz * 2 / 24))"
 		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RMAPBT"
 	fi
 
+	# Realtime Reference-count btree comes before the rtrmapbt so that
+	# the refcount entries are created in rtgroup 0.
+	if [ $is_reflink -gt 0 ] && [ $is_rt -gt 0 ]; then
+		echo "+ rtreflink btree"
+		rt_blksz=$(_xfs_get_rtextsize "$SCRATCH_MNT")
+		nr="$((rt_blksz * 2 / 12))"
+		$XFS_IO_PROG -R -f -c 'truncate 0' "${SCRATCH_MNT}/RTREFCOUNTBT"
+		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RTREFCOUNTBT"
+		$XFS_IO_PROG -R -f -c 'truncate 0' "${SCRATCH_MNT}/RTREFCOUNTBT2"
+		cp --reflink=always "${SCRATCH_MNT}/RTREFCOUNTBT" "${SCRATCH_MNT}/RTREFCOUNTBT2"
+	fi
+
 	# Realtime Reverse-mapping btree
-	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
 		nr="$((blksz * 2 / 24))"
@@ -456,7 +470,6 @@ _scratch_xfs_populate() {
 	fi
 
 	# Reference-count btree
-	is_reflink="$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)"
 	if [ $is_reflink -gt 0 ]; then
 		echo "+ reflink btree"
 		nr="$((blksz * 2 / 12))"
@@ -512,6 +525,7 @@ _scratch_xfs_populate() {
 	__populate_fragment_file "${SCRATCH_MNT}/RMAPBT"
 	__populate_fragment_file "${SCRATCH_MNT}/RTRMAPBT"
 	__populate_fragment_file "${SCRATCH_MNT}/REFCOUNTBT"
+	__populate_fragment_file "${SCRATCH_MNT}/RTREFCOUNTBT"
 
 	umount "${SCRATCH_MNT}"
 }
@@ -753,6 +767,10 @@ __populate_check_xfs_rgbtree_height() {
 		path_format="/realtime/%u.rmap"
 		bt_prefix="u3.rtrmapbt"
 		;;
+	"refcnt")
+		path_format="/realtime/%u.refcount"
+		bt_prefix="u3.rtrefcbt"
+		;;
 	*)
 		_fail "Don't know about rt btree ${bt_type}"
 		;;
@@ -827,6 +845,8 @@ _scratch_xfs_populate_check() {
 	test $is_reflink -ne 0 && __populate_check_xfs_agbtree_height "refcnt"
 	test $is_rmapbt -ne 0 && test $is_rt -gt 0 && \
 		__populate_check_xfs_rgbtree_height "rmap"
+	test $is_reflink -ne 0 && test $is_rt -gt 0 && \
+		__populate_check_xfs_rgbtree_height "refcnt"
 }
 
 # Check data fork format of ext4 file

