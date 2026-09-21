Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4FC1A683D;
	Mon, 21 Sep 2026 06:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971457; cv=none; b=g2An2O0V7D1LYkgp9kWhi62HUmRsGBlMVpCdk4nGKuI7jTU4Q8PnfoiYenUsI4jjV6BHWXNXvsadTqaYHsEthyPiMlvaT1a8H5bhiFqNnqXRJEmyDwPVMo7CNf3nKBfvSIuTYvoCGHxCk10+uMamheVspoSK0BRnhw8k3NSJbyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971457; c=relaxed/simple;
	bh=LqTGUaYl71YscF848NDJHxPtxV11ir0x+RJBqlkso0c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IhfWHPX9gP7kS+rfbf3L/3yESItz34JPRm+COhP3gDdnTWcoNHcy1E8i6V39XLqIB3hbNqqidB/QOLIbepy8ZxNr5T3umaMwevlitKPs68A/OVplN9sVnTatHdjDiiQdwMNK26vxHl7sIIyTsC6elSmLxEWVkc2+jSzbXEo0MF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3YZqZm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3YZqZm4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E9DCB1F000FF;
	Mon, 21 Sep 2026 06:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971456;
	bh=pwNe/WzMMNL/CBgqQZTqb/1ag8fy8Bj+cXtG5tlDxFg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=S3YZqZm4Kam8E/DF+n8l1auWkOs8AG1y0ZoeKpYT8IckbwpCQ2UifDvDFGCgKEUll
	 eR7vU6FNNK31THQaETrjIRWDCYV+bi7SCaZnfnwmAIIZaFAFv5Z0FKmjP150j0DECv
	 7kyMq/mnWI+3fVRiskVDCq100sXkTYnOQ8toTvQHmldjMfnRvwpCuZCvRXUdNd8LUK
	 B2vthaU51z47KqHjTN//F1KyV6BY3P4RQokkHlf3Ey5vWWfLZPnwNPqG+tDqeLLqm8
	 GGoINNOASySGYbHKeUr3qVOVgRajJ4FpD7wSTqCkklir4yrQZb7PyrexlfXw0bS9v2
	 rLc0rVfWanqYQ==
Date: Sun, 20 Sep 2026 23:17:35 -0700
Subject: [PATCH 10/14] xfarray: don't crash when sorting if array element
 crosses a folio
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996120763.181988.2563798655569721557.stgit@frogsfrogsfrogs>
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

LOLLM points out that if an array element crosses a folio boundary,
xfile_get_folio returns a NULL folio pointer.  If this happens,
si->folio is also set to NULL, and calling folio_pos/folio_address will
just crash the kernel.  Teach this function to handle this condition by
falling back to reading the array element into scratchpad memory.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: cf36f4f64c2d4e ("xfs: cache pages used for xfarray quicksort convergence")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/xfarray.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 2ce24bfe4c0fab..30a58e9d4378e4 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -830,22 +830,24 @@ xfarray_sort_scan(
 			return PTR_ERR(folio);
 		si->folio = folio;
 
-		si->first_folio_idx = xfarray_idx(si->array,
-				folio_pos(si->folio) + si->array->obj_size - 1);
+		if (si->folio) {
+			si->first_folio_idx = xfarray_idx(si->array,
+					folio_pos(si->folio) + si->array->obj_size - 1);
 
-		next_pos = folio_next_pos(si->folio);
-		si->last_folio_idx = xfarray_idx(si->array, next_pos - 1);
-		if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
-			si->last_folio_idx--;
+			next_pos = folio_next_pos(si->folio);
+			si->last_folio_idx = xfarray_idx(si->array, next_pos - 1);
+			if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
+				si->last_folio_idx--;
 
-		trace_xfarray_sort_scan(si, idx);
+			trace_xfarray_sort_scan(si, idx);
+		}
 	}
 
 	/*
 	 * If this folio still doesn't cover the desired element, it must cross
 	 * a folio boundary.  Read into the scratchpad and we're done.
 	 */
-	if (idx < si->first_folio_idx || idx > si->last_folio_idx) {
+	if (!si->folio || idx < si->first_folio_idx || idx > si->last_folio_idx) {
 		void		*temp = xfarray_scratch(si->array);
 
 		error = xfile_load(si->array->xfile, temp, si->array->obj_size,

