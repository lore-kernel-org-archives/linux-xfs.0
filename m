Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7626E191F77;
	Sat, 16 Nov 2024 19:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731784088; cv=none; b=pLwhaQfoS/tcOfExwRzh7U+LUc7/DxmiZh5F4GCSt7ja8XcvUPDPLDFqDn1QOEjIeWKY5TM2Kx7QYKJvM2ZJ2cYTkK2H08UMBK0TgzygoGNNBEOqe0LKvA7WLijwKD5O52nP3QOt5utTbiB+Cg35wn7gdcPp16EYgb2Ol2Xctkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731784088; c=relaxed/simple;
	bh=yrf+pgrl7U+ogiCQWimaa9y4WqjMRbzllajLxmT2aGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izVaumZNAR0+KBRu86pc5DqV4wcgoFFTTAbgbiqQB86m6CtXUsAPnRwF1XqFFwOlCZlkh+Urt8h9sbP7d5ggfos9doHNA1T5qldZchNZADahHlmRUpvXK2KWmLgIoehqHZtD/qtEhahJJWm8gglitlfEq9QUnMZyaF3HvwnIPfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ph3HTcBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ph3HTcBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8BCC4CED4;
	Sat, 16 Nov 2024 19:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731784086;
	bh=yrf+pgrl7U+ogiCQWimaa9y4WqjMRbzllajLxmT2aGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ph3HTcBCGSobSyH+J/9bZxAmZekjhfuClpP3Yq8Se+ZAQ6TA2K7UePaz1i/TVpig4
	 pTNuucNN465yRF6dNCwI+hwkQr566qRn4RMZkPojBfpoDvlgUq5B0IlADMx8BAtAR0
	 nzGu3ZIVjMsIX6+CkFZebSHUdZGxklHcX1OKy7e2tU5K9H6fU1fj9WfSPgOBMKDob7
	 0dMWQmB+E3iUlbTSTKhNxTP1p733Zy8GPWGVdKQgCQT2hgNgNkGeKfJwb0elCptDx0
	 7o3rAo/NCNkQcFxxhF9Cys6wzkKaA8p9zbJ8CrKp/GIn9kkr9LkGFsi0AWadToG13r
	 8etYcsbDP2Jzg==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs/157: do not drop necessary mkfs options
Date: Sun, 17 Nov 2024 03:08:00 +0800
Message-ID: <20241116190800.1870975-3-zlang@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241116190800.1870975-1-zlang@kernel.org>
References: <20241116190800.1870975-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 tests/xfs/157 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/xfs/157 b/tests/xfs/157
index 9b5badbae..f8f102d78 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -66,8 +66,7 @@ scenario() {
 }
 
 check_label() {
-	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
-		>> $seqres.full
+	_scratch_mkfs_sized "$fs_size" "" "-L oldlabel" >> $seqres.full 2>&1
 	_scratch_xfs_db -c label
 	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
 	_scratch_xfs_db -c label
-- 
2.45.2

