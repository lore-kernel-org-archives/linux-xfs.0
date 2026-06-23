Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EDA3845C4;
	Tue, 23 Jun 2026 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782224477; cv=none; b=KU5eJGCrfoJ4tEi67bq0caQbuseA4WLUrZovjAw24+rnSVEsdrlll1oZUqxAPJO7Xt99GMu4y2L3LWDal+a0rQNlkI4nqDp7B8O8POGoG2RwkvnKfaeqAlMdyfsMqzQkwEW0OG3YD9nbWvUO+dE2FuuK4HUeCCh3X7PZFhZ8csI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782224477; c=relaxed/simple;
	bh=uSqAquCCfx5Zo4PPsN79iAXGeUM/44mQbb7aCv7xkkM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o/6VSca0Wq9i1K71WoUjdAzdR2IbgcvbRg76IdGQ2eJzoXDTMaVpz4o2QpFWBm+Vo6hVGcUs9KOG1j35FXY3vN/86tsQeDzx6e5EWrGe+ft23KWiev/36RO475LhmyON9AAiV+SrxDglXkxha5A4/qOr5bm0a5UlvmuvCewy7Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qxcWuUhd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qxcWuUhd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Dkcrp6IwL5lNKNuQ1YOUat3sO2SXGMxGj5WnoeDRe4U=; b=qxcWuUhdwTGh6r5/ShofW8uK6R
	g8XpgueTdeE3Yk3bVE94YEQeLKX8DaGbf0zO2eAzU5xbmQhByZcTBMIVej1idS18+gynctR+xnNjF
	/Iknv5vE+uCfDSsLzQ2kTCxAvEYXkilWrKUcz5XYC7ece1yRRQplqjY8edGspD6zUd42lzpPsh/S1
	UFMbxSx7+thXHMnr6Q4+MT2hDSi7phjav4LL7/7WNdF1ujFFzG/jxyd4vyuRryxgF3I3kYe1/BYBr
	jZ5Er6loDrhRPQto+YLHBBBF6hOkLdcOvIEcDxerYZ5aH501xbPjmrExia43oaRCL/IYcB5XT0EZH
	Nkn7nhhQ==;
Received: from [2001:4bb8:2f6:ef61:5b2b:8638:3844:9408] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wc201-00000006QbX-0WPP;
	Tue, 23 Jun 2026 14:21:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: update BDI {io,ra}_pages values based on the RT device limits
Date: Tue, 23 Jun 2026 16:21:05 +0200
Message-ID: <20260623142109.1838702-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

we ran into a bit of a funny case where adding an SSD to store metadata
to a (zoned) XFS file system reduced the performance vs using a HDD for
both data and metadata.  It turns out this is due to readahead code
looking at the BDI limits, including the io_pages value that can't be
inspected or tuned from userspace.

This patch has the simplest fix for that by just updating the values from
XFS, but for a long-term solution this feels a bit ugly.  Other, a lot
more invasive options would be:


  1) support multiple BDIs per file system.

	This would work pretty well for XFS, as data for a given file is
	always entirely on one device, and the VFS writeback code is not
	used for metadata.  But it probably doesn't work well for other
	cases

  2) stop propagating these values through the BDI

	Have a way to query these parameters from the file system, either
	through a method if we want to be fully dynamic, or through fields
	instead of going through the BDI.  The downside would be that
	sysfs modifications of the readahead size would not work after
	the file system initially queried them.

Thoughts?
