Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB431422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990547; cv=none; b=aLOojJYRTYrVoq7RYEzuDK1hIFtV/lIZS4fZXuRvC3i1hqjww7ewK3TVPtszgZc8JHbBcO3yrcY3cAqsSRhYpRerZr1snFmMBtepR8EMAVHlWiuPGbEznyV1SnqayJtcPbSelJ0GUu9KXQRtboQ87HNk8iVgYa6k95f/8S71rME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990547; c=relaxed/simple;
	bh=nziJQXVtNGQWDTn/nOrd+uzhPF2xU9JGJeIpLMT9bDo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EOUNNF4MlDa9T+versDl8Ro0j5yL3ERtStROUUTh5KWunuvNVxc/hP2ipjoTIakTFWMxty+mkHC+rg17ErsaJi/3ZAkl2qiZGUQGrwDna8H9y/9YcTowDz+wz37xkaA7BQMMSibjj5ame5QasZYtqSlw8IPePOI02G91gpW5azg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnDn3dRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnDn3dRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3D5C4CED3;
	Mon, 23 Dec 2024 21:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990546;
	bh=nziJQXVtNGQWDTn/nOrd+uzhPF2xU9JGJeIpLMT9bDo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lnDn3dRHGV0OkfuX3u53j1FDOjg0Ew0I22ZJWUFeUUoxYdo1XEBFtwdFfJ8Og5eeH
	 QIKQ2tolt+eSXu795lOKUxchnd1Xk5zqqv8jDSo3ZjpNnTXQt5tuOg0SdKv1iQt+nf
	 ds3rA5C7d7cXIL1e7Xu+xYpvaSVlwhC8lC4BNHC4nWk+g+LtoIHmi6cwZ2lTnnrCB1
	 dKSYo7951HijXbGPZYwJtKoaXTQhhOKd+fkL/gn6mvxDb+zO4SfAXDYd07O3iVgsc+
	 OP+6nNnK0EUTxwSUyIr48Six7CDTfUQR5xp/YXosOpPZCwJlat7K6ROajIfSr2fkc6
	 IdQCr+IbEZiOA==
Date: Mon, 23 Dec 2024 13:49:06 -0800
Subject: [PATCH 10/41] xfs_db: report metadir support for version command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941121.2294268.1474501519126070613.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Report metadir support if we have it enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/inode.c |    3 +++
 db/sb.c    |    2 ++
 2 files changed, 5 insertions(+)


diff --git a/db/inode.c b/db/inode.c
index 246febb5929aa1..0aff68083508cb 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -207,6 +207,9 @@ const field_t	inode_v3_flds[] = {
 	{ "nrext64", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "metadata", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_METADATA_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/sb.c b/db/sb.c
index 9fcb7340f8b02f..4f115650e1283f 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -710,6 +710,8 @@ version_string(
 		strcat(s, ",EXCHANGE");
 	if (xfs_has_parent(mp))
 		strcat(s, ",PARENT");
+	if (xfs_has_metadir(mp))
+		strcat(s, ",METADIR");
 	return s;
 }
 

