Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB140478846;
	Thu, 20 Aug 2026 17:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787245398; cv=none; b=nY6so56Ipohm8CBcdu//6jeAY8T5m6/hoV2WymAL+to5NJBxfZHcwQlcfEbf5WWLlu5gkoNY2DYGK28vCeOWL/txSqH8O2Jdy6KTeTUTRKmd1deh6uygRJTNavISvFsO9YAzn919YGA1yLCEtoaNbIVLARZtRKWBsjDuGkUO9ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787245398; c=relaxed/simple;
	bh=UL5olmBLz4vCpi4CTfdNdOVt35NDxiRVlv14PKj30f4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=dSffe8XU/c5JHTRUGWYlthKN0Txb/ToPgGFezWTwWNXrCrTVEmzqzavTLhM0M4CqRju+l1lzI0QEJVUvBM+dxLimfX2rnVS4uPqKKSWF6nvu5CUhspspFfaS1rcY02LcZyaV63Vr1IPM4wG55afeOcsJggiY7WFUBRx+D2w5eB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=Zh+zStUK; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="Zh+zStUK"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 29FD71A1771;
	Thu, 20 Aug 2026 17:03:13 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D97385FF59;
	Thu, 20 Aug 2026 17:03:12 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0129211C76574;
	Thu, 20 Aug 2026 19:03:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1787245391; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=dzpDPpSnAM2uONOW9dmectfOGf7mS7OXVGaVHm+mTHA=;
	b=Zh+zStUKsoTQ14HSj68/KZzX5U8fCX5OXTe7NJwgpbvcWVhSzToGds53ZMrg3UhD0Kmfub
	5NIJnuAdmXR1nzyTgC+5ZojvLLM8Bqm11JiVNkadHetkkAn3MGltA62jAZ0JnByIfJT1kS
	3vG/yvRtWKSE6Mky8yM9CFII58TT7mspbtxk1cXwY0XZZR/QCZb9142Nhak9OubBkeylqw
	qWqY38luPuIpDp8N1eJbIBkBxOTAlOg91cjwvsJntQDFMFDTWiJBZVHcpdpfH0w++lIAFn
	44K1x9DkuuX8Fd2XUGkTOD8ntvHuaKH0wuy+kAC1mLvmEKnpn3ZmspD3LyMKqg==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Thu, 20 Aug 2026 19:03:07 +0200
Subject: [PATCH 5.10.y] iomap: adjust read range correctly for
 non-block-aligned positions
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-cve-2025-68974-5-10-v1-1-26ff0db1f8e8@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMyw6CMBCF4VchZ+2QaUO5+CrGBW1HHRdoWiQSw
 rtbdfmd5PwbsiSVjGO1IcmiWR9TgTlUCLdxugppLIZl23JvmcIiVOCo7YeuIUeGKUrn/TDGENm
 gPJ9JLvr+VU9wteF6xfm/55e/S5i/Sez7B3eYEP1/AAAA
X-Change-ID: 20260820-cve-2025-68974-5-10-de7bb9adcd01
To: stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, 
 "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 linux-kernel@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>, 
 syzbot@syzkaller.appspotmail.com, Brian Foster <bfoster@redhat.com>, 
 Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, 
 Sasha Levin <sashal@kernel.org>, 
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787245388; l=2376;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=CNtMEBmJPiIKjl+lDDc5UbR9iCo9r73AmjrCfA5GqX0=;
 b=naMS4CUhlormixQdBh0yb08DTrCcZpVVcAB/BehBV+7ddR7RbtjBr6y58AENKmZrKwsq7uZWJ
 lSmH4iCUL7WB38bsfrwn7z+Kh0E3EdvaCgtWWhyZWTwe47Xo2ivlzFw
X-Developer-Key: i=miguel.gazquez@bootlin.com; a=ed25519;
 pk=k/2KI9jkmayaF0ghZ8QYUH9Wm/kFHDhl8QoZ0RHbr4w=
X-Last-TLS-Session-Version: TLSv1.3

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 7aa6bc3e8766990824f66ca76c19596ce10daf3e ]

iomap_adjust_read_range() assumes that the position and length passed in
are block-aligned. This is not always the case however, as shown in the
syzbot generated case for erofs. This causes too many bytes to be
skipped for uptodate blocks, which results in returning the incorrect
position and length to read in. If all the blocks are uptodate, this
underflows length and returns a position beyond the folio.

Fix the calculation to also take into account the block offset when
calculating how many bytes can be skipped for uptodate blocks.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Tested-by: syzbot@syzkaller.appspotmail.com
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
---
 fs/iomap/buffered-io.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 219f9e1a2643..5ad3bf906b35 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -103,17 +103,24 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
 	 * to avoid reading in already uptodate ranges.
 	 */
 	if (iop) {
-		unsigned int i;
+		unsigned int i, blocks_skipped;
 
 		/* move forward for each leading block marked uptodate */
-		for (i = first; i <= last; i++) {
+		for (i = first; i <= last; i++)
 			if (!test_bit(i, iop->uptodate))
 				break;
-			*pos += block_size;
-			poff += block_size;
-			plen -= block_size;
-			first++;
+
+		blocks_skipped = i - first;
+		if (blocks_skipped) {
+			unsigned long block_offset = *pos & (block_size - 1);
+			unsigned bytes_skipped =
+				(blocks_skipped << block_bits) - block_offset;
+
+			*pos += bytes_skipped;
+			poff += bytes_skipped;
+			plen -= bytes_skipped;
 		}
+		first = i;
 
 		/* truncate len if we find any trailing uptodate block(s) */
 		for ( ; i <= last; i++) {

---
base-commit: 2a3da1f4966798b0b48ce302944ad356b2c98b5d
change-id: 20260820-cve-2025-68974-5-10-de7bb9adcd01

Best regards,
--  
Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>

