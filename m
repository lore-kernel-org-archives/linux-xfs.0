Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB15338758C;
	Wed,  2 Sep 2026 05:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327721; cv=none; b=pTF+l6nOb2IwZNQEUwLJTkWBgYj2bCHy8eBj0iutkdNfnazp/Kj63tuKvCIKA7I8LwuAEBgGXAJG7gXiGJmtrrUuDzVqyhHezEE4SeO1xKxxj/lfy6y90Z6C8GhXCvJt20j9xYAUxr4/ZKmgUznsZszlccX+ZAkYd8Tz4DFgATA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327721; c=relaxed/simple;
	bh=pvob5cN74H9qF+wsMgrEqIR9HUb7wFCagJARzm5diYM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LbhNSlKWFTJEGj23Xkt1ztfD87cUT66ykXgvF0+/Hg4o0/os0dUPINb6X7Pz2Qp5veeWsrP8VJsr7cu1ooz1g2ncEgvmNHFEo0/XIycYkOkYDNq1asooPrLLl5ayWmwO18hogBjrVTlO9UJNm9jEtXQD6//jggdvayNqZMsNEZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JiXae3/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JiXae3/t"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 689171F000E9;
	Wed,  2 Sep 2026 05:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327720;
	bh=W0TpSnJPgFNcNvUuSoIdaO+dTLKF9gQ0ZuB/GJJcU4Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=JiXae3/tCQJIVBePor3UNhh35CEd112RJqiUKpk+RyG9y3m8A35KcLKaittuDwOGp
	 SosyRjE44zh7hd3ua+SjSNQIcFFP+WlCSQqn5ryuhLynb4Xcn4U0Wq0XbGLpU82Q4b
	 bo8R9TUZv0E8WlP+obKCIPMBmLdlwJ/JdglP7hMev34n1UblYbxRYlrsxDnMO8SIVy
	 vKNkBGDqqV6tkkW1MjFnX6mUuPb/3UUgpH69N4s549ey5sq3KgUFdHYYoVhvYASJpF
	 BIBmfkbeBzt2jwLWULSqk9js1VY3d2DKy4ta3adr1pEasYT3If0Dn84VNT7qdGNozG
	 b0cUgc4NH2v+A==
Date: Tue, 01 Sep 2026 22:41:59 -0700
Subject: [PATCH 1/6] xfs: fix unit conversions in per_binval computation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749031.3506928.7471175126550499558.stgit@frogsfrogsfrogs>
In-Reply-To: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
References: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
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

