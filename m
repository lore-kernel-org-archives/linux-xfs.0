Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE38244692
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376332; cv=none; b=aSuI1JcNf4ZbmICWDQxZX9fFsnYepvK5Va3m9aAT9MJgWsps1wyQkCc0DblDIqiPwAZL9rvlbZcjujug8C2MIgOLZ6GBEELaUCEC0DssFtmp94JbHa4R2h073PACuFWR+MNq1sGXjy+FTRiXQokF3SGYykBcoKyJQmhnLtHi4U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376332; c=relaxed/simple;
	bh=Lfh6EOPmulLIrYmNvf7JLXsC6OZEO/Iiv7GC/kdGlqI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gmNlwLCl+S47N6FdmVDQ00o3tM8TWCL/rBb5MC3hpOwTLln1Zn4pJ9qYRj2Lc+m2igpoui970BHv8e+zRoYdh3Vp+pVwEsnZ2rwRr4wDZy0WrSn/w0uGTetp7swuS72vN5GZYRXv0Ki2WEk3OI2p/WekiEs/aRGHB1qiCnHS3XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBkcCrmE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBkcCrmE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 219D21F00893;
	Tue,  2 Jun 2026 04:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376331;
	bh=FKI+hE0LI1uh7l1Is+L9X34lTMSXSEcQYkn9IyaGNdk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=FBkcCrmEdfx4KvzmioOK68UMWmgkL7FQnc2ZqWH/kDU0bepuqoVg7zC6Zp96o7QSf
	 x37TQdhUeD2b1XS30iXkKnsaDZqMHC/5imSAri164JYTaqcJjtC9Avh8GmzFteETp1
	 vWU/7daLLC8AcW2BKsmHK196y//urzwGsftHlc9MsCYARr8uTSoXFIUhWKXV3GOjWE
	 H0NLGs6DwRHgX0EThyze/5okM9L21Dd4nm8y4Oq0YxBZ0LiFr2DPwNV4pLSp6bWjou
	 Ygt5uuj4mdkkbUv578+EzG5i0BI1QtqV2PQFNk6ziQAa1n38lgpg7IPUZQL3ceq9MG
	 rq9VYTMewM0YQ==
Date: Mon, 01 Jun 2026 21:58:50 -0700
Subject: [PATCH 3/7] xfs_healer: initialize variable here
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178037627098.588879.13826546294889049395.stgit@frogsfrogsfrogs>
In-Reply-To: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Initialize the event prefix to zeroes so that we don't read bogus stack
data if the filesystem doesn't support parent pointers.  Found by Codex.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: 17d840245c0e20 ("xfs_healer: use getparents to look up file names")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/fsrepair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/healer/fsrepair.c b/healer/fsrepair.c
index 3f9bd39de9cec6..7ad513b2d69b93 100644
--- a/healer/fsrepair.c
+++ b/healer/fsrepair.c
@@ -203,7 +203,7 @@ try_repair_inode(
 		{0,		0},
 	};
 #undef X
-	struct hme_prefix	new_pfx;
+	struct hme_prefix	new_pfx = { };
 	const struct hme_prefix	*pfx = orig_pfx;
 	const struct u32_scrub	*f;
 

