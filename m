Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE304C7E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230575; cv=none; b=ezut81+1/NK3PGCsuVGnJCdrwHpT3ajtha54XCeXcA+tU+2xN8DNsO2HA+9F0whd6G2SYEIanZrrrnDsK7YxlxODk8WITauCmJe8Hd94ywrfqe2dFFa0ZUqbYeugYGcSgNGieUOR90RntPB18/H366Mr440RDR3mliAkL/sVjZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230575; c=relaxed/simple;
	bh=BbwWPJHAs41/BiFSXfhdkt4C6ndeFJaPF5/ojM1m4x8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SogbVdz5yyFvaekOFwJN6w90rqy02p9pLNSbQqivIE6UbASBthxiIlCBHhv6b3Kpa41AJ8EndY8u90Z7P0ouVT7tuQIGDzG8gthAyyehW2nY2ix8eauPFrCk1BQ5u5ERje4vSo+Fc7E0pjDBTr5xfnk9/b/7NdHGHzmAdHLCiJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uBFdemEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uBFdemEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5417CC113CC;
	Tue, 16 Apr 2024 01:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230575;
	bh=BbwWPJHAs41/BiFSXfhdkt4C6ndeFJaPF5/ojM1m4x8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uBFdemEpHBKZlM7K1azN5Oxao1VqXQ0TZdg2MGn35O8/0ie1KO0RkYuQDRbJHnD8A
	 NQy5KLz9Gf4dp/GhQjPcJs5R4oNFdyWX9f8b0eF/KMKwujVWwWb4d+TRCfvaVfBAXJ
	 hQYenPskIhbxa4hovsD19Cg4P+UsBPUJtT0o3xvCe5DQg+nb8RpHD4fh/a7jHduNkT
	 2gE+XnsK4HKpScNIgvzk+7L0VpKCcsFVerwDC/lagSbsyNMbJW9PBb7MASzj0wsbFm
	 EEWwYA+7QlfXsDAhAo1kdLr2Fd6ybQ0o5EqyOiAtJIRCCIqxA+IraS4399cWNKQV+s
	 3cPOsKZR5yr6A==
Date: Mon, 15 Apr 2024 18:22:54 -0700
Subject: [PATCH 02/14] xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr
 log intent item recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323027106.251201.3904990345776870279.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The XFS_SB_FEAT_INCOMPAT_LOG_XATTRS feature bit protects a filesystem
from old kernels that do not know how to recover extended attribute log
intent items.  Make this check mandatory instead of a debugging assert.

Fixes: fd920008784ea ("xfs: Set up infrastructure for log attribute replay")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 541455731618b..dfe7039dac989 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -469,6 +469,9 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
+	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return false;
+
 	if (attrp->__pad != 0)
 		return false;
 
@@ -570,8 +573,6 @@ xfs_attri_recover_work(
 			 XFS_DA_OP_LOGGED;
 	args->owner = args->dp->i_ino;
 
-	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
-
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:

