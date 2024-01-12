Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E83A1B290
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 04:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X6i2XjyA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=tX+Q67mMu2OtHp1VRl9zn/xe2vxQdVcuAVxIFEDzDdc=; b=X6i2XjyAZhhM800mihYWEbIQDX
	Nc9q1RK2PozdGNMhypw8coXjAXCFz+vQokvTMpivHmN0rUfG4K6Xt2xU98QlprAEbZSG7Se02aO3K
	PGBQ8ulbtyhlyTJvcfasEXLSZcxC23ZruQ9e+bhPF2OGAFaZxKUvQBCryQDsVlYbd5EKsTOZkt7wI
	fBDpCjJQVCMyfnJEeJ0XTum91ttRfMgcCJ0midPEac2X0RXxfETBs2PoHRKKSIfROeRS1AhKwgW4g
	eV5w4ny5Yj/pkNbjrvIRaCxSAfIXjRg45B9ct3yPvt/x/lXhxO75npUG2jf/T/hgQep7t303dAVNM
	ztWDfppQ==;
Received: from [2001:4bb8:191:2f6b:85c6:d242:5819:3c29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rO9SM-001sWs-0V;
	Fri, 12 Jan 2024 04:47:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix log sector size detection
Date: Fri, 12 Jan 2024 05:47:39 +0100
Message-Id: <20240112044743.2254211-1-hch@lst.de>
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

this series cleans up the libxfs toplogy code and then fixes detection
of the log sector size in mkfs.xfs, so that it doesn't create smaller
than possible log sectors by default on > 512 byte sector size devices.
