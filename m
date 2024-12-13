Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8980A2F4A
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052606; cv=none; b=sXFAc/Md/Gd+R7WT3LZCsNmpWimmqC1nedOL9cJ/G0Yo7vhJFxLDALLldndMC+/heUeTLxZEATQU5tWZiGIZ6U1SyxHBc9tbvFc6sXIIEzBz/spdM438fTXef/NQXrpmGsKWf/L+bpI5s42LuTGYVP8IjgTZSP8687vial+XmwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052606; c=relaxed/simple;
	bh=yLWeIeFlMJR9KaaG3By3tG+ZNcrXFKqVxj6yQdDkHwU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lCN2MQyPxKJIZsLeP3/To2Nsj6sac/0BzcVY2JM6DE71XQPQG4aZDlIU61Qtq3A16E9a0pvG2R65B7qZWrv7UizDr1gTqPOFRWaNYgRBPNpjOzwY0Xk0tBR+CmpSC1dBffXdYBcfwUaflJeRYZCiY8NiFtGrrdb9ykGcBQODO5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBXrsWLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBXrsWLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056F7C4CECE;
	Fri, 13 Dec 2024 01:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052606;
	bh=yLWeIeFlMJR9KaaG3By3tG+ZNcrXFKqVxj6yQdDkHwU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rBXrsWLuZcR+4/KcFnKf571UshAIr8d1B7k/2ciBthe604pcCratqoW1prCQvo1TK
	 C/41elLCzAvfZlyWiRUkdHwBTXNmkaixZ+UbLzvoi11+kcilg+dVLsI8BtwB0Escyr
	 f8ZyiO7z+gbD8sORNqGj1hvqyD9qmIrtJ2BixLuuMWyzU5VAnrs68RBREb8YolkHlD
	 kdBU/Ud7WZCzzNYqBccHxv65r78Z0Oe0UcrFPRHtTuW3w2AlGeaKJEU+l8L7EnQERU
	 L8d6153bb5P1Dfj950eWi+hy1OAQh+UdvzOkyM6kfRHFUfoD99OjtJWl6/ihgcYm6J
	 sQ8lwmZfDGSiQ==
Date: Thu, 12 Dec 2024 17:16:45 -0800
Subject: [PATCH 25/43] xfs: enable extent size hints for CoW operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124995.1182620.912936243410911232.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

