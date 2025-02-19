Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3818485C5E;
	Wed, 19 Feb 2025 00:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926752; cv=none; b=UD2zPF24CdzUnDxpHo4+xNKVtLW+BmmRCM8S7XzywQJfIum232u0HnUiTE7NcCXQUzj6BeOScKJL+mMK95wwjqhFTUYRyHV+C5RzvR8+LIuLsdH9/NL7lg5huKYvLYTlzhPlRRSk0wssujS/1dZtvqBybsdzE8SIWIGzU5npk2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926752; c=relaxed/simple;
	bh=znBTG2CrkipuWwoJUrB+iX0KUhqPI741QQj79rwL078=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ukZituuiqrWM+e7qwSPbrLo+euXc/BSt2I0pDavCAQrVDXXB1wvOHMQwCCTpm1Z+u/OcIuuhDWNfQXWrOuZvK2hxQ3USHILDktOjoFYz4C1uQDsB8N6kVSnAYk3bHPd/BP6kyd4vjBEbLOw8dnOhoDBVv6YO5ZrZltFk2ogB0Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0s4ZtEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0s4ZtEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EF0C4CEE2;
	Wed, 19 Feb 2025 00:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926751;
	bh=znBTG2CrkipuWwoJUrB+iX0KUhqPI741QQj79rwL078=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k0s4ZtEXtvVoX4yz8B39dd0wCeuL7Zxbi4Zo6mqAoVKwNmzn32qz7DRSAzoC97ReB
	 HWYheA2ew/LP2WjSXJCOqi8smTy5v0rUY0RHXGGSgijr4c5NZikIMVM8mLwrUM+LRw
	 0ZbsfNK/V5V8Z/mtaXFuNe0VMeNY4pT3ajDpW68IA70iRSC6Lk13eYoosQCxgA+bcq
	 +QhUm9FoRA1EqW7/CFjHhVSCpkaYScANwhDPAk0oqeFX+OWsLiHHSJjV4iFt14k7dI
	 S7IzJC/PicFOpSjADchCLGf5YTfsYDwtU8Ic/1NZBnpJxIXziT6EYfNkPW9esD4VYs
	 +Mc4E3SZJ7AAQ==
Date: Tue, 18 Feb 2025 16:59:11 -0800
Subject: [PATCH 06/15] common/populate: use metadump v2 format by default for
 fs metadata snapshots
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589290.4079457.11127255945217928255.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're snapshotting filesystem metadata after creating a populated
filesystem, force the creation of metadump v2 files by default to
exercise the new format, since xfs_metadump continues to use the v1
format unless told otherwise.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)


diff --git a/common/populate b/common/populate
index 32dc5275e2debd..9fc1ee32bd490d 100644
--- a/common/populate
+++ b/common/populate
@@ -55,7 +55,12 @@ __populate_fail() {
 	case "$FSTYP" in
 	xfs)
 		_scratch_unmount
-		_scratch_xfs_metadump "$metadump" -a -o
+
+		mdargs=('-a' '-o')
+		test "$(_xfs_metadump_max_version)" -gt 1 && \
+			mdargs+=('-v' '2')
+
+		_scratch_xfs_metadump "$metadump" "${mdargs[@]}"
 		;;
 	ext4)
 		_scratch_unmount
@@ -1056,8 +1061,12 @@ _scratch_populate_save_metadump()
 		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 			logdev=$SCRATCH_LOGDEV
 
+		mdargs=('-a' '-o')
+		test "$(_xfs_metadump_max_version)" -gt 1 && \
+			mdargs+=('-v' '2')
+
 		_xfs_metadump "$metadump_file" "$SCRATCH_DEV" "$logdev" \
-				compress -a -o
+				compress "${mdargs[@]}"
 		res=$?
 		;;
 	"ext2"|"ext3"|"ext4")

