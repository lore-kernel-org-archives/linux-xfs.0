Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299483CB8FD;
	Tue,  4 Aug 2026 12:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785847454; cv=none; b=UzPEr9mmw69VFU65yuKUglf27Ra7e0crDCu/mkOCKAYOG611zL2MyEf8EG6JaKEK9bCst7O3XwFhbKUjZRsLcT3+efnqsathyyl96LdcY0bzVhDZXMAE7O9yWhCNw9FtYiq/zHVhrZm10SoxCeBYu5KIdCsDOhmvsvalLjAbukQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785847454; c=relaxed/simple;
	bh=7tgNNfOvzKRan/7CildNQez4giYgSUPgz7QeEMO6/Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YaJmMLs/QAKrYNuvizuNPsydwKEwWL+VYYuR7WxEnCe2AD930Wrc6f8SLNGaE/ObH/fydOQbIZgH0RhfjmM8RbTwBjmUp3Gv4zwBvzOlxBOW30U4QCLhUoPj8wSDw3e+zUw32v4725f3BxKY4PEId8aeZUq7V5++zx1kYiJY68k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DLxETZBO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DLxETZBO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7tgNNfOvzKRan/7CildNQez4giYgSUPgz7QeEMO6/Bg=; b=DLxETZBO7RReUsM2ptQZWG91Vs
	MckAiQ+H+DsqDt24TrzfIkBsW6Q2a/QZ2pBVAcK3tP/n/Gb6rGM2TElk1ahLBtFKqM9z2nmwqbomR
	biM+sJGD7xHJ0OFc2N8hQNqwr77e60BlcetjJbavmD77MCoMPkDHr74WQ3oZq5kWjnyAcrt2ZNZJM
	GyD56uScVcLXqquZYjG8DDsugE9BEz1SrJ0nud+oSx4Wokevqyubzk1BxSOYMDGBksBd8Y5LNC2RE
	k5gKcjJSCp7Lc53DdeL8cSXeKSmsOObwHkx50elJZ9WpPyPOv5Mo301yRDirDn4P0iki37Mdiq9jR
	JK4/DPpg==;
Received: from [93.123.20.94] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrEV9-00000001qRr-2qmv;
	Tue, 04 Aug 2026 12:44:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: fixes for iomap_bio_read_folio_range_sync
Date: Tue,  4 Aug 2026 05:43:56 -0700
Message-ID: <20260804124404.737145-1-hch@lst.de>
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

two fixes for iomap_bio_read_folio_range_sync, a potential kernel
crash when tweaking the device integrity behvavior using sysfs,
and a missing bio_uninit that the Sashiko review of the first fix
found.

