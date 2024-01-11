Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395F53C48D;
	Thu, 11 Jan 2024 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lcGgtUQS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WU+8aSaBaYmzG/Cf85/VtI2sZbUgPvSk/Eybf9tRl44=; b=lcGgtUQSIW2qPp5WVxeLuv2T4F
	WaqHsqWk+9HCt31GYpSAc/cNYLONyghNQUPUEyEmu0W6NqKZLkfYO0Mcdk06XISHZLMSV5zBp3com
	gB/E1MbiOEL8IvzO510sn+scl+mZzvuSABQbKfyv9h6D+SYKfqR2oXeCREygB20lOdE+icVq1fPUU
	3Pnnkl01+oYOE+9BsX+WQisTyHQfZ4pS9ECBGSowP5QcCGSN0+CSA7iILSHRxxBAfLR6anf2cjMD6
	/njjitMP344XoNxJ+g7Lw3IMiU5fzXWVDhC0XOW9KNyAQCKCiKOnch/J0HTAozj8s76uXZGUS11zK
	dEsTdNPQ==;
Received: from [2001:4bb8:191:2f6b:63ff:a340:8ed1:7cd5] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rNvyc-000HFa-30;
	Thu, 11 Jan 2024 14:24:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@redhat.com
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: _supports_xfs_scrub cleanups
Date: Thu, 11 Jan 2024 15:24:04 +0100
Message-Id: <20240111142407.2163578-1-hch@lst.de>
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

this series adds a missing scrub support fix to xfs/262 and cleans
up a few bits around this.
