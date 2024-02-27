Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E5538DDC
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000453; cv=none; b=L2tftEe8ymTh9wrdoSfu72GhX7WiQh/ryHk2sWNN3jy7SsMNzlpMwXRC1sPIa1MOv6IcXSdqgSJ9Xmu3uD5742vANslUnU35I1YL2zy9ARx9hwcb4/Z6/6JLy/NLGdGVNOY6TNl0AUZl1L4LZv7novYRwqwuTaYWsLK/Cq70xTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000453; c=relaxed/simple;
	bh=m1BorWELMFk0u6xfGHcvOVmN/8QF7CzwiQ6knkfp+84=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R4C79/q+k+32J5VmQJx8cZroHp5hcvJvKam5K0BXvAUt33TgFz85jfc9P5Nj8iO08GARHIes/oNBBuShyefkakZAOhNm72RxdSsz30Hr524xMlM2FGi9bKxS2OH+oKZzQKw2fAv+kVI5TNYdIbyTkvww/zhgTayqhxj8SRzfzEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opsPvcZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opsPvcZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85326C433C7;
	Tue, 27 Feb 2024 02:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000452;
	bh=m1BorWELMFk0u6xfGHcvOVmN/8QF7CzwiQ6knkfp+84=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=opsPvcZpwZl6L9EBHDRTBUkj0ZIa7S3MezgXxyBCTW6y0/9k4yfJ871/fpAsJk9d3
	 boCBSpFdWFp26d4CLbfHTEg61IyPszWouRHmwaVAMgHZudZvHhIw8tWKcEcqpd+dFV
	 pqU3PHtZIWza4lj4NpP8dkt4okn3D6LEQ1VWGedQP9EMR/SodfspN+jkvkxGwQi7WU
	 8l8khSf+YlHFqYqBn6Z1Btgmy9nUbP0K8D8/CEgfmsep8gerJ8pCS3M3/mTsFVE8yB
	 /VfctjqpK2kx7a3JKdSTMEK0HTlXHP1Dy8i5GhMyEdvH0wj3SGdK4hnVgAXpy8+yXR
	 w/gmu3RUsNDHw==
Date: Mon, 26 Feb 2024 18:20:52 -0800
Subject: [PATCH 6/6] xfs: refactor non-power-of-two alignment checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011230.938068.18189033969735593047.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
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
index 73854ad981eb5..439f10b4a77a5 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -199,6 +199,11 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
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

