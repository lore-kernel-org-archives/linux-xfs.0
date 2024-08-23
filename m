Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0C0195
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371847; cv=none; b=lE3Lx8k91b1jEeP3/B2Nlu6wKo0ZpIX3WhS5tU266LLNGC7DAUzCKpOB8Wg/DZivm2WuQcOeHfy1ot5jM/7qfDuTndLdm59GINmHLnjpGb280cUtn5H4wvFASJjBBsgb/yqn+A5LQx2HAKpKqiAwriS808hZivSc5jiZKKd1TcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371847; c=relaxed/simple;
	bh=hMaYFX1/S+cV07J1bb4Hyzo4by/2tw109a9qnFX8OM4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sUXolWTCIM+GcDsGqG6ZFmlpDgUQqFroVN1NHdFmt5/QEnE7Fwxy+wHt/O+CmTyIxhdI5Hkrkyz5Ui1b7snoMGOHta/jvEX7Fvv7vFe9Y9W/Q7cPR91kh0bNWWyifDpisrP+WOk7UANJ1xmmR3i5FE8EbR7ntVD6UvPOI89+azE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Walbqk4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Walbqk4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24C7C32782;
	Fri, 23 Aug 2024 00:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371845;
	bh=hMaYFX1/S+cV07J1bb4Hyzo4by/2tw109a9qnFX8OM4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Walbqk4GbwxtaGXHKMVZGwOuHpMLZ3BjUKCnyhzxqZTih8sJYEDUhqNDiEdd6/5Q8
	 hiJ1w0fliC2Y2l6kCTY4EFYUQD96Q6b+ucEqP46xaffdr/pg2Ua3JI0LQ9xNZEVeia
	 PKF6T0BS5mBzfUM8o7OvgREqKG5WqSJi85OM8s6ZZGiRXLdF/1stxhXYKbdJrAo0bX
	 OAN4HWHnTDjkulV4vLheZqbPOFmQcthP/639bO2EoayTnrpzw7vYvf0eaX5ap0XjYz
	 RQrP9F2Uk8Xysu7QQNsv9cVRpeFAlPlx49R+tregzslboNiwF+V7KSVQuJLOvaHcht
	 2sI51dZ1ilNPw==
Date: Thu, 22 Aug 2024 17:10:45 -0700
Subject: [PATCH 07/12] xfs: cleanup the calling convention for
 xfs_rtpick_extent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086139.58604.9757741400946849728.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
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

xfs_rtpick_extent never returns an error.  Do away with the error return
and directly return the picked extent instead of doing that through a
call by reference argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index aaa969433ba8a..8da59d941db3c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1306,12 +1306,11 @@ xfs_rtunmount_inodes(
  * of rtextents and the fraction.
  * The fraction sequence is 0, 1/2, 1/4, 3/4, 1/8, ..., 7/8, 1/16, ...
  */
-static int
+static xfs_rtxnum_t
 xfs_rtpick_extent(
 	xfs_mount_t		*mp,		/* file system mount point */
 	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_rtxlen_t		len,		/* allocation length (rtextents) */
-	xfs_rtxnum_t		*pick)		/* result rt extent */
+	xfs_rtxlen_t		len)		/* allocation length (rtextents) */
 {
 	xfs_rtxnum_t		b;		/* result rtext */
 	int			log2;		/* log of sequence number */
@@ -1342,8 +1341,7 @@ xfs_rtpick_extent(
 	ts.tv_sec = seq + 1;
 	inode_set_atime_to_ts(VFS_I(mp->m_rbmip), ts);
 	xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
-	*pick = b;
-	return 0;
+	return b;
 }
 
 static void
@@ -1450,9 +1448,7 @@ xfs_bmap_rtalloc(
 		 * If it's an allocation to an empty file at offset 0, pick an
 		 * extent that will space things out in the rt area.
 		 */
-		error = xfs_rtpick_extent(mp, ap->tp, ralen, &start);
-		if (error)
-			return error;
+		start = xfs_rtpick_extent(mp, ap->tp, ralen);
 	} else {
 		start = 0;
 	}

