Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8221363C79;
	Mon, 12 Oct 2026 05:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784639; cv=none; b=EIr5ElLn6QTylkkKK6wO/jJaLffvnxoBACasxjUDEvc01TDgG82fRnPbdaOzMePfQbqLaVdd5NBSczy8z4fICWqlO51ZURDSHEUOVQWnfRI9lwDjNKtoKZerp0vlyiSEFGYNuDmluMLvBW0G6AuzlllYrOEbOI4ugDzUFEGSQNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784639; c=relaxed/simple;
	bh=re2AkThea1uQ84gCxiGbq6C2t2oCCi1Lr9EoJB6+ETY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A/Ogv6t45PMWehyRfUGIth88Ng5Ppo2WS3Q56VhoMeNVJhFcQ1mva1intbZjtbgTf3oJCQElEdQ7GjtjJFzx9lK7Yu2zlW9TMhc2kG1gpP4y3ft7uyuIQCKnFdRjwakaow9py4C2d+TwCzoljbnpNcOJmVH7rJxKgZ+4tGH0DAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5oQ5W6q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5oQ5W6q"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6134B1F0089B;
	Mon, 12 Oct 2026 05:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784638;
	bh=qENhsNILBRoYV600uyeV9esh7PZBgPpXaCdon7t0N14=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=W5oQ5W6qtsVX+diaO/T8jsQ6wcqcJ9jQFxHMJlob0kG/FtUD8vb0Z8gP02oxOe4fh
	 Dhp79KDGANlwHvtZvrqi5BE2YUN8N4AHV+bmcYRZEBxj54toslNKQtzmBHHyxHmyfe
	 7A6F3vihdhYwQjePw0kbObZ7/EKH9hRbYGOie+oWBW7QyljKzwbGXUW3v+XG8l1MeV
	 zMwBMoQQEPKUHzzJgHDNCc5cYf0GyyPSkqJTCGJThwztqNAy5XgfXbe2h9HFfuOhc7
	 XpKT6LD48KwuzoP4vaorSP0oITcTu6598rIIiTIbagnkJyOIFpWfzp3FaneUNT5dld
	 JAqUoJ7OCj0jQ==
Date: Sun, 11 Oct 2026 22:57:18 -0700
Subject: [PATCH 06/12] xfs: only written file data blocks can be shared
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065324.1058326.3356948076285838276.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xchk_refcountbt_rmap_check (and its rt equivalent)
will count any rmap owner towards the shared count.  However, the only
blocks that can be shared between xfs files are written file data
blocks; and the only blocks that can have single-refcount entries are
COW staging extents.  Fix the checking code.

Cc: <stable@vger.kernel.org> # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/refcount.c   |   12 ++++++++++++
 fs/xfs/scrub/rtrefcount.c |   12 ++++++++++++
 2 files changed, 24 insertions(+)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index f8c51d8fbb3da5..a900d13c9e27c0 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -129,6 +129,18 @@ xchk_refcountbt_rmap_check(
 		return 0;
 	}
 
+	/*
+	 * The refcount btree should only have records for written file data
+	 * blocks or for COW staging blocks.
+	 */
+	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
+	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
+	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			      XFS_RMAP_UNWRITTEN))) {
+		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		return 0;
+	}
+
 	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
 		/*
 		 * The rmap overlaps the refcount record, so we can confirm
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 3d916d71a135dc..00da8e98506d63 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -144,6 +144,18 @@ xchk_rtrefcountbt_rmap_check(
 		return 0;
 	}
 
+	/*
+	 * The refcount btree should only have records for written file data
+	 * blocks or for COW staging blocks.
+	 */
+	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
+	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
+	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			      XFS_RMAP_UNWRITTEN))) {
+		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		return 0;
+	}
+
 	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
 		/*
 		 * The rmap overlaps the refcount record, so we can confirm

