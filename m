Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225653BF694
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 09:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784711894; cv=none; b=A9d3+D2DZK9srfg8JTVERRSpQv0SxOJ6+ZB9y70oMgTZsVpfPSY7KeKNJxLUyET2kAWhQYgiNv6fpoiB2nIY7aIk1FFrJQACwoAPM1mnmhBiwBHW4Vi9THqYO/v0WKVWlTnPJLtRfqjiOBzd+KcdB5hnbtigFLVZeFLTfVsd+2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784711894; c=relaxed/simple;
	bh=pmRG0B1rxOGZno4aROONr3K7NnAgrzYuGzGdTpXVs9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IauykM+go5zwCZ+GTdlPFNMK49+ixjofbdt2MY3cCK3LeeRNH7dKOZMvltDMrC619xlJUa2qShfApOw62jY47qPCzdB4jW0duHcv0HwRylkz75S/kFjBr5CdZK0U6O6ZZrmUfrlxhYb2BRqdZi039njWQlIi/hRLaU3sSmrfVl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmupnVEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmupnVEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCCB1F000E9;
	Wed, 22 Jul 2026 09:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784711892;
	bh=aBVKkseGR6L8TUV9amuohMO1UIQVhMxQTLuYjT/e7gk=;
	h=From:To:Cc:Subject:Date;
	b=bmupnVEzS+hyvFic4WVHqfrufiofrxe+w0Ox3lPuaqBLlWW/xM94go7+GHjg46ELW
	 HekZNbnLZHYC7ffEvwSa8XHpROeZKK9wKCoSBiiCxZuL+oxurZY4e7n6+LaB2ygvaa
	 vZrVLWog+XYkcJIa0Rm/ZGF8mmQI4FeKT+ehF1f5O52RZB3gL2HDQTT81BmOI6zwhd
	 UORK/sZO4elii4tjDv2WZJRCDRYA8VYHqsjq6w9j4LhpHQgYn9E3XUdsmKtfN5YBEf
	 yCWRCxoehrYwXlfiaF/4uaNBTr9+SfkB2YIY7ggPUyuvzaK82aWNt8Di0k1FyZFjc3
	 TBSzkyHGhKnjg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	cem@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	djwong@kernel.org
Subject: [PATCH] xfs: fix inverted clearance of inode junk flags
Date: Wed, 22 Jul 2026 11:17:59 +0200
Message-ID: <20260722091801.503245-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sashiko.dev noticed that these checks clear all the valid flags instead
of invalid. This probably was never hit as it only executed on invalid
flag presence.

Fixes: 2d295fe65776 ("xfs: repair inode records")
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/scrub/inode_repair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 3ec41c198351..3fc9a12b494a 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1797,7 +1797,7 @@ xrep_inode_flags(
 
 	/* Clear junk flags */
 	if (sc->ip->i_diflags & ~XFS_DIFLAG_ANY)
-		sc->ip->i_diflags &= ~XFS_DIFLAG_ANY;
+		sc->ip->i_diflags &= XFS_DIFLAG_ANY;
 
 	/* NEWRTBM only applies to realtime bitmaps */
 	if (I_INO(sc->ip) == sc->mp->m_sb.sb_rbmino)
@@ -1828,7 +1828,7 @@ xrep_inode_flags(
 
 	/* Clear junk flags. */
 	if (sc->ip->i_diflags2 & ~XFS_DIFLAG2_ANY)
-		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_ANY;
+		sc->ip->i_diflags2 &= XFS_DIFLAG2_ANY;
 
 	/* No reflink flag unless we support it and it's a file. */
 	if (!xfs_has_reflink(sc->mp) || !S_ISREG(mode))
-- 
2.54.0

