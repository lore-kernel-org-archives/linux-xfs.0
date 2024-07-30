Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DA3BA38
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299387; cv=none; b=EPTAVQIke25z4aYMc3lsVCYduV38pgYEMZCFk/RTNuAcj8YBqRGHg/lI/hughyzbFKWfDOl+82TS2VswjIvopVwwgCrQfyA4YaFekvT+zpmEyJLN+ss7Hv6DwysreLVd/ioV6rKhuk/NN3EaBQzimn+HchfiPVt6MUrxW7lt/TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299387; c=relaxed/simple;
	bh=kd3/Bj2B7H/L0vqTGtmxmOv1voNMgS5GKGDWNUUd6Z8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pllS5D8xr+76EBE7BEEFju+3hWBumBdEEfaWSFYFAdxxz3rWOhbdfZO1j78GX2y9jGQh9DnlTc9Ulz8sve+ggzhSl5l2RZE1hJ7pRHgwap7E8qoLjCisxD/J8jnfZGUS+EifHk8QkBredvpHMYAws3V/GqhqAKyD3uzBACIEUGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ki3vDSmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ki3vDSmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFB6C32786;
	Tue, 30 Jul 2024 00:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299386;
	bh=kd3/Bj2B7H/L0vqTGtmxmOv1voNMgS5GKGDWNUUd6Z8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ki3vDSmWDiPhAnkdade6zlnDGD4Qi6hfukZgKLle2jf5Aw0Ajw8z7xEl1wWv6k9+P
	 waHXYChCnGUSKrMJKaBRoSAdOiY15ZVaHoqAyYfN3HbD81q0If8VtRVO9rcWc7fx0q
	 ZMAYSbEN8Z+WFaCiuv56zbncY4giD2elAlYJhZtXn7IOVxo7iYyH00LbwcCxpB5HBl
	 ZJ5Rwv5zv+Rs/O1Qx7XflQ4aXM3PSFoaXWtFHIKJvvLPfwRU19/+v1OFghUB1Nq5p9
	 ZQPDCUD6AZVXHt3AiR6gq1/+5smbaQ/N2KMGrNtQqr02M+iNydWz13zWaND3mWlhYU
	 OMfl3yP+ooFGw==
Date: Mon, 29 Jul 2024 17:29:46 -0700
Subject: [PATCH 023/115] xfs: use atomic extent swapping to fix user file fork
 data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842767.1338752.13236502200324811627.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 629fdaf5f5b1b7f7107ed4de04e0991a99501ced

Build on the code that was recently added to the temporary repair file
code so that we can atomically switch the contents of any file fork,
even if the fork is in local format.  The upcoming functions to repair
xattrs, directories, and symlinks will need that capability.

Repair can lock out access to these user files by holding IOLOCK_EXCL on
these user files.  Therefore, it is safe to drop the ILOCK of both the
file being repaired and the tempfile being used for staging, and cancel
the scrub transaction.  We do this so that we can reuse the resource
estimation and transaction allocation functions used by a regular file
exchange operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_exchmaps.c |    2 +-
 libxfs/xfs_exchmaps.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 71408d713..a8a51ce53 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -672,7 +672,7 @@ xfs_exchmaps_rmapbt_blocks(
 }
 
 /* Estimate the bmbt and rmapbt overhead required to exchange mappings. */
-static int
+int
 xfs_exchmaps_estimate_overhead(
 	struct xfs_exchmaps_req		*req)
 {
diff --git a/libxfs/xfs_exchmaps.h b/libxfs/xfs_exchmaps.h
index d8718fca6..fa822dff2 100644
--- a/libxfs/xfs_exchmaps.h
+++ b/libxfs/xfs_exchmaps.h
@@ -97,6 +97,7 @@ xfs_exchmaps_reqfork(const struct xfs_exchmaps_req *req)
 	return XFS_DATA_FORK;
 }
 
+int xfs_exchmaps_estimate_overhead(struct xfs_exchmaps_req *req);
 int xfs_exchmaps_estimate(struct xfs_exchmaps_req *req);
 
 extern struct kmem_cache	*xfs_exchmaps_intent_cache;

