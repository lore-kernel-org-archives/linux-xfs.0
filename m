Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67323493656
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435747; cv=none; b=ZurE2od67y5xhZ9BAUm69dUpRXnQbyaolLm90OvewKZ6yN7c+vqrrdHkafjZauBgQ+Fok0vG2ZjPPHni7bnW/olRgr8rtjRSUuO2lKYo0XXl6FKN6xjJqv8ouYqRvykBUNHEXoajIro1ImnC5n+5Aqbaw85swmB3yD3NI7Yg7r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435747; c=relaxed/simple;
	bh=v6XBl7bMUOOP10MaaScPx3rRf/NRTFqlvzrIzZG9278=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iT4+bw+cqLhCQSgOClXUcjypz2+NW4OI7rmjFpSzluU3aVIcSvrMoaTluWQgbM2JAALJOtcRnjphRH4ADGbgI4baTLeHdNk1CSbPH1MgMcrqYGS0V0TMg3klIC6HE4JMCHfqmcowU2aR2cOU2psD8Nv+Poa1yBMCpILBBgoit+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9eojbdl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9eojbdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244B31F00A3E;
	Thu,  3 Sep 2026 11:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435722;
	bh=koFWBEpamxhmmyFaNYU6tz05UHjjYiy2PYzUtQ+Jk68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9eojbdlFJWNuREW6lLXWmV9u5rTfh7gj6csDgIr3S+ix/5JuxdqKQ0MDOiHoQWhJ
	 YBSr9hPxqShThKyQRaQdm+0beEnsct0RmGiuWZyz+fH/g723CEMztO0/hFr1Q+wJJL
	 Hyd6/+Fblhm/xaUyBuItDKqxBvFt/sCii6Of5nAL/Yca48jAbox/1jaNxm9zCBL9gy
	 qVNs1I/JPFM0CwyzPsc/b3fu+vmU8wGvMldYeQJuaxuBDZpiu12y1ESaOmgGMlaY+q
	 3sWfNNVJI3C4NcLLIg/jWPS2ghSBU4OA9D1Z/a+Xcl9mWzLOBva1nXyNdPDe70wUvJ
	 UuYWeFtur9DrQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu,
	Lin Jiapeng <ljp1205831794@gmail.com>
Subject: [PATCH v2 22/23] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN
Date: Thu,  3 Sep 2026 13:40:04 +0200
Message-ID: <20260903114022.570210-23-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lin Jiapeng <ljp1205831794@gmail.com>

Source kernel commit: b2d5a81dae385333f9734910277fbf94c78bd17f

When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
can move the reflink inode flag from the file that currently has it to
the other file, as long as exactly one side is marked.  This assumes
that the file contents, and therefore all shared extents, are exchanged.

That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
from file1, so an exchange can complete without moving every mapping
that the earlier flag-swap decision accounted for.  In that case the
post-operation cleanup can clear the reflink flag from an inode that
still owns shared written extents.  Later writes then take the
non-reflink write path and may update blocks that should still have
been protected by CoW, which shows up as data corruption between
reflink-related files.

Fix this by disabling the reflink flag exchange whenever
XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
proceed; the conservative outcome is that both inodes keep the reflink
flag.  The regular reflink flag cleanup path can drop the extra flag
later once the inode no longer has shared extents.

Reported-by: Lin Jiapeng (TencentOS Red Team) <jiapenglin@tencent.com>
Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_exchmaps.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 3347dee2c1a8..78bd421b26d5 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -956,6 +956,16 @@ xmi_can_exchange_reflink_flags(
 {
 	struct xfs_mount		*mp = req->ip1->i_mount;
 
+	/*
+	 * The INO1_WRITTEN optimization can skip exchanging hole and
+	 * unwritten mappings, which means we cannot guarantee that all
+	 * shared extents actually moved to the other file.  Clearing the
+	 * reflink flag of an inode that still holds shared extents breaks
+	 * the CoW write path, so refuse to exchange the flags in that case.
+	 */
+	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
+		return false;
+
 	if (hweight32(reflink_state) != 1)
 		return false;
 	if (req->startoff1 != 0 || req->startoff2 != 0)
-- 
2.55.0

