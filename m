Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132FC246A36;
	Thu, 16 Jan 2025 23:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070224; cv=none; b=NwqHsltTuwtz8/lBboje2OgewKTwZw1t5bYDdH3yUYkTiCRTwIM34JCWVpT7h1f3jvv4U0OMidDTBAKbuf+db34FSZuvIEe83qW+jCU7t5UXlebhGSYTXMmvR7PwpXAU18PYI/7zujxY4pEDu9ndyUx21QoYkiCYduUAjKIqF2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070224; c=relaxed/simple;
	bh=kviDYx/tiZ6S2quEjPzgbnlcQNGrHrI04gkxA1v/nW8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIXgLHRSlPSA0MSnIyjgMywHrZ55rkMR8cdf2UofgxWrllP5haEQL0j0CFtrxoTzObI5hIwOX+WEJ2tfA7Nm5szjHNxFMgOPPh1cKYPK97ijNhiJWCs5Zip4o8DMLRmJZRq6vzJRNeZqMFgmAkbG3Jpc/NrICcYeHKjK5HJwp4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rsw46QuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rsw46QuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743CCC4CED6;
	Thu, 16 Jan 2025 23:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070223;
	bh=kviDYx/tiZ6S2quEjPzgbnlcQNGrHrI04gkxA1v/nW8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rsw46QuAzkGKN8sJS6s4rHQiAfxosas1nwZUBrkZyL6F4mn6EIniKAfVVAPgrrt9b
	 kJGaziG86D9uu0kITJ7DnQ9j/SABomjReWKBADH0AFDVN9SXtTXX0U3PyXOiBlx4I/
	 fAimKK4qbAmeMRPIL3WR+3pCCfvlPWA5d3zBx1Qml9Roatkf+t//qBGqQg/DMDk2jy
	 Ctr0JMOMhxpNwmB/o6UjR++S5xF+/fexWp19xZOu+ZxFbqo/CKkQ7J2EaOxdKezqR5
	 o8akLXeruN5wlzOJJiE2+8DB1yZ7yIFz4xls5cqVyncCvQQsX4Drr6x/OptWE49+hT
	 6lbS8jWTtxx4Q==
Date: Thu, 16 Jan 2025 15:30:23 -0800
Subject: [PATCH 20/23] fix _require_scratch_duperemove ordering
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974378.1927324.3637401394689754053.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
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

