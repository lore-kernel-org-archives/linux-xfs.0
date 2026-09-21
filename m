Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F5D234994
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971504; cv=none; b=ubPR1Se19XIoSA1kOy1q2An7QdKUN7Akx7ZrnuYgpCb5bbxF2vfXgl6CBzioGKCvzpzWDyJ9LECFz9eOjz6iy0VRT01xPHzC1Ee28eFPxRS9vpKUYhG53167OBpsmMx9Q1vJB0elBLW40b8DOB8I2NaXke/e5oieHxOxqw5U658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971504; c=relaxed/simple;
	bh=S0ha00++lUrMNIZdq4HZ0ODOkr2Zk2Ohw8Fvq3+jhzI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2HlBSN8RPP+u7XgBMqbpOky2ACss3RmszyOMNfk/dMKPzrcNWzMPRZn8UbVad1dmvWcjCtJJj/Fhy2xr7B08e8lFtiNumvVx/M3JKiTh5mjVVLwf4/+SFz8/B9EV9xFz8P6bD5Lc/HqF9AGKj7ftOnY6SC+fTEifjbc2lQ56zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=il/pgAL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="il/pgAL8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2A14D1F000FF;
	Mon, 21 Sep 2026 06:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971503;
	bh=5rfUmKBwLmP2HmjKWhWmXVhJmWfydX/ZQX+1iDkSdOw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=il/pgAL810um90Gl9QkiD/hNV58hnNjxQBGUoCNvCLREmK0IrRaa2KP9RriqOYKGm
	 lq0EjGDxowSR9s63SE8HQkGEoJ6c4Dc7ft2QwdXMIl/XkcqZr5sARRxaksNsN7X5i5
	 UmjrlWC52p4RtXXjOZxMxQJJXXcl3Rt5FDJdGEiMrukHA7P7NGxS7TRjWew6cte7tt
	 zCq/6Z8kPDR8hTU6YdD8UGwsjZ5TfasGqdGWAfN+2NmObDa9bulnJZDb3hKF4dN4xh
	 sm7YykoJT1hHqbTZDNGfQoPAudvmdYHjQ6SdwrWm0cr6uPilie2D4AVN5hcsVGXBbi
	 MCYqv8CZoyQDA==
Date: Sun, 20 Sep 2026 23:18:22 -0700
Subject: [PATCH 13/14] xfs: simply the free space btree repair code
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178996120828.181988.215380146814084651.stgit@frogsfrogsfrogs>
In-Reply-To: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that the xfarray always knows how many valid records there are
stored inside of it, get rid of the shadow variable.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/alloc_repair.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index b37b80af52a03b..bdd58738777072 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -108,9 +108,6 @@ struct xrep_abt {
 
 	struct xfs_scrub	*sc;
 
-	/* Number of non-null records in @free_records. */
-	uint64_t		nr_real_records;
-
 	/* get_records()'s position in the free space record array. */
 	xfarray_idx_t		array_cur;
 
@@ -403,7 +400,6 @@ xrep_abt_find_freespace(
 	if (error)
 		goto err_agfl;
 
-	ra->nr_real_records = xfarray_length(ra->free_records);
 err_agfl:
 	xfs_trans_brelse(sc->tp, agfl_bp);
 err:
@@ -446,15 +442,17 @@ xrep_abt_reserve_space(
 		uint64_t		required;
 		unsigned int		desired;
 		unsigned int		len;
+		const uint64_t		nr_records =
+			xfarray_length(ra->free_records);
 
 		/* Compute how many blocks we'll need. */
 		error = xfs_btree_bload_compute_geometry(cnt_cur,
-				&ra->new_cntbt.bload, ra->nr_real_records);
+				&ra->new_cntbt.bload, nr_records);
 		if (error)
 			break;
 
 		error = xfs_btree_bload_compute_geometry(bno_cur,
-				&ra->new_bnobt.bload, ra->nr_real_records);
+				&ra->new_bnobt.bload, nr_records);
 		if (error)
 			break;
 
@@ -470,7 +468,7 @@ xrep_abt_reserve_space(
 		desired = required - allocated;
 
 		/* We need space but there's none left; bye! */
-		if (ra->nr_real_records == 0) {
+		if (nr_records == 0) {
 			error = -ENOSPC;
 			break;
 		}
@@ -520,7 +518,6 @@ xrep_abt_reserve_space(
 		error = xfarray_trim(ra->free_records, 1);
 		if (error)
 			break;
-		ra->nr_real_records--;
 		record_nr--;
 	} while (1);
 

