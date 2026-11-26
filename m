Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795656651;
	b=gTPLnqfsFdNdgykShdEpvPUSOMD6/I0tPAiVLGqSQI4CbtJW02eYU3PZn5DXhy0AEh+d
	 9qPuZLOEP82hCXieEMYH2QO5fApv1OPsLH1AOgnpxeuIQkcH+q3qzOybe7gx2/2JhLQra
	 QPblAdb/5r03EEODgs5Gmb2TlqluvcjB0r3DWRS4PWoQhOYNWoSb0T8NZyKTg6eF+/7wc
	 p1oohWLruOrXfmCky4qOkurlxorfyUJV2kcCrOFmL9NWa7EfkFeGT/pwomuOdJ17gEB1C
	 5LX4oQhnS9xqNFoIXs69K5Mm3ww1EgjCs4cVhby36EUYW+2BWUJYRZDoZO777U7kVkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795656651;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=P7MA+gIfiY/TuVi4hs/vRyz8aFWmfFjZOeo850ER9yk=;
	b=tdsth3Z9bzBSKFew4QWnj2xaSi1bVzrssOES5j1rVtkPH6bI31lbBlfNyluvAgKnmbDO
	 WG4wAjr+FnnT1ljTiFK3U9p4mYAP4+no6FIn7Gbcu+dVfUbD+AcFVkhAVnCRWO3VoPWSh
	 wA7r97n0OYpiRP30/RADSX/yiOTV/wV/1sN7X+b074SeKtN9ajQ7zXraLRsskb5x8NAvm
	 w19Xv4aKdccxeD0DF0ppSvooNogQNJ4/hUi2gDzykN3IgWrTcOpvTdTq1ArebB8TwFqpq
	 4b3EP9zvPn5aeErUJNXdSoSJLxqyrY8o6jy6t9vIVejEdpr0NGNiSdXnNwWSEKxxOsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=kKILImnC;
	arc=none smtp.remote-ip=117.135.210.3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB58606A335;
	Thu, 26 Nov 2026 01:30:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DB58606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=kKILImnC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=P7
	MA+gIfiY/TuVi4hs/vRyz8aFWmfFjZOeo850ER9yk=; b=kKILImnCeW3uJp8B1u
	FFyUdxozZeaNS7hExPDuAM7eXCGSrm53efPrkD87HLNd4ZvUUqzb2iDe3EaCzs8+
	y3KOeEysnThgsdZo18oHUhsD6+LXxuwSGhJ8xzsjdfjqt8YenhIocT5XhC/eq3kV
	kyEhfkq7beLM0QpEWIA6RzyUM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wB3VCGhiwdr3Kw5KQ--.18805S3;
	Thu, 26 Nov 2026 09:30:10 +0800 (CST)
From: zhangshida2026@163.com
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida2026@163.com,
	Shida Zhang <zhangshida@kylinos.cn>
Subject: [PATCH v2 1/2] xfs: factor out a xfs_getfsmap_del_cursors helper
Date: Thu, 26 Nov 2026 09:30:08 +0800
Message-Id: <20261126013009.533557-2-zhangshida2026@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261126013009.533557-1-zhangshida2026@163.com>
References: <20261123075048.3658960-1-zhangshida@kylinos.cn>
 <20261126013009.533557-1-zhangshida2026@163.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3VCGhiwdr3Kw5KQ--.18805S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFykWFW7Gr47tFykXw1rtFb_yoW8tF1fpr
	ZrJayfKw4kKan7WF18J34jqF4Svw4Fyw48Kr9xCa429w45Jr13J3sYqFyFkayDCr4rZrW5
	Xr98AF18Gw1SkaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zEeHqDUUUUU=
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbC5wKns2sHi6LxwgAA3H

From: Shida Zhang <zhangshida@kylinos.cn>

The data and rt device getfsmap walkers open-code the same rmap btree
cursor deletion at group boundaries and at the end of the walk.  Fold
it into a helper in preparation for caching a refcount cursor across
the walk.

No functional change.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/xfs_fsmap.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 041bb2105ec..fe9093c0987 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -202,6 +202,17 @@ xfs_getfsmap_dev_compare(
 	return d1->dev - d2->dev;
 }
 
+/* Delete the btree cursors used by a getfsmap group walk. */
+static void
+xfs_getfsmap_del_cursors(
+	struct xfs_btree_cur	*bt_cur,
+	int			error)
+{
+	if (bt_cur)
+		xfs_btree_del_cursor(bt_cur, error < 0 ?
+				XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+}
+
 /* Decide if this mapping is shared. */
 STATIC int
 xfs_getfsmap_is_shared(
@@ -545,7 +556,7 @@ __xfs_getfsmap_datadev(
 		}
 
 		if (bt_cur) {
-			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			xfs_getfsmap_del_cursors(bt_cur, 0);
 			bt_cur = NULL;
 			xfs_trans_brelse(tp, info->agf_bp);
 			info->agf_bp = NULL;
@@ -585,9 +596,7 @@ __xfs_getfsmap_datadev(
 		info->group = NULL;
 	}
 
-	if (bt_cur)
-		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
-							 XFS_BTREE_NOERROR);
+	xfs_getfsmap_del_cursors(bt_cur, error);
 	if (info->agf_bp) {
 		xfs_trans_brelse(tp, info->agf_bp);
 		info->agf_bp = NULL;
@@ -989,7 +998,7 @@ xfs_getfsmap_rtdev_rmapbt(
 			xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
 					XFS_RTGLOCK_RMAP |
 					XFS_RTGLOCK_REFCOUNT);
-			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			xfs_getfsmap_del_cursors(bt_cur, 0);
 			bt_cur = NULL;
 		}
 
@@ -1027,8 +1036,7 @@ xfs_getfsmap_rtdev_rmapbt(
 	if (bt_cur) {
 		xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
 				XFS_RTGLOCK_RMAP | XFS_RTGLOCK_REFCOUNT);
-		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
-							 XFS_BTREE_NOERROR);
+		xfs_getfsmap_del_cursors(bt_cur, error);
 	}
 
 	/* loop termination case */
-- 
2.34.1

