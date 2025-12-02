Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6353147C9B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 01:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764638896; cv=none; b=n5sEdFaGgzgL9Rt495Z68XTZIOKrug0AfMe0pTFX9KWZXxyHmbTuyZXcmcpmVh5QzquI5QRcWptRkr31yDZxYttrbc7IK5KvFVpeTRBZQxcSvAOsmqcD7KtZrnahWX8ejCFATeeUchqshvlHTnR5LM8b666bh531D18IsoZYmsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764638896; c=relaxed/simple;
	bh=Eju+j26wxBR5fsaYXJV7L2mByUM05DcQkb5BlrSqdPw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJ6M3SBkkopLerFB6s77ah8dQhtMZBUqYhdNBM4425RYO9vHzOz7VdDi5tl1bsxI/3wwGZhmP2xWiyutk9EM3LAoCJBMli5ais/ht01MetB1Z1rwFHWDhqkx4U5WeC0nhSJB57k0sugMhpOTMPp6/HDkms30g7j8Ke7K/VT6fE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uq4tzeU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uq4tzeU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9484FC4CEF1;
	Tue,  2 Dec 2025 01:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764638896;
	bh=Eju+j26wxBR5fsaYXJV7L2mByUM05DcQkb5BlrSqdPw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uq4tzeU4g9mBNcjcVSwsi/1paLc0WDxioDuxDDGWRltqRtYf9dYy6MiYPT/5XbNLe
	 cOasI4ESh/qvFqWvg0pIl11Kz1+GONiKtdEv4GWEfy5w0ow5scXeIF/JjhBH6dHHa0
	 Kr048n14YpTAEevLzc0MYT0HzMW8RQ39TnkBoAN6p5zZ77/h43MH0j5PxNO5OzfKdf
	 +jd5WFebWWYAQcZXLGMq3Qi8DgWQTzX5eIbQ5Enaw/m5bpVhtMiIQOlBuuF7vrMHj0
	 i7DzLA1DPhq3Dc4RCgy1Y+uW3Zqb1S+VMa8jwvl4Hq+7VZ/Ye7IS2ht4aDRpOqQbjd
	 1c+djt5ijxhCQ==
Date: Mon, 01 Dec 2025 17:28:16 -0800
Subject: [PATCH 1/2] mkfs: enable new features by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176463876397.839908.4080899024281714980.stgit@frogsfrogsfrogs>
In-Reply-To: <176463876373.839908.10273510618759502417.stgit@frogsfrogsfrogs>
References: <176463876373.839908.10273510618759502417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Since the LTS is coming up, enable parent pointers and exchange-range by
default for all users.  Also fix up an out of date comment.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8f5a6fa5676453..8db51217016eb0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1044,7 +1044,7 @@ struct sb_feat_args {
 	bool	inode_align;		/* XFS_SB_VERSION_ALIGNBIT */
 	bool	nci;			/* XFS_SB_VERSION_BORGBIT */
 	bool	lazy_sb_counters;	/* XFS_SB_VERSION2_LAZYSBCOUNTBIT */
-	bool	parent_pointers;	/* XFS_SB_VERSION2_PARENTBIT */
+	bool	parent_pointers;	/* XFS_SB_FEAT_INCOMPAT_PARENT */
 	bool	projid32bit;		/* XFS_SB_VERSION2_PROJID32BIT */
 	bool	crcs_enabled;		/* XFS_SB_VERSION2_CRCBIT */
 	bool	dirftype;		/* XFS_SB_VERSION2_FTYPE */
@@ -5984,11 +5984,12 @@ main(
 			.rmapbt = true,
 			.reflink = true,
 			.inobtcnt = true,
-			.parent_pointers = false,
+			.parent_pointers = true,
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = true,
 			.nrext64 = true,
+			.exchrange = true,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.

