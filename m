Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD8C30DD2A
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942832; cv=none; b=FmnG4nd4ischvOgQW4FL2pk88xvzoX/paHraW83rpo9NkKCsTJ5vUOXCsvFAxzfiW5rjSnLwJeSZfOzBv9uj89irv9suEVTh6v1E8FlgSfioZ1V0ek5dbVvDmNzLISJVok7neQXCj5eID0LWmI2t2ZwAEfae9vBmGo81cz0XHCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942832; c=relaxed/simple;
	bh=QGbXc9CBTVOUDcaCe25IsT6ze8XEftxA47ZllJUXRD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WsZiJkQUGtVjnHExjcknt+qcbeOVUY8rCaK0lDQOEnYIIC9CxLsrALsY7F8l/+d5Ci4fH0P210l9xrum04TFgzh36LI5jP4hYF1jaIX9wF3U6nzIYRg9B6eWDH1JatkJXbv7jvjsSKhRkYObeYy3+Y+RHSPGE1R86yqmvuSKd9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zDwawCf9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zDwawCf9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=UR27qxRAgKpQq22TA8Nr+kM033J0w5FwJqbX0gb53l4=; b=zDwawCf9rswf8m2fro5PnYvCt0
	RPM/oAmPbeBJceMaQr/TX8/f/NczrdBl0/dRF56LjERUw+cc8QgftmlSo9A8bJBZzi8LG8/KLkfE+
	1CWqL5fOZ3edlkIxLUUTVYMg0f1NTBNCEj614LipHyGREAsfQ0qh2/cNYM1pEutD3bAfoy5JqVaCo
	xxS3ZVDXBUesmSVpxDjANEHeKpxGAZT+CKaF44nWRjAnt7vQ1dBhfl1QONnwzajKsnHI0pjcjzhFf
	AzJFjIGVKv9cNR3Ce0zApOcpUErr1mveVTRayGxi0U8rLiI/bjxiRzPP0gPzVr5EVqi0Ix5AOXNZP
	b66+bK0w==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ec-00000004JZj-0QnV;
	Mon, 15 Sep 2025 13:27:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: remove most typedefs from xfs_log_format.h
Date: Mon, 15 Sep 2025 06:26:50 -0700
Message-ID: <20250915132709.160247-1-hch@lst.de>
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

this removes most of the mostly unused typedefs in xfs_log_format.h.
There's a few left for which I have series pending that will do the
removal together with changes to the area.

Diffstat:
 libxfs/xfs_log_format.h  |   83 +++++++++++++++++++++++------------------------
 libxfs/xfs_log_recover.h |    2 -
 xfs_extfree_item.c       |    4 +-
 xfs_extfree_item.h       |    4 +-
 xfs_log.c                |   19 +++++-----
 5 files changed, 56 insertions(+), 56 deletions(-)
