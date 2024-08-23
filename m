Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8DB4A02
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372158; cv=none; b=KIGT5rqYk4bItUeZIOWPO026fARY26ZNoRibiMZQCV01TZ2CVh3VXw2cp0sK5AE47og8hjmkPy96AwzTrsic9qSAgaDkv7ogejGiEz30nQgGL8i/8LPLIGlspmUELCCM+sd8eSIj/WrdNCDhPdKRR5C7ySQzKTy3P51ocDzHIfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372158; c=relaxed/simple;
	bh=Dm46UwKvKXTIXHdpZihW8yyTlFssf50cboLtFa1RD9Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FsSCU0XFtX+CVybtRTR4gVkxz/K1oW7ov7Jfx0/g7B/OC3O3SzZWlKxN5N6YAcd3Uc3Ik+k5HtBnFetZrTZSAPsH6OhHgR7R30Cqklqo0S/Yh1USItJHrP7lZXu46p76nVP5MfvILzDon6sRpV7DiZV94kh4ntx2c2nCb5ACnJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCn8M30L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCn8M30L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110BBC32782;
	Fri, 23 Aug 2024 00:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372158;
	bh=Dm46UwKvKXTIXHdpZihW8yyTlFssf50cboLtFa1RD9Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RCn8M30Liisj6hR+SN5GpX92gNjauZOsYwT4G+gbvxTjHATZx24IAYAQHdZ1MTp6V
	 sokfXSPLdSPnv0fwildXrq1ctorF31umEi3kfQurJdjD8xPHOr6CNkUiJ9RM8F+EZ1
	 jqWRg962DyTpAAoGb2eXgK31pdk5++PS0qS0DKGOjbaYxyZ2hJGiBgg79pVFta1MP5
	 hF3pMsrtj9NFpjcJqhFwzJcFYqqzPhp85U3ugwIR0PqxQ0RfsZOrdJhAFDFB4ZIBVI
	 QgTtpdG3wOr6xwl7WRmnH84Y6kh1Ft+aOPZAHA4EPlI3OAl2RTYjpOfREA0PN5HdP9
	 yRUA5xrLG2wUA==
Date: Thu, 22 Aug 2024 17:15:57 -0700
Subject: [PATCH 05/24] xfs: make the rtalloc start hint a xfs_rtblock_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087329.59588.10885914516722982578.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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

0 is a valid start RT extent, and with pending changes it will become
both more common and non-unique.  Switch to pass a xfs_rtblock_t instead
so that we can use NULLRTBLOCK to determine if a hint was set or not.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7f20bc412d074..7854cd355311b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1272,7 +1272,7 @@ xfs_rtalloc_align_minmax(
 static int
 xfs_rtallocate(
 	struct xfs_trans	*tp,
-	xfs_rtxnum_t		start,
+	xfs_rtblock_t		bno_hint,
 	xfs_rtxlen_t		minlen,
 	xfs_rtxlen_t		maxlen,
 	xfs_rtxlen_t		prod,
@@ -1286,6 +1286,7 @@ xfs_rtallocate(
 		.mp		= tp->t_mountp,
 		.tp		= tp,
 	};
+	xfs_rtxnum_t		start = 0;
 	xfs_rtxnum_t		rtx;
 	xfs_rtxlen_t		len = 0;
 	int			error = 0;
@@ -1303,7 +1304,9 @@ xfs_rtallocate(
 	 * For an allocation to an empty file at offset 0, pick an extent that
 	 * will space things out in the rt area.
 	 */
-	if (!start && initial_user_data)
+	if (bno_hint)
+		start = xfs_rtb_to_rtx(args.mp, bno_hint);
+	else if (initial_user_data)
 		start = xfs_rtpick_extent(args.mp, tp, maxlen);
 
 	if (start) {
@@ -1416,15 +1419,16 @@ int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
 	xfs_fileoff_t		orig_offset = ap->offset;
-	xfs_rtxnum_t		start = 0; /* allocation hint rtextent no */
 	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
 	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
+	xfs_rtblock_t		bno_hint = NULLRTBLOCK;
 	xfs_extlen_t		orig_length = ap->length;
 	xfs_rtxlen_t		raminlen;
 	bool			rtlocked = false;
 	bool			noalign = false;
+	bool			initial_user_data =
+		ap->datatype & XFS_ALLOC_INITIAL_USER_DATA;
 	int			error;
 
 retry:
@@ -1433,10 +1437,10 @@ xfs_bmap_rtalloc(
 		return error;
 
 	if (xfs_bmap_adjacent(ap))
-		start = xfs_rtb_to_rtx(mp, ap->blkno);
+		bno_hint = ap->blkno;
 
-	error = xfs_rtallocate(ap->tp, start, raminlen, ralen, prod, ap->wasdel,
-			ap->datatype & XFS_ALLOC_INITIAL_USER_DATA, &rtlocked,
+	error = xfs_rtallocate(ap->tp, bno_hint, raminlen, ralen, prod,
+			ap->wasdel, initial_user_data, &rtlocked,
 			&ap->blkno, &ap->length);
 	if (error == -ENOSPC) {
 		if (!noalign) {

