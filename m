Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065EF271839;
	Wed, 12 Feb 2025 03:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331057; cv=none; b=Y02mLtODevHp20lhHw1jpbeHQ7TRYGNy9BqqcHjkgaOfS7xf8YYWHzukMCgQ6vTeY/EnO7E8w6Vj6DbgfBE0DEy8SLzj2e2ZhE5j8LXUC0NIlZ6kHKoN+m+5jigWOa2NGH5oxcPLCKbYBzp6THeI+Stpqs2lL49RIU7AzQa+lEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331057; c=relaxed/simple;
	bh=N1rXFWHU7xpuvJ/Ro0LntOQc/zBjBAt9QtuzxcNfxbE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nyIrokyXgzGj9lrBqRnIW6cZHWNw/tk2dVgeKNI3un2CrqhVv5TQme0CrkCrp//lZEKIhKNx929W+fGYvnmns7Y7AVh4o+tbJEvHjFY3qqLKhc/4MLbNpQXrVlr2IukBsUD7cd1MHYNilWeKNMgVsttXDOXNprbO7xNyPbytLZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9LsDwrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9LsDwrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74591C4CEDF;
	Wed, 12 Feb 2025 03:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331056;
	bh=N1rXFWHU7xpuvJ/Ro0LntOQc/zBjBAt9QtuzxcNfxbE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u9LsDwrMMRnfQ553nkzKc9VpS1RaSYHt5KGsB81+OLyUN3GvzIuH7Cz+ZgO2Mt8WR
	 72GN8j/UtoHz6rBVWxYQLuwQL+ut7vNolWL8ApWFJi29G1uRtdps2X8Qf72Fatyzud
	 xZ8gM307rVZqWo7VVsDtHJVGgydDb7jtiAb5nLTDt+v+GhbAtZhoAaEzMIeAnLagHz
	 gTPZ/fTknBLLxOCTIanfoECiePlEZAYFvO5Cz7BmR0YrTkpAVAmX5o6/EbbodVQp02
	 4soyX73M1XJtTM3nWkCVZ2QkSiQ/NXaRE3ZWkLkBKXnZ5u8ovCqrfBB3W2epkcd06n
	 uwiD0Pz30ds9w==
Date: Tue, 11 Feb 2025 19:30:55 -0800
Subject: [PATCH 01/34] generic/476: fix fsstress process management
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094369.1758477.3132820500237081050.stgit@frogsfrogsfrogs>
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

