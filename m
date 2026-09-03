Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A70D48C8AF
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435702; cv=none; b=JRLMdli52o6dMgRslEDZZuHbk2efC1p5ACL0XT/y6BA7dbmWsyDpEK5RBna6hfqBvfXAbaKbcz3B/M40plE0xcBkjveVAL8Dr8yUiREJpUm2ndTcyvQo45IBevgRbHPoeix2FQAZEGDm/LbeB/MZRHtYcp9mH1wlB8oTVU24g+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435702; c=relaxed/simple;
	bh=7cIva+Eg9xuo8uJFAdAsyrYc6ETXe48Kw+fc24NtbM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aE9UmrGiEzM4pg/CdZhn3gNuSAr3zCHUTIHSczRYZYnCDFlm9fYgwULRJkYSiudM3tWj2H5CYQXdz/4HCRNfxNh07XGGIJsJcVv/PpZ2Uq9wQV6HwqsvtYXsP7Ed/ap9CwNzYApIfASr1nqY9CK6lhveLiIKcYFmjvUC3oH5rs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2zrdpzE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2zrdpzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E501F00A3F;
	Thu,  3 Sep 2026 11:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435694;
	bh=24l209I2LzH4OtG9ghTlQdgof2jpBCePllm/rLdxsQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2zrdpzE9/D/JfJ5fgnXhAKr1ApnK2japToKstS/irPUSm3Y3I0WCIN8SEeDvBJhR
	 az1t5glCKfPSV1ZkKIC6TXUJyI1uc+J63JJaeCUY5C8ciRFr9KZmBpBLol9G/4b+Fe
	 W8vHw6Qm/wS3ToUvaHL+rs4Mg1LuMc1ag4jfUOS4svmPF5190uVowt1eYSrogdu9Dc
	 dGQgaHQAdO9GepfOsGiSOyeJtqYYyZR3Lrd1Md92QgVcbRFQXhu422NnqBL8Vodf6i
	 5MWkqpbrhShii+iG6Q8IQZ1+4CphEipxzZ4NIbSbUiXwolLfbqJC9jSLEaInleUTro
	 51+ppo0bwNX3g==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH v2 14/23] xfs: mark struct xfs_imap as __packed
Date: Thu,  3 Sep 2026 13:39:56 +0200
Message-ID: <20260903114022.570210-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 4f16139d8e296ec5403c3ebbe874dcd5c57648ca

This returns 2 bytes of padding at the to struct xfs_inode into which
this structure is embedded.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_inode_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 57192adc7744..f3624532b023 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -16,7 +16,7 @@ struct xfs_dinode;
 struct xfs_imap {
 	xfs_agblock_t	im_agbno;	/* starting agbno of inode cluster */
 	unsigned short	im_boffset;	/* offset in inode cluster in bytes */
-};
+} __packed;
 
 int	xfs_read_icluster(struct xfs_perag *pag, struct xfs_trans *tp,
 		xfs_agblock_t agbno, struct xfs_buf **bpp);
-- 
2.55.0

