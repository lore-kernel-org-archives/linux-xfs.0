Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794794727;
	b=lb4phWsIwDMi6Q8Fr87PFePZwHF4Oi3lLgY0NIOXRoXN9j0Qvjq5b3fFy64CKIwDwKiW
	 qtYZ1N7ctQf2MYs7mdBQW+uFwdlVpwWZEJxnb4o1RS1KKDf1fRQMpevmw2UlyK3V27IU3
	 gtzcEqgqMb+0KDNhrq6fuo08Hrk0DutiWome3kE303lWlkHd6nTaBdIaN0eAhNNVEs/or
	 vXR+PJ3TVm18WYdHCFx9+At9D7bXW3hmLgS0KCZPIcUejXXUb5LohdmW2ksLwxUKLNtzM
	 5GMe7/JqCdJ/fE49wq1fKgVOQsURzWVKDhMBOb7Zksd4kQ4jMmPdllfx7eDVsaAoKKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794794727;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2515uiLTOM/+vjYwb37E+7pSLDJDjWStwAr/vSQ+Lg8=;
	b=B4zQ9J4qxRd7pyEsbksG92gXXYd+/e1Caccz/nJTVgQxHUFuyY7ri3XbUzJr7dg9uM8C
	 YiPTXD12J4307sjTSWRzNeit4OU05fHZwtDUUPGJsPnwC+a/T9mYoEvrCDq2VkGy+ENz3
	 siyh2Vv3Jswb2gFnzfNdnbF/JLZ5F3993FMmXYubccucrCX9vHYL1rcHoySREOTNRzpU2
	 VS9lo4DzM4+J/Tvrwc0TwhQIDIOMEyJMhi9Diq95kMGAZ9M4pVL8PzTHnaNzr6Z3FOwGF
	 7HBhZkL3V4VloKJJi/JEb2KhT/CeYJ5xC+rybFOprpW1W9uqp5ZtCU9eTYOh7+gmwVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=JIlKpums;
	arc=none smtp.remote-ip=111.22.67.135
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472E5606A31C;
	Mon, 16 Nov 2026 02:05:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 472E5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=JIlKpums
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=JIlKpums5C2z7N7Joa5gWYg7JI+ZMMFU9RzKxu6/iy/V63sKeFszQ5nee/GeUlemdDaKv4yFzrj9T
	 G/flvWJlLbJi5vomvTs3p7U1K/DHRlwBHQ7xUpbXhTkbsHebPouAGvpYdHNnAbhka3g76or9bLLaAO
	 Crgeyf+UkbB0IFd0=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee76afa64e21db-faeb0;
	Mon, 16 Nov 2026 10:05:23 +0800 (CST)
X-RM-TRANSID:2ee76afa64e21db-faeb0
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from fedora (unknown[223.108.79.102])
	by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee76afa64deb3c-77a94;
	Mon, 16 Nov 2026 10:05:23 +0800 (CST)
X-RM-TRANSID:2ee76afa64deb3c-77a94
From: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yiqing Wu <wuyiqing@cmss.chinamobile.com>
Subject: [PATCH] xfs: remove unused variable in xrep_tempfile_copyin()
Date: Mon, 16 Nov 2026 10:05:10 +0800
Message-ID: <20261116020510.17329-1-wuyiqing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pos variable in xrep_tempfile_copyin() is initialized from the
starting file offset and incremented on every iteration of the copy
loop, but it is never used.  GCC flags this as a dead assignment when
building with W=1:

  fs/xfs/scrub/tempfile.c:493:33: warning: variable pos set but not used [-Wunused-but-set-variable=]

Drop the variable and the loop increment.

Signed-off-by: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
---
 fs/xfs/scrub/tempfile.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 59a9213a3c7d..6340afcc22cf 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -490,7 +490,6 @@ xrep_tempfile_copyin(
 	struct xfs_buf		*bp;
 	xfs_fileoff_t		flush_mask;
 	xfs_fileoff_t		end = off + len;
-	loff_t			pos = XFS_FSB_TO_B(mp, off);
 	int			error = 0;
 
 	ASSERT(S_ISREG(VFS_I(sc->tempip)->i_mode));
@@ -498,7 +497,7 @@ xrep_tempfile_copyin(
 	/* Flush buffers to disk every 512K */
 	flush_mask = XFS_B_TO_FSBT(mp, (1U << 19)) - 1;
 
-	for (; off < end; off++, pos += mp->m_sb.sb_blocksize) {
+	for (; off < end; off++) {
 		struct xfs_bmbt_irec	map;
 		int			nmaps = 1;
 
-- 
2.56.0



