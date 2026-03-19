Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28E163CB
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895548; cv=none; b=IeEjCxuAlHqIbW8SNtsBEYRz/CPpr+laA4rOFU5BdNyLOUQj/GZh1njk3p2Dq79+zjYFge9C4VXdrfiojcgfU66ManIIERXkIxm746WRfD4MHFV+S9/GCKPvl2iJwKByctV1IhyjXDGSXhlCOvkcKEZ078Nn+VmiD/+rAfpGpOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895548; c=relaxed/simple;
	bh=w64GbYZ1B8YyDZD9k6YOLy0rK1UiLlZpoVGzuIbxsno=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fAQYHqTVkucBSnf09dsI6EyRBaeLXpcopIjVQyvEom2Fp9q3Um8jzBVAhB2yqQ4Di8pPKZYps6eKJvGbCaTvLtQ6Mot1TypdSLO7WgJcP3K2xw6D7ROG1QStfkVYgmSDdmW3leeTSZJjIWVPB/EV0CoP6g4/ExSmqi9GKm4OS5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJMG7WLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJMG7WLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4EEC19425;
	Thu, 19 Mar 2026 04:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895547;
	bh=w64GbYZ1B8YyDZD9k6YOLy0rK1UiLlZpoVGzuIbxsno=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CJMG7WLMm+QR6QBbqjhG0uiEmU7GHht9KugXtWJex24Des96B700ghoUnVAmoS+6M
	 C0E1IMZf1vCkzLVSX4wruKdmKij1KyAuThDR8QgsXqUVW4l7O1xut/jSiAMiV48y0K
	 gPvJo6MiLyYGoqDT0Pg5TLRE4xBCsbJUr9xCHFEC8KJEZbawjOOtfHKYqKjr92pd2M
	 rDPvTMp3Y4R6nfiTEqImoOEyt2hSj5fxwPb/XlZYXAgM9h/tBxGb9/YdHHtp45jn4n
	 FeM7MfypRUQbmQXaqX8UkXIR17as0tkLVw5sMDCYQNg51NsvLFS/ESDuUlY1+zGN3v
	 9WHnf7MLrllWg==
Date: Wed, 18 Mar 2026 21:45:47 -0700
Subject: [PATCH 01/22] libfrog: allow bitmap_free to handle a null bitmap
 pointer
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389506958.3681140.9104825233192607870.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow bitmap_free() callers to pass a pointer to a NULL pointer.
This will help subsequent refactorings in xfs_scrub have cleaner
bitmap_free callsites.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/bitmap.c |    3 +++
 repair/rmap.c    |    3 +--
 scrub/phase5.c   |    6 ++----
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index 0308886d446ff2..6a3d852c25a46c 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -109,6 +109,9 @@ bitmap_free(
 	struct bitmap_node	*ext;
 
 	bmap = *bmapp;
+	if (!bmap)
+		return;
+
 	avl_for_each_safe(bmap->bt_tree, node, n) {
 		ext = container_of(node, struct bitmap_node, btn_node);
 		free(ext);
diff --git a/repair/rmap.c b/repair/rmap.c
index e89bd32d63a953..55c2b0928c52b0 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -752,8 +752,7 @@ rmap_commit_agbtree_mappings(
 err:
 	if (agflbp)
 		libxfs_buf_relse(agflbp);
-	if (own_ag_bitmap)
-		bitmap_free(&own_ag_bitmap);
+	bitmap_free(&own_ag_bitmap);
 	return error;
 }
 
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 577dda8064c3a8..52bbbca4b9f06a 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -897,10 +897,8 @@ _("Filesystem has errors, skipping connectivity checks."));
 	scrub_report_preen_triggers(ctx);
 out_lock:
 	pthread_mutex_destroy(&ncs.lock);
-	if (ncs.new_deferred)
-		bitmap_free(&ncs.new_deferred);
-	if (ncs.cur_deferred)
-		bitmap_free(&ncs.cur_deferred);
+	bitmap_free(&ncs.new_deferred);
+	bitmap_free(&ncs.cur_deferred);
 	return ret;
 }
 

