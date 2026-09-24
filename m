Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40C344E662;
	Thu, 24 Sep 2026 10:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244148; cv=none; b=KclfWdx9CE/W7SdNnGf9jOrbm9SAzIcHhkZMk3vJxooM3aAixoz6lMM6MxV9+DUTR+UiIst+4QXM5B8Ndk7JAGPcCNMCLPdTa5Ve9Nh09/FJCZSuH+ILhbbh0DtI1oYQQLQAMHkmLKmPdhGIZRpD9CLDmET9Pr42RTF83zhPZzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244148; c=relaxed/simple;
	bh=8E5zvgkxqfoDE172o0vgx3WiL48qr+oOljKrrCrd9xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m31Ctpp2OwiFa5A33T01mf9ag0YbaIHv9L/MVLqJErJkqtN9ECWFVZp0fO0GqDxdIPWPrGGzZD92bEF3VHZ6AFxYzpgEOare1WaSdlixDlGgOF6P5YL35f2cZoYr5ls1T/Ufr1jAtNH21X/ZIzg+2O1fTU2lNIyGu6lkIcE9eMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i1hfWxWO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i1hfWxWO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=w55yEHLDsLjykarlB58vQpbheuFIhN1a5bzST/zSKxo=; b=i1hfWxWO6AZSMTuE++b/6foTYw
	9aSxGh4Pz61GGHhlJlNrwunscoI07CjugY3kNYKUE4a4gI9GOn+pBdps2jJ5scdjsnmPAGuvjqKBM
	yYeDm1K0jRoTIWmuu26clMCIBWxf8NBuuK7yf2Wm15zr7u0E9XLlIndRi0HDPZmm1vLGksBf+9H/N
	TsubJwFNcATcrbgxrl/2o2lhJhoJ8/UjZX8O0r4ujZ0/wELi856TFUb0uGe21mqCzh1rb9OT/8QQS
	VUos5IPUfU8mQJmeujyCtryPO59d7kqVcH5zXku1j0SkAVEc1rXiDMlmUy3Xj7PoM6I46S1TD4UeJ
	xPEJdlAA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gHR-0000000AeiM-49dM;
	Thu, 24 Sep 2026 10:02:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 20/21] xfs: add an experimental feature warning for RT data checksums
Date: Thu, 24 Sep 2026 11:59:52 +0200
Message-ID: <20260924100032.2733101-21-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_message.c | 4 ++++
 fs/xfs/xfs_message.h | 1 +
 fs/xfs/xfs_mount.h   | 2 ++
 fs/xfs/xfs_rtcsum.c  | 2 +-
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 0243e509a468..53e8ed976a9b 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -149,6 +149,10 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_LARP,
 			.name		= "logged extended attributes",
 		},
+		[XFS_EXPERIMENTAL_CSUM] = {
+			.opstate	= XFS_OPSTATE_WARNED_CSUM,
+			.name		= "data checksum",
+		},
 	};
 	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
 	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 811b885f41c3..d858e93e5426 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -93,6 +93,7 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 enum xfs_experimental_feat {
 	XFS_EXPERIMENTAL_SHRINK,
 	XFS_EXPERIMENTAL_LARP,
+	XFS_EXPERIMENTAL_CSUM,
 
 	XFS_EXPERIMENTAL_MAX,
 };
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fa86697f463a..c62eb42e490a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -586,6 +586,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
  */
 #define XFS_OPSTATE_BLOCKGC_ENABLED	6
 
+/* Kernel has logged a warning about checksums */
+#define XFS_OPSTATE_WARNED_CSUM		8
 /* Kernel has logged a warning about shrink being used on this fs. */
 #define XFS_OPSTATE_WARNED_SHRINK	9
 /* Kernel has logged a warning about logged xattr updates being used. */
diff --git a/fs/xfs/xfs_rtcsum.c b/fs/xfs/xfs_rtcsum.c
index 7cdc5a5029eb..47a7b67f7412 100644
--- a/fs/xfs/xfs_rtcsum.c
+++ b/fs/xfs/xfs_rtcsum.c
@@ -310,8 +310,8 @@ xfs_rtcsum_mount(
 	}
 	mp->m_features |= XFS_FEAT_DAX_NEVER;
 
+	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_CSUM);
 	xfs_info(mp, "using %s for RT device data checksums",
 		xfs_data_csum_names[mp->m_sb.sb_rtcsum_type]);
-
 	return 0;
 }
-- 
2.53.0

