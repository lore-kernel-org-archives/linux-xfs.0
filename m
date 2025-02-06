Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1B62417CA
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882763; cv=none; b=Eumgi28Y46cAtsXl//SubypBqo43Gz3oqMSV7/oozCMxAMBJjD/odC5k7no/FvyJanvOVdDfDdPPA1brEzvPTaOymYFWPYhwSvENkZvmYRb3TWSjh6YfrCOlM6TbFOX/7hJxyT+0yR6zr+zlof2jHeGuvgInkj98JCRuqvZUr5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882763; c=relaxed/simple;
	bh=8wAjtw1BgcgBlJwtKxLngsGeYn0QtP3sZsu15hyP6LE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XnMrdJAFDQu1UfxIGg4uyIoZsZq7MMk58yYl0pFYN4snqHx6uFffrbqusDByaVdGnLqeMCK9xCc3UvvW5pjZUVLJjAFVzLEJ3R6CZj6N5ejxMqS9Nx19xki37vNoYXrDcUxeDB4nObZUdETVcw9NcoZaNjk0IrIx//ual/8mXDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hwEBWOTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hwEBWOTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCAEC4CEDD;
	Thu,  6 Feb 2025 22:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882763;
	bh=8wAjtw1BgcgBlJwtKxLngsGeYn0QtP3sZsu15hyP6LE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hwEBWOTAC3Y+NMPam/uTZLvrmZsR2jxkawrp7dLz+CMV/XnirxZ2GQd3BHEzEek/I
	 ZmzxPP0AauLxhLGiaZ3w/cNdQ3HGYrD8Y2d/EzH+OqTOx/jNXVeJgdRuL5hsIb71Dc
	 FyRYFm2snWLmOrAZDbe/MWW4x0zCJW1MgWy8hkf06Ie46u5meBYZobHQ8se82/DEBa
	 uO7YW+ZBLV2/+R33pTrYEavVxzggCJ4YuV8V6+GhReRYnCrZJgmk6Yw13u46MV/5MV
	 bnxk3lU+yyo6K6kcUN+fWTAdPYHu4NTWPG8Dh6fdv2En1z/DQ09i/8Y6fDwZs98sCH
	 IssqErVN8ar7A==
Date: Thu, 06 Feb 2025 14:59:22 -0800
Subject: [PATCH 10/22] xfs_spaceman: report health of the realtime refcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089085.2741962.7445820399757044454.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Report the health of the realtime reference count btree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 spaceman/health.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index 5774d609a28de3..efe2a7261de5c4 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -47,6 +47,11 @@ static bool has_rtrmapbt(const struct xfs_fsop_geom *g)
 	return g->rtblocks > 0 && (g->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT);
 }
 
+static bool has_rtreflink(const struct xfs_fsop_geom *g)
+{
+	return g->rtblocks > 0 && (g->flags & XFS_FSOP_GEOM_FLAGS_REFLINK);
+}
+
 struct flag_map {
 	unsigned int		mask;
 	bool			(*has_fn)(const struct xfs_fsop_geom *g);
@@ -156,6 +161,11 @@ static const struct flag_map rtgroup_flags[] = {
 		.descr = "realtime reverse mappings btree",
 		.has_fn = has_rtrmapbt,
 	},
+	{
+		.mask = XFS_RTGROUP_GEOM_SICK_REFCNTBT,
+		.descr = "realtime reference count btree",
+		.has_fn = has_rtreflink,
+	},
 	{0},
 };
 

