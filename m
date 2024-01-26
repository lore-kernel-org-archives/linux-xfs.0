Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A011F1B813
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275770; cv=none; b=XS79q+rlQApjJGQeXbzreuDC5vMUXQIJP6KMZRJBQK8H6P9k0dW2rmNaR0zDJjfDvRhg79Axmpb0pqkUYOgTP2hlzSxJJevxUYRqPtyFoyTCR1iNXbTdDXrM/Oo59WNIYGY7Zi8agPC1+mbhBeKh94Nmg/LDo+K/oR3n/XlL7EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275770; c=relaxed/simple;
	bh=/f0jWSoziT8KKN8XVNkSoRfX1N/UCi9qiUpr4/QiWJg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DKCsFEdX2u2iSFNbMuuXJFMpveB7mnSQkP8erfKPe5Mf81M32eSfKBCyqDhEGUmn0bKIS9f788/+tvLNBVWuLoP18hPQ4TECr2/wD8tDJ3vV0W7p128xGLtHPCEBkQRBmJD/tiUtN3HlnyAmdZqyMImMR2LzzsbmgUN0mMIIENY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UeYennuX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UeYennuX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0iKTKDcwlGTInQAMwUK2KO8AY6uPQ9BP+hArH0/aSbQ=; b=UeYennuXziCc+zdB372FuC0/HR
	hb6hwObADJ+u0qirrQQSkwydcainIxZiErI9BUMvAeuIgioUBjkXfn0dz0Gx6FjLryifXOqo0JZai
	Kq9uCtM8f4VKyQaLNpLcZmlNzbMkerdRpZVjQvFLw5gH9dLYYUFCmKP0/hdOzi5rwuk958xNLk3Jk
	zheSxk0hFT/FcGN+8kdqe8fKZYovpF30hiwAj1n31kuDgmh0jCcpHc/vos3vyvjpxO3bnKqYREcwz
	bHZet5+xHphrBFrHS+eE2iUHyRnTyFmOT9Hk9D44NQnmNOFzM1uVw+gtYUwXp3UweuimJByQTHHuV
	XS26AYNQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMGu-00000004CfW-0d0W;
	Fri, 26 Jan 2024 13:29:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/21] shmem: export shmem_kernel_file_setup
Date: Fri, 26 Jan 2024 14:28:48 +0100
Message-Id: <20240126132903.2700077-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

XFS wants to use this for it's internal in-memory data structures and
currently duplicates the functionality.  Export shmem_kernel_file_setup
to allow XFS to switch over to using the proper kernel API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index dae684cd3c99fb..e89fb5eccb0c0a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4856,6 +4856,7 @@ struct file *shmem_kernel_file_setup(const char *name, loff_t size, unsigned lon
 {
 	return __shmem_file_setup(shm_mnt, name, size, flags, S_PRIVATE);
 }
+EXPORT_SYMBOL_GPL(shmem_kernel_file_setup);
 
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
-- 
2.39.2

