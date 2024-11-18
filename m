Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DF61E8825;
	Mon, 18 Nov 2024 23:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971071; cv=none; b=D+JIvBZkRuUUpW8JDv9DCMqfDV6sY8wj98ZcQFMEHvxTw6aMpSgUbQeUKjNDi0RVtK5luHhATZ7CoQ3S3D+mYh1Aa9KtrdRca3zQsraWj15VnG6GNrOeR4pR5KB2oiZt9BApdm20WuwFWaDAgmupptRyCvCbJ4bgYNDor7oLLBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971071; c=relaxed/simple;
	bh=xDBnKYtPKRwk7HgznItCGQUs7M1arUlp40YnOffzAiQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4ak4veZ1E/lXI/e88e3WOQgt7d40HD6efcKPOPq9GtBrsCHo4F/IqqXGmFF95SfJuVBI8glo0bo4sNHf0N4e8vkc9U5YNjV5GTewpIfe47Y+hTwMonrnPFdPekbme/iGQD9X769tTADp65UrrW4wpxOBpBk6N7cU+aFWJln3TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mv0X0pLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mv0X0pLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690B8C4CECC;
	Mon, 18 Nov 2024 23:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971071;
	bh=xDBnKYtPKRwk7HgznItCGQUs7M1arUlp40YnOffzAiQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mv0X0pLIbsh4rzRlBf/qbwYNhFzCAXJcRyibneJLWDZHfq0GrmG8NeGceR1HII3Vo
	 UE/pmwNvaoDtQzbBF8p2wPUPFfX3aubt0BUWtJZ3RuHVYMHyi15CPErH63Uxo1ULTD
	 VjZaWIf1/Ty0mMt4FAyV11OODraNjW9cpprDVLmmRF20FO1ukT1rPK8f6bzgJI9WZR
	 1I8P6M2/1pvLSJOaw+N7YCHYSKKe2dNBobHBmio6cwN2RQk9Q06pd6IZuuKZyDNBbS
	 Jvkhca6B5CHrgK7sjwQdswmpIV7ajtB6+otwf00VtWAva/vwpCvWEJv01TWBFL9knZ
	 bNZY/TohzE+lQ==
Date: Mon, 18 Nov 2024 15:04:31 -0800
Subject: [PATCH 12/12] xfs/157: fix test failures when MKFS_OPTIONS has -L
 options
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <173197064609.904310.7896567442225446738.stgit@frogsfrogsfrogs>
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

Zorro reports that this test fails if the test runner set an -L (label)
option in MKFS_OPTIONS.  Fix the test to work around this with a bunch
of horrid sed filtering magic.  It's probably not *critical* to make
this test test work with random labels, but it'd be nice not to lose
them.

Cc: <fstests@vger.kernel.org> # v2024.10.14
Fixes: 2f7e1b8a6f09b6 ("xfs/157,xfs/547,xfs/548: switch to using _scratch_mkfs_sized")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/157 |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/157 b/tests/xfs/157
index e102a5a10abe4b..0c21786e389695 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -65,9 +65,34 @@ scenario() {
 	SCRATCH_RTDEV=$orig_rtdev
 }
 
+extract_mkfs_label() {
+	set -- $MKFS_OPTIONS
+	local in_l
+
+	for arg in "$@"; do
+		if [ "$in_l" = "1" ]; then
+			echo "$arg"
+			return 0
+		elif [ "$arg" = "-L" ]; then
+			in_l=1
+		fi
+	done
+	return 1
+}
+
 check_label() {
-	_scratch_mkfs_sized "$fs_size" "" -L oldlabel >> $seqres.full 2>&1
-	_scratch_xfs_db -c label
+	local existing_label
+	local filter
+
+	# Handle -L somelabel being set in MKFS_OPTIONS
+	if existing_label="$(extract_mkfs_label)"; then
+		filter=(sed -e "s|$existing_label|oldlabel|g")
+		_scratch_mkfs_sized $fs_size >> $seqres.full
+	else
+		filter=(cat)
+		_scratch_mkfs_sized "$fs_size" "" -L oldlabel >> $seqres.full 2>&1
+	fi
+	_scratch_xfs_db -c label | "${filter[@]}"
 	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
 	_scratch_xfs_db -c label
 	_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"

