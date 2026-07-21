Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83AD78F26;
	Tue, 21 Jul 2026 03:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604368; cv=none; b=PWvN6gqw5CrAyyhsIqGjYkxq85JjPDpoMDDqXnXcsTeCgm0rx3HnWfs4rOF/KB7IblCrcaIuLAcM3SWD7VHToKc8GqcJ15TcnM+0KNt8gDf8bQrlq+HNgquIYFYLzf3Ws6iee2uoTWjBg8wuBgW7Nt2JRWXHVHVv1PImiSFLgr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604368; c=relaxed/simple;
	bh=Oz5bHppM5ArPS9jeoO58chk4gcnXC8lFW2Ppk9p4/WQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VPQ2cuBh18JoyGbUI1F9deI9nlwtbacdmC0GA2B/eWhqHCJ1Y//O8961C/ut4BK1Crge71sB84E71+8pJMYUgHk2/Rj0MzvQ1ZJsBwFZfM9Hx1Geg9RtR28Uh1LLYITRRYw6xzTeZHGO4Ux1ye30+Emp0cbETubMYhH2jywhGsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RMUKljF4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RMUKljF4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3330F1F00A3A;
	Tue, 21 Jul 2026 03:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604367;
	bh=CAVByXTsd2WBKyIPfGXaLISJuDY7khKwPW09hak+BFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=RMUKljF4fIYqJ8lik+1d6DBugbpZ+I7JLA/aW7M9LkQUEgfW91lPYDuSobcYrdCUF
	 yd1FjzpksFZo8e9RyGtAziJi7POOZ5DpgrET/aqNzFTMGZuVK0LRqXh3Fq5nPwCFq2
	 bgEcu/itBiWGf7joYNx+JCPoBpSZSz8Cjs9S85bPxTxvG152460CHWlE7yXgBJg+HB
	 RCZyGR+GIRansRDRvdcqw58RxqfdloTxHao+MXGrKQDBVhYpVrp/XIk8AtK20SeDYB
	 WtgArAkaMUphgC+ZlyFBsr58zboEwYkWoWWu44qntzyA9TlXeGEbyGTQVfKEkm0sUL
	 6kCHdau+bU7wQ==
Date: Mon, 20 Jul 2026 20:26:06 -0700
Subject: [PATCH 5/9] xfs: pass runtime errors from
 xrep_iunlink_mark_ondisk_rec up to callers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419595.830862.11183226779231035029.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
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

