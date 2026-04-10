Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B8D1A6815
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801859; cv=none; b=nBVVSSKry67hIHfyTQeBO/k5ASKkmJUv/9GME+kQSOu4FU7ZGsMQlZ9+rYL8VRl52QmjJqH6YLcPoA4DLBZUmzNz0DwPe9pSmvW9ohTmFqKo9cszBWubbHvvE99iVuxezQECvogWVeYOyYWQUNIS2XjnZDPSSbPASrg+uzlfoyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801859; c=relaxed/simple;
	bh=/qc4gQwoaCCOtkOmAMeMZ+UZHedSdokuOMVgETSlsN8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oPO3Mqz6U2NBEHqLXB5jXm8dzbOnhDfy4l38ftt1yTbDQM9gy6j1WNJjHTCRKEbCKxoZfes/PwFxaWRq0hGckp6VAusf2x1Mqly995J25pgROuwjgnYMifLd3BkCHEcodFeY5OVPMH5sfbf1GYHkn52c1Be6V0kqLR1zZiXBTqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fu3cPyW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fu3cPyW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DECC19421;
	Fri, 10 Apr 2026 06:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801858;
	bh=/qc4gQwoaCCOtkOmAMeMZ+UZHedSdokuOMVgETSlsN8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fu3cPyW8tazADyO8XnxSPflPvJ1QNP1zYSo29XBbpTbjO4GiLQJ2fgfmdEK6DSpm9
	 VB7KYtGIhvXntWTGQ6PWpxO6BmnK/eQhC9AxcNz5SFhiypLBOUzizHP0ADSk91m7cX
	 5Oq+GevrPz23fC3Ms+9dK9yxKm/ZoKsIbexpXhUZ9GszBn88n8QYDUiNhDzsma+R6X
	 u+JdWfDfHbiQTO2peL7ACJNNxGQ3u8z6/4QTVS1icyfsLEIwnVB/7zfz3Fa182OOZV
	 2jPvFfs1JXzc2WcFhcouBKIUoVW9pmb1rirKxaS/8o9Z8NrF/DPdA52d/runYzUwyg
	 FtwmpDSjv/AeA==
Date: Thu, 09 Apr 2026 23:17:38 -0700
Subject: [PATCH 01/21] libfrog: allow bitmap_free to handle a null bitmap
 pointer
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385049.2090237.8575438996086812617.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
References: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

