Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B421FBCAF;
	Tue, 29 Jul 2025 20:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819773; cv=none; b=N+43opUZlPg0p879N0KBXw0va+7v191+10BTNw3V9D7Ggy1e2NFUXm0cWsEQdeTdnEF8+mx6cISKspyI9qoXYnvoEq8w9bXspMWfdfPzQwjSJIGgL1Ix5GuKNGKAM8j3onwH+MFLQrV4Y4MqeCweCOlRfgHh5vpwSU9UIMoia+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819773; c=relaxed/simple;
	bh=dFTZ+MY2spvniqriiGjheG+CJdICjlLcYdv/4+THVy4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1AO7C9cH+LEzXboyc4nRBfCB7BxzOlsAXgaY+OkHEiQAqS1Sb3nulZimhoD6lKpuHDp6VnNB/l6CSfDphXymos8HqqfYKY2QJPHSAzsHvnClaFFxA3gDV9khxHWmdEBsufng2+MwIo3YALyPCZWGtqD/Q+K+UTlBDu6Pa7lHt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9D166lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9D166lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44114C4CEEF;
	Tue, 29 Jul 2025 20:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819773;
	bh=dFTZ+MY2spvniqriiGjheG+CJdICjlLcYdv/4+THVy4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E9D166lfGk1tKq0jSQ6LqzPUMFtI5K75xj36RL1I1d4XwtRVVDC6MkDqeZlnhgg3U
	 ucdG2iBeX7Kv2TKwlog6r8nlu1wjnHZ85G20iLoki3+0Ea2dIYn3Q0EuR2hCnYpFCA
	 eMF+FIwf/SuatLnAYKtm1XcZRlZ4oInX7a22/5fUzia7UAZJCqFnVYWfcBDMFqSRf/
	 QfbQ+vCjQ7ohumrSawYDvLiVSR7XWFBBlBj3eXgda5+4d1+pgOlDlr2V4pkBLCZ6Kj
	 lg1ELgAxEZ6xwEaMUaJwHPfaNplli16gryCNvwGDKLbRv1mXbJONpYWPZoqRNg1gu8
	 ylR5/6tumbIkQ==
Date: Tue, 29 Jul 2025 13:09:32 -0700
Subject: [PATCH 5/7] generic/767: allow on any atomic writes filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <175381957992.3020742.8103178252494146518.stgit@frogsfrogsfrogs>
In-Reply-To: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test now works correctly for any atomic writes geometry since we
control all the parameters.  Remove this restriction so that we can get
minimal testing on ext4 and fuse2fs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/767 |    1 -
 1 file changed, 1 deletion(-)


diff --git a/tests/generic/767 b/tests/generic/767
index 161fef03825db4..558aab1e6acf34 100755
--- a/tests/generic/767
+++ b/tests/generic/767
@@ -36,7 +36,6 @@ export SCRATCH_DEV=$dev
 unset USE_EXTERNAL
 
 _require_scratch_write_atomic
-_require_scratch_write_atomic_multi_fsblock
 
 # Check that xfs_io supports the commands needed to run this test
 # Note: _require_xfs_io_command is not used here because we want to

