Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84343B774B;
	Thu, 13 Aug 2026 05:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598662; cv=none; b=Imr/3rXSPkmAMZeSx6h6khnploid1ujdt9z7YwI0OecVhl7wp0TisoVi7KJdnWHl7DgkLfaCe9We1yuyXBoyf06i7l7aHZPAzY7JjcYCG4OWBnVXfZsODbl1zZzVwpSyH4W0zdSX1gDX5l9WnjMmfaPFKisYBxawrAmyapAisFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598662; c=relaxed/simple;
	bh=pvob5cN74H9qF+wsMgrEqIR9HUb7wFCagJARzm5diYM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SnuON4EM3RrotBv8Q0E9TVyzSOtBAq46U2wv5SgD1kt2DaLSlLagrbLl8wo77Fy0UvRwFMuKO8CcX0Rvbe1f+2hcxXLHaqBZFl987rTHTRIqJHRTFbtzoeROVLPgZPVkHKm6UFdhEAV82V2sccSI/KYKt/k+QDuTNQ5EE0md2IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBw/5lwW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBw/5lwW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C033C1F00A3D;
	Thu, 13 Aug 2026 05:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598647;
	bh=W0TpSnJPgFNcNvUuSoIdaO+dTLKF9gQ0ZuB/GJJcU4Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=JBw/5lwW1xUtmgkky66/d/pKNVsXYitsRT9n2Xo1/iWCphKwIYEWG+1csI+7cVHcX
	 CiaS9kYpGEM95mb1ZfV+r3giU3/aI/5pPmtPT9cQ1S27r2kt1CVr7Io8y9N12xDk5R
	 120MVhujEtCBPIl1JsnGKY3Q9LHF5t9XV/h11NBV0gk12DYqXZ60XwBJTWx9q6qlI5
	 etmhJ8EpVD4bBlfLOBNcLpPv7KFFCMWpdpLVu+s01ind6mNgnQ302SUlIlWlewrKh3
	 j8mORPm6kYKw59k6X5hWQQb0AK9L3MkzUXYY5WI3ZVGE5IOoURFo65NhhTlmNlG9ZS
	 8jrUw4Z/V/wlw==
Date: Wed, 12 Aug 2026 22:24:07 -0700
Subject: [PATCH 1/6] xfs: fix unit conversions in per_binval computation
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861484.833642.4783547308799219818.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
References: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

