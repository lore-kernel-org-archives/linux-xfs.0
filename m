Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688ED7ED;
	Mon,  1 Jan 2024 01:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJggcsGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FCBC433C8;
	Mon,  1 Jan 2024 01:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070852;
	bh=us6fFchlveF9YnzBfw+mkLNNtgQJsnqLggFWDd7NHgQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XJggcsGjQKbgnL2IHg+Ie26014VTQIrkQvOXody3MfpbSQoT0CU9H4wxHbVNocplk
	 s1dBZGKvKKVEw/TYSPRK9VVlB0d8G3O0qKHmjE0IwgqAm9e+zq00aB0gLnHO9novT/
	 gizP3Vs2gQdR8R5dHmDbSprn+ymTvGGl6hecRxCtHYh+CKHqogBxGnzKSW/1IM+QXP
	 lm9fYXZPWWsR/uu44T0a6cD1RAe2OK8LaGVzrpBlmF0GTe6x+jBi2z2BUAK/cyIrsZ
	 bMesKwkQvfUkgVusMuQ/MyETe7nZAe7wv83HsKu919p+2I1SlKXWff4Bmm5U94/qX0
	 1k3paAXCRRkgQ==
Date: Sun, 31 Dec 2023 17:00:51 +9900
Subject: [PATCH 12/13] populate: check that we created a realtime rmap btree
 of the given height
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031391.1826914.10155953070500273029.stgit@frogsfrogsfrogs>
In-Reply-To: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
References: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
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

Make sure that we actually create an rt rmap btree of the desired height
somewhere in the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)


diff --git a/common/populate b/common/populate
index d8d19bf782..84ff9304e3 100644
--- a/common/populate
+++ b/common/populate
@@ -740,6 +740,37 @@ __populate_check_xfs_agbtree_height() {
 	return 1
 }
 
+# Check that there's at least one rt btree with multiple levels
+__populate_check_xfs_rgbtree_height() {
+	local bt_type="$1"
+	local rgcount=$(_scratch_xfs_db -c 'sb 0' -c 'p rgcount' | awk '{print $3}')
+	local path
+	local path_format
+	local bt_prefix
+
+	case "${bt_type}" in
+	"rmap")
+		path_format="/realtime/%u.rmap"
+		bt_prefix="u3.rtrmapbt"
+		;;
+	*)
+		_fail "Don't know about rt btree ${bt_type}"
+		;;
+	esac
+
+	for ((rgno = 0; rgno < rgcount; rgno++)); do
+		path="$(printf "${path_format}" "${rgno}")"
+		bt_level=$(_scratch_xfs_db -c "path -m ${path}" -c "p ${bt_prefix}.level" | awk '{print $3}')
+		# "level" is the actual level within the btree
+		if [ "${bt_level}" -gt 0 ]; then
+			return 0
+		fi
+	done
+
+	__populate_fail "Failed to create rt ${bt_type} of sufficient height!"
+	return 1
+}
+
 # Check that populate created all the types of files we wanted
 _scratch_xfs_populate_check() {
 	_scratch_mount
@@ -763,6 +794,7 @@ _scratch_xfs_populate_check() {
 	is_finobt=$(_xfs_has_feature "$SCRATCH_MNT" finobt -v)
 	is_rmapbt=$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)
 	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
+	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
@@ -793,6 +825,8 @@ _scratch_xfs_populate_check() {
 	test $is_finobt -ne 0 && __populate_check_xfs_agbtree_height "fino"
 	test $is_rmapbt -ne 0 && __populate_check_xfs_agbtree_height "rmap"
 	test $is_reflink -ne 0 && __populate_check_xfs_agbtree_height "refcnt"
+	test $is_rmapbt -ne 0 && test $is_rt -gt 0 && \
+		__populate_check_xfs_rgbtree_height "rmap"
 }
 
 # Check data fork format of ext4 file

