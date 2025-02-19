Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D921E4AB;
	Wed, 19 Feb 2025 01:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927207; cv=none; b=BV00a8Zz0XhIvjx0vTYGx1bYVSV0+8jQSFJK3Csdx87ZpYGJPDnVgUHFwGk1lrx7mq2YzJEETI1jRYClELg00YwDzqLUYIlOfhIDaOzjYqiMrp8k9VA9axCGzw/2FGfckK483hNjYWlLrOcIJk5l+Zn7Ogkz1mDtobLnEPZuIYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927207; c=relaxed/simple;
	bh=hKos3fui9F2+OmCnT6yWsN51EouiC6jy3WG+gpfAY0M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWKdNZdQ1PTBm3QfhY67FZD0TZjIae8BszZkWfGa/zgwRsXmmkDltHR5J9Asotutxm6RfRtBC1i4V45/GX4oFeOxxA2WsVmqmEKDr18IbE/T+MCoPoXfwwSpBXzQoIoCpc7d9Z+P9yvLAPJSVZ4E1cfpapH8ovLrBrb4bHjs198=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UEJulNSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UEJulNSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F0EC4CEE2;
	Wed, 19 Feb 2025 01:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927207;
	bh=hKos3fui9F2+OmCnT6yWsN51EouiC6jy3WG+gpfAY0M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UEJulNSLyFTck6UqM28lGJ2l8Wg52rPJgSUK34x0pETRurdxcSGnZzTeHl1QqK/UY
	 va4QcxZJN2LGMyy25UNsyJdgC9UQowwSu2gupMRH16PwQFARTsftPBw2jlmDzVpTfG
	 Y9rbchodl53reEHNc9gzR6Dad2ftQ02E4w4PyyZ2m7RY/k7Gq6ltx5u2JE3hgyLNya
	 vsS8ODBGRI3RbNXaHbeEqrE6+tyb370Jf1dGUZ6nYCm1YknJdS/zF+uLsYKvUUKg8f
	 lGyRC5QAY9nrhU5pPdD+1gW25S8jIWl+KbAHixJWcoSHc57sGrMnmmHH3FtOQ5Xl4a
	 ZDYRqBfavCcJA==
Date: Tue, 18 Feb 2025 17:06:46 -0800
Subject: [PATCH 12/13] populate: check that we created a realtime rmap btree
 of the given height
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591331.4080556.11286805171906703815.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)


diff --git a/common/populate b/common/populate
index 1741403fafd9aa..dd80f0796a4d36 100644
--- a/common/populate
+++ b/common/populate
@@ -766,6 +766,37 @@ __populate_check_xfs_agbtree_height() {
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
+		path_format="/rtgroups/%u.rmap"
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
@@ -789,6 +820,7 @@ _scratch_xfs_populate_check() {
 	is_finobt=$(_xfs_has_feature "$SCRATCH_MNT" finobt -v)
 	is_rmapbt=$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)
 	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
+	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
@@ -819,6 +851,8 @@ _scratch_xfs_populate_check() {
 	test $is_finobt -ne 0 && __populate_check_xfs_agbtree_height "fino"
 	test $is_rmapbt -ne 0 && __populate_check_xfs_agbtree_height "rmap"
 	test $is_reflink -ne 0 && __populate_check_xfs_agbtree_height "refcnt"
+	test $is_rmapbt -ne 0 && test $is_rt -gt 0 && \
+		__populate_check_xfs_rgbtree_height "rmap"
 }
 
 # Check data fork format of ext4 file

