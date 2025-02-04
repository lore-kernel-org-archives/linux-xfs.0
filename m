Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C7525A62C;
	Tue,  4 Feb 2025 21:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704577; cv=none; b=RsqSby5pxfJzllXzsGgqFhHrRPJycm36cmccDaA3FH4C9IppFddPeV4rxegxh9LL/0mUckFaUfgkw3VQKi74b52XbLLOMvZUfPg+SGBhJOy20WPP/FGHRD0ZtnXmlvOXDINn2YBD0PhWHs/c2ElXqNmMGz0qy+v4mDMkOGzPmj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704577; c=relaxed/simple;
	bh=kviDYx/tiZ6S2quEjPzgbnlcQNGrHrI04gkxA1v/nW8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b/XadSWXVX+MkggY8c97tYZ198z+lxaN9sMnqFnRmtVCK+PzEC45YYBGtq2783kBbRZSJ2Ho0m9pgslwfC4udzO4TQQs57Hrnpm9fYC2Y/S5vMOedo5d+qw2qaIx46WvG+AAQ3RebZR9jsXS5xFN0kBWBPwOK1FnLA2k0B1g8sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fPsHtDFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPsHtDFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035FBC4CEDF;
	Tue,  4 Feb 2025 21:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704577;
	bh=kviDYx/tiZ6S2quEjPzgbnlcQNGrHrI04gkxA1v/nW8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fPsHtDFgRz4knSuY9m2rr49X6MBO/q7E/Jdrtn0JyQ4GUBKqmJVYsx8jCGAu5+aiz
	 DrJ9BxL3Tn7tzzzex1GZhWEGfUbwZL4vsGtJaJL8d2P0nE22ACVPqp8LNj2ORa7LfO
	 kAIZPOVLRqcD/V6KXbSEQjRTOCMbJT4ME51L8D0mXTweK9gwWFaKebH1ukLClt4X8Y
	 UuhB68N937vpjP4pZv8tQ+p29HfVP2bYfuDnjYyuLZOWzQr7GztIwx3k1e9mtGs0xN
	 VwSaC5zWsr/I0JZpfWNp+K01jXj/KPMjfQGo+jPIrPjfBRgWDXeFlaTHaIZM6Zo1f7
	 XUv7ZfvUCPqnQ==
Date: Tue, 04 Feb 2025 13:29:36 -0800
Subject: [PATCH 28/34] fix _require_scratch_duperemove ordering
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406534.546134.14642160815740463828.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
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

