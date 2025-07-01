Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4281B95B
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393296; cv=none; b=cCzU5l4K0L0k6QD6o0YhgMXewBxeKe0koQz3uKBu+iQEZDlENVrc6X0TU1XsRxmRFXrPGEz3hN0evVgfv+qTcQAwgikiW5gOuKoB8AHKu28mjzze7XBKCiqm26MdfqN/p3U9P1I9BfL9pHBbO9pj0JDdNWVg64PJkko/2p3D9+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393296; c=relaxed/simple;
	bh=WM4tiVSbTkzaPGM5XP8eebXcOj9SUTdp76MLP92ZzVk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q/uvdXoRoOiX3pn/Y3xoKxPcW3dXKt8zcAKvbsHhNynfVoKAT2pLWaPT9jagxglsg0kBTArtFxGc7vV0Q2Y2XhvUUmcNcHMXCTC0eghxcEd30nWHEv5fhLIppY+/BwNJnfUIsj6jjKYDO4wIIcIfIpM/oPCi4PeoQPb75+N9cHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6s20mjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6s20mjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DF5C4CEEB;
	Tue,  1 Jul 2025 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393295;
	bh=WM4tiVSbTkzaPGM5XP8eebXcOj9SUTdp76MLP92ZzVk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e6s20mjbbxQDOcQzH+P92UbIS1P8Q3+GD62K5LnGE6E82ReWTL4xT8cjeU2o1FjQF
	 62sUZJOwTbuJt/LBzRaOZ/MN5JZJS7n/dmuXxLoEWK/iNrlJhPR+N5l8SnmotGcU4N
	 3jhehjbENx/7Zml8sF8jlphByWobvTDH7WfEFnKxmU6XbR3GJD1Kgsixf1h+l2U52K
	 o2rruywMBRRwXAn/LAA+MgUe+gHzAAGHVmBhh/df+2kxNvdmbIW8mm2CJZC8Ky/MYs
	 R5uUv2onJe0gdFXQAJeKia7i8XuDoxGn4k7QgdHt5vJLtC7js21J0gb32q8pjVW4Ck
	 /hl/vtuTM2obg==
Date: Tue, 01 Jul 2025 11:08:15 -0700
Subject: [PATCH 5/7] mkfs: autodetect log stripe unit for external log devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: catherine.hoang@oracle.com, john.g.garry@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <175139303929.916168.12779038046139976787.stgit@frogsfrogsfrogs>
In-Reply-To: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we're using an external log device and the caller doesn't give us a
lsunit, use the block device geometry (if present) to set it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8b946f3ef817da..6c8cc715d3476b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3624,6 +3624,10 @@ _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
 		   cfg->loginternal && cfg->dsunit) {
 		/* lsunit and dsunit now in fs blocks */
 		cfg->lsunit = cfg->dsunit;
+	} else if (cfg->sb_feat.log_version == 2 &&
+		   !cfg->loginternal) {
+		/* use the external log device properties */
+		cfg->lsunit = DTOBT(ft->log.sunit, cfg->blocklog);
 	}
 
 	if (cfg->sb_feat.log_version == 2 &&

