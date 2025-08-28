Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D0921CA02
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391398; cv=none; b=uxdlMVhzsRIq1NJupfYhxuD8Jlidil1Gi6qMywEdA+tSkGHhE+aOZUz0tW41YYtO7SHjk7/nQ/FuUMGelX8s4VptnyghNKAFYc7uQHj4+OnWekI7kJK+Vmt/ByGXJQnLzzunfyI5mLc4hkgDSbQTa4gYDX663UQHxO0ztb3JEW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391398; c=relaxed/simple;
	bh=2tgmIuECmgS22ATYp61gHOf5NssmkWxFoZnVpMO8G10=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+C1mkoJYzl0dgBmPwTRrCvADaQuhL8sdEfUE1qNCXvE2RbJtapOZH8n/nVbXibSAjMycX3+EAbTlEPmhJ1x5cqhf2ZBTpwUmQ9xt0AmyOggjAIUREWAw1KcgSiZGcQnfjQT7kbdax+0ajz2MoM5GW3kQ9kwQLx23AetHguPIAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jm4tI+57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jm4tI+57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D49DC4CEEB;
	Thu, 28 Aug 2025 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391398;
	bh=2tgmIuECmgS22ATYp61gHOf5NssmkWxFoZnVpMO8G10=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Jm4tI+571ha7w160RZL1v3xiyPtOmUMFLgsOXryYInmKx9mDPawKWr3S0zQza01si
	 xONTOpd5v0+dEumf37cO/TsGVqutnVcz1LspOv1NdyjAn/nyfkCNZQ56o9zA9iSn9n
	 4K7/xaUxxJG388xkz82714QanWhyR6W8AqRXih8w76eVJvbqzKdIb+RR6MXshz3li4
	 xHOpJQcI3K9eGm1/pWl3A76SUBHaqgHe8LXvXLyEUxvANhYelJVVjJVUNS/pcIZ/+z
	 exMri6bgvWVyW1n3fMkiZ1Hq88XhzEVqzUztQrYwMcHILeWWOZ9Fo2N30QDCcqHfmW
	 I/VMKv9k54qQw==
Date: Thu, 28 Aug 2025 07:29:57 -0700
Subject: [PATCH 8/9] xfs: remove static reap limits
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175639126605.761138.1788578695179861070.stgit@frogsfrogsfrogs>
In-Reply-To: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Get rid of two of the static limits, and move the third to the one file
that uses it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/repair.h |    8 --------
 fs/xfs/scrub/newbt.c  |    7 +++++++
 fs/xfs/scrub/reap.c   |    4 ----
 3 files changed, 7 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 9c04295742c85f..2bb125c4f9bf2b 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -18,14 +18,6 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 
-/*
- * This is the maximum number of deferred extent freeing item extents (EFIs)
- * that we'll attach to a transaction without rolling the transaction to avoid
- * overrunning a tr_itruncate reservation.
- */
-#define XREP_MAX_ITRUNCATE_EFIS	(128)
-
-
 /* Repair helpers */
 
 int xrep_attempt(struct xfs_scrub *sc, struct xchk_stats_run *run);
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 1588ce971cb8e1..f00ec278fdc53e 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -27,6 +27,13 @@
 #include "scrub/repair.h"
 #include "scrub/newbt.h"
 
+/*
+ * This is the maximum number of deferred extent freeing item extents (EFIs)
+ * that we'll attach to a transaction without rolling the transaction to avoid
+ * overrunning a tr_itruncate reservation.
+ */
+#define XREP_MAX_ITRUNCATE_EFIS	(128)
+
 /*
  * Estimate proper slack values for a btree that's being reloaded.
  *
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index d58fd57aaebb43..82910188111dd7 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -171,8 +171,6 @@ static inline bool xreap_is_dirty(const struct xreap_state *rs)
 	return rs->nr_binval > 0 || rs->nr_deferred > 0;
 }
 
-#define XREAP_MAX_BINVAL	(2048)
-
 /*
  * Decide if we need to roll the transaction to clear out the the log
  * reservation that we allocated to buffer invalidations.
@@ -198,8 +196,6 @@ static inline bool xreap_inc_binval(struct xreap_state *rs)
 	return rs->nr_binval < rs->max_binval;
 }
 
-#define XREAP_MAX_DEFER_CHAIN		(2048)
-
 /*
  * Decide if we want to finish the deferred ops that are attached to the scrub
  * transaction.  We don't want to queue huge chains of deferred ops because

