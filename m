Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61592563
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300654; cv=none; b=U6h7Dl9kH3ux3fg2lIKFqwaSoHK4BokhKzQFg4zyUpt+y5g5bIxQ/LWHTIgX6wskU81ZlhGtr1WCbY6E+lR9lEEQxvF+rdHCBKkAIHjAoFQFfwWZyjEYxP38VK+ioQKq8mOqw4pcU2d4Zf/RCVQKt6+DYEMKJZtWHuT363rmMIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300654; c=relaxed/simple;
	bh=xTIMnnubxwLmA9tcjXfYwIoxJ5BHgce+qN1cnPf9r9I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qh6rBkAkm9/xAT9g+RoiIfuJg51niqJ6HNZP9TbAMxZJNmWRGRvUMisU7SdgdWUd1a6AoLsMia7/isM48SBkuMy4vbXbdPyLKH9P0KG+TxHjOwIvw1H8RPFGYAT9qK6ejBWyHJLeIZsmbhQl+oskz09hySCCSkQ1hiL+uqNpS4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pbFDCTkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pbFDCTkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAA9C32786;
	Tue, 30 Jul 2024 00:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300654;
	bh=xTIMnnubxwLmA9tcjXfYwIoxJ5BHgce+qN1cnPf9r9I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pbFDCTkJBLgxvdiOTLyPWFNGgZyQuusUM5VTtDnI4eG+bWkpWHAILzfchhBYzuH6O
	 aiVXBeWOlSsBAgBVmzOXtQkAWGMVp6KgN38ImGyvybWBxX/gm38zaAqB1SSqjZB8tN
	 kcIOQyhxl/pEtgU4cxFxobHErGKS+uwzYUFyrzO2pi7OX7yEnXrB5Uhutws6Fb9mf+
	 dUpeh4Gb2zNUN24blAGTxUXk3IusbuHESroIvBWWDM2957kzkJ4XEq1OIFEABIeZ2s
	 NymgLLthw21yH293+CXEVmT87nDMUMvjDCJiezr4g9pCuNedTPDQdTsHcJyr6pqYaV
	 WMArLb257BNJQ==
Date: Mon, 29 Jul 2024 17:50:54 -0700
Subject: [PATCH 104/115] xfs: create a helper to compute the blockcount of a
 max sized remote value
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843916.1338752.3701572370367235328.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 204a26aa1d5a891154c9275fe4022e28793ca112

Create a helper function to compute the number of fsblocks needed to
store a maximally-sized extended attribute value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c        |    2 +-
 libxfs/xfs_attr_remote.h |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 52fcb1c4c..99648d78c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1035,7 +1035,7 @@ xfs_attr_set(
 		break;
 	case XFS_ATTRUPDATE_REMOVE:
 		XFS_STATS_INC(mp, xs_attr_remove);
-		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+		rmt_blks = xfs_attr3_max_rmt_blocks(mp);
 		break;
 	}
 
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index c64b04f91..e3c6c7d77 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -8,6 +8,12 @@
 
 unsigned int xfs_attr3_rmt_blocks(struct xfs_mount *mp, unsigned int attrlen);
 
+/* Number of rmt blocks needed to store the maximally sized attr value */
+static inline unsigned int xfs_attr3_max_rmt_blocks(struct xfs_mount *mp)
+{
+	return xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+}
+
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);

