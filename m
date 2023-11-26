Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cz1QhwqS"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524A210A
	for <linux-xfs@vger.kernel.org>; Sun, 26 Nov 2023 05:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=euM8Z9z2twfbPiyA0O961SitAyXhfVNF5WGN7FoNOy4=; b=cz1QhwqS0Ac1cV6eheSNLJ74nn
	QXhH1gm0TcUoGv0Htd1FEt3BAAVU959wraaMSQTYEXkE71KerXRjHaTd/I6S4T8JHWXkh6k3M1k6T
	ZmkPvvPXTX+f0qTv+iXvPshnefmWCDRSJsv+wMdvEahFEBvVfiE+NGbZh71Gss9EfvICZ5lwJilpa
	J/havJqORCcjMGWSLRewrIQJ4JU2vjP9v9bIZUDRszr4E7Q75mtMiJiAMA6FTgVVS/V514elkudyo
	oMZhaoC0yqy9C2+4FYuK5cdwJgX/IzB+YVtySD2tntZHH6TWxcre4qDMcs0clUnPZ7QWDMo5z2ioV
	RxXrxXLQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r7Ela-00BGmZ-2P;
	Sun, 26 Nov 2023 13:01:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: clean up xfs_fsops.h
Date: Sun, 26 Nov 2023 14:01:24 +0100
Message-Id: <20231126130124.1251467-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231126130124.1251467-1-hch@lst.de>
References: <20231126130124.1251467-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use struct types instead of typedefs so that the header can be included
with pulling in the headers that define the typedefs, and remove the
pointless externs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 7536f8a92746f6..44457b0a059376 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -6,12 +6,12 @@
 #ifndef __XFS_FSOPS_H__
 #define	__XFS_FSOPS_H__
 
-extern int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
-extern int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
+int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
+int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
 int xfs_reserve_blocks(struct xfs_mount *mp, uint64_t request);
-extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
+int xfs_fs_goingdown(struct xfs_mount *mp, uint32_t inflags);
 
-extern int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
-extern int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
+int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
+int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
 
 #endif	/* __XFS_FSOPS_H__ */
-- 
2.39.2

