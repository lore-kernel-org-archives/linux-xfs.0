Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214DD25C6FC
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185499; cv=none; b=qZ3hjvkFPYmolZu0DcL4Okk3eY/lTl8yr5Jp+RxdgKv5fmy6ImnQa5Bx6NdKLrqVMWpc/YL9ZrLPyJfPtfwTpTb+KohXALkumxOx3MNSv8NquScwo3w4Ar4rSUY9qHdZRrS2XyIBRWII9LJO8pL3lZxX3wrVR3h7VU9EjNPvnIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185499; c=relaxed/simple;
	bh=d5FRS9eiXWa4Dd/B5NvayLp797D7jQaMjvKXRDQJZGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irSXSIhP9VLPo5wU3cCil7KlpS1SHOtu1CKbDT31wtnKGgWH1DNeaOgQXBFiUCZKnFyU4wTAr/FPbEAQ9MPW9e9HAq8UwhiVHpEYwgoWGUhWW1hxypV7fzGwIj2NVselDm0oINykmtdMKAsxEjVxkfs71Zo0h4b+Hv9nNvWHq/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ka+JXWLU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ka+JXWLU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IzzL6PqQM2+LQH6LJM6s2WemsWmaG3SyOQ2Vz6KRso4=; b=Ka+JXWLUwmuW2/+Cy0Leqd82pG
	cp5CZoye1bUuiRcbIybDidD+VdH/00GD/nlL1joL/+kmK6685a4OLIeASV9ZtbX58tBTbU6QYqLbb
	vkNP7eqvf5OZFLtC6DgWV/nceILSRqx3k7nJVGOdHHc2Rjpw9h2MLyn3eOGmKjsl83iRdbTvd2wTf
	zieRGNaJA7E3lp0JA42gwjjOl2t0L9YJrSyP13B7IzXaUt/zDKfr7SnP3DbTje1GAYnKcEaoT0yCF
	Lpp1s+h+NErWpk+TB8TcquNKD3sko+gJuXkYV93MroOduO0kYlqHgdA7wJJqB5a/WYzRYPPubgDJ/
	W+KKwV5A==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QK9-00000006Uft-1Z7n;
	Wed, 09 Apr 2025 07:58:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 34/45] xfs_mkfs: document the new zoned options in the man page
Date: Wed,  9 Apr 2025 09:55:37 +0200
Message-ID: <20250409075557.3535745-35-hch@lst.de>
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

Add documentation for the zoned file system specific options.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/mkfs.xfs.8.in | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 37e3a88e7ac7..27df7f4546c7 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1248,6 +1248,23 @@ The magic value of
 .I 0
 forces use of the older rtgroups geometry calculations that is used for
 mechanical storage.
+.TP
+.BI zoned= value
+Controls if the zoned allocator is used for the realtime device.
+The value is either 0 to disable the feature, or 1 to enable it.
+Defaults to 1 for zoned block device, else 0.
+.TP
+.BI start= value
+Controls the start of the internal realtime section.  Defaults to 0
+for conventional block devices, or the start of the first sequential
+required zone for zoned block devices.
+This option is only valid if the zoned realtime allocator is used.
+.TP
+.BI reserved= value
+Controls the amount of space in the realtime section that is reserved for
+internal use by garbage collection and reorganization algorithms.
+Defaults 0 if not set.
+This option is only valid if the zoned realtime allocator is used.
 .RE
 .PP
 .PD 0
-- 
2.47.2

