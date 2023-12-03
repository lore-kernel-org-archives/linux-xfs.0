Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5134517735
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tkKCcLng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27748C433C7;
	Sun,  3 Dec 2023 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630131;
	bh=2bijz1zZ7NohtfXRxXgBU6tM0T37TLfItFIVA3FtCoo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tkKCcLngkK4ZupK3Su3sC+SYYz+vgnbOxDTPRSNjJwzz0OgyxdRg9hNOcNu7UnZoI
	 d56k0rgz6CciJFeYl1IrWNH/pYqfTl8TWifoHBH9rcwlAr2VUkI2r2PSrqFpKmhTXk
	 8N/LaAlbH2Mh4aTCY2BYSdavM/XosTIR7kURUzXNhTb3nF6qhBXkLO323MANu8zAtA
	 Nv7CYLjcw19CpQW5w07Z44URTxw7xxz7aPH3MIKfePRBhkJgm67K4XnYg1nvb65f5N
	 v7cKelL4BcuI0Xa0ba4CLQ7Q5fv5LOL74XFhMokBfA8sAYezvr1IbGahlwlamCsgI1
	 VhQaMPBDH68oA==
Date: Sun, 03 Dec 2023 11:02:10 -0800
Subject: [PATCH 6/8] xfs: dump the recovered xattri log item if corruption
 happens
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de,
 leo.lilong@huawei.com
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162989802.3037528.5252429066673340449.stgit@frogsfrogsfrogs>
In-Reply-To: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs>
References: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs>
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

If xfs_attri_item_recover receives a corruption error when it tries to
finish a recovered log intent item, it should dump the log item for
debugging, just like all the other log intent items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c4441eacf51c..c7c308d2f897 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -666,6 +666,10 @@ xfs_attri_item_recover(
 		xfs_irele(ip);
 		return 0;
 	}
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&attrip->attri_format,
+				sizeof(attrip->attri_format));
 	if (error) {
 		xfs_trans_cancel(tp);
 		goto out_unlock;

