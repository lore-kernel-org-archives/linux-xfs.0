Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DC7366;
	Tue, 26 Nov 2024 01:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584079; cv=none; b=JTYLXreqt9AO8fkUP7cMNlnebNIZGKjbFlnBTR6oDGcX1wyV4nFAeU5WZxzMltjr2h8M32tlHiTkuPOpq3w2MB09jBhrA85oRbvSYbTSZR5iPzS9R3/tdkoXrNz4nAjJ9TDyIwynH0gkhUBadiAxhwq5QgqNtakw5bvblFz1oIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584079; c=relaxed/simple;
	bh=MwlLblXm4yvShNCo+masInqXiO+qwCtzzMrlK5awwk4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jEQ6p1MeHwjbsEIsYjaoMgHKc7RWdJsmKxt9jzvrDYu39/uEYUg28SZUWMAW2Ad4ghvNJizJTUOEqYeLC28u91mQ1+RfYCfFWs0UJsmxzf+5YNf4dd2UIqBBL3evjI1piFTS/xUMnas7dELJrZtxZAoSSScds7JPgbr0mSzoq7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hYSJlkQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hYSJlkQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F45DC4CECE;
	Tue, 26 Nov 2024 01:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584079;
	bh=MwlLblXm4yvShNCo+masInqXiO+qwCtzzMrlK5awwk4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hYSJlkQol9PsAUxtqEGslJHKlFWGQr1MFomkOPCyaMLzNmtePorY05x5d718w9Dh9
	 JeO7fUakz50QwiLHBAgmfswX9RlhcL3nkEk8NfQSPSiWmkm4/2ooEe9p2KUc418hkl
	 TOr7CEpgSfJPdQhBDrI6y724as8ZJ93K8SxflCadY//aM8PZQIrYxJM97pgH4OUHEX
	 6/WlTJiZhBM0bFTH1u9Ar/1tqBlyBuKQR7pv7GvRhCcC3V2mckto5wpg6zOWcJWmdw
	 D6a48WoAluJ259hE+EDPlZrqQU0GQyXYtNhfF1TRdaf5BoomIDIVA5WtquHkxo3iZ8
	 ek7seAJRO4/UA==
Date: Mon, 25 Nov 2024 17:21:18 -0800
Subject: [PATCH 03/16] xfs/113: fix failure to corrupt the entire directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <173258395116.4031902.7860965991021855237.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

