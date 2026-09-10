Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF79248896;
	Thu, 10 Sep 2026 06:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789020049; cv=none; b=WU/tdG9scjYnk9giDmD7VEKaUcTXPfGVdogQgGo/29aCo5X3fzDFAjBZqs9gWIk0ivLMo6Om9GNzlr7aepjrt3vCcytVXmK/0LGQCS4eCM7xiH3/nnU/ik5Z3+/l3lVu9QMlNy0FleLwStk7YqyFxyRRwvfLel4uHkcgcMZ4zys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789020049; c=relaxed/simple;
	bh=j8p/K5ycc9kBYfA3xC3AqlDu3KeE676+wWjKIMobDAE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oZhfueW1kiIL3Yh4MkNv6oNaEh4AfRRF+Fmq5zBPNrYqZDPWQx3b0U6utN8m4C/TE6SfHTZnittasgCMLi0KL7D6KxzX6KydMmKDvusJ9rp5eQipqVaUqx/xl+YaPKf05J4f/7Gr6wVK8+q+0FSAmniKCT2pYGMJZT6WpC9WcLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V37YFIj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V37YFIj5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C86421F000FF;
	Thu, 10 Sep 2026 06:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789020047;
	bh=vxGevTzjUBQK0SrKppT5IAK6Zm/0BdEZ6V7CbC5O76Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=V37YFIj5oxP0Gke+JWwW7FTCPpEFSv4EfakoIPDZsN+Ly8uxCw8hMsHxeopbhm72z
	 /W8uiO79ja8NukxCT2geZ6O/ydAoClXpNK1SQJ5wXnv/pMIl+6sDpaZAta1a1VRScY
	 kh1K4g7HK7XB/nn7BOWQ3CbjWo4pj4jzaVGNecw92qmbfv7rCYLEvmQLJ85hbSX+bE
	 D7A0rmFgIkmyVnqgsOQY/K/snPlAThT527kEelEHDFl6k7j8AYMsuizeIihnA5+QgT
	 DfYZaTSFMdSFoEPzEU71/NOyfujQWW2idMgDI2x2uE2/YlaLOyNmiW42zykd362D6l
	 MbPgs+NBVq8gA==
Date: Wed, 09 Sep 2026 23:00:47 -0700
Subject: [PATCH 4/6] xfs: release orphanage dir inode if chown fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178901989915.361651.3303301107990083757.stgit@frogsfrogsfrogs>
In-Reply-To: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that we leak the igrab'd reference to the orphanage
directory inode if chowning it fails.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 1e58a8ccf2597c ("xfs: move orphan files to the orphanage")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/orphanage.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 3aca66869b8000..21e31eeaa042f9 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -192,12 +192,16 @@ xrep_orphanage_create(
 	/* Make sure the orphanage is owned by root. */
 	error = xrep_chown_orphanage(sc, XFS_I(orphanage_inode));
 	if (error)
-		goto out_dput_orphanage;
+		goto out_rele_orphanage;
 
 	/* Stash the reference for later and bail out. */
 	sc->orphanage = XFS_I(orphanage_inode);
 	sc->orphanage_ilock_flags = 0;
+	orphanage_inode = NULL;
 
+out_rele_orphanage:
+	if (orphanage_inode)
+		xchk_irele(sc, XFS_I(orphanage_inode));
 out_dput_orphanage:
 	end_creating(orphanage_dentry);
 out_dput_root:

