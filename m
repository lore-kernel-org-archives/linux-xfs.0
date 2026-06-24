Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB83D385D70;
	Wed, 24 Jun 2026 06:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782282455; cv=none; b=C9Dy4EHg5y4tsHXdASMO5mgVi3OUElm86ow08wkAhUJT8OW8HDKqNujh2HnoVBoqhhn5/UEmkx54AdbZkixVg35Lx1l/DGoPIctvNsrR8zAAx6amGnvAWFOeNfeDgiHxDUT4mGfItWF1kpdfFopGeoiOMuYotSfQ6Ste/s2/SWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782282455; c=relaxed/simple;
	bh=ExL1JLp1Ke3UZLsZxaqB+SMmfn7zk+5OlHVzGtaMESI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S8jW+GEVulMhqFKJlxZhrVjesdjY24nuCLhl5+3kcLLFEe81HdZ99h/1QFPyqWPr30e2uoW+RpS97np9nd4+n4WzMGDEKZRaafJmu9ng+0d+vIqYpGJvbLtzP/H8jkjZbAZ3F9wpQAIWy5rh7NTIir/n9XgKAReXtWg9kuivSzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Ba7Kz8YD; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Ba7Kz8YD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782282403;
	bh=gmYOo4t6zp+ULX0y69XD/Dv1yAg1FqQkoB2lXnky0ho=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Ba7Kz8YDSgLeb3odbk774ALQBa3xt93rWY+W38navOW1/XnX5mzEQYe2S1+jiWCZE
	 hxq8JbhgmYy4h2JZomzskY5ffgfUZ97arMbJstzsHMx6jZw3LKHFKhpOf7dJK4fN3X
	 6+69vC3xqV4teHPbGKS2b69MPRzDN+FUcxDoqqwk=
X-QQ-mid: esmtpsz17t1782282387t4b5e1499
X-QQ-Originating-IP: /jK24wufqUWTp05O6j1SmFfux982Pd5KlBXh+WfNkOI=
Received: from uos-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 24 Jun 2026 14:26:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15835268725803703521
EX-QQ-RecipientCnt: 7
From: Morduan Zang <zhangdandan@uniontech.com>
To: brauner@kernel.org,
	hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	Morduan Zang <zhangdandan@uniontech.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] iomap: guard io_size EOF trim against concurrent truncate underflow
Date: Wed, 24 Jun 2026 14:26:22 +0800
Message-ID: <9E38E2659B47DC2A+20260624062622.337469-1-zhangdandan@uniontech.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MgEbn4EBW630QwTtn2GHtZaKE+qZMBPpXaceTMYGxe+CLpnPVTq1zH4+
	H7uWDFtIiyYJxKzPIBvwOaHnIA2lgPSc7BExh2U+ojGKv2RKrqQew9Fl8n75/Y9cWDgXVh+
	5z/dNckGePCb+Eu38pZGzqq4FUrOWEI9UvG3jm2u7covwEUIwYh1+vPslK84e2f5egOo4QC
	CmRniLEz0Y5uohBv+lRppWM0QdXntdFbN1Ykn1332WMc6ZqIIzA2UBoY3XkQehn7jkpzLOf
	ePdvXkef536QBpIVKyvpoiZVYqCXjHnADsqZb/w0PkHipfvFTdDEw4QcFq2RW+jlsPt73i4
	T/PUVUr6+ZAstH5kB9vDr7vc5QTO7b8fpaE2X+MvFUGPq1j+wDxSiyoDKPuGQ+0QynTlq8r
	0W/fG4IeLBwINIbzake6wfPNyZCF0E8UkA9kyxCAjOfyjlh6x0wV4kaXX6cb6O9dM4roPE/
	HGz3aQpjol3wyHxgjhjbuV59o6q/aOgDgpUzdSfBKc90Z6IiMfCTuKvGHHSI7GlmTI3hFEP
	H+cw35j0O5UtrqFXkwzLAUOUzCrkmfAl2qLk+51oDEdrcmrxKRdWyqd3sqhFlXrExBUW2Dl
	DhW73Jm/+ThyihQx2s018q0PPuO6KyQH/qwmLL0NLbMmLL38YMVnZOjAFw+Mo8Atg9QLxQZ
	YtMwHX5/vAQQG4aIMJPobiO29jRWZqf/1sb/joovpQ8p4HMG/l2qy4m4v9Hvr43qYR36MLF
	IF3s8vodT6RSt/kCNEWZ+4QGWGveyXAzD1OwxG4otcepNv447SAm61Q2uWLV0pE+skXvu2r
	ZwdNX5vYDczpuuN/itPRAAxxFcHkx60/mnkgosMC8ycNIGq8r2GsGxxeO4CvmxxcWoDtY++
	aqe/VK04OtAoeCCb6evb+NUryXp1NBRnmAj6WZyWb+DREsM5Cnz2OyMiJrXRPfeR+M4cNwr
	VPlyRPpJ/x7fxkSJtKFlv+WUfDsgplef3vOanor0G25QsdtaAFR0PCu5lYZ5C8dTH/xYqDO
	5Iu/ZlALIx/ZgphaFffMKE2Mz2ZVEV2goSyRmWVrGtBru3e8a7yoiQa3kCVPoyIhvPLBpYL
	DOV1SsVq2WqYcvnzRbmxEVJVFsZpCmbpJavoFHnsfRN8MY/DpGW1CY=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

iomap: fix zero padding data issue in concurrent append writes
changed ioend accounting so that io_size tracks only valid data
within EOF.  This trims io_size when a writeback range extends
past end_pos:

    ioend->io_size += map_len;
    if (ioend->io_offset + ioend->io_size > end_pos)
        ioend->io_size = end_pos - ioend->io_offset;

However, if end_pos ends up below ioend->io_offset, the subtraction
becomes negative and is stored in size_t io_size, causing an unsigned
wrap to a huge value.  This can happen when writeback continues past
byte-level EOF up to a block-aligned range, or when a concurrent
truncate shrinks the file after end_pos was sampled in
iomap_writeback_handle_eof().

A wrapped io_size can mislead append detection and corrupt
completion-time size handling, since filesystem end_io paths consume
io_size for decisions such as on-disk EOF updates and unwritten/COW
completion ranges.

Fix this by clamping io_size to zero when EOF has moved to or before
the ioend start offset.  This preserves the original intent of trimming
io_size to valid in-EOF data while avoiding the underflow.

Fixes: 51d20d1dacbe ("iomap: fix zero padding data issue in concurrent append writes")
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
---
Changes in v2:
- Adopt Christoph's suggested condition ordering for readability
- No runtime reproducer yet; still working on a test setup

v1: https://lore.kernel.org/all/863D407CB3ECEB04+20260618053820.506635-1-zhangdandan@uniontech.com/
---
 fs/iomap/ioend.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index acf3cf98b23a..2d5611f6cc57 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -297,8 +297,12 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	 * appending writes.
 	 */
 	ioend->io_size += map_len;
-	if (ioend->io_offset + ioend->io_size > end_pos)
-		ioend->io_size = end_pos - ioend->io_offset;
+	if (ioend->io_offset + ioend->io_size > end_pos) {
+		if (ioend->io_offset >= end_pos)
+			ioend->io_size = 0;
+		else
+			ioend->io_size = end_pos - ioend->io_offset;
+	}
 
 	wbc_account_cgroup_owner(wpc->wbc, folio, map_len);
 	return map_len;
-- 
2.50.1

