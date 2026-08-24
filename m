Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254A34052BB
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571999; cv=none; b=pigIkbFDoq4uTKOkzz3+4YgqSmncYP55N1gS9Pss1PU6xD+BNwaVAxeYLv/QcbvBo4zeibQQti/gv1flrmIATGsRWuMTnYSfo0/pLiViTg8xcQcL0tSatrL8Ka0bDQkBN7ElwMzm8eG0QB+/6RQjDt9rvGy951Jy/Jy/HYON14A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571999; c=relaxed/simple;
	bh=RX2t8EwYttVZZxu23DOUa2tk9cwjE9Ii+ZwfpNg9oS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gV5D5IQmtjqqcNmO2f7aE6Xua2Y3eajUsA/GMuj6+TiUSB7UTBSALahecJ3jCFMYej0G08wslf+3JFcHm72CMSa5px8N24SGMVC8rdzm9U+SrUvvwJGV9sUAenODTmarFDXkYwAJgJnKT1xzd1GEt23xWCgvbsyVu/mkMVGwhWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XiaPk4iD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XiaPk4iD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F3D1F000E9;
	Mon, 24 Aug 2026 11:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571998;
	bh=oottIkmZp5lHChWjaL2nMGqTss0zAc30qdb9w2L9amc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XiaPk4iDAYiNEuc/WytqQdI1D8fA4RKPaSrSgacI5TmvO+RGEhoHFSiPm4TrYgi9Z
	 ne3ONHfTsTDMYfGr+loddUKiS+1CEa3u3iSwsbnYFWXarSLVnOgFZVAXku8xKGxFYJ
	 wqMH+SJwS9Au5XDRG9caMbeyttDy20k3nznv9dPpobQGrNEWsHehR5+JEfjG1jYuQR
	 S/S5DDAzXGZKfmdQ9Ob1/FCbOWjoY09yvo4fKFVN46XfRqYeL96yU+q7W0lvzxi1k+
	 Tn1Byofa9wRqvvh2Z9FEnqNgBXKl0Ud9GvnKVjRgs7PWu0TocrgCWPQQYIxBhAdcmy
	 ZB0R+fTk0YkFg==
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
Subject: [PATCH 13/21] xfs: mark struct xfs_imap as __packed
Date: Mon, 24 Aug 2026 12:40:11 +0200
Message-ID: <20260824104022.420566-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
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

