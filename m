Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0C530C62F
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 08:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123157; cv=none; b=syc/mU158Uc2eLZ+slBxs1OPVpwF1zM2eiggnfYC4dFXHZ8jf16N8nqMlF7J5MI9lKV7KFtURip2jv6B1n2vR4WiNvpREcnDjTfqj7MENkaZXg1eesFDPfRPJ7TV+EzDDkjYdht90xeDwYFTD+Igzr2KJEXOu4Ioh87Ob16Vcps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123157; c=relaxed/simple;
	bh=HEJpTOdcpu9/myOwNFMsHlEa2vlMSKgSZKZG/djXQKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LjWhx9suN6/VgOzrhsP2FOW5dGoBG4ttIq8X3PNcZ6OtzJ5OOWA1HwV6/cCOsdq6nODN4+GMQTDjMxJy7pKwhnlgrqEyvqCaj9HYF0o78mMcM92WcYO81Ro2D1zNFsl7xeBjvd3NIQVDoP/eJJXBF6d9Hhqv8vYPu/4v8DdMS7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z+Ohb+Po; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z+Ohb+Po"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=HEJpTOdcpu9/myOwNFMsHlEa2vlMSKgSZKZG/djXQKs=; b=z+Ohb+PoII0MvymASuF2w52ny3
	MIw+HbpLXNbfMHa6vW5XC/QiBDRqZGphK9c6Qi6goHHYjflfkdKel4BLOfBJh+KtaMBlIq97iTl8U
	heyf6i1d05SXzsnxOvgqiD8bjU3WC65e7RyKxMSfedg2NePkIdL8hdkR6N7aRXUT08IoEshiTuIvY
	1eUCVfIuAE5DEen4G62mFmbBW9ivNRVcSdpiWkUgd1dF5PGKb7wU2cfsUudRDP3a47a7WRKg5pAfn
	MPy3F/M2u25x/VmipIM1VZAxziqA23g4GWl5uKdjCc6luEEvjdGAXt/zaqoi7GPSh6xhhf25O8UYz
	4l4GS7zg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBUaB-000000029RW-06mI;
	Wed, 22 Oct 2025 08:52:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: improve a few messages in mkfs and xfs_copy
Date: Wed, 22 Oct 2025 10:52:02 +0200
Message-ID: <20251022085232.2151491-1-hch@lst.de>
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

these patches have been in my stash for a while and improve messages
that confused me when I ran into them to be a bit more useful.

