Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D122D1292F5
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425538; cv=none; b=OVghS2VZ5L1UW3AM+Ma+qyvlyA5kzpfmrK7xjgYPY14I934qgvncoH1/AjO4fRoyaDNQLn3iBAh2X9bDqecOsT3Do/NAUjCYlLOCIUUo7wrNx+syO7GNV+5K9KFioCtn+P+lRKmPPvdyKFNZ0ws/1ZnvP4a8zuCivZ8qGoRRoug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425538; c=relaxed/simple;
	bh=9FeWrqHEzLNV/NXPmUKiTPT9vUGmi6j++eyEW1xvpy0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t0irTWWuxsKaxENoBxZpfOsEvA9mcY4WSjaXGPXKRBnmpk7Wd2e6nykc4x0vUeoxd+zzmxOOL9RKbkFevXT8Z9k9m4x/+XizNi2f1kQ3AbSdNRop1I+yTMnarIq3l92NuiOgO6SRhWOBOq49IqrnM3dZmpMMsy+Hf4OGCbrd49E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9QG1r9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9QG1r9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAE2C433C7;
	Tue, 26 Mar 2024 03:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425538;
	bh=9FeWrqHEzLNV/NXPmUKiTPT9vUGmi6j++eyEW1xvpy0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h9QG1r9uOE93fnzFUK85UQN13cdDIprK5qpdsvB+EQUX7NfXXxuJGf/DYmNB0i1GD
	 i2K4wJ5W7NxGgG2iioxTuwYrPPKamM2eGQzyVetPz0RbdcRsVAlrjkzar2tPtNTpkx
	 97GJsQvEtjMSxmohnwajfaRWg5zIA5q1i08kT8h/Kj0cmmz54yen8+FnBX5M+uWKyK
	 Cp/5d8S7XVbfo1YXVAeoaoN6fPY2Rsjf6XwnisvlRwHGnCvhXG6mcrrpzEt5GV+pKa
	 aMxPM5h/pTd/mFoaSaz9BkJ0jpMbs+mw5m1nBX/wbi4WriNpHh+PDg8zVEGU4uvC6L
	 wbCXA1X0u8QVA==
Date: Mon, 25 Mar 2024 20:58:57 -0700
Subject: [PATCH 2/2] xfs_spaceman: report health of inode link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142134008.2218093.11193146609274529471.stgit@frogsfrogsfrogs>
In-Reply-To: <171142133977.2218093.3413240563781218051.stgit@frogsfrogsfrogs>
References: <171142133977.2218093.3413240563781218051.stgit@frogsfrogsfrogs>
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

Report on the health of the inode link counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 spaceman/health.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index 3318f9d1a7f4..88b12c0b0ea3 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -76,6 +76,10 @@ static const struct flag_map fs_flags[] = {
 		.mask = XFS_FSOP_GEOM_SICK_QUOTACHECK,
 		.descr = "quota counts",
 	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_NLINKS,
+		.descr = "inode link counts",
+	},
 	{0},
 };
 

