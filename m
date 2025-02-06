Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F572417D5
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882778; cv=none; b=t5KqNdU74DISgyS0zuM4ea5ZNt3ppv0LN7IjpQPSmyA9kwau38ED5Is8D54pwbq5+Pnh5ApgthbWVDFzBaUPpoe9PUiEaYl0FY5FLkG/Hx0/abkOwxyP9FmA+p18GlU06W4tMVfCuTbUiE2PCbECG9s89KUpYQyqNSDnRDSuvQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882778; c=relaxed/simple;
	bh=4HCzjCZlDWg/xI1eENdpRt1+Px9HjZ5CfyZxL7L4k4g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0Puxh+x9gFdpbGhYgCcrfYcQpeQvElBBGJ3+g5RpP0ARyccj/uC75Ne2UObpupD1i8OUzgKii3XyIYcBDrYo/KRbXMcFf9kximbeCLrlU9Lp8QDNW3Bt3DRLT8RT0VSu4aL6/8VKu3j5qkOPb90X64nwrF2q+GgwCppB4PA+7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pnsqQOZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pnsqQOZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87391C4CEDD;
	Thu,  6 Feb 2025 22:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882778;
	bh=4HCzjCZlDWg/xI1eENdpRt1+Px9HjZ5CfyZxL7L4k4g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pnsqQOZ+AY1c/GbgCAlRreY8Wx2xclC0Y4bKSrBHbKC1VHhYKcSvpT3E3FvLvmtGB
	 h5hjGtYLJTJO4OCak+INEELH12sz+9z7d/SNfU2IjlppJa9xtXejopL1mp9HZDDSd0
	 DRE3DWMzaHCbU7X6o7l92AcVY4h24tvT9bm6k9L8UijGqnWwLsGf5q1eeRgvFGgWka
	 wnFc+t1kIINM8wTw6ylzm4LPb5YBpa/IVwkNdBKEb+x11C1VXijM7dUQWHkPAeri5P
	 80UdtfFw9qmbj/3P7war++0at/bAoaZ7TY7LsaI82qU1eY9+IhdPWCfQpwz7/1dKOO
	 JXHkvLFdYJCdA==
Date: Thu, 06 Feb 2025 14:59:38 -0800
Subject: [PATCH 11/22] xfs_repair: allow CoW staging extents in the realtime
 rmap records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089101.2741962.17270845980448624809.stgit@frogsfrogsfrogs>
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

Don't flag the rt rmap btree as having errors if there are CoW staging
extent records in it and the filesystem supports reflink.  As far as
reporting leftover staging extents, we'll report them when we scan the
rt refcount btree, in a future patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/scan.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 7a74f87c5f0c61..7980795e3a6f9f 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1407,9 +1407,20 @@ _("invalid length %llu in record %u of %s\n"),
 			continue;
 		}
 
-		/* We only store file data and superblocks in the rtrmap. */
-		if (XFS_RMAP_NON_INODE_OWNER(owner) &&
-		    owner != XFS_RMAP_OWN_FS) {
+		/*
+		 * We only store file data, COW data, and superblocks in the
+		 * rtrmap.
+		 */
+		if (owner == XFS_RMAP_OWN_COW) {
+			if (!xfs_has_reflink(mp)) {
+				do_warn(
+_("invalid CoW staging extent in record %u of %s\n"),
+						i, name);
+				suspect++;
+				continue;
+			}
+		} else if (XFS_RMAP_NON_INODE_OWNER(owner) &&
+			   owner != XFS_RMAP_OWN_FS) {
 			do_warn(
 _("invalid owner %lld in record %u of %s\n"),
 				(long long int)owner, i, name);

