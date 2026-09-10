Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F13348F03E
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789046937; cv=none; b=W9NMDkbX1bkasOM+tcy2o8ucbSHTtyuVdYWBgF8UEjcRG/Ua3G7313/nds9BIaqoKvk2xnZiyHdAiTeQgmZqHOUSlChT6btRupFYmJMeKP6dKEODEq2KIh2pyAIL8xjjdiv6zDohLAr81Uqa0Uj3o5QFEDIk9tNryGElME1cLDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789046937; c=relaxed/simple;
	bh=F2xW6brlpYavNTfIO3GCom3eakZq/ZtVLXLntWAGvZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JC2E8bGrrHay85gaO0Fx5osbC2BT+60ejlyxodF0hrNI6OfX813pyGHYNjcFzqJeNB9pZWrFBzt0OVpr8SLEvdNLRK5gnA4CiFxJm8YmydYcPhmVebP/lwLahB1BfZP6qgVEXy1WKfyZbbCimNQcENwOW4lQrOU+9rVSWoL50kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q6k84VQH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q6k84VQH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wp+wR6dciGZBrZGeqFpFSm1H0k4Gil8snYti4HX+I+A=; b=q6k84VQHpwnI+zIm4PMltQVwt/
	RykJbfIkTzxPAkjyChJpOspzjUtC7Ur9Y8mzAk99RFcxIGEkgiRtHa8Ge64US0IKJw1FmlGeQ5iC0
	Nn9IoXXd+NEzdcCGUbAWJHwKLs4edR/EDV7r3QLyUlg/7VAOmoTU8Nke1IW4w+6hao2xuBhlga+lL
	fg3KXdQwZ5CSQyJejMRVr/5Nm0T4+JTMZ6XCz05mGCEYjP/z0wFAVY9ul9b70QDReX8v9iLXK74Cw
	Yk0ooX4qVsvAO7lPIHmy7NhBdbRWVyQJU+t6yJPGOCAe2IzBfmxNWKwczNvOIiiTO2fGjmQ6pCnPE
	uOg8iCuQ==;
Received: from [2001:4bb8:2c4:6e16:7921:e451:555c:a765] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4epf-0000000ESsK-0yhA;
	Thu, 10 Sep 2026 13:28:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] include: fix LIBHFILES in Makefile
Date: Thu, 10 Sep 2026 15:28:31 +0200
Message-ID: <20260910132840.1541283-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910132840.1541283-1-hch@lst.de>
References: <20260910132840.1541283-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Remove a whole bunch of files that moves to libxfs/.  Al but one are
already handled there, but add the missing xfs_log_recover.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/Makefile | 4 ----
 libxfs/Makefile  | 1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/Makefile b/include/Makefile
index f7c40a5ce1a1..a4f0c365db12 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -18,12 +18,8 @@ LIBHFILES = libxfs.h \
 	parent.h \
 	spinlock.h \
 	xfs_inode.h \
-	xfs_log_recover.h \
 	xfs_metadump.h \
 	xfs_mount.h \
-	xfs_quota_defs.h \
-	xfs_sb.h \
-	xfs_shared.h \
 	xfs_trace.h \
 	xfs_trans.h \
 	command.h \
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 83c8592e5fe5..bd6b8f54d2ae 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -55,6 +55,7 @@ HFILES = \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_inode_util.h \
+	xfs_log_recover.h \
 	xfs_metadir.h \
 	xfs_metafile.h \
 	xfs_parent.h \
-- 
2.53.0

