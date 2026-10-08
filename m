Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D31F38333A;
	Thu,  8 Oct 2026 05:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791438907; cv=none; b=gkv4Q4R4oTmqRi66MAVi+uJb/TGnxd0jqZ1U0JKovL+ejx9ondu/+bdXZY7b2v/Hr6hGzCsgxDlLpSxFb21tWQ2fvGaQR4zj13Tr5vZ99PtinhO6RJC//cHwP0RCLqYoMyy9tGE7xSYc3UhrZD0H2BKGUqS0nKm2bEicmFZRRvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791438907; c=relaxed/simple;
	bh=qKeNWUhCH7suGzTB6TgIidyWtFqAN1J8I4yOYjR71x8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cPMX9XrGpqIvEv0IMdCkdGd8tFdLuadXmG6Yz9qBSoAMg9gaFarhC5LEHgWb9nBPRunwpvpKZ0ZRe3y5+WqhcYnvqEfHG+FNO5lcmdGE28zZms2MFMCEc7UAxcjle0GFFvcAAiUKW5M6rSVagfBe9K75PXejiR5wtfuDJY21vOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOD2FIVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOD2FIVF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4C92A1F000FF;
	Thu,  8 Oct 2026 05:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791438906;
	bh=L5N05p7QFW9pLcmgVepMwKu6GLZKITWxRGeubif7vwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=SOD2FIVFX51owZtk+hbfZWgE83V2cb6lcAAtVoSfUwjTpPFOOMZU752EK5i32ms4U
	 QGuY450ugoEcoUlRT+Dj12rrYW6s3iNUQGjur6RMH3Zqh1JHhUaB22VeDZwCxyCW0h
	 nB846l3cpzUb79E01DZ7LioN4FaspZjxSFbcFvoz5UyMGk0HWPFAcwMfN67pa8cMdg
	 80Mz64N7Q5aLC1DvlqySVdyKSNk6MdT9UI5TyttrI9dhffafzrcr0zM4KDI+oklEuC
	 J8c8/XF/nPxrVD6NRelfnCsHe8H9XH9pDBvTO/h2RoJz73dZs0mRSQ8pgpePB3/aUo
	 ehOj+ID0B7ZIA==
Date: Wed, 07 Oct 2026 22:55:05 -0700
Subject: [PATCH 01/12] xfs: check for termination during rmap btree walk
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521277.2728617.3453429073541203674.stgit@frogsfrogsfrogs>
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

LOLLM complains that we should check for a fatal signal *every* time we
walk a record in the rmap btree as part of rebuilding the free space
btrees.  Fix that, and improve responsiveness to ^C of xfs_scrub.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/alloc_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 6e835240536181..9a09a9ea9c3089 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -224,7 +224,10 @@ xrep_abt_walk_rmap(
 	void				*priv)
 {
 	struct xrep_abt			*ra = priv;
-	int				error;
+	int				error = 0;
+
+	if (xchk_should_terminate(ra->sc, &error))
+		return error;
 
 	/* Record all the OWN_AG blocks... */
 	if (rec->rm_owner == XFS_RMAP_OWN_AG) {

