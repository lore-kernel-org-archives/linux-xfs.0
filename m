Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6869937179
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591229; cv=none; b=PLmBbyf6jDlKt5XHcyX6dsKaCXB3noDTTeBNC2zVlzN1ZQTOlumJ5GRG62epHoZaWCvx7u9jRj9DCrKzpiRMVWFMsTx7iuDSBOX2K+RXk2jZ9xYdF7Pm1oUhwLyAHJkCigtugUTpmj9y4CusXkDXSO97snofyS83X2VzxbOcnS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591229; c=relaxed/simple;
	bh=7BfBVsiUnYr3iUe1J4xnV9Luy8EmUWzA7T5xan84BVc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gIbImDKsP11hArRUSQrkTEPcV3bxZjOc08XzYo3AdmSuA88x6t+V5gzaFYbBO+PfzQKt7weVv8486xkmY4QyyfuvtZZFtNKkLdGhpGQ88QzGB76NczTWH9NVIVRfa6Uw0Cz97DAe2xPQMj03uHXi1+O3SRDnUHDQVDAipbpZaAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DE9wLeZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DE9wLeZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE927C433F1;
	Tue, 30 Jan 2024 05:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591228;
	bh=7BfBVsiUnYr3iUe1J4xnV9Luy8EmUWzA7T5xan84BVc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DE9wLeZ0wCtmrG7nztmSx8HG0P4AoWf1xitknO/CIxBzrxyVM6DTN5DcofERVGXNK
	 OanUfhZCoIBUBFKDi1lpUoBguWp1QdJL3gxFvqB46b141lmpwcyXHqLEmthitNT2PS
	 +bkVN/m9kxGCkOFsiG2SjKnpMILurdYtYHAqmaBToMbSzNEtOKVRf0N/6bI4H5YhKw
	 WkdiqOPzTfomtvdf0fmaQI8tX+F+QKjBdkVangKmqZNmYy+fVMLC5AE5v5FO84Cx7z
	 sUiqlS85t1Pk+INCyDFdRjmip1/ejP7LwHRT0Ww/WtNzbv3tLAnr2znCVA5H22PvZp
	 UizCclfEDELbw==
Date: Mon, 29 Jan 2024 21:07:08 -0800
Subject: [PATCH 4/8] xfs: create a sparse load xfarray function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062818.3353369.15735312742710633221.stgit@frogsfrogsfrogs>
In-Reply-To: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
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

Create a new method to load an xfarray element from the xfile, but with
a twist.  If we've never stored to the array index, zero the caller's
buffer.  This will facilitate RMWs updates of records in a sparse array
without fuss, since the sparse xfarray convention is that uninitialized
array elements default to zeroes.

Christoph requested this as a separate patch to reduce the size
of the upcoming quotacheck patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfarray.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index ec643cc9fc143..acb2f94c56c13 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -45,6 +45,25 @@ int xfarray_store(struct xfarray *array, xfarray_idx_t idx, const void *ptr);
 int xfarray_store_anywhere(struct xfarray *array, const void *ptr);
 bool xfarray_element_is_null(struct xfarray *array, const void *ptr);
 
+/*
+ * Load an array element, but zero the buffer if there's no data because we
+ * haven't stored to that array element yet.
+ */
+static inline int
+xfarray_load_sparse(
+	struct xfarray	*array,
+	uint64_t	idx,
+	void		*rec)
+{
+	int		error = xfarray_load(array, idx, rec);
+
+	if (error == -ENODATA) {
+		memset(rec, 0, array->obj_size);
+		return 0;
+	}
+	return error;
+}
+
 /* Append an element to the array. */
 static inline int xfarray_append(struct xfarray *array, const void *ptr)
 {

