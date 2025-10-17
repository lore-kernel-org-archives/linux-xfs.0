Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1493334689
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 06:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760681236; cv=none; b=dbiX05MeJf8hsTHT/2I0qihQoGyU4lMNl+j6/XTtcVayZfvD16fFQsD83/YkzxmKtpi3LkmhKtEOQPKV05Dtg0YQJO57qmmS0UzYhM89fgqP5JX2aD0oht7FfTsaTMz/NqH2S2uMIrBey3FXjxEcrl6O5rJDIajrOJhEY5sV0Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760681236; c=relaxed/simple;
	bh=AOuLhmVAs1KlfeMIA/tT636MRNAbWC3FICY7jKH58Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r1rJfs+YO1m/71LL3TR1hJxLwEnfwnbB0XQ/sr9UE4eM+XufI4Ohc5peeKryr33/HdbyfQtbaY1TRm3/j4tefuHis+4Hy0Yxn17eUhMvMNrpjLmOOlveQPz98H7giDppL61+k2vehqtE0YC8BiXdt0h5berABo4ezCtHk6iWZEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=emqPslxW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="emqPslxW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=AOuLhmVAs1KlfeMIA/tT636MRNAbWC3FICY7jKH58Vw=; b=emqPslxW0qLR6xOdLSgbGaM6RI
	PbpMtA9KoXOosCNQaeDqtRQdR72YHUZkFtiExSukeX5qzSq/UzvJp7h8A0mYKliPAXmp+JSg4HJWq
	VaBKUqGtwrXEAPuUluV8TpBvczkAVFQa5qUHxnk6B5t0k6WnkLeBq8MstzuZ25JFKjIMh5Pe8NSdK
	pP0m0Hfei4nGdjcXyAwQRN0xbDC9lYhwFmTLtRLg3zUXZD4aegc46J0ZSkj8lIbi3uGE1ifqNOhrn
	+Z8+WGTuWPKrqrSrrwgKxMwCI4e9vtvyuGyn3v5RlZzeHyEfM8w0iZ0l9wk73HBnTuiHkgLMX/brl
	2pDYkm3g==;
Received: from 5-226-109-134.static.ip.netia.com.pl ([5.226.109.134] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9dcP-00000006hE5-1Ead;
	Fri, 17 Oct 2025 06:07:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix for selecting a zone with active GC I/O for GC
Date: Fri, 17 Oct 2025 08:07:01 +0200
Message-ID: <20251017060710.696868-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

the first patch in the series adds a counter to ensure that we never
select a zone for which there is active GC I/O for GC again, as we'd
try to copy the same blocks again, only to see the mapping had changed
in I/O completion to discard that I/O.

The second one documents an non-obvious version of that GC race detection
that took us way too long to track down.

