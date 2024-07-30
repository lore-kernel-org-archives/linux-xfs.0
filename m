Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5371653
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299136; cv=none; b=OAgw5EYwFwCFXVha8lr9/zsYmx9sgvHrk+WbQD5e5l8nD8Uy1cRAGQmnEfOISS4xVXK+EGKKDGAlNXsH3dExQrbEJWMr+1DcHkr9Zhd6OVYB9dtM0prOY/OeBaaMMdrDRKphMAcEDTeHZ8VW9FBQITExYBopNCk1VDGbGyon32U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299136; c=relaxed/simple;
	bh=8AbjniY70OoOLp4Xo7HplRxrJpZrdWI/8ZLyyw+epig=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mwkj1UbNwR0vOU9mM3O5ifZN/9TK125zXFU9qe9PD29b4hbuAsV943EHYXbxI8kQwIiXZD/7cQRge+NYaZmH1SKPzHIeRzJxgdcQ63P1LNyXXftY63TNuHvE0aCeIkzhKAR+YJDPhD2Lt26FGpSTi3NGNu12ekUAH6/PK8WtIE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAZL2UM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAZL2UM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7609AC32786;
	Tue, 30 Jul 2024 00:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299136;
	bh=8AbjniY70OoOLp4Xo7HplRxrJpZrdWI/8ZLyyw+epig=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mAZL2UM2BlR0Cr4E+OCavjFMsMl8mPE1n3OaQd/ChpanzoqciV5noJiQ64enCMgmH
	 BZ8EMlKTLtlTPkXcT9ZhIioAH73/7p0f5bjpNS2z/qytIcOHb3ZBa2T3XGGg4slVVy
	 kote9vmbBBfdkbZ6d2McjLp5eD0AEH2JwVDOB12gNLI3EGNbIJ0L+cNlj+y0U8bNFQ
	 liaKKxoKvk7qI3algb6+NGYt5ZfctwWFsgnadvFUelhQu+w5xO9NKdgMzAXSTp0r+p
	 w1RlYwe2O8TkwPbdBSJHquHzAHZsrtRga8NFb0w9PxQEdVgxdNk0gONkyp92SmcHtY
	 RXEqsG4a2QifA==
Date: Mon, 29 Jul 2024 17:25:36 -0700
Subject: [PATCH 007/115] xfs: add error injection to test file mapping
 exchange recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842540.1338752.4469830307040779156.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5fd022ec7d420dfca1eaaf997923a5d4dd0dcf62

Add an errortag so that we can test recovery of exchmaps log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/inject.c           |    1 +
 libxfs/xfs_errortag.h |    4 +++-
 libxfs/xfs_exchmaps.c |    3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/io/inject.c b/io/inject.c
index 6ef1fc8d2..4aeb6da32 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -63,6 +63,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_ATTR_LEAF_TO_NODE,		"attr_leaf_to_node" },
 		{ XFS_ERRTAG_WB_DELAY_MS,		"wb_delay_ms" },
 		{ XFS_ERRTAG_WRITE_DELAY_MS,		"write_delay_ms" },
+		{ XFS_ERRTAG_EXCHMAPS_FINISH_ONE,	"exchmaps_finish_one" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 01a9e86b3..7002d7676 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -63,7 +63,8 @@
 #define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
 #define XFS_ERRTAG_WB_DELAY_MS				42
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
-#define XFS_ERRTAG_MAX					44
+#define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
+#define XFS_ERRTAG_MAX					45
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -111,5 +112,6 @@
 #define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
 #define XFS_RANDOM_WB_DELAY_MS				3000
 #define XFS_RANDOM_WRITE_DELAY_MS			3000
+#define XFS_RANDOM_EXCHMAPS_FINISH_ONE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index b2c35032d..ef30d0b27 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -434,6 +434,9 @@ xfs_exchmaps_finish_one(
 			return error;
 	}
 
+	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_EXCHMAPS_FINISH_ONE))
+		return -EIO;
+
 	/* If we still have work to do, ask for a new transaction. */
 	if (xmi_has_more_exchange_work(xmi) || xmi_has_postop_work(xmi)) {
 		trace_xfs_exchmaps_defer(tp->t_mountp, xmi);

