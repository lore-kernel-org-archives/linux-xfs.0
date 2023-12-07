Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E0E1845
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFvVrGLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855AAC433C8;
	Thu,  7 Dec 2023 02:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916082;
	bh=TXSw1NoUr7L7aaAvXGsYfmimuraDeVMRnIudSxisW10=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hFvVrGLAldLqnejW5P3dEq9vp2Z8yuS7rCqw8dg3NasUcnD96qU9fg6S/n2hmOCMl
	 qJl4z176iiXh1Ob7T0bMVa1u1PeY4eaGrFz7YMBwjp4L8sGqvuikuoZIsPCG5LS1zg
	 qBF9ffEBGqBATCDUl5K5A9tpMDar2y0WI/R2CZzd+ScABhBnCmVk0QodCio91Y9adA
	 miUjj4dkfkP7yP2JlVWSR2DjQQ0/YI6Kh1Ig++y1dhVl4MZfV4Tws9IMe8C36w0dV6
	 yiyqRAwq7XFncs+IYOofkVRvvEc/oVMGYSWGuPvKBBm8Tgry6WG7ZSxRXkpWuPtmvL
	 kSZKMQ22RDrhQ==
Date: Wed, 06 Dec 2023 18:28:02 -0800
Subject: [PATCH 2/3] xfs: fix 32-bit truncation in xfs_compute_rextslog
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191562908.1133665.16568150380282853858.stgit@frogsfrogsfrogs>
In-Reply-To: <170191562871.1133665.6520990725805302209.stgit@frogsfrogsfrogs>
References: <170191562871.1133665.6520990725805302209.stgit@frogsfrogsfrogs>
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

It's quite reasonable that some customer somewhere will want to
configure a realtime volume with more than 2^32 extents.  If they try to
do this, the highbit32() call will truncate the upper bits of the
xfs_rtbxlen_t and produce the wrong value for rextslog.  This in turn
causes the rsumlevels to be wrong, which results in a realtime summary
file that is the wrong length.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 1c9fed76a356..30a2844f62e3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1132,14 +1132,16 @@ xfs_rtbitmap_blockcount(
 
 /*
  * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
- * prohibits correct use of rt volumes with more than 2^32 extents.
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
  */
 uint8_t
 xfs_compute_rextslog(
 	xfs_rtbxlen_t		rtextents)
 {
-	return rtextents ? xfs_highbit32(rtextents) : 0;
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
 }
 
 /*

