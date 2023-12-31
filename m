Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA25BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzTJdRzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D0FC433C8;
	Sun, 31 Dec 2023 20:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054364;
	bh=O18SgLPbV1y7aEfy59cG22QzMeXr+itz4ydgnrqfxFY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EzTJdRzMGnnp9tvisCRnR/dhrrV/rczViwIsyc1v6lzr77AV2RJaIjCbPQF77ew2R
	 KqlnyUAau/Fh6IDK59ZDCoptx08oel7bahxRyKq42pfufZJ8JPazoGHi2UfNGyq+K4
	 NQXj/wQsEPFTebLiLhXbgESa2/asZIsh6ccNNXyRqR0mOWPDGk59JhGSwxSoqmetyZ
	 RwWsqTvA+6EOx2na2zx0b1Eh2ICwxvI+1fpvA/owcirh0gtp22YZYe5DZdeo0Gu+mO
	 wiBxaOa1AtVm8I4Na+vFPIABJmwDG4pBsf0GfTr7X5VE+uhbUoJevZGez67dt6HViJ
	 6SKSyRUBzNEig==
Date: Sun, 31 Dec 2023 12:26:03 -0800
Subject: [PATCH 07/25] xfs: refactor non-power-of-two alignment checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833250.1750288.5664786581403068269.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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

Create a helper function that can compute if a 64-bit number is an
integer multiple of a 32-bit number, where the 32-bit number is not
required to be an even power of two.  This is needed for some new code
for the realtime device, where we can set 37k allocation units and then
have to remap them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |   12 +++---------
 fs/xfs/xfs_linux.h |    5 +++++
 2 files changed, 8 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8ac3bc98e4369..fdbeb6c3fbc44 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -47,15 +47,9 @@ xfs_is_falloc_aligned(
 {
 	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(ip);
 
-	if (!is_power_of_2(alloc_unit)) {
-		u32	mod;
-
-		div_u64_rem(pos, alloc_unit, &mod);
-		if (mod)
-			return false;
-		div_u64_rem(len, alloc_unit, &mod);
-		return mod == 0;
-	}
+	if (!is_power_of_2(alloc_unit))
+		return isaligned_64(pos, alloc_unit) &&
+		       isaligned_64(len, alloc_unit);
 
 	return !((pos | len) & (alloc_unit - 1));
 }
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index c24e0d52bc04e..13511ff810d18 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -200,6 +200,11 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 	return x;
 }
 
+static inline bool isaligned_64(uint64_t x, uint32_t y)
+{
+	return do_div(x, y) == 0;
+}
+
 /* If @b is a power of 2, return log2(b).  Else return -1. */
 static inline int8_t log2_if_power2(unsigned long b)
 {

