Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DD227AC31
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571965; cv=none; b=sKLX9Ef9b11PJuSFpwy1+I5NUc4YIkiuO84dIuJVoM8NL5EtnV+/rj2+UAa0UyflYp9zMRvjGt9/sEICex+bUYWRFJin+G0KDpcRC7T2zWwhf5JRHWA2ojKd+G5BelYbOwSsV0C07jj1Tn2YexoBqS9+AhsnfBM+wHRzRF38OEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571965; c=relaxed/simple;
	bh=gRgX4ta/dIF66hdsN5jbx0MOFnd3HBgRF5rKvWGkufg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVZvV2oOWWqOvYt+CEFLM7X0qJLIcolwyzxqCkxRXETOl6mgdzqdwswF7s8YJZBCnDwnHp+DZ+KpjwClQf3nGlXP5TjLHwtm01B0mUWqXl0U3r5z8vH9yjhgapn7+ivmILPV83RojydUd+bp2PNXSdJvuG7pTGJOPDv/i+4rwZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7vgwgSz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7vgwgSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB2A1F000E9;
	Mon, 24 Aug 2026 11:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571963;
	bh=fNrx39j4ajJWDd7kYj4U78Ck3j3O5MK6ziF3VNvCPBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7vgwgSz0++P4ZBg+8Gl8f2zSQK3e06wnXdUNHHuHQ0Eq2AZ4l/TbX+e/kft3sdu1
	 /naVWtFFoId7pCdQnAQ8BmofwvV0g1sCwhUbBT6jVC8im9jJWDXaBuPmwuVwa3eS2V
	 cUSwR9FRkAE+Nvj6M8p2gxfjaOWwsqSSl2JT8G9qA0odJISVW2eVLpQYhTw/AIRx//
	 PZlPUBavXTEW9R7Z8SKcy3EJBxEaxS6wtrvrYeS02+FEjWvgcltfRAcbjNeVIuuKgA
	 yqsDSZTOWS7tEF9vIK7rEraE+7CgYXS2eqEQHR7h5kG2CxWmMDxHXPKw7iTL6DCRoD
	 puqTmeQwhk1og==
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
Subject: [PATCH 04/21] xfs: add a XFS_INODE_TO_AGINO helper
Date: Mon, 24 Aug 2026 12:40:02 +0200
Message-ID: <20260824104022.420566-5-aalbersh@kernel.org>
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

Source kernel commit: f46edc9f1310d27710e2b39bf561ecef51f879d2

Add a shortcut for the common XFS_INO_TO_AGINO(mp, ip->i_ino) pattern.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h     | 2 ++
 libxfs/xfs_inode_util.c | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 36a00c174f1e..f812c6782492 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1280,6 +1280,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 	XFS_INO_TO_AGNO((ip)->i_mount, (ip)->i_ino)
 #define	XFS_INO_TO_AGINO(mp,i)		\
 	((xfs_agino_t)(i) & XFS_INO_MASK(XFS_INO_AGINO_BITS(mp)))
+#define	XFS_INODE_TO_AGINO(ip)		\
+	XFS_INO_TO_AGINO((ip)->i_mount, (ip)->i_ino)
 #define	XFS_INO_TO_AGBNO(mp,i)		\
 	(((xfs_agblock_t)(i) >> XFS_INO_OFFSET_BITS(mp)) & \
 		XFS_INO_MASK(XFS_INO_AGBNO_BITS(mp)))
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 8e439dc2f4fa..63b95238d8ce 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -461,10 +461,9 @@ xfs_iunlink_insert_inode(
 	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		next_agino;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
@@ -550,7 +549,7 @@ xfs_iunlink_remove_inode(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
 	xfs_agino_t		head_agino;
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
-- 
2.55.0

