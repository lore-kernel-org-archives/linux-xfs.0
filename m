Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BA01E8846;
	Mon, 18 Nov 2024 23:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970915; cv=none; b=IgeScIQid+skby7nU2UahMcH/tCO5CRp/E7k8FUTA9BVs0r8/PGALDzLMU8+X4S+bC1eW670EB4hkopkHnu2t6ZE3miMLkB8IJVsqgcGYw35qc5rL3LrXdXCVuM5rQZt/gk+JEpPcw4gvK7PikwGnH6titrk0kA1CaZgMkJyfZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970915; c=relaxed/simple;
	bh=o6zb0xaKvT1Phfnf+O/+8ow1anPAvLrsASAA2MUzl/I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lymfQCkK7c96+0PcZYo7WpKM1kxbMqaX1q50t7exj7Wfum8gPwcsYlrcDfd5BppjvnbuP68FNZaysv7GuGQiq2ylxkaNIvYox3gylknEAPrw7eE4PsPeCkze/McmnX8c6WGquwFilxcoZFiwGekgYoGghwvS4jI0XMbzBZ9KvjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WxmI30mI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WxmI30mI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DA9C4CECC;
	Mon, 18 Nov 2024 23:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731970915;
	bh=o6zb0xaKvT1Phfnf+O/+8ow1anPAvLrsASAA2MUzl/I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WxmI30mIcyqB4lzwQ2iQt6tqkDqmI9jgYWTOV1IYymgn4/MxXkyKGtKkJq5Ny2Rhj
	 CbypQK6wSQrTm/yGIdCEjKNy8EzESxgh0fLcfpH72TSj+kf7lX/7VOeUbHjzmq0AJe
	 WB+3405tpNJ0H+r4hGl3nG5SUBo9TYTzfW/Pa55BdCvnJV/10oTGLr7IrHKfDOimqe
	 9Ozm9TkPFACQxMJeDUfEwOunHPZQV4h/QCMvQjx0I//dGhDjkXJcFx0UqjgULgC+fM
	 h7FIPM/i7iMCAhpEQhDsy7GQuASf3k/gWxN42e6lPoXkRP/Qj3d6w5BLJ3zUxfwZGk
	 M0ivoa+duOeTQ==
Date: Mon, 18 Nov 2024 15:01:54 -0800
Subject: [PATCH 02/12] xfs/113: fix failure to corrupt the entire directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <173197064456.904310.9904578922751677795.stgit@frogsfrogsfrogs>
In-Reply-To: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test tries to corrupt the data blocks of a directory, but it
doesn't take into account the fact that __populate_check_xfs_dir can
remove enough entries to cause sparse holes in the directory.  If that
happens, this "file data block is unmapped" logic will cause the
corruption loop to exit early.  Then we can add to the directory, which
causes the test to fail.

Instead, create a list of mappable dir block offsets, and run 100
corruptions at a time to reduce the amount of time we spend initializing
xfs_db.  This fixes the regressions that I see with 32k/64k block sizes.

Cc: <fstests@vger.kernel.org> # v2022.05.01
Fixes: c8e6dbc8812653 ("xfs: test directory metadata corruption checking and repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/113 |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)


diff --git a/tests/xfs/113 b/tests/xfs/113
index 094ab71f2aefec..22ac8c3fd51b80 100755
--- a/tests/xfs/113
+++ b/tests/xfs/113
@@ -52,13 +52,34 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 echo "+ check dir"
 __populate_check_xfs_dir "${inode}" btree
 
+dir_data_offsets() {
+	_scratch_xfs_db -c "inode ${inode}" -c 'bmap' | \
+		awk -v leaf_lblk=$leaf_lblk \
+		'{
+			if ($3 >= leaf_lblk)
+				exit;
+			for (i = 0; i < $8; i++)
+				printf("%d\n", $3 + i);
+		}'
+}
+
 echo "+ corrupt dir"
-loff=0
-while true; do
-	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" | grep -q 'file data block is unmapped' && break
-	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
-	loff="$((loff + 1))"
-done
+subcommands=()
+while read loff; do
+	# run 100 commands at a time
+	if [ "${#subcommands[@]}" -lt 600 ]; then
+		subcommands+=(-c "inode ${inode}")
+		subcommands+=(-c "dblock ${loff}")
+		subcommands+=(-c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}")
+		continue
+	fi
+
+	_scratch_xfs_db -x "${subcommands[@]}" >> $seqres.full
+	subcommands=()
+done < <(dir_data_offsets)
+if [ "${#subcommands[@]}" -gt 0 ]; then
+	_scratch_xfs_db -x "${subcommands[@]}" >> $seqres.full
+fi
 
 echo "+ mount image && modify dir"
 if _try_scratch_mount >> $seqres.full 2>&1; then

