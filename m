Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66907485CFA
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329951; cv=none; b=A0U2kwDZyjpz1weKmzCmkD7EJp226Wgu2Wk4vunaH2MWkIaTUhtw8G6Ww2hXTC9pIlkqgrY0qbKBG/08Pp8w46/mAKfNrBpxdQXZrta0dM9G0S4RHHRse5BQQBn1ZVpf3GOEuZtRwkWwJFOr0qmBQKx2pmSa65PVlSEno17MkR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329951; c=relaxed/simple;
	bh=3mFaF8FDLRZDJ/QOe4T5LE1uJ/qbygun3HB1Syvbz1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yc557GyYU3gqlLSbx/24S24XKVFBOd8CVioZ3C9j8rtGdF+RtLF0hIgq8AfAVWswfyogPOnzeSlYAu1UyTrfmEghlr5RUGDqjiFZn/L604+d8JB+IHVwaRIFLCbW4gp8QZXUKsFVNxMkhXryt7vnbjs7xo0TYUDXMuht7qGjgmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sPWpAvoC; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sPWpAvoC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=sBzKCzxnvVMYZNzrHm8nooFJqBRofelbiFOcwX8UHhQ=; b=sPWpAvoCdp5YEK//BcpnVz0WsA
	mzWEPKaaDxv7BPiKX2D94a+IdhvEKflnPkTduqx74og0B2BMJ8KvmYTkj6DWtzdTz5uu+redyLI3J
	n7N4ffP2FHWYmmg8vL+qKbCvpggAaebcVJ7Mcl6GMsJB/FTje4czJN6myZFrww97JqJJcX8IbvfaB
	0r0MwYYeEPiNbcoUhqi3H17tPb4Skvy9dqDNb9AgiK9mAvmjNRr5cshg/aH4YVSETmNnKqzMUhf+g
	1VmSz9Jk6xfxUYH6/JK5rllNbk0qcYzTVCDQ81WngcBSP24efZrz88oQUlhgdHJ2Z9tHhvQggltsa
	SQtlBw4A==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3sH-00000004N73-2Iap;
	Wed, 29 Jul 2026 12:59:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] copy: always align to at least page size
Date: Wed, 29 Jul 2026 14:58:57 +0200
Message-ID: <20260729125902.2281706-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729125902.2281706-1-hch@lst.de>
References: <20260729125902.2281706-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

The buffers used by xfs_copy need to fit the alignment of both the source
and target.  As we can't rely on statx for more detailed information yet,
work around this by never going below the default page size alignment.

This fixes copy an image from an xfs file systems on a NVMe device that
only reqires dword alignment to a virtio_blk device that requires
512-byte alignment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index ad18ceb1ac1b..5435c87dba38 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -673,6 +673,7 @@ main(int argc, char **argv)
 	if (S_ISREG(statbuf.st_mode))
 		source_is_file = 1;
 
+	wbuf_align = getpagesize();
 	if (source_is_file && platform_test_xfs_fd(source_fd))  {
 		if (fcntl(source_fd, F_SETFL, open_flags | O_DIRECT) < 0)  {
 			do_log(_("%s: Cannot set direct I/O flag on \"%s\".\n"),
@@ -685,13 +686,12 @@ main(int argc, char **argv)
 			die_perror();
 		}
 
-		wbuf_align = d.d_mem;
+		wbuf_align = max(wbuf_align, d.d_mem);
 		wbuf_size = min(d.d_maxiosz, 1 * 1024 * 1024);
 		wbuf_miniosize = d.d_miniosz;
 	} else  {
 		/* set arbitrary I/O params, miniosize at least 1 disk block */
 
-		wbuf_align = getpagesize();
 		wbuf_size = 1 * 1024 * 1024;
 		wbuf_miniosize = -1;	/* set after mounting source fs */
 	}
-- 
2.53.0

