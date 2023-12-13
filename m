Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695D78183A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EyDhTsrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C174C433C7;
	Wed, 13 Dec 2023 22:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508043;
	bh=HqIUrH7N8vUNXw46qEn3SjsMcpQt0F4X72c4QAJXGmc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EyDhTsrRasolpY4Dixf8a3fsPLE349yyPQ8ha/R1dQqlv70S/T+JNIcTjQIqkKdW0
	 QnLJh5eJvjT/ISkxDM2+dyqtaswRPFw1AjkR5+45LeskDrbHqdnNJdLu6GVSW1/iSh
	 UK1F2WH1PDIDELJQ+I+hQl1Tj/i+EqELB6W2Sq2j9+7FJ9wJfhs/nzwDTMDO3n/y9L
	 T/KeqOdfw18zuNgz39yYAXtvuy+t2vHDbOSsNENiVNm5VQAVUFpIGDppXDY1y8vbyG
	 M9Ab8pdORPeHxjWq4jNiym29PmSF6+0HyYCre/XG2kPDzLcsq1cgjeXdHOjMdfavgy
	 oOkXROFkik7SA==
Date: Wed, 13 Dec 2023 14:54:02 -0800
Subject: [PATCH 3/9] xfs: add missing nrext64 inode flag check to scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783515.1399182.15025735208882818074.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
References: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
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

Add this missing check that the superblock nrext64 flag is set if the
inode flag is set.

Fixes: 9b7d16e34bbeb ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 7e97db8255c6..6c40f3e020ea 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -342,6 +342,10 @@ xchk_inode_flags2(
 	if (xfs_dinode_has_bigtime(dip) && !xfs_has_bigtime(mp))
 		goto bad;
 
+	/* no large extent counts without the filesystem feature */
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && !xfs_has_large_extent_counts(mp))
+		goto bad;
+
 	return;
 bad:
 	xchk_ino_set_corrupt(sc, ino);

