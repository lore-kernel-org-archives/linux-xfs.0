Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDBA225774
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824396; cv=none; b=jF87m68fXbYDE4yC+4dq1Rg2NOAfATRjGMWLNurMQ1+JsvsEix16XKKPj3xILqIshf3Gdt3Z9+7DgNGuTM2qhvgqwZuZ3FJuVbhKd10FjI16hvb8nFNh6QtF90fkh3f9F0s5MZTcW816uFo8EONwNyoxoe+JpFAsXsYnH0kv52w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824396; c=relaxed/simple;
	bh=WShP+yVDFksr/aOBqj/M9MzOpJUix0lpDhZeC8mVg5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3NxYzBRCWhxCSgVpDoyy31ZXT7JzIa6CdAJwQC4p88PqfJKm6jPxdog9820t39ufkElhaChetEuCxpiMmoJ8IqGxJ8d50ZurFcpwqex/9WjtxWWNqe+G08azXSU/KD2lLhnAn25Ua7kq2LIrpqltNC5tR3oAQvda/EMt69Wi/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ESmvhSsv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ESmvhSsv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kXQcG+hpmPdN2fK4Kkbt2KAd68WsrOeML+uXoyjHHXo=; b=ESmvhSsv6lo1RTg15FhH01Ll1R
	K/NGSDQ+GeLBnJo9fe3ZRp8bSqau6OUwhhdPCH0WU00rjJhqbUEQS3MMfPowGJMcwBFOTK4JZqeSf
	5Dq5FmJFNDgGKEzKj94/AnIXojkZonBlw9KW4QOvIS95iT2AUUkVsZmn4NqL5wV3qXftRyl27b6A2
	m95VqOqpIMUz5HQfBMdPA9XNozAhxEenx/wkeJ1ep0Eb6Hb3+3hw8TgZkLPgkiB2KECMiuUJv1NZR
	B5sGN5/vgWAV9Ur1rGVTHJfjrwFZAibnku4KPnVgtsgrZU5cFMIMqp2VdbrJ7jRI8g1z37sbG5vK7
	IU1qIgUQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvek-00000005QfK-26l1;
	Thu, 06 Feb 2025 06:46:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 28/43] xfs: hide reserved RT blocks from statfs
Date: Thu,  6 Feb 2025 07:44:44 +0100
Message-ID: <20250206064511.2323878-29-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

File systems with a zoned RT device have a large number of reserved
blocks that are required for garbage collection, and which can't be
filled with user data.  Exclude them from the available blocks reported
through stat(v)fs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5c1e01e92814..34b0f5a80412 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -869,7 +869,8 @@ xfs_statfs_rt(
 {
 	st->f_bfree = xfs_rtbxlen_to_blen(mp,
 			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
-	st->f_blocks = mp->m_sb.sb_rblocks;
+	st->f_blocks = mp->m_sb.sb_rblocks -
+		xfs_rtbxlen_to_blen(mp, mp->m_resblks[XC_FREE_RTEXTENTS].total);
 }
 
 static void
-- 
2.45.2

