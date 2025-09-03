Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97051EFF9A
	for <linux-xfs@vger.kernel.org>; Wed,  3 Sep 2025 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756911640; cv=none; b=ua4Mc94UmJwkuEWZsUx6zm2j9CULRUhT36ZbU1xobngOGt0DXWEjgbN8LaQtuFT7DWFsuRqgpt3rCVgvTjm/PU9C1HS1APgJyNzbv/TH1wzscLxfj4J//8H0V+jYa0iZJ54iFUb6O8Kgw9Vn09JwqwfwqjoxbBAGuiVqOfX/WmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756911640; c=relaxed/simple;
	bh=Syns4pcuF3Ulxpzwc5Z+9obEeQgiMw3kydEuCaYdv28=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ikthg/z9Wk/oj6QL0xWyMSKgofvtd5e7reDDf16cZQ9uX/+gQOtMuxDiP2Iq8Ap2ddKzFqVHxi3c+iHrf+7iX/B0SI9aGC4OKjwjiVJ5WI75ULH6YBammBm5Yd977RPtP2NtQ7jdx+I6r08oOHZKpchHnIQscWt0lxXJ6qog9CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tnjp+iBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tnjp+iBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E723C4CEE7;
	Wed,  3 Sep 2025 15:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756911640;
	bh=Syns4pcuF3Ulxpzwc5Z+9obEeQgiMw3kydEuCaYdv28=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Tnjp+iBub0zNeOrlTqPGXQxDyBRNh8+Qgs0UnjkpmYY+4v+u9vzfCc54cISD9A/X7
	 +eZrTOWcEAgrLQQvUT+wIwHXkr+kQAKsUx51IaTKqMp+ISRhvw0vOI+Q6OLZvPkyQa
	 edBECGkjo8PEFB1MWDZ5jLQmtV5vyUqpUQ/xjvSCLCqnMtNj1E5FOwl0t+pPymCVfl
	 58KwyZ2oQcwT/9Qh1GCUZ/f91j/h8zjEKQGVOZruqZGXzqVZ0BHEwnxAaLAeX4oXOq
	 ocwBjQxzH2e/osnBznf6z3YUJKaTPPEHvtfNJuVQE/YWCTYyoDJzvzyf95y4neM7G5
	 b5R08Dt4vfCOw==
Date: Wed, 03 Sep 2025 08:00:39 -0700
Subject: [PATCH 4/4] xfs: enable online fsck by default in Kconfig
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <175691147712.1206750.10415065465026735526.stgit@frogsfrogsfrogs>
In-Reply-To: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
References: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Online fsck has been a part of upstream for over a year now without any
serious problems.  Turn it on by default in time for the 2025 LTS
kernel.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/Kconfig |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index ecebd3ebab1342..dc55bbf295208d 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -137,7 +137,7 @@ config XFS_BTREE_IN_MEM
 
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
-	default n
+	default y
 	depends on XFS_FS
 	depends on TMPFS && SHMEM
 	select XFS_LIVE_HOOKS
@@ -150,8 +150,6 @@ config XFS_ONLINE_SCRUB
 	  advantage here is to look for problems proactively so that
 	  they can be dealt with in a controlled manner.
 
-	  This feature is considered EXPERIMENTAL.  Use with caution!
-
 	  See the xfs_scrub man page in section 8 for additional information.
 
 	  If unsure, say N.
@@ -175,7 +173,7 @@ config XFS_ONLINE_SCRUB_STATS
 
 config XFS_ONLINE_REPAIR
 	bool "XFS online metadata repair support"
-	default n
+	default y
 	depends on XFS_FS && XFS_ONLINE_SCRUB
 	select XFS_BTREE_IN_MEM
 	help
@@ -186,8 +184,6 @@ config XFS_ONLINE_REPAIR
 	  formatted with secondary metadata, such as reverse mappings and inode
 	  parent pointers.
 
-	  This feature is considered EXPERIMENTAL.  Use with caution!
-
 	  See the xfs_scrub man page in section 8 for additional information.
 
 	  If unsure, say N.

