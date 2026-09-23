Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B293BCD04
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 06:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143215; cv=none; b=fFy6sTNfD2mCLnraM8c1nmzhg3ie1+yXJdKRwY9p+IjaZw66VTiJlxdLbk7EXJ/qE7Is7KXXUhSSqKFw3owRLCVahe62B4I+g+MV8nYI/WHw5JLXnWrQLbn5ubPS4eMgqsvGhWVw5HSZKQNrbJYbRWovXldF/d7VgavFmUuSI9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143215; c=relaxed/simple;
	bh=IxEt42f33/gX5JckLyuuSHbNz8oujjwsBHuOVK9OCz0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzzbMcdYOB5FpvBgdiL5YaW91OrXogggqzhTTNpdrc3IDMSDPELPuwnBER5eeoxjXwSHqfHQlqTiNP1U1s9aBlicwn3u+TwPK3N46hNN99csMJmm3MeD7j+AFwPL5KMBSZfsVjG9dgXi8298dHLmE7djifjv99bbXCqz/ta96zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlmgQc1z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlmgQc1z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E223A1F000FF;
	Wed, 23 Sep 2026 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143214;
	bh=3gbJxy0n+xf7u4Ny/oaCPZZac7yUOv5VE8uxmBfh4rs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HlmgQc1zDtrAeoZbHRT+x+XJGpZYtvldHe+y3uO4XJSohgo3xcSKac2RX1nTBx5XT
	 p1pEh1sRIdMfyJqdUNhNzpBtJ46kTFMeM4C7laCdbuf4fJsmJG5/xChEXNyFxCTx8E
	 xy7mc3t+du+ktEG2nKE0/tzm+m3AxA+qNebf0k/Tos0bRKSLPOFdB+dAc8FMvAtBck
	 rL3LrVrEukcoZo97KSPtMowl2vwq6vM5WWjk9CARkMefqGszI7QHIdTu+dsgq68b+K
	 MFS5nsQNj+8ppmoCyH+D2QUzwWWX4TFf+w0rxEJ7jyXp7MG3FomFu6w6n12GWTFDQL
	 UaX4vXYWSVXXQ==
Date: Tue, 22 Sep 2026 23:00:13 -0700
Subject: [PATCH 11/13] xfs: don't allow sorting sparse arrays
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179014159163.1874904.11504328187497175238.stgit@frogsfrogsfrogs>
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

Now that we've reduced the functionality of xfarray_unset, let's add a
new safeguard: no sorting of xfarrays with sparse holes in them.  It's
not clear what that even means, and nobody actually does this, so we're
really just eliminating subtle logic bombs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfarray.h |    3 +++
 fs/xfs/scrub/xfarray.c |   14 ++++++++++++++
 2 files changed, 17 insertions(+)


diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index d55225c7885b25..05ff65b09fcf41 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -32,6 +32,9 @@ struct xfarray {
 
 	/* log2 of array element size, if possible. */
 	int		obj_size_log;
+
+	/* Might there be sparse holes in this array? */
+	bool		possibly_sparse;
 };
 
 int xfarray_create(const char *descr, unsigned long long required_capacity,
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 685824efdb93f6..7f85855588ed54 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -152,6 +152,9 @@ xfarray_trim(
 		return -ENODATA;
 
 	array->nr -= nr;
+	if (!array->nr)
+		array->possibly_sparse = false;
+
 	new_eof = xfarray_pos(array, array->nr);
 	xfile_discard(array->xfile, new_eof, MAX_LFS_FILESIZE - new_eof);
 	return 0;
@@ -179,6 +182,8 @@ xfarray_store(
 	if (ret)
 		return ret;
 
+	if (idx > array->nr)
+		array->possibly_sparse = true;
 	array->nr = max(array->nr, idx + 1);
 	return 0;
 }
@@ -853,6 +858,14 @@ xfarray_sort(
 		return 0;
 	if (array->nr >= QSORT_MAX_RECS)
 		return -E2BIG;
+	if (array->possibly_sparse) {
+		/*
+		 * What does it mean to sort an array with holes in it?
+		 * Currently none of the users need this ability.
+		 */
+		ASSERT(!array->possibly_sparse);
+		return -EINVAL;
+	}
 
 	error = xfarray_sortinfo_alloc(array, cmp_fn, flags, &si);
 	if (error)
@@ -1006,4 +1019,5 @@ xfarray_truncate(
 {
 	xfile_discard(array->xfile, 0, MAX_LFS_FILESIZE);
 	array->nr = 0;
+	array->possibly_sparse = false;
 }

