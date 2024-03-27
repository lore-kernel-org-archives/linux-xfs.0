Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641342901
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504355; cv=none; b=L60h2x4jpxEPFgr+AMv/zCvK4Jsi8tdqvlJWlfau9roW3mXQ3q/I9dmxIaJP6Ri5dSqDk0glzqMe7hMOtJn7xugTWKQZt+yEes6NPgjaP9oaK2BCDZxfCCCEU71MJClDxNSTiOxVqEcG8XCUyYcuD9bEnmR3Fr71Hs2nh+zjz78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504355; c=relaxed/simple;
	bh=9T8a/EweUpF+ytJCx3CxVe5rfLBOD0M4ev4ZOFGUuFU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebKYylajNxpi4gSD4gyAxUHkoEXIBvQjd6a0dPeZbEveeJYpUaK0JF6Ms8sg29MgWeg+hPhuH/br1nJgnZkZwY1bAJN6M/ZyplE/Wtch6FSTi111HUW3n45Sbsn3V/+LUSnU46rH3gbDFO9DmbccTHwehmHHmPX96IGCumYVRcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfGdSMOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfGdSMOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA1BC433B1;
	Wed, 27 Mar 2024 01:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504354;
	bh=9T8a/EweUpF+ytJCx3CxVe5rfLBOD0M4ev4ZOFGUuFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FfGdSMOpsZnbsBm08OOFu49Fs76gphGK4rIijjiPS7tmOmWslobhcDUkwv7KxdeUH
	 cYMugIw18itL32F8dDrXWmBjdpdGl+3qGyNlbZ0F2FKIJHE1C25r6Qqs0ToGMMZlV9
	 IZDaDxC416u3KJ0QsdMbsvyGdahM1yNF39kicU9KC1bPymCKEO5NaIjeZ4MYRNW4My
	 5QYfyVTplm6ryMSrpMrJIa6/elZHUy1x5PMduAsohSyAAxBNIhHapqVGszRv1btGp7
	 r+1nxYywlbD0e99eSPcefpQmOJNRGSGVxVSDmsdr5QPgDaihCJbs2PaUShrjkw00hx
	 bu9jMAv7lYsiw==
Date: Tue, 26 Mar 2024 18:52:34 -0700
Subject: [PATCH 6/7] xfs: refactor non-power-of-two alignment checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380232.3216450.15831256989489004254.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
References: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  |   12 +++---------
 fs/xfs/xfs_linux.h |    5 +++++
 2 files changed, 8 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 64278f8acaeee..d1d4158441bd9 100644
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
index 8f07c9f6157fb..ac355328121ac 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -198,6 +198,11 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
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

