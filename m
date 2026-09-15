Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F783F4118;
	Tue, 15 Sep 2026 05:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450767; cv=none; b=NQ5IvrfMZFhyhYgy38ZRqf7OZnofffhLd+vk2elY68Y9HBquENiZ5MhM5tUDY6du6YK6rXaabeTvdT4ZCzFRTfJ/MLUr9FgIqKALC7pt/BqmUJwo9PwMKBDPGpz30qfcUjWy8w8Zc5u5uUhQcGALEG3Ut7P1nODjzcPBfnOAZe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450767; c=relaxed/simple;
	bh=k36TUeJ4LPohYVuTOUVTtqz/laZZ8LiNX9lXo1lYpYs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kJUcxmly1Z9ep0BhEfbU+O50Kj9DBkFgYh731yhY7QAL4xO3ZRPFfGethXbw1Upl9+QgqY4io/e2DyiWtNjdZWZmsyPOqtQSBj+IA2d/tn3T5cKbABAJKhD6DL1fATFkU+4rnJRzD0vYBGJgcHC3NoT7xK0hSid6eFvWwraP2cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMWJ4r3i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMWJ4r3i"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5E6A21F000FF;
	Tue, 15 Sep 2026 05:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450766;
	bh=AOaizP4fS70hxRpmokHCzkJIDTJVRkqFl4gDV+A8QtU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=eMWJ4r3iB5xFgi2ttTStAh/foHMdZkqEz1ykpz+fk30bwmwhI8jcUsGEhGhBsEGw+
	 uBB9/dYc07UTMubF5DPg0DbDWHoKKolxgj2GgScg/NVY5CK9B1Iai4gVF8v16OeL52
	 /q92hR9BWO9kaSiSTBSv13kOt5u/IRsiH4YDajVGzZHnvrEQ3KKIbiV5qLKk9CCX0J
	 7AMCygPS/plE/V3jZ+2QcSgGHcneXxisKqKu8dk99aJMdQvX0Fc+2HRyhG6G6lrKKK
	 NSveMHXxGkjsPPpNAv13cOrhbcBL9M/xlREsS7Ov0I98tlBbOzYEjhglmSeX25BaxG
	 Lko5ftrnK/ZfQ==
Date: Mon, 14 Sep 2026 22:39:25 -0700
Subject: [PATCH 11/11] xfs: fix wild memcpy access when formatting ondisk
 rtrefcount btree roots
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048731.3061055.2062919508652373941.stgit@frogsfrogsfrogs>
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that the inode btree root formatting methods copy too many
bytes -- there's only one set of keys in node blocks, not two.  This
causes memory corruption of whatever's beyond the buffers.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: f0415af60f482a ("xfs: wire up a new metafile type for the realtime refcount")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index e2950dbe20681b..dcc89b8e149b05 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -617,7 +617,7 @@ xfs_rtrefcountbt_from_disk(
 		fpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
 		tpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
 		numrecs = be16_to_cpu(dblock->bb_numrecs);
-		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tkp, fkp, sizeof(*fkp) * numrecs);
 		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
 	} else {
 		frp = xfs_rtrefcount_droot_rec_addr(dblock, 1);
@@ -703,7 +703,7 @@ xfs_rtrefcountbt_to_disk(
 		fpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
 		tpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
 		numrecs = be16_to_cpu(rblock->bb_numrecs);
-		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tkp, fkp, sizeof(*fkp) * numrecs);
 		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
 	} else {
 		frp = xfs_rtrefcount_rec_addr(rblock, 1);

