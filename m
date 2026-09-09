Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC6438E8DA
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933633; cv=none; b=DvTqYsRflKQkcXRtU+RN0HJY0pdZkwm+eCcH5mMaYTD5X41eNzMylpfCS01NjkS9bgmbSoWhGHqxt6xLaJ4c7bE40t1RD5TD16jOnuf3yaJV0VxraWtcc/ZxsnFCQ2/c7/d7qBJbykf2K0xmVEriHujsMqQ8a8NZxbJe92yueZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933633; c=relaxed/simple;
	bh=GQzfNJTxby2sj9mExU6MIflVgddAByqb74A6iNjwto8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S04JQ646AjdKXf7cZvomHi9EnYCmdvdnY5zILwmnX18awS0Wzs9+MQ0jaC4LZ8+enTxbrlTBSgkBYo5KTcASPAuMBepPJmnFtYmJfkJQyDT7x3SoqumV/8HgTGy/YqZYZheZEgZQm0AIMbb0Ha3Qzpz4qKFCZeX9R/Emp99CAyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEVRmfKC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEVRmfKC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8803D1F00A3D;
	Wed,  9 Sep 2026 06:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933631;
	bh=jxAIuKqMaUn3/beSbqiYt43RZWzR4rcVipPqCuuBwhk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=dEVRmfKCLXINVrVqoXece+t1ZnfOJWD4QYP7iHBhfEqdsS3ZNGmHUSCg8MSru7doL
	 DwHaLsAqZngcD3jlODaJYdJ6wBQT8+HALCe3SXGMY6iBRBbDRuZT239Qm247mqLX+b
	 2HYJxycqPDR3aJp7ZC9//tz254yjsnvj3p9ba+wm+DAd3v8Xerq6OZFBPwbrAsQphx
	 WaLTWFXGh8bJKtiGmf3sJSmeW4hD89EKyTKYRE9IjaWAPNUrbjaxGrC9bmaTToJaVb
	 uFbwOr4JmSH5Ks4+yPTxpx8FPiDer5v0Rz7Hm5naTrLb8TXu+W35CfHdEeLXKEfSMQ
	 r1odSHQnblCyQ==
Date: Tue, 08 Sep 2026 23:00:31 -0700
Subject: [PATCH 1/9] mkfs: automatically upgrade autofsck earlier
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178892910547.4047311.12714199545208525271.stgit@frogsfrogsfrogs>
In-Reply-To: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
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
 

