Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EFD2676C9;
	Wed,  9 Apr 2025 15:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744211773; cv=none; b=cI8iOJTCwIj9egf9QCfY2tiZU6b5Ey0oD0QzXsxF04E0eCk2uTjGkqKlY6NzZfDiQyy11ibanwdcYFmWz/IV4mP1OYnVukumbdAyK31n+sGxiJXHNa4Y2pMwynFv1q5x9WUnGmWE1+CTLCzQIJZkrHWYXhDwAmL5AK560q/RaNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744211773; c=relaxed/simple;
	bh=61cPw9YTEZYGKu5kPd5fDHg7RBs6rTgXl7O64u0VBZU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gkPxcjBM9NJ5MJHaUbslJ85hHcTFV+9h1t3vUoBUVWis3SLa7nq4bzu3SPsSp89Py3Q4PtsuViG+QCxtHRYsZMdVAbgXRPgyLGrlenLSCWwU4qUqOcMyfs+2mNuHOYkrQLgpnio4Bm2adv1DUmknndF+PfVEgzlmxtuLPit/UMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rf5fCXgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rf5fCXgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB53C4CEE2;
	Wed,  9 Apr 2025 15:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744211773;
	bh=61cPw9YTEZYGKu5kPd5fDHg7RBs6rTgXl7O64u0VBZU=;
	h=Date:From:To:Cc:Subject:From;
	b=Rf5fCXgNbOu0TLJIyhjg5kJ4Ra+z2nLC50/drRrxMMt55kjJfrQsWGTmY4pXS/tHf
	 Y33mN+5sJUMOrxp0DXJxh8kcFMVdLDyJ6bCBRlp9e+3TwtXXcfJEbqY8QwYHyuryJI
	 dFskmb31svSdu9boQgiIRfBP8UNmaulgNXPa2G7dnyC3v9iHG33JQvQ8Qu39IkncY+
	 6H2ARAZxb0XieVCYHVbGSMbgcSE7vXcuHt1zk71Z06xZ7LKBtxgxYS2iEUE5Vo14Ah
	 Lqwvd+QLs1lNR15rp9C2rhx7I4flFsHJqiGovbFCE2r/ssaK4I0p8e0SRgqLFiTBJd
	 aFg27ji7mQExw==
Date: Wed, 9 Apr 2025 08:16:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] generic/275: fix on 32k fsblock filesystems
Message-ID: <20250409151612.GJ6274@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

This test fails on 32k-fsblock filesystems:

dd: failed to open '/opt/tmp3': No space left on device
dd: failed to open '/opt/tmp4': No space left on device
Pre rm space:
Filesystem     Type 1024-blocks    Used Available Capacity Mounted on
/dev/sda4      xfs      2031616 2030624       992     100% /opt
Post rm space:
Filesystem     Type 1024-blocks    Used Available Capacity Mounted on
/dev/sda4      xfs      2031616 2030368      1248     100% /opt
could not sufficiently fill filesystem

On a 32k-fsblock filesystem, creating tmp3 and tmp4 requires more than
1MB for the transaction allocation, which is why this test fails to fill
the filesystem.  To fix this, touch the four tmp files before trying to
use up all the free space.  The fix in ef25a29fa49a50 was incomplete.

Cc: <fstests@vger.kernel.org> # v2022.07.24
Fixes: ef25a29fa49a50 ("generic/275: fix premature enospc errors when fs block size is large")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/275 |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/generic/275 b/tests/generic/275
index fbfe158163f336..42d8ff00562ee7 100755
--- a/tests/generic/275
+++ b/tests/generic/275
@@ -43,6 +43,9 @@ _scratch_mount
 # now when we know there's enough free blocks.
 later_file=$SCRATCH_MNT/later
 touch $later_file
+for i in 1 2 3 4; do
+	touch $SCRATCH_MNT/tmp$i
+done
 
 # this file will get removed to create 256k of free space after ENOSPC
 # conditions are created.
