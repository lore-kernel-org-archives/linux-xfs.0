Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5E736CDFE
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 01:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485403; cv=none; b=FOukPCuj0Z9/ITmR1TY0e0XkkO4SYXzGiLhr0+W2Rp6s161OlizyK5qJOKEYMAbGIKAvhx3Pc9AMo6y3pyJSgK8FNNf8HSUdIKGlvOqmoEWqrwV9NxbUwQvOxKzUbPN4Wo5PL167F5R4+lB5aVT/9Zsu8VDeFWhZzCySYZRb/wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485403; c=relaxed/simple;
	bh=a12NAGklXteNIw0ptL00bJN3/DG5+ZRwaujeRnm22v0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GixPx7MZk0P2xkB6KTJ9ikOxWe6/NF/nbKdAbe8zbdDSNUYB2YPzLDUqU9rfSJJfjBDQFpnnZpcYz068+Gr5xw8Lno5VFqx/IXcT+pOMLyZVQ+/DoBcbBZrhql+Fv2ujrc3ua98GOpeASJSRHDfauqucsqxexyeSPvmRBbC5ses=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PxIEXznz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PxIEXznz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4527F1F000E9;
	Fri,  4 Sep 2026 01:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485402;
	bh=VMJRMvUl1cODK3EfQJ2NQcYzrzSlrvIAOQ0A85bnYqU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=PxIEXznzCigvJPpyfwsEzVF7leqs8aGWnPM+sLXUynWrJ9Ula/O03VWo3nSUp5OQg
	 /coFkKgJ+qxfUFYibg+zm/c033zP0SWHrCwqdfmj8odT+45tt7rc/Q/Tvn5Zut6Y0Q
	 1R4GgTxjAwIw9MleV6choLSNDQKwHZ2tfF+fkzy38nG8IvZzDeoDt82xmDzboiK7WN
	 ikjk5Nf7+nncg2hetYzkmwE5DLd48lTKbAOMavguEqbLW8v8C0CXMWaBDzdKfjkWEK
	 j+ypGKunW4ak1FKe/cKEb2fv8YUMQzQFbC85KFUP++StAZj/OuYv2Yvv22tUzQjomm
	 iFtfnatLTd4bg==
Date: Thu, 03 Sep 2026 18:30:01 -0700
Subject: [PATCH 1/8] mkfs: automatically upgrade autofsck earlier
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178848534876.1052910.13581739165501202934.stgit@frogsfrogsfrogs>
In-Reply-To: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
References: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move this chunk of code earlier in mkfs.xfs because a subsequent patch
will need the final value of cli.autofsck at the point where we do the
dry run reporting stuff.  Nobody changes cli.autofsck after
validate_sb_features().

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 mkfs/xfs_mkfs.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a4864c37a8821b..74bbb677eee2b6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6106,6 +6106,15 @@ main(
 	validate_zoned(&cfg, &cli, &dft, &zt);
 	validate_sb_features(&cfg, &cli);
 
+	/*
+	 * If the filesystem has full backreferences and the user didn't
+	 * express an autofsck preference, enable online repair because they
+	 * might as well get some useful functionality from the extra metadata.
+	 */
+	if (cli.autofsck == FSPROP_AUTOFSCK_UNSET &&
+	    cli.sb_feat.rmapbt && cli.sb_feat.parent_pointers)
+		cli.autofsck = FSPROP_AUTOFSCK_REPAIR;
+
 	/*
 	 * we've now completed basic validation of the features, sector and
 	 * block sizes, so from this point onwards we use the values found in
@@ -6297,15 +6306,6 @@ main(
 	if (mp->m_sb.sb_agcount > 1)
 		rewrite_secondary_superblocks(mp);
 
-	/*
-	 * If the filesystem has full backreferences and the user didn't
-	 * express an autofsck preference, enable online repair because they
-	 * might as well get some useful functionality from the extra metadata.
-	 */
-	if (cli.autofsck == FSPROP_AUTOFSCK_UNSET &&
-	    cli.sb_feat.rmapbt && cli.sb_feat.parent_pointers)
-		cli.autofsck = FSPROP_AUTOFSCK_REPAIR;
-
 	if (cli.autofsck != FSPROP_AUTOFSCK_UNSET)
 		set_autofsck(mp, &cli);
 

