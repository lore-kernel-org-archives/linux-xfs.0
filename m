Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE1815099A
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803951; cv=none; b=lfkGnIJgptbBG3BfHLa/2M/cBI9WH0KYR6lGC/3ebOOy0uc/8CeiA+zWT7Ly3CkLzzrLapqDiRKeZKXmJZ03+dlfqffJZ2/lwK5QGax99TWkV82I48rHG5L+KL+PeQMCFMSTqCFmI1OOP0sxgrWrOxD8GkwkJqZvnqraevI7xy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803951; c=relaxed/simple;
	bh=OCDnrkGQoDio//OEuJtqdOtJTzNzHVIQUv884XFzDPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAsWsnu9W6frLQlqOTYDqhASOJza8dJCMGKO0eRZBWbTG13HJTco9cb+CURgcggVJR2XG1AUqPTZ1pQl7fpP8x7Ge+FyV/IFLcmxKxkVEXrtwjPb0o2tKxASBfWPW6+p2plnAoT0plXT+lONJUVV/GXebj1prt2/Wh1RqXS9g3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AVaTieIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVaTieIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB14C32781;
	Mon, 22 Apr 2024 16:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803951;
	bh=OCDnrkGQoDio//OEuJtqdOtJTzNzHVIQUv884XFzDPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVaTieIRXCJ0485UEXdXpBiO/W5FRuK4PI56FbAhIWskvjUl858xKbhauVMtZsIDt
	 bfQePR6ryLV2K05zlDWwpw5xLkRxooRaf4VstZx9KMDaGm3jlJL6uVR34mGbeEGMwP
	 Bs5inBNhhEOIvR5am/A7a/73LGdayhquWu9JBrWNDkfDQHEmny3kl32M6miWgMFAkR
	 Uwi5JUwW1sH2OW6chrXeULkVoVqAv8eyTIodHnuQE6OD4QxVcphXIVxLsw7yx3vlGj
	 Y8YpzIU/6aay8j1AdgCrPQiNCIN50FAyqnS96MgVyNX6sMBDbXhb7SaQyqNaRMhHdX
	 Z66sJC3TvFT3w==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 02/67] xfs: recreate work items when recovering intent items
Date: Mon, 22 Apr 2024 18:25:24 +0200
Message-ID: <20240422163832.858420-4-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: e70fb328d5277297ea2d9169a3a046de6412d777

Recreate work items for each xfs_defer_pending object when we are
recovering intent items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 3 +--
 libxfs/xfs_defer.h | 9 +++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index bd6f14a2c..4900a7d62 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -671,9 +671,8 @@ xfs_defer_add(
 		list_add_tail(&dfp->dfp_list, &tp->t_dfops);
 	}
 
-	list_add_tail(li, &dfp->dfp_work);
+	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
-	dfp->dfp_count++;
 }
 
 /*
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 5dce938ba..bef5823f6 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -130,6 +130,15 @@ void xfs_defer_start_recovery(struct xfs_log_item *lip,
 void xfs_defer_cancel_recovery(struct xfs_mount *mp,
 		struct xfs_defer_pending *dfp);
 
+static inline void
+xfs_defer_add_item(
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*work)
+{
+	list_add_tail(work, &dfp->dfp_work);
+	dfp->dfp_count++;
+}
+
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 
-- 
2.44.0

