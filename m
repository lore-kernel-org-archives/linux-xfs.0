Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F238244667
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311494; cv=none; b=Qy1+rPswUsVlFGJTZJ0/r02BoXFZJ+SHH2IuhwC9lpwdEx+iFHw8Dg43Elsqjy4f3Fm+PNx0ZKH4LgurVnxKMlS2Vmq2lXQlV1g6+XvX06U8yxu+LnwTwJ+dTJkTVjXZVDGohFayWk8RslzOKlvxOoBYhR5s3Kgm7Cw+v1qxvAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311494; c=relaxed/simple;
	bh=JS/7cewU028/26c8YrNRBbYq/yNkxItFNvnYBOXX9hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDUBIQtSng4rCZilOQsorcKDvQ2rC2WN/W3yGtYZJhf5YjWQhLmkvbCrUZMUl2d5laEXSbrlvOjAiCxE4rtk8SYb3sIDZCGoFkO7NEN6BJHAsbrGcoRKM+2SekEVQLtp/Dyi8Oe7RkSpB8l2eA1SnmNqI0z5Ux1+zPUegZfzJ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GIC0Jtyw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GIC0Jtyw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Pr+BGUSrWFT0oYWyYWdRn1i9HrgZwTmIH187rWtSt1w=; b=GIC0JtywOBUfCWYVP4SfVphvsQ
	1iYIfJBRxTc5IAu2FymcrnWudyZNupqPzBQcxiXFVBGaEqG67v5/exXIhKtBS5kULR0F17T3Csvbo
	PhL/UrfFgFuRAtvPdlW3/YmxFY1cgYkBb+UoWZ4ZqmLqhExYIizHN/HJ6xsx1Q2SgTT9KCsV75aIM
	XE39aE0kILRVNf305OIKBAcgBytMkH324GWxmRMOQolmtVkK3uOe2EYm09jJXcPgY0Z/HL0UCiwn8
	Ojd+3lvYyvw/C3XF2NrisWRRkqyW/dW4/LQlellGelqbpgaEOxhkyXgwpiZR0BxEVFjIfK0VPu9QO
	Qqb0vPRg==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs0s-000000002dG-2dnM;
	Fri, 28 Nov 2025 06:31:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 10/25] logprint: cleanup xlog_print_trans_inode_core
Date: Fri, 28 Nov 2025 07:29:47 +0100
Message-ID: <20251128063007.1495036-11-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Re-indent and drop typedefs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 69 +++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 28 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 227a0c84644f..a3aa4a323193 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -531,39 +531,52 @@ static void
 xlog_print_trans_inode_core(
 	struct xfs_log_dinode	*ip)
 {
-    xfs_extnum_t		nextents;
-
-    printf(_("INODE CORE\n"));
-    printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
-	   ip->di_magic, ip->di_mode, (int)ip->di_version,
-	   (int)ip->di_format);
-    printf(_("nlink %" PRIu32 " uid %d gid %d\n"),
-	   ip->di_nlink, ip->di_uid, ip->di_gid);
-    printf(_("atime 0x%llx mtime 0x%llx ctime 0x%llx\n"),
+	xfs_extnum_t		nextents;
+
+	printf(_("INODE CORE\n"));
+	printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
+		ip->di_magic,
+		ip->di_mode,
+		(int)ip->di_version,
+		(int)ip->di_format);
+	printf(_("nlink %" PRIu32 " uid %d gid %d\n"),
+		ip->di_nlink,
+		ip->di_uid,
+		ip->di_gid);
+	printf(_("atime 0x%llx mtime 0x%llx ctime 0x%llx\n"),
 		xlog_extract_dinode_ts(ip->di_atime),
 		xlog_extract_dinode_ts(ip->di_mtime),
 		xlog_extract_dinode_ts(ip->di_ctime));
 
-    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
-	nextents = ip->di_big_nextents;
-    else
-	nextents = ip->di_nextents;
-    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%llx\n"),
-	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
-	   ip->di_extsize, (unsigned long long)nextents);
+	if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
+		nextents = ip->di_big_nextents;
+	else
+		nextents = ip->di_nextents;
+	printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%llx\n"),
+		(unsigned long long)ip->di_size,
+		(unsigned long long)ip->di_nblocks,
+		ip->di_extsize,
+		(unsigned long long)nextents);
+
+	if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
+		nextents = ip->di_big_anextents;
+	else
+		nextents = ip->di_anextents;
+	printf(_("naextents 0x%llx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
+		(unsigned long long)nextents,
+		(int)ip->di_forkoff,
+		ip->di_dmevmask,
+		ip->di_dmstate);
+	printf(_("flags 0x%x gen 0x%x\n"),
+		ip->di_flags,
+		ip->di_gen);
+
+	if (ip->di_version < 3)
+		return;
 
-    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
-	nextents = ip->di_big_anextents;
-    else
-	nextents = ip->di_anextents;
-    printf(_("naextents 0x%llx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
-	   (unsigned long long)nextents, (int)ip->di_forkoff, ip->di_dmevmask, ip->di_dmstate);
-    printf(_("flags 0x%x gen 0x%x\n"),
-	   ip->di_flags, ip->di_gen);
-    if (ip->di_version == 3) {
-        printf(_("flags2 0x%llx cowextsize 0x%x\n"),
-            (unsigned long long)ip->di_flags2, ip->di_cowextsize);
-    }
+	printf(_("flags2 0x%llx cowextsize 0x%x\n"),
+		(unsigned long long)ip->di_flags2,
+		ip->di_cowextsize);
 }
 
 static int
-- 
2.47.3

