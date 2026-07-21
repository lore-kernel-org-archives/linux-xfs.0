Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105363358B0;
	Tue, 21 Jul 2026 03:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604275; cv=none; b=J6f9DAUnxCf9fOyH+QII3TGoWcWeWzM4DRmb1Scin6T2ymbop7PpN8kcjZyH9Ihe2/6yFQQ9A5cmxv100NeMC2oxq26SqjKVqIJDuvn0FRNU01sZbP+VoYUP6cLPqZV9UcbuGZzHDd8sXG3CyJNF6NiywsyxLY9IKtii6cacEXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604275; c=relaxed/simple;
	bh=IK+cZ30juj80lMALqbvzr4obsaVsBKlDGZp5F02tY9c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vD7/cJNNAyrlT36nrPIHS6VaIms3GFMK+4ltjLcR+cO+pm9iEKBnfAWlXm3cealLpuHgwldhlAZtsHqy/VLfFxZN2pYb5zkPtHxOqTofZD0SEfkb3h7QyeupCZxyOgFRB+nwXCGEieoaIucYUfSblE4Vj+e/vB8sPWLjduXAu/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Br4al3aL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Br4al3aL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9A9861F00A3A;
	Tue, 21 Jul 2026 03:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604273;
	bh=W5RaSrckEbRcqQTy+ZjtAPC0W6KgD1eAkCipqTpROkM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Br4al3aLjgDKoggyFHR7m/hr5ceCUPTPPAeqOUXnDhtHZ7/XQ4mmbzmmprDTROS0j
	 mf9nTYwUm1XfADIAE44eFc/IxfGl0DaF4MuHt7S6HV2pjs/7gztEcRyvNlyZ8qP1Pz
	 dEAyMA0gmrQTBAXQdqH9IA2bMeu7hEAerkwyXpotP+GgvAdZHgnOiujT4hqpFv9bRC
	 6qSzP5lyBEVQTmUv5Zht3JrTF0l2OLduzhBeLCn8mrFZuI8FtVB+YVLWWaNObEqRLD
	 CnO5Ybdsa79ajo3N2n7j21ONEZ5Tc/ZD6DI6enjl+KMTrui1Hw02lXY1z/3Z2EWOPH
	 4Jkx/K8n3bGrQ==
Date: Mon, 20 Jul 2026 20:24:33 -0700
Subject: [PATCH 4/5] xfs: zero i_nlink before repair puts inode on unlinked
 list
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419170.830618.15605959823888461973.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
References: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that we don't reset i_nlink if we encounter a file with
no parent that isn't on the unlinked list.  This causes unnecessary
assertion trips on debugging kernels and an inconsistent file, so let's
fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 669dfe883c8e20 ("xfs: update the unlinked list when repairing link counts")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/nlinks_repair.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index fbc2ff809fc06f..09e097e1668935 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -232,9 +232,14 @@ xrep_nlinks_repair_inode(
 	 * unlinked list, put it on the unlinked list.
 	 */
 	if (total_links == 0 && !xfs_inode_on_unlinked_list(ip)) {
+		if (actual_nlink)
+			clear_nlink(VFS_I(ip));
 		error = xfs_iunlink(sc->tp, ip);
-		if (error)
+		if (error) {
+			if (actual_nlink)
+				set_nlink(VFS_I(ip), actual_nlink);
 			goto out_trans;
+		}
 		dirty = true;
 	}
 

