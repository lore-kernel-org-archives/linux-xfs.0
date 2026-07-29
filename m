Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DAD4779B8
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330086; cv=none; b=NHonZT76nhktd4Wm6dAkRYGnQKBQ6zsUOlWN55B+wlX309+h4WkMBCjAs5rWT7ULFyGoIDN2cu4i76nad8ZW7aANrapB76QZPz/485DjZaIFFKDKpg7hq3aXFRVkPcLqU9Kfo2EeU6OQPBQzyNgsHjoqifEZGND0Iyqk7czwY08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330086; c=relaxed/simple;
	bh=iG8RCErDu0t8tY63KzcR7ofSo/de5Cc1S1ndcmwT2Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q48dNUm0vR7JWWzTLhiClCK7UTC6w/GYfQONNGeRPWUmdbcvCMXQ8Ob5Hkd4+K23Fq0wXoiDzoVl20pRiWnQ8lzsPM5XV/8B+34iwwGPLl1/EAzA7/ZtoONcZX0fb/usw03SUxzuRwir5199xnTYz8G6rz/dtmJwnZIL60QfwUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i0QzGuxS; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i0QzGuxS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=wD4etcgvYU/SNYGxP4fvEpnr1tUkCJ1rrMffuk5SmPU=; b=i0QzGuxSqlQ63h37IC9as8d6G+
	CKsr1/OzF6AYB8iSiquPe2TIap/K/ov7SyHIEmMP3A3IfLREz0fow7P7b9HvbB/vezrOKrIA60jNx
	fti3z63/BhP8oqHbUr116Y3a8bkLPGv1NJB7jG/3NvkYVpSgZLLIUI1n61X3pkPO1AFKNphdO4qq/
	987VL5Ehe2/ocSJhim2ITwzm5dzcZit9t1ggsNIY8E+UHHqIXxbC4LSnKdyMuDHch0r2DVZtifJp1
	YYN2+eGrQ5pOLRH028HHGNtr0RecLiRKKj28CnD7G1M2FisiSnEVuNK9ICR9iHPs3wXwBe33Czh00
	0iigcPyA==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3uT-00000004UMl-35WG;
	Wed, 29 Jul 2026 13:01:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: darrick.wong@oracle.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: check v5 superblock features early
Date: Wed, 29 Jul 2026 15:00:58 +0200
Message-ID: <20260729130121.2281910-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

When working on a new features that reuses the existing pad in the
superblock, I noticed that mounting such a file system on an old kernel
logs a rather confusing warning:

    XFS (vdc): Metadir superblock padding fields must be zero.

This is because we only validate the various feature fields in v5
superblocks after the common superblock validation helper is called.

Fix this by calling the feature validation first.

Fixes: eca383fcd63b ("xfs: refactor superblock verifiers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Changes since v1:
 - minimize the fix, and implement all the good ideas later

 fs/xfs/libxfs/xfs_sb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 47322adb7690..75f2a021ee6d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1118,10 +1118,10 @@ xfs_sb_read_verify(
 	 * because _verify_common checks the on-disk values.
 	 */
 	__xfs_sb_from_disk(&sb, dsb, false);
-	error = xfs_validate_sb_common(mp, bp, &sb);
+	error = xfs_validate_sb_read(mp, &sb);
 	if (error)
 		goto out_error;
-	error = xfs_validate_sb_read(mp, &sb);
+	error = xfs_validate_sb_common(mp, bp, &sb);
 
 out_error:
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
-- 
2.53.0

