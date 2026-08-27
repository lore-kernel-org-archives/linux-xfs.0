Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5CA3C2D;
	Thu, 27 Aug 2026 05:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808671; cv=none; b=QYKFGTh8iGdA8MPwclKj4CRLdA9XI2VDOFvwp01Dcr7T/bmOshNmZV9OZUmbK4PFYxnQEGBxjpjAXCd7I5svqItBhYJ2UhH03xMYbYNQ66ExmSj9qmwEsSMfD4i3ESTYk4w5lwHRNWDX5ehmgPsdVMdusuzQsefx6lByHc9Ru8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808671; c=relaxed/simple;
	bh=+Wk44bF/0iuvwn109DgMY9iJL9t2Wk1I37mTNLSDH44=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fgx4Ow8Hr24DgikeSqITSv2GN69/T1PAztvVtNkEcolXlX+w9sClNQXCL/h2otRm6UX3Oaa2XNf8leQEMTZsIc3NgXJ4i4fRnNFTcuOixivKcBUfnMoIKrrdcciJyysfFnLwxNMT4rBX0PfjZ0w6gwfVMINdQZcWVDxgztql4N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nn4juAcM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nn4juAcM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A24C41F000E9;
	Thu, 27 Aug 2026 05:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808670;
	bh=r88GzeaQGvnNHKTGKZHLfwMUBlmwJJxdbxMCxHXHxH8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=nn4juAcMosDH37QQhQtpE3dVtZht2KdsX+7pNiwKWXnUkLvxBRGsF6oQBHD5djo1b
	 q8QOUiCB1nKw5A1CJtTq/KDKi7wNMFAL3zn4sT4FiwXpsJOAIzS65wDQr3FYx0zzIH
	 iweyVY3dgxie1jCJ4l+diUCJU8O1w+FCOK5gvx8VgFTJcLJvFKHGAblZbe9Za14mVP
	 doX6PL5j4me83VGUW7l2LPyr3adkXj3zrbR9SpmZv6cTwkSbB1ZPpA+wX09m7EulbK
	 UPWuYRi2MmYOyM8zCxq7gdHpKqec1bkD1De1DsHKo0xMuOPjKbqa70qwun1s+QnTJO
	 OgNlCAnVb+zHg==
Date: Wed, 26 Aug 2026 22:31:10 -0700
Subject: [PATCH 1/6] xfs: don't spin forever on zero-length dirents when
 salvaging them
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640197.3528187.14161751912109618201.stgit@frogsfrogsfrogs>
In-Reply-To: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
References: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_dir_recover_data can spin forever if it
encounters an unused dirent that claims to have length zero.  Fix that,
and prevent the same thing from happening with a zero-length entry.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: b1991ee3e7cf85 ("xfs: online repair of directories")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir_repair.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 1c088cfba10ea9..0c1224d05d579a 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -484,18 +484,24 @@ xrep_dir_recover_data(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int			advance;
 
 		if (xchk_should_terminate(rd->sc, &error))
 			return error;
 
 		/* Skip unused entries. */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			if (!dup->length)
+				break;
 			offset += be16_to_cpu(dup->length);
 			continue;
 		}
 
 		/* Don't walk off the end of the block. */
-		offset += xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		if (!advance)
+			break;
+		offset += advance;
 		if (offset > end)
 			break;
 

