Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6F527FD43
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789364898; cv=none; b=GCGph/7XUpiT/46V3t87IkfsOAPpxHkRiLXALP6D4XyM1k+hAEBYHARlKscUQGuWx3TdERMcz5VQ69wkdkocFpBPADFLe8EXmCl/doSAvNP0xahu4+5PVVkz4JWl4uG6cveTjMKL242ZMcnJ9TerUyCVM0AXWqyDPzPWFEIhgSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789364898; c=relaxed/simple;
	bh=7nOK3JJ/8MnMTULFcPtMj+hfov1+ekalKoUu9fAbY28=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+V4YrMYd8QIxBr7/FiLG0scORVhFGehRQvIwdZihg3dT5MMw74jnK8ym1a7aIaHWiznLSCCzXJAI+5F7TEs83rIwW0d9Y3OW3O7w9x9EMc3WfkLZLwJloepYyst137W2kvoP6e+PJmsG6iEMilN8P9Zs6ws3jKnNAsE3Po/uac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSqx07ta; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSqx07ta"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 313841F000FF;
	Mon, 14 Sep 2026 05:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789364897;
	bh=AALJ1AsjtgZwX60QimjOif1ja8B3IQ3q/5+tQpepo+w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=FSqx07taWoPKOwQX+nFWdNGPpikT71FCHPN6uk/sBxPfglsFWAV7PvM86KDDGktrs
	 oIqf6xFxIGD0XY+MLoGAm5a/46LIAwTQ3u5kgqDv8p8DOgdDvNH/Wf9Kzk0RjD/fwT
	 GXKiafeYAjtt5Zc4n87KVaKVnJ8kD0aPt5zbCiN36MVPF9NkKntVXkiHdmfUJVHA+6
	 QFcAI8yxyBPk6cbHxPcblq8OydLfi8BZQ9dUr+BK8aW9FROdRB52nR1x4FHl5p1PNv
	 aeuq38qLdGuNcUkqNx6CVCHZVApUHhic+1Jto+4+QIs5vnHcjHpbiymf5QY5wgpi9b
	 +AVq6KvrxvUBA==
Date: Sun, 13 Sep 2026 22:48:16 -0700
Subject: [PATCH 1/6] mkfs: automatically upgrade autofsck earlier
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178936484476.2108437.681184448931512331.stgit@frogsfrogsfrogs>
In-Reply-To: <178936484431.2108437.14645667775156303668.stgit@frogsfrogsfrogs>
References: <178936484431.2108437.14645667775156303668.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4f11c9de339c2a..56e6f892e455dc 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6123,6 +6123,15 @@ main(
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
@@ -6314,15 +6323,6 @@ main(
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
 

