Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C03931716D;
	Thu,  8 Oct 2026 05:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791438985; cv=none; b=Nip17jKYTpJ09Q35reRCyXwHCscL4Hi+78Z9mzzwSf1G7dm5PzyeFgJWOYBwOM/qvQXLhPEGQlNimvKRpf/vMFVLHtA9uJT1kcEzy8M4qNEgxg5bIxv00juTqd3prAgLB++di9Wr2N46xfUsKzyaqDBsJjOBUhyR1eSJBfshIFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791438985; c=relaxed/simple;
	bh=KfpyKr9KLJK2bBV//NiR+rsn7oG8j21a156wEv2PkMA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MMDnMHT5g4fraxA+o9x5Fr9wLRRgyx35zROsVT3CyRa8ea7MEm7UtW3ohBw53C88NiO1JuJS0kDinIC6aVLktruqXUeGgi1Hdxcjj+6zd4KDwtaM5PN6iqcSGlnZRwnZxa2TGeZXVAgZ7Ex+kQpy4F7UH+6KhiTfacR1dDW875Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3YXfNLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3YXfNLi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7FA3E1F000FF;
	Thu,  8 Oct 2026 05:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791438984;
	bh=4g345jtdJKTrxwFBmFDoKpMtcPYq7XIV9ieVrEoVBas=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=o3YXfNLicRD7uuY1mur4q+8hIAHr//fG0v3CXSHkaP4YOQTpMuS3f5x2/RUNy0YkQ
	 yBV1emQIyqMpZAO+i0qlRVgEF5t5blOMRNaqDEcMjk1C+H8QlwMSoCnuqUl32aCDlp
	 O07VPIqvaJV//dEwB3+/vJBu0S1nCoMw76Etonu7edVjehJuurT1UZSGbHB1z1AhRq
	 nRwhpB7vulPnskjvs7cRNte8c4hZuVGIN+LK5YSVu3sbbTfDPWZjgkqFamRzCsjx2O
	 nqwo6NlEo3ifE2/MGpyGt9DbPawcH8GPv6aEtPWWH7hBaScuwV8t53u5EsyDqKodyT
	 OKUHgwekC/trQ==
Date: Wed, 07 Oct 2026 22:56:24 -0700
Subject: [PATCH 06/12] xfs: fix correction of unwritten extents in quota file
 data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521385.2728617.15371099582568233395.stgit@frogsfrogsfrogs>
In-Reply-To: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/quota_repair.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 2b695e5b34177c..5ee1ec82fc2fc8 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -431,6 +431,7 @@ xrep_quota_data_fork(
 	xfs_fsblock_t		fsbno;
 	bool			truncate = false;
 	bool			joined = false;
+	bool			need_quotacheck = false;
 	int			error = 0;
 
 	error = xrep_metadata_inode_forks(sc);
@@ -464,7 +465,8 @@ xrep_quota_data_fork(
 
 			error = xfs_bmapi_write(sc->tp, sc->ip,
 					irec.br_startoff, irec.br_blockcount,
-					XFS_BMAPI_CONVERT, 0, &nrec, &nmap);
+					XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO, 0,
+					&nrec, &nmap);
 			if (error)
 				goto out;
 			ASSERT(nrec.br_startoff == irec.br_startoff);
@@ -473,9 +475,23 @@ xrep_quota_data_fork(
 			error = xfs_defer_finish(&sc->tp);
 			if (error)
 				goto out;
+
+			need_quotacheck = true;
+
+			/*
+			 * Reset cursor to the end of the extent we just
+			 * converted because bmapi write could have merged
+			 * records.
+			 */
+			if (!xfs_iext_lookup_extent(sc->ip, ifp,
+					irec.br_startoff + irec.br_blockcount - 1,
+					&icur, &irec))
+				break;
 		}
 	}
 
+	if (need_quotacheck)
+		xrep_force_quotacheck(sc, dqtype);
 	if (!joined) {
 		xfs_trans_ijoin(sc->tp, sc->ip, 0);
 		joined = true;

