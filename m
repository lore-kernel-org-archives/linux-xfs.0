Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327113DDDD5
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 09:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773221117; cv=none; b=cD5OVYlOIG0SKt3FuMbgEqy87ri3Azef2yZD0dg6ZyMS5BUUNiZG4rL/e6/WITTovEciH1h53E7RxYOLJQrNg1DeS6qnog50uiaRYviBcS0T/SUaJhB9Sq18FttLoVmTklfnuI969+xvsLXwkLCNTuoCQZwygHJsluEhiA/vvd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773221117; c=relaxed/simple;
	bh=KdNglbRz+CmKIc9cpKsgfSfqm29qi8WiY9h3FMgXXi4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n3zle8ZQvk17e305PYg8i793ilQHHkFTnbOZrGu13woGedHjzU6Vz7cN+I71u63+d3/czrMEVWhf7iK1MV3qW62GqgaBItNq+1tC3wO2Zu+8OT2/pFApJbQVP8goQR/ZMKSCxIajRhx/2qZ+cAz6jIiCyLiboNIYAVAAg1e09qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NLxLmGWi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NLxLmGWi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=6ScTYNeDTmWGxDCfpLThczfKwZsW2Sd+Wu+0t+hGE2Q=; b=NLxLmGWidOZ1rhV61sIGcqmo4s
	SFNP3qnw6H4JUGxTD5n5+aXXZ1wjzFNmJBES8fkPXdSr3uIFUlF5lGWLGW1N2vjleYfbC7iAT5UEC
	zqq/m9askibpu0mJbl+BjGO+Ln8F+DN8aKUqT/+FTL4jN4sVCRXx0QOeR8xsVw7dGGsxGEXo5M4+t
	CxUTudVxfkJAjkkBbpIihIzloSexklYrc/0j44uHZc7scZFKzgbIkjQgUndjkiB8Jzs0rFYKjYGNt
	YDuaNOVwoRelWkRemZJddZtWBArUsOtwcWVhzjOuG7lDj0H6cNB2ZfdhYxpGwtFPhUQZp7yAwphiB
	rwEnJGbA==;
Received: from [195.12.231.117] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0FoV-0000000BH3x-1zXD;
	Wed, 11 Mar 2026 09:25:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_io: fix fsmap help
Date: Wed, 11 Mar 2026 10:25:00 +0100
Message-ID: <20260311092503.995666-1-hch@lst.de>
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
---
 io/fsmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io/fsmap.c b/io/fsmap.c
index 005d32e500a0..0182154fee47 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -24,7 +24,8 @@ fsmap_help(void)
 "\n"
 " Prints the block mapping for the filesystem hosting the current file"
 "\n"
-" fsmap prints the map of disk blocks used by the whole filesystem.\n"
+" fsmap prints the map of disk blocks used on a given file system filesystem.\n"
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

