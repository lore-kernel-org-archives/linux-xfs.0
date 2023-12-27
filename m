Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E30C4A03;
	Mon,  1 Jan 2024 00:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bc3zUwwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B5DC433C7;
	Mon,  1 Jan 2024 00:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070539;
	bh=wsqC3D7LUO/WzeJWOdHsFQhiOxAWi4EJ1NZMu3PLVgo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bc3zUwwUu0+nL95YdO4AUM/hIm9nqXTcZXzo/tz6OGxKX/mnwBRAAdBmmhFWTbmpN
	 t02tp+C2EPhOoxIZxYJrSyxFbWKY6mw5VvotEAxhVn5LtzRNrf4fMG3tLKGJPAt1DG
	 qIwjBmd42ed7bL3Y6+94iFSk1VufnGNNRbXSOx/eKZ0pv+FfFTibqfYcY10Kx1GKOW
	 E2RUXFAPO5o0P/pBpfISxwSLpJ/Er8leqk/pG/A0ngnxY6OhpMSwdxOM4dgd/NDm2G
	 I9XwD+ttrLUl7hW3pEO7JSaemg3MfEk/G8582gOQzHw8ufUcMTNI7n7ZvOUb7SFNVz
	 TuLfQLedVMUMg==
Date: Sun, 31 Dec 2023 16:55:38 +9900
Subject: [PATCH 11/17] xfs/185: update for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030481.1826350.1992373630394927074.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Send the fallocate results to seqres.full, since it doesn't matter if
the call fails as long as we get the layout that we wanted.  This test
already has code to check the layout, so there's no point in failing on
random ENOSPC errors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/185 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/185 b/tests/xfs/185
index abeb052580..04770fd6c9 100755
--- a/tests/xfs/185
+++ b/tests/xfs/185
@@ -100,7 +100,7 @@ test "$ddbytes" -lt "$((rtbytes + (10 * rtextsize) ))" || \
 # easy because fallocate for the first rt file always starts allocating at
 # physical offset zero.
 alloc_rtx="$((rtbytes / rtextsize))"
-$XFS_IO_PROG -c "falloc 0 $((alloc_rtx * rtextsize))" $rtfile
+$XFS_IO_PROG -c "falloc 0 $((alloc_rtx * rtextsize))" $rtfile &>> $seqres.full
 
 expected_end="$(( (alloc_rtx * rtextsize - 1) / 512 ))"
 

