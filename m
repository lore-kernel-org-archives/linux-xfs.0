Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D2B359A89
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 23:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218811; cv=none; b=o+Tvx7OoUkUSjgd3rIWZurUuY8Rj0vDF5tqrHEnZihWoS9KVvCSEzpKp+JiAJbQGI+X1ceCW6GBdfR+mvR8xN620rfww/tpF7mFxLyQPt47IVhKJvabqhUHRAKNXM/KU27v6H9fKh3TynNLOJ8RZL0orf0BaaUjrG/3VHHjy+/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218811; c=relaxed/simple;
	bh=w7NCCtPxt5nXdn8cuNIdGoNEfoF28zqaUIxu8WFFKCA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ili1T29LZT1Dms3PTFHoxFLzyqSNJTN8BPfv4FYimQ03lqm4rb375SkBVfbcpcpvyBBuXCFS0HZpSv6LkKvqvso468GFoovBIIbtRcJoS4GEvLN9MUCuRZHaCjCI0dhC3WS6yXUmJB1e4C+HbgGpoyLmN3PxS/kF55YcAIoqtVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xdyq2IEg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xdyq2IEg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EE5FE1F000E9;
	Mon, 31 Aug 2026 23:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788218810;
	bh=MZWUHjYgMfFumW1Uoien0170jtUmpSsM5fpvFZs6Ips=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Xdyq2IEgp+Laf3UeNvlKjow+ByjMzzRB1V5BDK5OxNvJcas8M+ikvjv4KclIs5h2R
	 a6Ko6o3GFiFsEawa0scRvaYWxnbd4F9EYChcKgwGSt/w26WpEAxkpA8cjQrf+U/Nue
	 eLPWt4q3kcajzw4KuzhfltzFWhrAHQOMtis2KIn7b2K5fWTlnPoIFXhMe5Y+QxHXAK
	 lw1SAfhvfmcMpGgI97iNi2R4aKpC4KOEFFvS/90qdWOa9PJn2i7QyXp11wDKDv+vKz
	 j0XYS5JhN2cYI655pYQTiDUML3s3fE0HTNWFMd4J7frqk6UEhDSHD+cCidFV4zMGOJ
	 Pjh6iet/TokMw==
Date: Mon, 31 Aug 2026 16:26:49 -0700
Subject: [PATCH 1/5] mkfs: automatically upgrade autofsck earlier
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178821870608.2381199.14359672932086572200.stgit@frogsfrogsfrogs>
In-Reply-To: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
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
 

