Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1E428628D;
	Wed, 19 Feb 2025 01:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927238; cv=none; b=TCnBGNbKvFBOHOM/MSySz+B+kf+5SKaSMPDV8+46HGuiMWC+vSwkMrphKaVDr79EDOzjs6Z7zSFraNY2f/g06wPRi9c8MobFXFNbcynTCijFAsf53nOkbw2AzhciLZ82hNjA/+s70WbrI3qRj2ldHYhBPuZZKmosUrSTYPNRX+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927238; c=relaxed/simple;
	bh=F/jq24nUgqPdKABA77F9DJjfjo8G6/hwuuWCI1vzctI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jHWOjilcQGosoQEEH3at93j0FuMME3y/9v79FgCeKi87zfLD6cbfNyVIFHl6ihs08NwbQiats01Xw35zI547TE5x1IGACxXnJYCQq43z63UQ4nUGOE6zPCdZW1XphRkOtVZ8EV+SoiWHsxd8eZbhkQjqyEcblwQfFiKSb852afY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bjb7oG71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bjb7oG71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560B4C4CEE2;
	Wed, 19 Feb 2025 01:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927238;
	bh=F/jq24nUgqPdKABA77F9DJjfjo8G6/hwuuWCI1vzctI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bjb7oG71gvXbe+JNCJsDazxuWtRZltiwotRoyRjE4gN2UUkiknxsFZEhk4SuAP+K/
	 RWrdbqNkhCywH2pF2JcgNjwWyTdSW8JGhk9jsRwvge+byDYo2ElVW9gKoz8bSmvBcq
	 H1naNarOREw7MjZ4qn6HtZ3dT0JyLhyQ32D3gB3Hs9t/MpgFK9peNAERmxa3yAhDHz
	 ZNbez+7zY35EZVQ9GILEXae6nLtgb+tI5DyuyAPsEAs2107vz6CM7B91/U49z9j/z0
	 kNlpVuudPqaGjp91M2DvQ7DmrT0Xm9ISsTTm73XJBxILsLBqSmxYatBQn+8qXER2Hv
	 yT5JCIlY1UmdA==
Date: Tue, 18 Feb 2025 17:07:17 -0800
Subject: [PATCH 1/7] common/populate: create realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591771.4081089.11279761022882150065.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)


diff --git a/common/populate b/common/populate
index dd80f0796a4d36..a1be26d5b24adf 100644
--- a/common/populate
+++ b/common/populate
@@ -451,16 +451,30 @@ _scratch_xfs_populate() {
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
@@ -469,7 +483,6 @@ _scratch_xfs_populate() {
 	fi
 
 	# Reference-count btree
-	is_reflink="$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)"
 	if [ $is_reflink -gt 0 ]; then
 		echo "+ reflink btree"
 		nr="$((blksz * 2 / 12))"
@@ -534,6 +547,7 @@ _scratch_xfs_populate() {
 	__populate_fragment_file "${SCRATCH_MNT}/RMAPBT"
 	__populate_fragment_file "${SCRATCH_MNT}/RTRMAPBT"
 	__populate_fragment_file "${SCRATCH_MNT}/REFCOUNTBT"
+	__populate_fragment_file "${SCRATCH_MNT}/RTREFCOUNTBT"
 
 	_scratch_unmount
 }
@@ -779,6 +793,10 @@ __populate_check_xfs_rgbtree_height() {
 		path_format="/rtgroups/%u.rmap"
 		bt_prefix="u3.rtrmapbt"
 		;;
+	"refcnt")
+		path_format="/rtgroups/%u.refcount"
+		bt_prefix="u3.rtrefcbt"
+		;;
 	*)
 		_fail "Don't know about rt btree ${bt_type}"
 		;;
@@ -853,6 +871,8 @@ _scratch_xfs_populate_check() {
 	test $is_reflink -ne 0 && __populate_check_xfs_agbtree_height "refcnt"
 	test $is_rmapbt -ne 0 && test $is_rt -gt 0 && \
 		__populate_check_xfs_rgbtree_height "rmap"
+	test $is_reflink -ne 0 && test $is_rt -gt 0 && \
+		__populate_check_xfs_rgbtree_height "refcnt"
 }
 
 # Check data fork format of ext4 file

