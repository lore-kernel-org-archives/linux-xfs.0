Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E4C1A08CA
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609087; cv=none; b=bnLGn4mWtX/v6jKkF1lvSaU/4DHf/7aLfyWmhw8urfnUtibOAGGEvECeTkd1PxHrBp3RyJ5Ir9G8yMDa+wW0xi5DYL1eh1mAEoWxZMYOQmiPcF20EAtxIoucXqZMciDhvb5W8JrAVo+3cGpEDebUgq71A0698oAkW88OZC9CkGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609087; c=relaxed/simple;
	bh=zWn6WjaGDhqGI1r1ICIcAT+iNaehWh3YwadmjqRTJP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLARajtREyX7xE7UTreJMp4m+PiD5iI+oL8YZ5uTlD8wf0n7dd5pn4TKBj6RymyMG1Ghk893k3Hylvjaom2eu/12c/TxCmyrZq0WcdJIz44M6XX1t9ngCM2byrDYLQpUP5pk+qocXN0U+SEVaWQfpp1YTD0zGVisKjESqtPL++4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vRjqtSBI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vRjqtSBI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iwTd/ILDbAX80nSXrRGmmpiLboly4mHQ8KbOIa7hJIo=; b=vRjqtSBIA6QZUShnlGcXSMPtEK
	8YCBvy//scSOBCw5Kcy9KKebV3IxUgu3lXcBYnCHPao/qsWv6ButOd0+6jQqji4aTXzOEHgxjGxGw
	B8Su0SKsGGeF9o9+WwSZjHDu/0Dvq22m4IQEz6UCjJlE5vytyM93f+d5mj3ZkiFyyfZ2ygamWEsaA
	An9ZvX+uSIKgeqsd53cg44Ban2bQSju1ahkOolNK4iHQekRJBong5kMn9DTwLawkvBRPGyoysL/OQ
	jVmq0NLPPrbKfYgYcFT9mbDHTdcxh8bCYBVGyqfljvIPRqP7JkPa9eL4L5iHg7PGYgvh7U3eML4s8
	1d1zlT4w==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWD-00000000iOq-1HFI;
	Mon, 14 Apr 2025 05:38:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 33/43] xfs_mkfs: default to rtinherit=1 for zoned file systems
Date: Mon, 14 Apr 2025 07:36:16 +0200
Message-ID: <20250414053629.360672-34-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zone file systems are intended to use sequential write required zones
(or areas treated as such) for the main data store. And usually use the
data device only for metadata that requires random writes.

rtinherit=1 is the way to achieve that, so enabled it by default, but
still allow the user to override it if needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>

inherit
---
 mkfs/xfs_mkfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5cd100c87f43..e6adb345551e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2966,6 +2966,13 @@ _("rt extent size not supported on realtime devices with zoned mode\n"));
 			}
 			cli->rtextsize = 0;
 		}
+
+		/*
+		 * Set the rtinherit by default for zoned file systems as they
+		 * usually use the data device purely as a metadata container.
+		 */
+		if (!cli_opt_set(&dopts, D_RTINHERIT))
+			cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;
 	} else {
 		if (cli->rtstart) {
 			fprintf(stderr,
-- 
2.47.2

