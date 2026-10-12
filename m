Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803AD494833;
	Mon, 12 Oct 2026 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818437; cv=none; b=rnsQuuKifOJXKfG0cg3kubEZqdMKHQmhfpUCEu2mrB6F9puc+XwYJTKXCPIQGwKdZ8xL6YS59kbWWemD9ZLZTlaohDTzuPqMwFR3rMEbOaPMb58NFSgtyfXpt53EYaZYy5/Xf1GFmNUoA2/ZZfCLvQ5YjHgkNaVLVW+P1wZ0VLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818437; c=relaxed/simple;
	bh=gLpX2D/iF+IKhkqBF7BrxsfdLcm82jnspRaj+M2c2SQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uECcif8ekGQX2dkinsP478DsfzJ+94IO19x8OVycnJd3fTq3ma7V2rMNgaSlubF+cKtBdwQy6w241uZtXY0QWN7DNWLq/V0eBoWISO6OqSCaae+amca6lk2QjfgOV4r55CiSqsAvhvyb/IEIxKBsmkyWz+bcvyQ9IARJUjoH4S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mR1PlP38; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mR1PlP38"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 244A61F0089C;
	Mon, 12 Oct 2026 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818436;
	bh=oz0FZNknJNLnRVKxtqMWkztsnRqtEVJOuVrJWI5jirM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mR1PlP38wLtHhqWDe529HpF480RswyygJJwAVtOYmMlRKEZIB+V9BUf/+4g+typyR
	 TBRTkuYW7Hq96KGOm89QtM4VwGI3iJj3RK3E+b6Lh9TLvw31a8zveqLy8rNv+tTxYB
	 bRVHhHXXXVmiN1idfhQBcwdntRucCApWbvAzC2XUFMziSuY7hlIT/l+xAT5wC9Msco
	 18Yly1EiIJgWCYB4i/x0LueL9iBGkZqSQcM5c4YDcu3xtZkrCx9C+OmXiWN/4u62mN
	 vHql+6wO8Twri7MtFgUu0Rgs1HcWR5fVbDoLksWaBFiWXP3aExLkNv/GU/mCj8jfet
	 QoGB6l930c9EA==
Date: Mon, 12 Oct 2026 08:20:35 -0700
Subject: [PATCH 01/13] xfs: check for termination during rmap btree walk
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839268.1417179.17091275661660149807.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that we should check for a fatal signal *every* time we
walk a record in the rmap btree as part of rebuilding the free space
btrees.  Fix that, and improve responsiveness to ^C of xfs_scrub.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/alloc_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 6e835240536181..9a09a9ea9c3089 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -224,7 +224,10 @@ xrep_abt_walk_rmap(
 	void				*priv)
 {
 	struct xrep_abt			*ra = priv;
-	int				error;
+	int				error = 0;
+
+	if (xchk_should_terminate(ra->sc, &error))
+		return error;
 
 	/* Record all the OWN_AG blocks... */
 	if (rec->rm_owner == XFS_RMAP_OWN_AG) {

