Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A641A1845
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pbmFY+4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CC1C433C7;
	Thu,  7 Dec 2023 02:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701915879;
	bh=FlQecoIai3EiUzeAYTa7gxR6N4qrHddRaKSM5r++MCw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pbmFY+4QKfQhAR3ujzPAd5tZuYIiASZWoEgDXHubVNgDgH1qJ0zyEhfs+cMdfWYB4
	 Xq7zFh2HvdXhpTNiP/iC4dj+uFUUXqisOIn2b0oYn5BZVFWIzxkL/adby8eYperoJG
	 U1QZS6O9kAzdgJ8TE8EuWF/RbyRUf7IfweJ1D63+7ynQ6F1AsEDrZoqawuYXdqWCM8
	 jNOnVe1+9jlTsiP0AviVqzDLs+KEzXmQRF3Yi2T+4nFOaVoCnTCLIBDbeh5xuugbUt
	 HmlwaFspJA7/a5nhSgoMUI5x4HBJlVIvXr5GUNgtDBZ7fSUGGKVgA2qruMMAi8A0z/
	 hWewLR9lHophw==
Date: Wed, 06 Dec 2023 18:24:38 -0800
Subject: [PATCH 6/8] xfs: dump the recovered xattri log item if corruption
 happens
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, leo.lilong@huawei.com, hch@lst.de,
 djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191561986.1133151.8095029110077342876.stgit@frogsfrogsfrogs>
In-Reply-To: <170191561877.1133151.2814117942066315211.stgit@frogsfrogsfrogs>
References: <170191561877.1133151.2814117942066315211.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

