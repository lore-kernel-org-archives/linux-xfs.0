Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8F83242C8
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 06:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773298786; cv=none; b=lJrfDn+Er2t7kHIwWZGcSSekGyD+x686hRoH3lBnT96hahOH3CIgsr8r97Ev+v+Eg0gI3r6rfHcd3oSfe3XFCKamfavWneJmOwUz/fIsf+ISBw7hxvDkln2ycN7URDq7wLTMgwCpRA4dvsRLCS51F7QXaVy3guHc9wMW28mzHVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773298786; c=relaxed/simple;
	bh=wM6MXG3i3rDo70Pavi6oDyHSmYZVidkj0AjbC2iGq98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P92qg4I8GJuhD49vTL9vGLRcNOKjI8aLYcVZ61+Gr+CAwklPT+BGx1r3YCap7uH+RH0g2kXzWQipk+Mvp8beNWMPaM63MVdPzZQYbjeD0eYaEPJOnKixuQrW2/Z+WwFyiEmjv8lLUyoggjt8k5E4gRkVQyoxZGN/rJQYDnjhkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HP03etUx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HP03etUx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SjnvDvtmqGgoQPoFEwJmo1xfKpbC9ISnJGXzHs60JDE=; b=HP03etUxaY0BzPxDo4LG8/a6/u
	6P8eX69NY3u7QV+edxpGv6lF9BKd+WJrcGP2B0KYNXTNEhqN4Vh3OMlKkfB6R5XzU1UouQB+4hUvf
	Sspt/hgWSAl5P9SmA2usSm+D2Hz/SxFfPZY6mipVuC8MwS5Gr/u0JK+jfiD+kV69YY22cNKAAy+cE
	qFag8hTyXiEn22d1pA5HhiscIfqLrjZpIOVMoIipawSURz8/Yr3CnPfodXnRx5jWSrS4A3nBOxToU
	u3CDnMlR7MBLZ0E5C20imUB9cm875M8fzadJpHW5//86Skg4JNfTNZqHAJiyeKNrx9lbTrlL+rUyi
	RwQATXAQ==;
Received: from [94.156.175.128] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0a1H-0000000DVeI-20oN;
	Thu, 12 Mar 2026 06:59:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_io: fix fsmap help
Date: Thu, 12 Mar 2026 07:59:36 +0100
Message-ID: <20260312065937.1156721-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

By default fsmap prints the reverse mapping for all devices.  Update the
help text to correctly reflect that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 io/fsmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io/fsmap.c b/io/fsmap.c
index 005d32e500a0..83ea24d69175 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -24,7 +24,8 @@ fsmap_help(void)
 "\n"
 " Prints the block mapping for the filesystem hosting the current file"
 "\n"
-" fsmap prints the map of disk blocks used by the whole filesystem.\n"
+" fsmap prints the map of disk blocks used on a given filesystem.\n"
+" By default, the blocks for all devices are printed.\n"
 " When possible, owner and offset information will be included in the\n"
 " space report.\n"
 "\n"
@@ -32,7 +33,7 @@ fsmap_help(void)
 "     extent: major:minor [startblock..endblock]: owner startoffset..endoffset length\n"
 " The owner field is either an inode number or a special value.\n"
 " All the file offsets and disk blocks are in units of 512-byte blocks.\n"
-" -d -- query only the data device (default).\n"
+" -d -- query only the data device.\n"
 " -l -- query only the log device.\n"
 " -r -- query only the realtime device.\n"
 " -n -- query n extents at a time.\n"
-- 
2.47.3

