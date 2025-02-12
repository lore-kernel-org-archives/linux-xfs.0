Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F333271839;
	Wed, 12 Feb 2025 03:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331479; cv=none; b=rbT8P0lWTorKPRNbuOlEisN77e4mZkRhdi5uRg/hpt3oVBOCQ477keF0xVD5776NMngbcfhNTmK3Awl2muLIiMbkJiCb9Y1BUdVkXfThBDRFVdRYCssSvbsVF6CZxcZVk0XIiSRwYFNZUu4EEXxWECXGqAjNG98euv7E1+R8L4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331479; c=relaxed/simple;
	bh=i0vuHDpHRnX1b7UNIWn+0PO/L2igXmIW0SrbyXJfgOo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IOkYLfy1o8EHZxhuKuMkpmaCULKa6/99CqOtKkjuqbXC+gFLeT/HS4H5Q7YifYKASdAdCjASuJrnZ8LA9s12cviJ0TaVe2hdWKzvym5zbutaFe47H6BLlh9CoQg/0Ldfjf92oIeaB5cug9mX5duOk1agiZ7V32gQtdJhb1IUFuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHBPt1Q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHBPt1Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4A8C4CEDF;
	Wed, 12 Feb 2025 03:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331479;
	bh=i0vuHDpHRnX1b7UNIWn+0PO/L2igXmIW0SrbyXJfgOo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cHBPt1Q9SQW1d05XAGt3VwkKnAnkIo8fZfMezFn6HiMZvG+MA8l2K3xIS8cELKqzf
	 E9EhixEhi0JR4bd3A/mR9F2WgZEnl9+12OS2i3XIDcsQSotHKXYCu3InTJuZvgOatn
	 ALw0NMG3DqotZH+il83CLNk6XZgyd2vgzZ2qNzHFmnwZdZSyBq0FSnj2O4kznTg22b
	 3/hZpQ52/sVNllH1EtdaS+ArmwjWES46m2PAupfj6e2Lu4rjl8/V3WLvzt5m8aBldd
	 rcfchHK0z9V/kPZMBfxg8M6f7EZaUM5QiQuoJc5nB5YzUldh4xXg0IUSH3eo6Kud67
	 cRHgtB9Z+e4KA==
Date: Tue, 11 Feb 2025 19:37:58 -0800
Subject: [PATCH 28/34] fix _require_scratch_duperemove ordering
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094782.1758477.13906721277088652827.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Zorro complained that generic/559 stopped working, and I noticed that
the duperemove invocation in the _require_scratch_duperemove function
would fail with:

 Error 2: No such file or directory while getting path to file /opt/file1. Skipping.
 Error 2: No such file or directory while getting path to file /opt/file2. Skipping.
 No dedupe candidates found.
 Gathering file list...

The cause of this is the incorrect placement of _require_scratch_dedupe
after a _scratch_mount.  _require_scratch_dedupe formats, mounts, tests,
and unmounts the scratch filesystem, which means that it should not come
between a _scratch_mount call and code that uses $SCRATCH_MNT.

Cc: <fstests@vger.kernel.org> # v2024.12.22
Fixes: 3b9f5fc7d7d853 ("common: call _require_scratch_dedupe from _require_scratch_duperemove")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/reflink |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/common/reflink b/common/reflink
index 9177c45e70bb37..757f06c1c69fa7 100644
--- a/common/reflink
+++ b/common/reflink
@@ -80,11 +80,11 @@ _require_scratch_duperemove()
 {
 	_require_scratch
 	_require_command "$DUPEREMOVE_PROG" duperemove
-
-	_scratch_mkfs > /dev/null
-	_scratch_mount
 	_require_scratch_dedupe
 
+	_scratch_mkfs > /dev/null
+	_scratch_mount
+
 	dd if=/dev/zero of="$SCRATCH_MNT/file1" bs=128k count=1 >& /dev/null
 	dd if=/dev/zero of="$SCRATCH_MNT/file2" bs=128k count=1 >& /dev/null
 	if ! "$DUPEREMOVE_PROG" -d "$SCRATCH_MNT/file1" \

