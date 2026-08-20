Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD0347ECD7;
	Thu, 20 Aug 2026 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244375; cv=none; b=XSJOLNcetFZBeXKU5xYi3CDU5AJi6V7YBKHule/lbOJC7N2gs9uSyX5iF0F7G2AKlGw4hn83CearlKTZfNnFs0JlYpU3u0RgjBQ99lo24AhAdtCqkR1I3/xFnFCkcTRD2qto09DlbgbQ061U/wGKHaGxAWIFjAlHq6fZusmLg9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244375; c=relaxed/simple;
	bh=z/MYQwRoX8bnJdtLNfnYbGBYn1BFWTGbNo45Tnqiu4c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=n/t3AmpMRTI0aBAYmu1rw86TGBfiRooUjsttOMyQVgf8Ge/xLS3GMpI+krjKRNEsfUtmtJvAkvyQixmTI3R0nT2jW3qOKRNw0eCOxnB7NLtNvgBDggHIdhb/ISq1fIEJfaIJ6Y7vWiGnaeFPutn1adOlgY5sTovzNa2OaB82Jsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=AsTdC1FR; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="AsTdC1FR"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 638701A1771;
	Thu, 20 Aug 2026 16:46:08 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 366375FF59;
	Thu, 20 Aug 2026 16:46:08 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A5B3011C7654E;
	Thu, 20 Aug 2026 18:45:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1787244363; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=HB3hKEAR0K/Zlz38CcIUi9gTa02tRgfVSqPhOWzML+Y=;
	b=AsTdC1FRPpGzKUvw+2grQR1QEniKg1ucNMvHt3UEiEMuhwdafwbHWanUXkno+7UB4UmspS
	fHHpHlgH6KBySOZ5BlECWoX7RvxUqbwy30bBQxWZOWZEzN9gNinEVYq++8tLdgGNA7pgYJ
	nozEfo1T7tvAu4o90kHTT28+UL4XIVN6T/kDKBQWeHom6mkIwuP1J76TE3qONabti4paTR
	mPTg/k5p7tQf92Ba/+hereu3b4EC0G/MxuUB314R2/L2qtm8U3Lrbw/aQmAAnz125UJdw9
	9p8PU7/UuOb4Oa/WSC57u8XPofmmy8mZOzovTSRVr0GfZkzuObBtXYYdCUnKuw==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Thu, 20 Aug 2026 18:45:47 +0200
Subject: [PATCH 6.1.y] iomap: adjust read range correctly for
 non-block-aligned positions
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-cve-2025-68794-v1-1-361e41b0a66b@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ6CMBCE4Vchc3bJ0sC2+CrGg5ZV1wOaVgmE8
 O5WPX6TzL8iazLN2Fcrkk6W7TEWNLsK8XYar0o2FMOxEw6OKU5KBR1J8H1L3Iah69k78YJyeia
 92PwLHiB1Uy84/uf8Pt81vr4xbNsHQnxuK3kAAAA=
X-Change-ID: 20260820-cve-2025-68794-048d59072676
To: stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, 
 "Darrick J. Wong" <djwong@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>, 
 syzbot@syzkaller.appspotmail.com, Brian Foster <bfoster@redhat.com>, 
 Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, 
 Sasha Levin <sashal@kernel.org>, 
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787244359; l=2380;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=GuQBm+40zn8HQ8wMdHhVHzOjSRd6QlWZ4HdqZv19bw0=;
 b=S3Glc+Cmr1OykvXx5Hq2JdUEVNSKQFmtYlMZMNPQ6kq5/Zok7450XUiHthNaRHk2TUrnJ/wBm
 MuuRblD3VyCCV2I3hbEeqftBNlbPBZceKOJmP1kkVHxFW2LR6bcFgc4
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
index 243cb2ec76ed..d0cfc4c3389c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -107,17 +107,24 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
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
base-commit: 7e6e670547210424443261b2d54d2acfff85a37c
change-id: 20260820-cve-2025-68794-048d59072676

Best regards,
--  
Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>

