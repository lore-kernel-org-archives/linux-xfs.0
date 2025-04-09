Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBE725B67B
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185525; cv=none; b=rgTRVvf20Kc9CVjfy6MhOpHdNQWvxJZgrCSP+28Z4qfJ1+gZxQzIPuNzXwfvh0bdg7ZQJtA8RGWXEj0UNmwLts+eAIoUkofS5noPiZ27pXw4faqCP6gx5YxQk5GGrh6gXi8wEangUaom/JNp6vzgPp1CN/V9Lud3jfWTWP8fJ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185525; c=relaxed/simple;
	bh=UmggZ8S44cbOj3Y2KnCKoC9X1uU8R2xJZioMdoSNXyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvwy0xLZZ1/XR0z4tJmiPF73zNqJCWQraq01Wx3SlNxLkwGsZ27yAGmOBcc7g6NcEo28gIQYDhUTPX7dDP9wwbRO3KkwBY2FTc9ipcHZaN/TU6dyTFxzCFAqOEWtE1rvSwZiIxJhcjR+fbSU7f0LUWRl0mMcjDS9EAV2sJJmwAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HIkvbsuw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HIkvbsuw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/4mF26rALsy0yAdhbOCY7IGDdcYpIkQXUiuG9NAHnlg=; b=HIkvbsuw0m9AuCHNY8sfbzN1/J
	Q+Q6umnxcSOxF5ZJG+ctSUcdG1YbPrefudOtn5T6OHwMx0o5WCmyrGC1RkqfVWR6hR/lUvR7wD/0P
	5/1EC3fLrd86XN8sw5S2rAzhbsZEAW5Cy6J3sejq+MVoBIhzeRbSx0xYP1AGtECHnGribOyl3ZcMu
	fnG8NkxLMlNCO9T5ir+g/HMM/Hb7zL2wDLSqmMB4WBq5IM+OQH+alIZgshVuXIwAN9+Ss8FKj3DLr
	R9jQC7N9njtMFlcYC154bqNCCClsxVcIoiRGEu9kPcMrl/UscJLUt+PILPRzfoYCHWrf1XH4VPTrP
	eZG+p/AQ==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QKZ-00000006UmT-2RD8;
	Wed, 09 Apr 2025 07:58:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 41/45] xfs_spaceman: handle internal RT devices
Date: Wed,  9 Apr 2025 09:55:44 +0200
Message-ID: <20250409075557.3535745-42-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Handle the synthetic fmr_device values for fsmap.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 spaceman/freesp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index dfbec52a7160..9ad321c4843f 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -140,12 +140,19 @@ scan_ag(
 	if (agno != NULLAGNUMBER) {
 		l->fmr_physical = cvt_agbno_to_b(xfd, agno, 0);
 		h->fmr_physical = cvt_agbno_to_b(xfd, agno + 1, 0);
-		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
+		if (file->xfd.fsgeom.rtstart)
+			l->fmr_device = XFS_DEV_DATA;
+		else
+			l->fmr_device = file->fs_path.fs_datadev;
 	} else {
 		l->fmr_physical = 0;
 		h->fmr_physical = ULLONG_MAX;
-		l->fmr_device = h->fmr_device = file->fs_path.fs_rtdev;
+		if (file->xfd.fsgeom.rtstart)
+			l->fmr_device = XFS_DEV_RT;
+		else
+			l->fmr_device = file->fs_path.fs_rtdev;
 	}
+		h->fmr_device = l->fmr_device;
 	h->fmr_owner = ULLONG_MAX;
 	h->fmr_flags = UINT_MAX;
 	h->fmr_offset = ULLONG_MAX;
-- 
2.47.2

