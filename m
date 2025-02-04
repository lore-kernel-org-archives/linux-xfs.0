Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578562045B8;
	Tue,  4 Feb 2025 21:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704154; cv=none; b=nHAbMhRLcSk3OB6jj/vD2t/xvqQz5D3n3tL6aOyLtE9/lEkDJ+6l5sQNFwu9BAGmnDLvUlqPs+Tw1ka7b8EOofAqlqHk7S7TlMFUxw/BS/Du5cDJuK9heJJv9IccM7UamslqORe8GC8exjBuONU5PXbJnJpQTijAxnTNE4NX2QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704154; c=relaxed/simple;
	bh=N1rXFWHU7xpuvJ/Ro0LntOQc/zBjBAt9QtuzxcNfxbE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jqEM+4FNrEfa99TS7zs8GFFgGnve75T4c3XuqTsaKOCi8pR2PIvM+hcB/rmRHOnCTHP98P2f8msHTzzKHt+FyhLZvJFiXyo8rdMYzerIe6vI17aO1d4qG7aqlbCU2XwShlxWtDH+y9ABJeJTKTtSvJtpw/tbOrU4nDwPm6sFxPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXL0T0Iz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXL0T0Iz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C45C4CEDF;
	Tue,  4 Feb 2025 21:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704153;
	bh=N1rXFWHU7xpuvJ/Ro0LntOQc/zBjBAt9QtuzxcNfxbE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PXL0T0Iz4hkBjKuQsiqaSLHdoDIPQHy6iu+8JY7DfZ0+WHFDLoKeEQo+x9jYVNstN
	 0WJY2sBq60RVs+ZtsBZKAs+X2MEwZvOjOMHgYZRkWc3FkgTW5iwUKICNDXmbcMclO4
	 K+l/+byl/311dOLZ5A+i8IEhBwnDbvCZBvdTIrMaL2A9QMqJ3QiV6RWxlaA/CqBkDi
	 S3glXsfr0HxJ4R8+mizkfQPi3YICzVCtZBeYuVAzWKHziVvQ8pM+AFij6KbeeLg9nW
	 pga/S7ZumUuxhXgTYOcUj6hRP47sZFtGPTpLBs3RaRdY9/EcgRR5ji62ONQm4MFegM
	 tPUblL7LHpbww==
Date: Tue, 04 Feb 2025 13:22:33 -0800
Subject: [PATCH 01/34] generic/476: fix fsstress process management
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406123.546134.3003611331543311338.stgit@frogsfrogsfrogs>
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

generic/476 never used to run fsstress in the background, but
8973af00ec212f made it do that.  This is incorrect, because now 476 runs
for three seconds (i.e. long enough to fall out the bottom of the test
and end up in _cleanup), ignoring any SOAK_DURATION/TIME_FACTOR
settings.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/476 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/476 b/tests/generic/476
index 769b3745f75689..4537fcd77d2f07 100755
--- a/tests/generic/476
+++ b/tests/generic/476
@@ -22,7 +22,7 @@ nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
 fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
 test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
 
-_run_fsstress_bg "${fsstress_args[@]}"
+_run_fsstress "${fsstress_args[@]}"
 
 # success, all done
 status=0

