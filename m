Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092B922339;
	Fri, 22 Nov 2024 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294322; cv=none; b=KICuRXeef4Yr02gi7cZA2AvPusTF+kAICxROr3qsea0jn/PK0zYliSmFzi2vHv9Hy3W0e6nT2dVOiTrYrz2gU0WZ0i9U11LM/9PdsFOgbCh+tXcEktfZGbtjg393R0YmnmZ4WC6omEk5sjUdSFexTEWg8SjNHMtMpDUJ7LzDRvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294322; c=relaxed/simple;
	bh=KD0t3PuSiDqGGJor5+114IwU8rWTQoK7E4io5F5i2Y4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YHrASZMQ+gSmOB04KpjzH4GPffCzS1hcY1XfLUdjThrdCMMKROuRjQT10JlvF2nlnUrdWx27k0RZxEsHuP5Xqo84H85c5W6wnLogg6f1Q2MoBnYcVG3fUdCmfOFsuKuVhy6SfpIi4TsDwAlJmLoB6xIHCAQ+VDoLXvv+3D9+/xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfptBZVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfptBZVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6F4C4CECE;
	Fri, 22 Nov 2024 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294321;
	bh=KD0t3PuSiDqGGJor5+114IwU8rWTQoK7E4io5F5i2Y4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AfptBZViF17z2uaTQim2C8JKYsHQUFjyakFA8IbbewyCjcdo30mU7xRginKoOFxhk
	 hMQu2L7B0+gtFF8m3IZRaS9wvwytyDzNg6PoHlE9YPiUWthz7dVTzmcBXCEbdK22c0
	 DzVzwWYZP54rRH9Q7wmVrEFPdDjzn2X6MS0QR7C6AHihiIIKAfvWPUfO9OwcQbxefE
	 LRY7L9+FBzwd7d23Bc6DT0zgYZSTrFlP6Uu+gBktlsMCL2FIDIbfkn3a6tBHK0O8W9
	 1insqMq9MHZV42t9FswzSjmqguOujOM5ExclKYwuC8OCW8eaqC2tsPNndEb+dvETzD
	 kPwHvF29Qhssw==
Date: Fri, 22 Nov 2024 08:52:01 -0800
Subject: [PATCH 06/17] xfs/113: fix failure to corrupt the entire directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <173229420102.358248.14679957569173990136.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
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
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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

