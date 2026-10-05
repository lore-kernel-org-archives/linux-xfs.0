Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34FA2ED84A;
	Mon,  5 Oct 2026 05:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179906; cv=none; b=C3XDTqPgneO5A9M3OVBDbkIrY1VlFsgHLuUrzKJFxm63P4WbeKZn6XnzjvInL0QWE4fIrZrc6u4y/6uRu3b2MoZQQzIwHCRHEQeneCZCQm4nvzzy7LxESyYxCDPl+aEuAlIDkKwo9BTGNOsGQcA+e9WNEWRMA1mLnXn1SD2KCY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179906; c=relaxed/simple;
	bh=uiPpBO55etHCipfffM/DTB1Ixpf6Z508akxLwYupdjQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XOeYEaZOqs3KUyaVCRFQa6q3ojeJt+Dnkj5waOLxsc1NHn5VAbZwRjTadP5TPwPQFYfyhgvehIRBcEBANJQmMbFCIPg/lM1Z/MccerrItjU+jURBchEUEzaM+J/JNHkCH2ij+x1VK9W+OCbO5beI/Kza2pgCOi8uet15Gm8TBCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gsU/6Dez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gsU/6Dez"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7B6A81F000FF;
	Mon,  5 Oct 2026 05:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179905;
	bh=UEcSUxoICKKlGgHB1bQQcJqDPaBNZewpo3ogsygb8Dc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=gsU/6DezGqir+XOD85mg5YLPIOIBWehjm5fLaJPRMffxBOa/f68cXTZGMbdsdhHul
	 EEFk6unlHNJevv8MyTKbbQ18Mm+UP9Me/JwVNEHCRO6ed/tqIdwU/Yv2AH+kqGh9TO
	 PWFVAie/pFWdOu6j9/XF+vUHi2fKkKKH7UMRF+kYreGfBFupKpcsTmQqRbAijhFBgG
	 UOhB7t3RyVogods8sbpvmAgm25hGUakzb+0mkxSsmNU3crGFwGf1OI/eBBA58+Ekb1
	 Zq0ImiR9XOTx2hjjl5V89FTp8JRgf4sqnrqcCGYopCUT1qJRIDzgae/Z0Y0UdxUOO5
	 4IAXnJMDcIiZA==
Date: Sun, 04 Oct 2026 22:58:25 -0700
Subject: [PATCH 12/12] xfs: always forget cached ACLs if the attr fork swap
 succeeds
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965267.614350.7711860069277357124.stgit@frogsfrogsfrogs>
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that xrep_xattr_rebuild_tree omits the xfs_forget_acl
call if the attr fork swap succeeds (and hence the acls might have
changed) but reaping the old attr fork fails.  Fix it so that we always
purge the cached acls if the swap succeeds, even if subsequent steps do
not.  This avoids some cache coherency problems with access controls.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: e47dcf113ae348 ("xfs: repair extended attributes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/attr_repair.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 4a6124b592b525..c7695d4cc8e7cc 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1491,7 +1491,7 @@ xrep_xattr_rebuild_tree(
 
 	error = xrep_xattr_reset_tempfile_fork(sc);
 	if (error)
-		return error;
+		goto forget_acls;
 
 	/*
 	 * Roll to get a transaction without any inodes joined to it.  Then we
@@ -1500,7 +1500,7 @@ xrep_xattr_rebuild_tree(
 	 */
 	error = xfs_trans_roll(&sc->tp);
 	if (error)
-		return error;
+		goto forget_acls;
 
 	xrep_tempfile_iunlock(sc);
 	xrep_tempfile_iounlock(sc);
@@ -1509,7 +1509,7 @@ xrep_xattr_rebuild_tree(
 	/* Invalidate cached ACLs now that we've reloaded all the xattrs. */
 	xfs_forget_acl(VFS_I(sc->ip), SGI_ACL_FILE);
 	xfs_forget_acl(VFS_I(sc->ip), SGI_ACL_DEFAULT);
-	return 0;
+	return error;
 }
 
 /* Tear down all the incore scan stuff we created. */

