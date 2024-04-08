Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289C67BAF3;
	Mon,  8 Apr 2024 13:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583176; cv=none; b=QeaMzvFyVB7TP5LXS+Lkp1prjEjdu1jlbjkV7SlFVGqf/jYnOtZBLuunDP0SbwYRJpjGaYWXPBVO1vRrLy/VswJXguL1j5HZBjPOlfOpDGCMLlyBKa2t5AoNoHuCoobZ2SiagDTTyjMj0Y7GVMxLOJGuITWZGaH1yi0wlPdYKpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583176; c=relaxed/simple;
	bh=3WtGibFJGC8k8uV2QVBBnVDZds6YzyYe64+fZYVgHbE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YGGbm2eZU9rPkeRiA4DQMooqkk+mj8xCm22aKZIMFcAIocXbbwTKGy3pGBMouIj3Jd2OkeEucUnC0/MTI+MoKOHnuHzo5o74K1Y1F5qHyuMniyAi1tCYmI5OYs6gpSWNi54R0I/UTzht9P6QvmX9iqgirYT4b253jETKqmZISBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=im4GBBsu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="im4GBBsu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=kKFO5IUA2y1JDvpSGgNsS5QAgCe/vJ/gN5xlab5Png4=; b=im4GBBsu44re9omRyp+6UBc4oK
	T9p0GdjHfFegapoM8paOwsOFnSoXFF9pDzxYiP7JqLVXwzhyyfkb/ChW9t4gfd/67BpyeUI2FLqya
	AXex1w8PMakSt6X16akmYUY2Q0FEVfrLQuSopFGpT1Ffew4qeMQm73AtnO4DQj6km1qXRfHTqsXnk
	dnngzvoffJzR/8OLbGgbN78D3qTNu4sKKoRe9xRkXn8mFXL1fA1h61rRGbryqCrU1V2BCKETrU42U
	tqmWyqdfhRIlUhv0/rxkkbIcZ78Kj7xPekhL0937LSo9F+3x5pBd11U/dlMqAR4odviinofIIQn6T
	ID4NEX4g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtp79-0000000FjQw-10kW;
	Mon, 08 Apr 2024 13:32:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: fix kernels without v5 support
Date: Mon,  8 Apr 2024 15:32:37 +0200
Message-Id: <20240408133243.694134-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series ensures tests pass on kernels without v5 support.  As a side
effect it also removes support for historic kernels and xfsprogs without
any v5 support, and without mkfs input validation.
