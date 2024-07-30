Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8F7621
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299621; cv=none; b=Fap44eUQVXaeD0e8cKUKkNmSSUNvjJE5QI2FG/jSQ6W+pYRg0lJaIR1i6lXNfy0eaMsWhFnD5mFqdZ5bvty9Svelrt12QV1wiiHwu6Y4Q38SpvfGyWQJTKlLRwXSXaDNwbzdUbMxpDFul5Ajy5AbrJUxS+Gw3Fi6lJrg3KLEazQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299621; c=relaxed/simple;
	bh=wFnGyPuJFgpJeVQzMJIyfH+uZ2Ozqim+9eqWTloG0No=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBWCxCkdVJq6oClJxKd/Lww4msACCHLHqkHZlbtQSrIYn9XPKY/iXmXGVy8jW7qwzHUCjTUVMyD4bG5+cHdt4k63IxXJqb+rs63LKOEM+HFRg7xs1eWosV6qKdHmUxmm+ihYmoRzx4kSgOsoizMGpUBpCVc1ORGbYR1IBBGnuJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdlRzXu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdlRzXu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C63C32786;
	Tue, 30 Jul 2024 00:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299621;
	bh=wFnGyPuJFgpJeVQzMJIyfH+uZ2Ozqim+9eqWTloG0No=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UdlRzXu8q9X5/cdLR8mJxUvc0Zcja+z/JlgnnFh5NGTyl7DTANgoMjq5ssAakK2mW
	 lT4Rw3N9hOYyMGGYAniIdTEZfrNm1q+mXKvoCAK397mH4gOfTkBbLOyucunPsD3ff9
	 PTIpYe0iLFNmP6T9S/r3bei2FzbuZuFdMbsIOTg3u+pAL4p34HM1FHjWtWw1aR8+5w
	 B60HfkSngAzdwGSWC0SijEAnAw1h+xU4PefHbta/m3XBCeGsztPcn+YFlnmdNpsfpW
	 SvBTuKl6YM/Z/4+8AWXaNE0OWTCA0HjXyNpbSoKNT5f2xiAUQ3TZJ11WZo8GgW/K1k
	 HsK4o5/o1Ty9g==
Date: Mon, 29 Jul 2024 17:33:40 -0700
Subject: [PATCH 038/115] xfs: support RT inodes in xfs_mod_delalloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229842977.1338752.18120747394730937321.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 7099bd0f243fa7511de6e95b0b8807ba7d3e5204

To prepare for re-enabling delalloc on RT devices, track the data blocks
(which use the RT device when the inode sits on it) and the indirect
blocks (which don't) separately to xfs_mod_delalloc, and add a new
percpu counter to also track the RT delalloc blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/libxfs_priv.h |    2 +-
 libxfs/xfs_bmap.c    |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 40c418f54..cfe96b05a 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -141,7 +141,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
 
 #define xfs_force_shutdown(d,n)		((void) 0)
-#define xfs_mod_delalloc(a,b) 		((void) 0)
+#define xfs_mod_delalloc(a,b,c)		((void) 0)
 
 /* stop unused var warnings by assigning mp to itself */
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5de8c72a8..79cde87d0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1971,7 +1971,7 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	if (da_new != da_old)
-		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
+		xfs_mod_delalloc(bma->ip, 0, (int64_t)da_new - da_old);
 
 	if (bma->cur) {
 		da_new += bma->cur->bc_bmap.allocated;
@@ -2690,7 +2690,7 @@ xfs_bmap_add_extent_hole_delay(
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
-		xfs_mod_delalloc(ip->i_mount, (int64_t)newlen - oldlen);
+		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
 	}
 }
 
@@ -3367,7 +3367,7 @@ xfs_bmap_alloc_account(
 		 * yet.
 		 */
 		if (ap->wasdel) {
-			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+			xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
 			return;
 		}
 
@@ -3391,7 +3391,7 @@ xfs_bmap_alloc_account(
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= ap->length;
-		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+		xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
 		fld = isrt ? XFS_TRANS_DQ_DELRTBCOUNT : XFS_TRANS_DQ_DELBCOUNT;
 	} else {
 		fld = isrt ? XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
@@ -4120,7 +4120,7 @@ xfs_bmapi_reserve_delalloc(
 		goto out_unreserve_frextents;
 
 	ip->i_delayed_blks += alen;
-	xfs_mod_delalloc(ip->i_mount, alen + indlen);
+	xfs_mod_delalloc(ip, alen, indlen);
 
 	got->br_startoff = aoff;
 	got->br_startblock = nullstartblock(indlen);
@@ -5018,7 +5018,7 @@ xfs_bmap_del_extent_delay(
 		fdblocks += del->br_blockcount;
 
 	xfs_add_fdblocks(mp, fdblocks);
-	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
+	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
 	return error;
 }
 

