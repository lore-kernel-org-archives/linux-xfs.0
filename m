Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1749B3EC813;
	Fri,  9 Oct 2026 06:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526585; cv=none; b=HxZteTgHjhE8LoF19/gUD6Ak4tvHdnSDGKec3e3RtIsqADis5ydRS8ZTrJGDCk8V8AtxWy8tVVDzzWHbgV4EyX6p40v9bMByb/+MJm/noJBaD98QBihKcCmDCsSXq+BweYGcjH1H2NJGzMSiDlZkJ9yukEhjkPVeUVcEVOqqt3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526585; c=relaxed/simple;
	bh=z/FcKwoEqix+mMD/6T35guMIbJHwqC027kZGiHwWoF8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sheVvgzD+W2pPv1Mt5dzLhzdk88IiwsCI5ldnpdnO0K03jnmT2m/G/sMplfLgcVA2Mpi+yqTlUrwduS1Mn+sQ21WWDOPxNj3cQIgaCfjvghnqUOUB6otj0nUjCZT5XTXIn+W7KdWhcqcGqg0fkxVrkiZk8eRvdtMbYWvRKegBqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMjH9UL0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMjH9UL0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E2C891F000FF;
	Fri,  9 Oct 2026 06:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526584;
	bh=G+EE3ieFgAWxCGTdeGOHOQQZtM/Y81K5aUXTyT7zQpc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DMjH9UL0pXLTDLABR/BhY+WqzFUKjm0amoYs5vB0puDS+5IcC//zkSJeUJJHJarkV
	 tLSeG0sxK7ef7v9A3OTrVj3CzcWFfo1qFqUn8Tx3KneLpAhclh4nyMLmjxTcw+bfmc
	 +iJc14WtOD95gtuSeIb4PCkv6eJM9XJpNP41f2ZhNzssuO2FGIrIhmKsxUImlWQ+rb
	 NKKuU2iYeQx4uilfSPlkIMZLaix5msnfprpTGyvE70xQYjt5BRxYfaYAKwith5mPYa
	 IjH88Z7Z2gutZ8CtiWIfp1YabqN4M3cUUQmD32VJWOhEuEeyq9FfMCDD5Lyf7RCZb2
	 drBNs2jjdUo/Q==
Date: Thu, 08 Oct 2026 23:16:23 -0700
Subject: [PATCH 06/13] xfs: fix correction of unwritten extents in quota file
 data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614750.3163896.2873690969855180504.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
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

