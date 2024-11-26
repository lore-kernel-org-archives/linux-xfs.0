Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112D6BA27;
	Tue, 26 Nov 2024 01:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584237; cv=none; b=a7P0xYat9Bdel4LVr1cCJOSRPWA+9B7i6TOCTCagFHVW/pJBIge73QLjBlflMDyC4ma1Hw8r9a/PgBhLHahUrSm+tvlZgoN/ITS5ryPVP2IG16w7HhLTocsOdpdQ28a9IEIZqNL6Oa7x6iv/GUUc7DdzZ1jh/glW9UiT2zMQapc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584237; c=relaxed/simple;
	bh=xoZYZcbhaXPVuUUb3eqxkHGXvjFqsgU9jp/QiJ6gyyE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pX4YqyqdEPCynNeb4bv12HzUCqW5Gf/q+zZdTsQmsFuSxrtNEeDX7Qm7jnBWTmJa6Pq1TbEhDWBSFq/ZdTUDoxEy91PTcojnRbYVWxA+PYqD2djw7ypPTERbLiUnTojBAaKJ/rVOLFkxzVfgWC/z/kxEiFQi68JONV5E1jxSME0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=goVgyehj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="goVgyehj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE48C4CECE;
	Tue, 26 Nov 2024 01:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584236;
	bh=xoZYZcbhaXPVuUUb3eqxkHGXvjFqsgU9jp/QiJ6gyyE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=goVgyehjdw1uO+PHFS29bkInUPteGLmfAi1/pwUiJDFtfEcMpWAbfx5B06yhnLlqT
	 iHb360wntoRLImKPgAxJkq9l/MWcmtjsMoZv13/xuzit8G7gh83q1Q6UJGBkMEaxHE
	 Ect4mZC16sQV+I48kRQCdVZW119I8tGBy2OJroeHiMqxltWSL44j8hevmyJNUhJLJA
	 cAE8XmyaKjduNjpHWpgCbqyP8KkhmbN82sCAe7jCvckTsrUszIy1p+96R8io+fZfTn
	 R8VgqKXv0ATAfT2Haz8Cp3dVK/2Z7rW9tFNwGQwcCgKN2ldTIM2h3+GLWaxqSyedHe
	 P4GKryMj6udvw==
Date: Mon, 25 Nov 2024 17:23:56 -0800
Subject: [PATCH 13/16] xfs/157: do not drop necessary mkfs options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395269.4031902.7174495000706966581.stgit@frogsfrogsfrogs>
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

From: Zorro Lang <zlang@kernel.org>

To give the test option "-L oldlabel" to _scratch_mkfs_sized, xfs/157
does:

  MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size

but the _scratch_mkfs_sized trys to keep the $fs_size, when mkfs
fails with incompatible $MKFS_OPTIONS options, likes this:

  ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
  ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **

but the "-L oldlabel" is necessary, we shouldn't drop it. To avoid
that, we give the "-L oldlabel" to _scratch_mkfs_sized through
function parameters, not through global MKFS_OPTIONS.

Signed-off-by: Zorro Lang <zlang@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: fix more string quoting issues]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/157 |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/tests/xfs/157 b/tests/xfs/157
index 9b5badbaeb3c76..e102a5a10abe4b 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -66,8 +66,7 @@ scenario() {
 }
 
 check_label() {
-	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
-		>> $seqres.full
+	_scratch_mkfs_sized "$fs_size" "" -L oldlabel >> $seqres.full 2>&1
 	_scratch_xfs_db -c label
 	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
 	_scratch_xfs_db -c label

