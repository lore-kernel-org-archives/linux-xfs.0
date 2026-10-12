Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E30F49B457;
	Mon, 12 Oct 2026 15:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818516; cv=none; b=dw0B1sc3kgd5k+9nkHhlyNpaXuJ5nAtB3PFT55sqOeArvXbgJV1to7M7cKQ2kRsw9P0h8J5euoIuUaeKr6vnbMOH6pl5OKOMAkUu0DsL98tz00Tc84O6JhpQkrQotDMLBCRIYTzeqp9p+CwOcQCwUaAzjWRmaiSb5fpYdgnGxOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818516; c=relaxed/simple;
	bh=eZjeMwwGfUl9y3FPYvSXeM7XG4L1Fgpo99tR2JlEkYI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIUFwpMvONnpAC2Ms15aN+DG2DMZlcJCN9rM8naLnfIls9jfrjx6Cs9l2XieOa1SWbZ+qsBeFcyI8s276mq6txLfAzaBc4d3ItxpM6Hhd++z9Ue7zCOTSaor8F7mheXoaZN46h2BhfR7c1ktbVtrONe9gE0mPOhJEA9LArV0LKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VYUIJpmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VYUIJpmy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 99B6D1F0089B;
	Mon, 12 Oct 2026 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818514;
	bh=UX/ZouFRFX5alVgKT96TaOyAr+7KGnHZZ+4PJ7qjpbg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=VYUIJpmyTaimuMWLbkwmeODNskUnbRtdeMYXKYjtuKxx3B99dQ2Y5p7OWPi7cr0st
	 WugIfhtiYTvg9sXhmY++T+e6hjPcJ9UnKsLi+U+KEol3tVtK/xC1v6VNklqWSOmrW2
	 sgA5OHRa3/k+AT3uwfxioE8y5hEGV1e+mkM4jH19pqItrdNA1nDJHqndlzVLbUrgRk
	 afAX19hfA3mSjNJKzDCqwps2Ryki3Wod9id5lKwz33XrOYNCMA/hMA9We6lgPWuREh
	 Ey/ODxQk/pPbf/H7bXYUrLzTlZnDCZyYR0Nf6tbW+5koJ5n4hmZuzz+k9wQpU2KVj/
	 2NG8ZLzWlR1IQ==
Date: Mon, 12 Oct 2026 08:21:54 -0700
Subject: [PATCH 06/13] xfs: fix correction of unwritten extents in quota file
 data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839376.1417179.13075489753807986079.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed a couple of problems with the code that fixes unwritten
mappings in the quota file's data fork: first, we should zero the ondisk
contents as part of converting them to "unwritten" just in case we crash
shortly after the conversion.  Second, and more importantly, it noticed
that we fail to resynchronize the iext tree cursor after modifying the
iext tree.  If the tree shape changes, we could be in a world of hurt.
Third, we should force a quotacheck if we reset an ondisk dquot.  Fix
all issues.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota_repair.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 2b695e5b34177c..3be56d73dd665f 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -440,7 +440,9 @@ xrep_quota_data_fork(
 	/* Check for data fork problems that apply only to quota files. */
 	max_dqid_off = XFS_DQ_ID_MAX / qi->qi_dqperchunk;
 	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
-	for_each_xfs_iext(ifp, &icur, &irec) {
+	xfs_iext_first(ifp, &icur);
+
+	while (xfs_iext_get_extent(ifp, &icur, &irec)) {
 		if (isnullstartblock(irec.br_startblock)) {
 			error = -EFSCORRUPTED;
 			goto out;
@@ -464,16 +466,35 @@ xrep_quota_data_fork(
 
 			error = xfs_bmapi_write(sc->tp, sc->ip,
 					irec.br_startoff, irec.br_blockcount,
-					XFS_BMAPI_CONVERT, 0, &nrec, &nmap);
+					XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO, 0,
+					&nrec, &nmap);
 			if (error)
 				goto out;
 			ASSERT(nrec.br_startoff == irec.br_startoff);
 			ASSERT(nrec.br_blockcount == irec.br_blockcount);
 
+			/*
+			 * We just zeroed the ondisk dquot, so counts could be
+			 * wrong.  Schedule a quotacheck to fix that.
+			 */
+			xrep_force_quotacheck(sc, dqtype);
 			error = xfs_defer_finish(&sc->tp);
 			if (error)
 				goto out;
+
+			/*
+			 * Set cursor to the next block past the extent we just
+			 * converted because bmapi write could have merged
+			 * records.
+			 */
+			if (!xfs_iext_lookup_extent(sc->ip, ifp,
+					irec.br_startoff + irec.br_blockcount,
+					&icur, &irec))
+				break;
+			continue;
 		}
+
+		xfs_iext_next(ifp, &icur);
 	}
 
 	if (!joined) {

