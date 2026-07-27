Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E0F233723;
	Mon, 27 Jul 2026 05:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129937; cv=none; b=HHy1owdgSgEzVlFdK1JtFCBHwpGoXbFGSAfYVNM08nSFIzLOU4ebphhW7rM70xVPN21f8FHTsup/z9xzn6/x2JWYVT5fbzQ164Scov/9zzG863aj4qm8xGoVPLHJmejc2+VxljFlz73yFwVvQCOiPVSD7UM52E/X+xEwU3LJxBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129937; c=relaxed/simple;
	bh=MYGHL6f8vYFSB4KkJRM5EXI8bBiLX1igKsZNWDe0fno=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fgXlVKChXrxacRfAl+SilwjtQYV+sO8bas6jUyqzQUuHSwwSfy/Us5TNSJWNCrfMYEQB2ylAGoaBNM7SuyYsimwZUGVlhEOJIeJZpEarjHKLXE4LoZ3eq+oWIznQyP+x8Xerj8iF33026+UyDUQaYLDRVCLYvnGn/2RaMlA7YkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=moKp2aB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="moKp2aB4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9DA1B1F000E9;
	Mon, 27 Jul 2026 05:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129935;
	bh=H8Gt/x+LU4dnf3MPxZ5nHwLJuMx4D3QwQwSowzxonAg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=moKp2aB4tRJ72L0a30hS+yabAym/OGFVa8PuiCiMmoQJENQaS4/I76U4iNOtiZQz8
	 sDKKOEOnkNQBqqMkuoYpDilFSGrduHk6eReQ/anKttlCnb2oY3LNIlg1W+KHaav/M2
	 Kb2I2ekb4xUwGJQYUWJqi9cqyp10Yr5JiG1G/oe0Pr8QOrq+8heoeLqAeYOP837S7T
	 /prwwIGJoYHryPOQQ6DMGozv/CdgMkx7CZ7khBg3hpve6TdtlQCAtMDSrxQ4+jJkfQ
	 sPp+ic0K7BDMgR1tMgsfSUOzwpltf/g74fD6n2kQjImsd7/S6FSh+A8WNixmUO0pll
	 Xg9xx8wmic2ag==
Date: Sun, 26 Jul 2026 22:25:35 -0700
Subject: [PATCH 05/10] xfs: pass runtime errors from
 xrep_iunlink_mark_ondisk_rec up to callers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389702.1495075.13312621677801198050.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
References: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that the only error that xrep_iunlink_mark_ondisk_rec
returns is ENOMEM, but we ignore that, and can end up writing a garbage
AGI based on incomplete information.  We shouldn't do that, though here
we must be screen out EFSCORRUPTED/EFSBASDCRC because we haven't
checked the inobt yet.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader_repair.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 5204eab09c6450..7f19554843038d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1309,7 +1309,7 @@ xrep_iunlink_mark_ondisk_rec(
  * iunlink_bmp.   We haven't checked the inobt yet, so we don't error out if
  * the btree is corrupt.
  */
-STATIC void
+STATIC int
 xrep_iunlink_mark_ondisk(
 	struct xrep_agi		*ragi)
 {
@@ -1321,6 +1321,14 @@ xrep_iunlink_mark_ondisk(
 	cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, agi_bp);
 	error = xfs_btree_query_all(cur, xrep_iunlink_mark_ondisk_rec, ragi);
 	xfs_btree_del_cursor(cur, error);
+
+	/*
+	 * Don't proceed if we couldn't set a bit in the bitmap.  All other
+	 * errors we ignore because we haven't actually checked the inobt yet.
+	 */
+	if (error == -ENOMEM)
+		return -ENOMEM;
+	return 0;
 }
 
 /*
@@ -1508,7 +1516,9 @@ xrep_iunlink_rebuild_buckets(
 	 * If there are ondisk inodes that are unlinked and are not been loaded
 	 * into cache, record them in iunlink_bmp.
 	 */
-	xrep_iunlink_mark_ondisk(ragi);
+	error = xrep_iunlink_mark_ondisk(ragi);
+	if (error)
+		return error;
 
 	/*
 	 * Walk each iunlink bucket to (re)construct as much of the incore list

