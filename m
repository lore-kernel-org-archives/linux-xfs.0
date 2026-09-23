Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B803955CF
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 06:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143231; cv=none; b=sE8wGo47Xw1vqGhWJUI5aa9TrNqb9UK5cAK3VjMFwzYTQqvZ6KUeXrPhz6+uQ3c8JeIZV6zeTFDMJAO8k/vlVtj+HcsNDZqP6VtH9uB5bCdv7cwet7L9qfyVft8bZAHlE0pD3MLEHxKwwEG3YRnszqbKUCvVJTwgc7dxOtqOo4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143231; c=relaxed/simple;
	bh=a0t320cHmRFPxG7d3JKfokzPWdA3tnHfuuRta4X5bSQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ifvqjb6kehXCc6WlS2V6JgG/idLeLw4f4DA7Pg5pEMpCP55FyZ7gCESHkHe+zFyoiMtosR9MQlidTaqEqkQ9seKGSRiK9ANLkynaDEosT+ayMO23oNW9DSN/0jyhd7gwYxYpdxNPjFtOlnHZIVvg5y4GCBOnoy+gPPNAhkidZLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRk1PqEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRk1PqEY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8F7E41F000FF;
	Wed, 23 Sep 2026 06:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143229;
	bh=qKxLcDQsJ+gjEH3JZ5fhenlxULIAfdoED8ve9Si0kqU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=jRk1PqEYRg2OCw2LxL1V1iHO0kNfp771ShLw9rdWv5zQ0SaNvz9qo484vMJc2iiMY
	 bMVY+vSCcoJzdnmzxzOhawsAXQedMfBlDiA/iy24DM3YhH9i8SJQDZhq2qw0wg1OMQ
	 mL9dFRhprNp+td6WU5bSFRlpyqp4BTtDM+wArNtJq2udE9bePAUW5cEreTrSxwGVL6
	 S0KKt24bDySl34qYaAImagboitCeeKr9G6fFxmi9CEZrLGkjuystyDxME3C5uoM+cQ
	 9DEz7OCiQSYBjA75APv5S3yy01aNlH4CHo/ay93C4Eam8CIGW3wxbknGJ3OAGP9PUP
	 x78loPodNVTyA==
Date: Tue, 22 Sep 2026 23:00:29 -0700
Subject: [PATCH 12/13] xfs: simply the free space btree repair code
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179014159185.1874904.16413083267072133133.stgit@frogsfrogsfrogs>
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

