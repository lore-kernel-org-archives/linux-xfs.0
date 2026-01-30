Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AC1347BDB
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 05:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750422; cv=none; b=I7f/hQtQXPllExCTuCmNHxXWHd6+Be6usoatcEMqSQZeIe0oS2VThDbcJ0MTtTt9TS+hDF/7GsDn3q3pS/50SixQMX7UZKCLvG31rfn6fseFqSPMqFFPGTIzIYLPil1/qM+FBAUSqj56/E9ZuMvJTcfpiBt35DqBG365QOYWsuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750422; c=relaxed/simple;
	bh=nOu6DshXjpg8PTzID4Z6QhaW9onniNGYJeDABmepVDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkbHbd5aH8dQexsgkAed5976FLluFov6gf4pA40+Q/1eV9VkLiS/cnZv4yidMoDeNKihjiX+YcFZZ2H5K2hVGsqoZzKLaL4nQcR9zt6u02Z3FGQieQ5J1oFcbtjj0rcfssBrCrXRHzzXr5Kq1YDr58Rz/0EdE1CGaZ12TZPyRec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SdbfQk2d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SdbfQk2d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D2QGJeLKMyAtmCFFukRo7mNJmGb4u5PO798IP6WkeRU=; b=SdbfQk2dPVKPr93So4SgNQLQgw
	8cFiOI4VjDWiRAcC5o2fLbMnCTBMnoVFhaNCK9by7lSE6SvOJsTTTGe/4PQKcuZ0rDLrvKRTJNwDh
	RPInU6H3REEgX1hvL7C+14PU9l0UJAStgBR5Ap+H+iKbMqB0WP7gZcq/GAZvA+sYl8AsiGKNmwcZ3
	c68qdRCcuA9f3RSseSRbKJ/dHFhy+gZVsOZZEoAWr13kGqboMDajUtaHOsnx9g7KUbrlUBM8svhP3
	hEKFQPuq6YmnQsPd2CzHFQKclmFV27tb473y4oCqIZeFGhINwnLIvQaVXBOYaUt1/zq65RHcO79n6
	Gc6v1u4w==;
Received: from [185.190.48.89] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlgvb-000000013Ha-2BIM;
	Fri, 30 Jan 2026 05:20:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 01/11] xfs: fix the errno sign for the xfs_errortag_{add,clearall} stubs
Date: Fri, 30 Jan 2026 06:19:16 +0100
Message-ID: <20260130052012.171568-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130052012.171568-1-hch@lst.de>
References: <20260130052012.171568-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All errno values should be negative in the kernel.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_error.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index fe6a71bbe9cd..3a78c8dfaec8 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -60,8 +60,8 @@ int xfs_errortag_clearall(struct xfs_mount *mp);
 #define xfs_errortag_del(mp)
 #define XFS_TEST_ERROR(mp, tag)			(false)
 #define XFS_ERRORTAG_DELAY(mp, tag)		((void)0)
-#define xfs_errortag_add(mp, tag)		(ENOSYS)
-#define xfs_errortag_clearall(mp)		(ENOSYS)
+#define xfs_errortag_add(mp, tag)		(-ENOSYS)
+#define xfs_errortag_clearall(mp)		(-ENOSYS)
 #endif /* DEBUG */
 
 /*
-- 
2.47.3

