Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C793538E8AC;
	Wed, 23 Sep 2026 05:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143183; cv=none; b=hw+lSHsZWn3SPo3LZdmd0JWPOgCy4haH/6cBDi3c1Zzw+oXZCiFWTG2uU90QnGSkzlcJOmiEx8MHicnqesP3849oRwM4r77cKqNawd6DzvgiydsJnQJ8zgkwnYfkLFKVV0C0YtYaDjBOr6Gt7OTpzbcnzLtoCRuivW3OF3EVyjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143183; c=relaxed/simple;
	bh=zLn3E7QCqvRqszOavEBlzkL5lcbMo3yk2xBaENiGQWE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zvp7xv1o787IBSzb8GZEvYtsSbn9uHqfHUkzVlWGRdNMs4XQ5svgqRRQOXhKG77isy0sLfRGVLXY625c1R+uY1InXWcrWvdzmtFCyLxDiGsGRJyX/y+oE8lvolXJBH0AnpyO1jjpw4vnvjGxyObIZoBiFcs2Q4vJnkRMSjDQrwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9hspl5e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9hspl5e"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9F3881F00893;
	Wed, 23 Sep 2026 05:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143182;
	bh=ov4YgtKC61AYAV2nRrvDo3sRbS6rTkeecSTKBxWW9eA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=i9hspl5eGnsHGQqHrgyCIfXzWqijld1XiqlEvvan0UAUhdW5uAhviHOilIagb7eJR
	 R3UpevL20WsQ07WrJa4QhmtxUi8QY5gTTLUFDPnVM8Q7eoA7CkHAhQIrSznS/dAlby
	 EeeFIDFOBMBmv+BHQxRb179q4TCbVspUk3Mzwwf5zmFxcZTBIntg6dPtCk1IWEYDBc
	 WYndh8HqrcsZzwU2y3t2qkH96TDafK/gIejvNI5H/KRgtE2C50pWCSiNkJAEw+kawk
	 zuUKHpAQHkDM6Y2TTR3i4X/dm5mCDDlcK5WjeCrgjnEl3XtBG4VcAxED4MKBOojBrG
	 Y/Mq2puh/90fg==
Date: Tue, 22 Sep 2026 22:59:42 -0700
Subject: [PATCH 09/13] xfarray: don't crash when sorting if array element
 crosses a folio
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159120.1874904.10223064447351373669.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/xfarray.c |   69 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 2ce24bfe4c0fab..5ea3ce4bf8d846 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -794,6 +794,46 @@ xfarray_sort_scan_done(
 	si->folio = NULL;
 }
 
+static int
+xfarray_sort_load_folio(
+	struct xfarray_sortinfo	*si,
+	xfarray_idx_t		idx,
+	loff_t			idx_pos)
+{
+	struct folio		*folio;
+	loff_t			next_pos;
+
+	folio = xfile_get_folio(si->array->xfile, idx_pos, si->array->obj_size,
+			XFILE_ALLOC);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+	si->folio = folio;
+
+	/* No folio?  Get the caller to read into the scratchpad. */
+	if (!si->folio)
+		return 0;
+
+	si->first_folio_idx = xfarray_idx(si->array,
+			folio_pos(si->folio) + si->array->obj_size - 1);
+
+	next_pos = folio_next_pos(si->folio);
+	si->last_folio_idx = xfarray_idx(si->array, next_pos - 1);
+	if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
+		si->last_folio_idx--;
+
+	/*
+	 * If this folio still doesn't cover the desired element, it must cross
+	 * a folio boundary.  Get the caller to read into the scratchpad.
+	 */
+	if (idx < si->first_folio_idx || idx > si->last_folio_idx) {
+		xfarray_sort_scan_done(si);
+		return 0;
+	}
+
+	trace_xfarray_sort_scan(si, idx);
+	return 0;
+}
+
 /*
  * Cache the folio backing the start of the given array element.  If the array
  * element is contained entirely within the folio, return a pointer to the
@@ -819,33 +859,18 @@ xfarray_sort_scan(
 	    (idx < si->first_folio_idx || idx > si->last_folio_idx))
 		xfarray_sort_scan_done(si);
 
-	/* Grab the first folio that backs this array element. */
+	/* Grab the folio that backs this array element. */
 	if (!si->folio) {
-		struct folio	*folio;
-		loff_t		next_pos;
-
-		folio = xfile_get_folio(si->array->xfile, idx_pos,
-				si->array->obj_size, XFILE_ALLOC);
-		if (IS_ERR(folio))
-			return PTR_ERR(folio);
-		si->folio = folio;
-
-		si->first_folio_idx = xfarray_idx(si->array,
-				folio_pos(si->folio) + si->array->obj_size - 1);
-
-		next_pos = folio_next_pos(si->folio);
-		si->last_folio_idx = xfarray_idx(si->array, next_pos - 1);
-		if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
-			si->last_folio_idx--;
-
-		trace_xfarray_sort_scan(si, idx);
+		error = xfarray_sort_load_folio(si, idx, idx_pos);
+		if (error)
+			return error;
 	}
 
 	/*
-	 * If this folio still doesn't cover the desired element, it must cross
-	 * a folio boundary.  Read into the scratchpad and we're done.
+	 * If we don't have a folio mapping the entire array element, read into
+	 * the scratchpad and we're done.
 	 */
-	if (idx < si->first_folio_idx || idx > si->last_folio_idx) {
+	if (!si->folio) {
 		void		*temp = xfarray_scratch(si->array);
 
 		error = xfile_load(si->array->xfile, temp, si->array->obj_size,

