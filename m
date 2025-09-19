Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D139236A8B
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 13:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287549; cv=none; b=WLaW3CVKFVIqiZ1obkV32llplwZuitUSDO0yt5v5CdLA3L0DIvueTtKON+JuH7YPjyW1E/XKkoYKpfuZvEIsHBJVgBJV/wq1QF4P+b4ePC5hEblXfq5gPjzme9DCcvBXiGEA7GPuyU9c3pYD76sebcVElYEprmi5wZZzpCGTpbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287549; c=relaxed/simple;
	bh=pvv85a8TOTKCjq225kGcpZp2t43DMGB7Nf7QrpTHrPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pVG0jmSjHbtts4juLdseIMve3Fo51mzJnUm3FL/fkGOfG4ryour56v5vCc5qIfN1Tj200Vl7S0Vfi91wIpbb+D3uVyUqRfxxwuF24wDyjJrA4nKZP+hTvBzkOoj6HOx9xQpSp+372RtXITlrhiA8/CUG4CEObJqgDujCwG/Xsvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y73SkgxG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y73SkgxG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=uAN6h3EKWUI6JyNPQWShPpw5/zIVaT/0/2Kzppqg9MU=; b=y73SkgxGDw/zp+GjaVqQEfpy9b
	eYMLpJjEkFKhUdoOMZUmHhtOlSATyGPKabFedULditvDiF5xXCA63XVMxCCsLoyBULuCFHUSf1Fkw
	vkbyEkpQ9nHA2WxigouRLfX/SWMUX+QW+moS5I1U1J54JQ81OJvFpv2smBK2h9rtp4C/6vj6RdZ69
	0iaASO1UuSfwUYKd6rWpRKILOUig2yuo1V7h4PacI/RsKvvu++KVyoHKD3YAdElhdc/BhJ4uF+UHW
	cIna72hSyCGKNUHYD3hKeWxQE3A1o7fHN5bEbAsizwA5rWFs1m+I1pnwABWamYLVfkjp256Q0jcD+
	LpoeJ+7w==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzauV-00000002x11-2JW4;
	Fri, 19 Sep 2025 13:12:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: store the buftarg size in the buftarg v4
Date: Fri, 19 Sep 2025 06:12:07 -0700
Message-ID: <20250919131222.802840-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

when playing around with new code that stores more than the current
superblock in block zero of the RT device I ran into the assert in
xfs_buf_map_verify that checks that a buffer is withing sb_dblocks.

That check is obviously incorrect for targets that are not the main data
device, but unlike to hit in practice as the log buftarg doesn't store
any cached buffers, the RT device currently only one for block 0, and
the in-memory buftargs better don't grow larger than the data device.

It's probably better to fix it anyway before running into real issues
on day, and storing the value also removes the need for the notify
failure code to poke into the block device.

Changes since v3:
 - account in sectors

Changes since v2:
 - grow the correct buftarg when replying a primary sb update

Changes since v1:
 - grow the correct buftarg when applying the growfs deltas

Diffstat:
 xfs_buf.c              |   42 +++++++++++++++++++++++-------------------
 xfs_buf.h              |    4 +++-
 xfs_buf_item_recover.c |   10 ++++++++++
 xfs_notify_failure.c   |    2 +-
 xfs_super.c            |    7 ++++---
 xfs_trans.c            |   23 ++++++++++++-----------
 6 files changed, 53 insertions(+), 35 deletions(-)
