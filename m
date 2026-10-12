Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5486345CCE
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 05:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784592; cv=none; b=VtCArOaUO6q9mz2h9IZFjcPk2MmZKSuUGl993TS+f1awelG5nalkV7iHvf9My9EU7cemjCpIXal4FM05JNnpVP3T+K09gHV2tewmoQE33r10mXxNCVDvIQKkqlxCTEWxekdi7zTbp5DuRRum/5zlyyCzSmSJcUHRnE08rHY9x00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784592; c=relaxed/simple;
	bh=3TqeDCL3qzkCK3a+GVmcMXSx9zTx3W/Oi8+fDRjw/6I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qpjDGmx9J2nudOMSLO+JRPUDpcbPEvS9maQ+i+r+YQCvbG4JDrKk0iWtEwemQOokJAAb8N9t3ViP8wUPqJ/HgKc6EjYrIK5PuCx07+N5LXwzeDy6+vVO+ZZgFBaGksS458I4eNCR55o0NdHzkO3R7pOy+Q2j1E7BgqhI69Pw9P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T63AyFcx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T63AyFcx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 83AC41F0089B;
	Mon, 12 Oct 2026 05:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784591;
	bh=xxxF51BizTWq9F8577k72AneopEq/UdEEeJ4rHU5jcU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=T63AyFcxuRLZmZ7xLhUSlhVh8zWpjXdpoQwc65rRoqlNWikKmCpiClbtro2UfNdtI
	 pii8hX1Fs4CZrGuZHdsG4b1GlMAsCcmqdPCDGeYQ1kiCk0WGrPG2tKjTq1Q2X7nWZG
	 ZUY4qkMGvd0x8NirdHbGP0miy8xkRy8aCcuki6DpkQgmPKWhhMEBJK2DpSbEs4Y0CB
	 3CRECqQiGryGGvPtI9MKJ1UbmIaVLmedZOu9FxCDaASj3QLO4wcFVzoIGzcq6zbO/k
	 z3Kekrww/9Wmi6FnjuVMjTxIiUS2kf+i60aOghQjQtSzuqchcegNrugLR+qT1JZl8M
	 vpgiaQN5lwoCQ==
Date: Sun, 11 Oct 2026 22:56:31 -0700
Subject: [PATCH 03/12] xfs: avoid oversized space allocations when
 regenerating metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179178065259.1058326.14882859370057319539.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that the btree block preallocation code can be asked to
allocate more than XFS_MAX_BMBT_EXTLEN blocks.  If the allocation
succeeds, the reservation will be stored in a single autoreap record.
Unfortunately, the autoreap code uses deferred frees to get rid of
unused space and that code complains if it's given too much space to get
rid of all once.  Fix this theoretical problem by constraining the
allocation size since it's unlikely that we're going to need that much
space for a btree.  We don't fix the core code because the runtime users
of deferred frees are freeing file space or single btree blocks and we
want to catch problems there.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/newbt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index a7554f925b7440..1f28ca1647f8d3 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -280,7 +280,7 @@ xrep_newbt_alloc_ag_blocks(
 			.mp		= mp,
 			.oinfo		= xnr->oinfo,
 			.minlen		= 1,
-			.maxlen		= nr_blocks,
+			.maxlen		= min(XFS_MAX_BMBT_EXTLEN, nr_blocks),
 			.prod		= 1,
 			.resv		= xnr->resv,
 		};
@@ -354,7 +354,7 @@ xrep_newbt_alloc_file_blocks(
 			.mp		= mp,
 			.oinfo		= xnr->oinfo,
 			.minlen		= 1,
-			.maxlen		= nr_blocks,
+			.maxlen		= min(XFS_MAX_BMBT_EXTLEN, nr_blocks),
 			.prod		= 1,
 			.resv		= xnr->resv,
 		};

