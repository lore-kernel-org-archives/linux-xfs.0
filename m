Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCA43ACA41;
	Thu, 30 Jul 2026 05:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389179; cv=none; b=I43JnY3ZN+yXdPPtL7Zaazkv47DL/nMARWn14o9qb6aoBfRRJTXnquY3mZ9gIabB0Yw6kla6LUIMEJ+DTVKQc5QfvLOFP85XGGfJIeo0JE4+K4UxzqlazYZbXgpB+1ZXIjU/UDd4IMSAC6VQMLW62AUqVhzXFIJAteAPF4X1IkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389179; c=relaxed/simple;
	bh=b8ojyl33JmWD45AJ9X5gI60nlxWtNIaLLl/baeOCB1A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/vPyt/6SWxl4Tx2EJHW+6YW7y6UJzBCZ/7uXTyW1DHoF9+0R/jmsdFiA0/s9BSwTD2FndkcX86/TmeG+FAMbRdiJCiQ/9wLHb/nbWOCDYLHaOeJ6i5Jw7UYS/xXx8oMebBHfMxrh7rHKo1WD1rQ649FM7PwCAUXxpYp3gWZRCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCZcQ6bY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCZcQ6bY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9688B1F000E9;
	Thu, 30 Jul 2026 05:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785389178;
	bh=+ChdbIcTz9rJlxo/Q1HlhbYdAOwAUvCeosh2x+Fu8Ck=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=CCZcQ6bYFqiYKRijM9utdWJEa4vXl5nctPzkHEV1RMvbazqB5nxqnZ2ZDZrpgQpwJ
	 SuS0l5gh0rnwssKN6E0HET+/3zRwwc/D2HXPE606lNWQDqlewXj4ugCzj5173NPj2A
	 TxbjZ7TpDIyfRqzBtgyuVteOPIErKfk5Eqh+JcFZFzAeuDASZ/pXFbHtPevsVkYUVV
	 n8d/KlCq7qLQzra1rPkJKARsDqxr45nwLE4A58Dgjdre+RL13/wICcuJkqmujLXOYE
	 oDoVsC26GmbO9NiDhwbyoiey0LrAjGZN3zOaA0PWA7CgFaoSDpgt4ncRQUJ7QLUi9r
	 R66Gs3lNzoohg==
Date: Wed, 29 Jul 2026 22:26:18 -0700
Subject: [PATCH 1/6] xfs: fix unit conversions in per_binval computation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178538912901.4070956.12472652319090346828.stgit@frogsfrogsfrogs>
In-Reply-To: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we're doing the unit conversion in the per_binval
computation backwards -- xfs_buf_inval_log_space's second parameter is
supposed to be in bytes, but max_binval is in units of fsblocks.  Hence
the conversion should be FSB -> B, not the other way around.

Cc: <stable@vger.kernel.org> # v6.18
Fixes: b2311ec6778fcd ("xfs: compute per-AG extent reap limits dynamically")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/reap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index fcd14c1703ea04..496c6eab555e91 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -601,7 +601,7 @@ xreap_configure_agextent_limits(
 
 	/* Maximum overhead of invalidating one buffer. */
 	const unsigned int	per_binval =
-		xfs_buf_inval_log_space(1, XFS_B_TO_FSBT(mp, max_binval));
+		xfs_buf_inval_log_space(1, XFS_FSB_TO_B(mp, max_binval));
 
 	/*
 	 * For each transaction in a reap chain, we can delete some number of
@@ -680,7 +680,7 @@ xreap_configure_agcow_limits(
 
 	/* Overhead of invalidating one buffer */
 	const unsigned int	per_binval =
-		xfs_buf_inval_log_space(1, XFS_B_TO_FSBT(mp, max_binval));
+		xfs_buf_inval_log_space(1, XFS_FSB_TO_B(mp, max_binval));
 
 	/*
 	 * For each transaction in a reap chain, we can delete some number of

