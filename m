Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C7D429CEA
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 12:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414328; cv=none; b=tN8pmBetS9GUaWkQmuiovJky4jP41ifhjM2EOD/PYH0YAoOAe4aK6KRsvlMOQYkwU2OyeoFYH7lnNKXnyrwXs2SGbkbM0BW5kCkBsuEcQ4Y0Vi00Cc/I7bF06IVoQBSsW+jR8w1OAWpewgzDRJlBm5J8CMSglV+zB7jWyCFue0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414328; c=relaxed/simple;
	bh=hor3S4524UNOTlnKW9T06UDxcJHKZzBfCDi4NE0gdMg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GhKqg6ae8k8S8LpEJtfP+M7JLoSYbV5j89fec3xzks707gXJKgY2PhAPzJmu3U8n2IfYOl8nuzm1Dh4gbp9oiWX3PzqrUYT2yBPdg6vYbUIUCoN0+BMEIDffQR64v3dOAxI/jBggz8OL1y/0wlL33KDRgT75YftWZ0Dr9I0zmEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o/iZA1v9; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o/iZA1v9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hor3S4524UNOTlnKW9T06UDxcJHKZzBfCDi4NE0gdMg=; b=o/iZA1v9FGJHZ6riG/xTjd6n3L
	4jgRmtv2k+jxSh0Q3kDrguINm0dhFNz/VnL4NJzM4x6nJC9i2z2h4tjfZyEws3yDTANqGw+67G2zZ
	p2jydumgFVFIu7km1B0rQvhnV5zulTrUEok9If59qCJsj8JXAeO2MxBoe5nGtl6yNCadsxEFKoVCI
	m6dKqGbqtA4NHnhtbHShYTs95P8v6mTRl90Y8dJ68/IbbF85MgeQKBeEgEirCDTkkJScx3sAA8dYh
	KaOW+Wf8LqX55ScMA9VNtO/JoXOm0q6L4bJDhJ6hbt7axbyHwrqzogxYNaU3qmaeRXRPQqKV6iacR
	DScZ3hWQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpPpC-0000000Dgbr-37Ui;
	Thu, 30 Jul 2026 12:25:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: make the size options to xfs_growfs a bit more useful
Date: Thu, 30 Jul 2026 14:25:12 +0200
Message-ID: <20260730122521.2578459-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Use the same cvtnum-base parsing as mkfs to allow for easy human
readable sizes in growfs.
