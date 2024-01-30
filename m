Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED2D376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591213; cv=none; b=FXYgW7M3H+KrdvH+pUo20UJlDyrUW7aTuakFsTgx0+yFv4GcPSZwCkC/b3f8NC4kG7VJ8guXEA/XYmBS1qOrFCy0m1aoqLry758Ua966GA3elBaaJkcISfqCyQ+JvJ6pxoR3shv85Z89R+zhvt9b2MRTiR+A071uVtvvGfAqGKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591213; c=relaxed/simple;
	bh=9aUrKf5BXd+OWo3Ue8bjFRFzXg+fcxzYrzeEwkOMBII=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i2m/UVKoevTpUf8QceZIZwoi7qGWbP9+ewAsgnDN6Ea7R6w8iF6uLakZhmLBH1/QL8PUfCHfja/FnYeZETvfV0hha2GrzXRg8+08ggjWHYlRDXa/2DAroREUq8X7Bm45y+Xm7IF/13/bAJp78eDZPCC2AaD+SS+LcoH+KaHM4P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DhtW9tLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhtW9tLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E42CC433C7;
	Tue, 30 Jan 2024 05:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591213;
	bh=9aUrKf5BXd+OWo3Ue8bjFRFzXg+fcxzYrzeEwkOMBII=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DhtW9tLtFg4YxlDfM2r3KPjeyZvta1Fe4HVZJLmGUVbXioG2YfJmD9GHRF4KX66Wt
	 LsrnBNdZN8auT1TLw4xdLIQbaU6FT7Ta7UZTydxKqww4pQfCNqb1hFfgzdyJXS7H/1
	 PK5sVF0ruYmO9XpSynx9XZmW58OceZTfF4Nrc8JlIcwnZo+gl3S3w6Q17itziPm4/U
	 iJk3uLhLFym9asci6AQPJSzYLoJ1a6GnxRl4XLoZggKS/2UgvNFJDvf8BRI/K0+QB6
	 IVeyUU1HXLVNmKwNv1s9dOdu4ypUl3t77CY+GeicjLxwvQIlzDxKOTzgfkqBCz7miA
	 /Ju/qQLnF4tnA==
Date: Mon, 29 Jan 2024 21:06:52 -0800
Subject: [PATCH 3/8] xfs: create a helper to count per-device inode block
 usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062802.3353369.11902244582318302459.stgit@frogsfrogsfrogs>
In-Reply-To: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
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

Create a helper to compute the number of blocks that a file has
allocated from the data realtime volumes.  Christoph requested this be
split out to reduce the size of the upcoming quotacheck patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   16 ++++++++++++++++
 fs/xfs/xfs_inode.h |    2 ++
 2 files changed, 18 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1fd94958aa97a..5670a2966e19f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3777,3 +3777,19 @@ xfs_ifork_zapped(
 		return false;
 	}
 }
+
+/* Compute the number of data and realtime blocks used by a file. */
+void
+xfs_inode_count_blocks(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_filblks_t		*dblocks,
+	xfs_filblks_t		*rblocks)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+
+	*rblocks = 0;
+	if (XFS_IS_REALTIME_INODE(ip))
+		xfs_bmap_count_leaves(ifp, rblocks);
+	*dblocks = ip->i_nblocks - *rblocks;
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 97f63bacd4c2b..15a16e1404eea 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -623,5 +623,7 @@ int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip)
 int xfs_inode_reload_unlinked(struct xfs_inode *ip);
 
 bool xfs_ifork_zapped(const struct xfs_inode *ip, int whichfork);
+void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);
 
 #endif	/* __XFS_INODE_H__ */

