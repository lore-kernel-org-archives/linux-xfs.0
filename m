Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BAE4C900E
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349547; cv=none; b=ebweBdwyBQHsz6i+owTOXj+vp8qI/T+34a9Lpzt4fNQ4ry993V6TGcEa3WBOmUsHzRA9Pd2+ZYtG/IL4hfHyD8i2eF48+8FXuIoAnGKWbyMkukgHWoecczGiZO1aY16+T76C5USgP6o3tjs+R+/dsZ3cPgUIjZpytSx2sjn8b58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349547; c=relaxed/simple;
	bh=0/B69UCoxfptcq6QpTuh5m0h2PGyxiNg+xdsBzaPOGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwpHTyjCsF5tvlnbqHUawm1n4RM3GOF2byYYnX/zRsltNkg0+lUnerM8ULkc3EjOVFlCj7VP7ivDBVDxI7z6/tUcwIK3zve/UjK/6xOMTQH2eOOi56rsqr/07ekW7JTle5rtdDKmoObkelb+ZtwafFP8bHVrErhxo+dpb7nUQmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c3W11yIq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c3W11yIq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=e79LcPTvG5Ckow2POVyWDM33/JuQkebzA6N5EGZ80Po=; b=c3W11yIqOwHe9fnuWS+DxH+Zef
	f2EH4P8HoGLOASwt6UGujw0oCsOGE+G1V6UbjusB3ErMFWtrGh3fDXTZ9YjdEOBnOJXvnO4/kjVFi
	Hf3DtXpUe9lTByJtf105E4Y3miKu7YkBPMmxJ4BawzlVnOAdWpYarnecGoo2UhnRMbQwGjuoAUONe
	8FHW92/r5ZAilD4ym8F1N//C7r9mQ7YlVSa/YbAdrp54tCnkGhpfjrlLEE4LVOrRFoDC4FiycpmXs
	qmniTCqw6HKzQtUFU3RpZk4r+LNPVaqj7KTdesyQ++NIQ41SFysf8lav6EBBHg+VSguYrmzItRo12
	TjO3eYSA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7hR-0000000DlIx-0OOf;
	Fri, 25 Sep 2026 15:18:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: move xfs_trans.h to libxfs
Date: Fri, 25 Sep 2026 17:18:29 +0200
Message-ID: <20260925151841.3385994-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925151841.3385994-1-hch@lst.de>
References: <20260925151841.3385994-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This file can be reused in xfsprogs instead of carrying a slightly
modified version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/{ => libxfs}/xfs_trans.h | 2 --
 1 file changed, 2 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_trans.h (99%)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/libxfs/xfs_trans.h
similarity index 99%
rename from fs/xfs/xfs_trans.h
rename to fs/xfs/libxfs/xfs_trans.h
index eb83c5dac032..8a98735b8e15 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/libxfs/xfs_trans.h
@@ -6,8 +6,6 @@
 #ifndef	__XFS_TRANS_H__
 #define	__XFS_TRANS_H__
 
-/* kernel only transaction subsystem defines */
-
 struct xlog;
 struct xlog_format_buf;
 struct xfs_buf;
-- 
2.53.0

