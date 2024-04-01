Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2261C0DE7;
	Mon,  1 Apr 2024 16:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990173; cv=none; b=Jg9L81u3HvgtbBMpY15/gGXQ4b8hGFRwpKjZIFPQxRkJ3QKOG5ychLIGVg56nfM49HcixlI2xNELm1TrCTd53hDKM6eZYsP6YpOBPOSOjRIPnBNRjno81MrE309fNXsKkvVplcqTylvvrHzWuvldkIJhPR0bjJJQ3gXIkyNFTtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990173; c=relaxed/simple;
	bh=glbm2Ug8lQ37rSSsj/72nLzMOnwwpJ+/c1CL9taZbog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1n36B7YMj29/wLNO38C6y+DhG0pRTZVB7PTWmEQYr6mbPTjhyeL0Q96FCdhH4USBBJg+mAh5/k/npwwEDQ2CtQAgfY8YNcczfeOBy3LH5o04UfBpjOyIJFmd5oN6A1BUuajkyiY6R1qX1fjUp/58NlBc4AumOVxpV2U+XcHknw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YL5mWzJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YL5mWzJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29044C433C7;
	Mon,  1 Apr 2024 16:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990173;
	bh=glbm2Ug8lQ37rSSsj/72nLzMOnwwpJ+/c1CL9taZbog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YL5mWzJJq7S+63kqWKm3lqZPqnRSJRDViL1pwloxNrNTmN2BisZn6E6rtDdIY5HoT
	 pSkBlV7uuRUEaC/0qzRLxYhNtheBJEdbCb+yPDyYqhboKb+ArMhsNw+WRhX9TrPs2J
	 xrS3jAuM+WRKO3uf1aRShyq2/AAMMkSVOW+5QLOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 268/396] xfs: add missing nrext64 inode flag check to scrub
Date: Mon,  1 Apr 2024 17:45:17 +0200
Message-ID: <20240401152555.893893661@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit 576d30ecb620ae3bc156dfb2a4e91143e7f3256d upstream.

Add this missing check that the superblock nrext64 flag is set if the
inode flag is set.

Fixes: 9b7d16e34bbeb ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -337,6 +337,10 @@ xchk_inode_flags2(
 	if (xfs_dinode_has_bigtime(dip) && !xfs_has_bigtime(mp))
 		goto bad;
 
+	/* no large extent counts without the filesystem feature */
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && !xfs_has_large_extent_counts(mp))
+		goto bad;
+
 	return;
 bad:
 	xchk_ino_set_corrupt(sc, ino);


