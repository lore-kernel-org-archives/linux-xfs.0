Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90CF2837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995568; cv=none; b=cI8u3oQobadCyFxn3R50OGuOcWLRiFJbQjx4fzdl6t4uhJmnwsQYwDjPxfaC3KoPdyFMduorPJF9lfqRnPu/fFPpNpkqFRLa2tzYsYUc9GIqUzDvVmoK+kN1ZnvuwjNae7w4sEOUh9Vw/gkPqvioLkajUMrZYa5V2qhFJoqkpmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995568; c=relaxed/simple;
	bh=XfLvvQd0zYfgque//5sEmPpK2/NcGcBrEB9ZcfHi8eo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NnT7hRbbGMY+4Q4B8o1sCvR+xDCP4JucRGyJmGv5qftJZc0x9h0YIegoLLY9yUThJsBpC/X/PwzOt+qVognVwm8ZObLBs1FRLQO4lKN0/XMitx6wV6KOZVQDpl6pBX/GFjT5FXJiWGtrZmiS3q0PdG16E5Xrq2KhwPQ58X4ktNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TzUYvf/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TzUYvf/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0E4C4CED3;
	Mon, 23 Dec 2024 23:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995568;
	bh=XfLvvQd0zYfgque//5sEmPpK2/NcGcBrEB9ZcfHi8eo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TzUYvf/z/VDVIYkT/ChvlxqkcbKxBiEfGCNBkBkmMQrgHl1NIHmPZzUfenqv9SX/M
	 Qy5U3HOZrc4kiwh/yqXTfLirX8bBdhYeEbwu69oezDPauvAGNv/fM04z2l3mdWnG4O
	 Aa07pSWP7roXEE0SEoHxAB0qcVS5EDy16leGzs2hZ8u9tPk6b3/pbmaWPhHswWk9CM
	 PM2nyLcpdZxjfh6W/wi027ItFAd4Rju72bCV9BhPbTOzPEtJfsNNvNBLsPz3tvhbDw
	 oTXbfOZ8qYVFv0ZI8o3PaKsSO70W/pP1PEDKJqGBgQmP4JC0qZEZoCiRK0SZ34juAY
	 HA5ZBetFiLYbg==
Date: Mon, 23 Dec 2024 15:12:48 -0800
Subject: [PATCH 25/43] xfs: enable extent size hints for CoW operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420367.2381378.5631497253218351195.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Wire up the copy-on-write extent size hint for realtime files, and
connect it to the rt allocator so that we avoid fragmentation on rt
filesystems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |    8 +++++++-
 fs/xfs/xfs_rtalloc.c     |    5 ++++-
 2 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ae3d33d6076102..40ad22fb808b95 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6524,7 +6524,13 @@ xfs_get_cowextsz_hint(
 	a = 0;
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
-	b = xfs_get_extsz_hint(ip);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		b = 0;
+		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
+			b = ip->i_extsize;
+	} else {
+		b = xfs_get_extsz_hint(ip);
+	}
 
 	a = max(a, b);
 	if (a == 0)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 294aa0739be311..f5a3d5f8c948d8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2021,7 +2021,10 @@ xfs_rtallocate_align(
 	if (*noalign) {
 		align = mp->m_sb.sb_rextsize;
 	} else {
-		align = xfs_get_extsz_hint(ap->ip);
+		if (ap->flags & XFS_BMAPI_COWFORK)
+			align = xfs_get_cowextsz_hint(ap->ip);
+		else
+			align = xfs_get_extsz_hint(ap->ip);
 		if (!align)
 			align = 1;
 		if (align == mp->m_sb.sb_rextsize)

