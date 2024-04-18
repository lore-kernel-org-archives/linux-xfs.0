Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4E9495CB;
	Thu, 18 Apr 2024 07:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713426052; cv=none; b=AhXMbuAiMthMtv5SIWtHXJOmAqMdl0DdkITJzqwFBPQgrK9rpI13pgQQs3MVyXs4SwnWdv05H69GxUGPUzdIAY5/Q33b/KvwG6rW+nyQQSxS4wE9MF/qViMts8p+FLohW9uf3EokPdGmdYapIfuTWTRLb3FULXmaqOxgmaTWSxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713426052; c=relaxed/simple;
	bh=zGVysyWC3mhoQp8cAPoBo9VvEKY2onGDA32qeuq1D6M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V1TXkdYv8aY1cVusTlGudV6F1Oisf4fdRAx3axPXrEGNd823C8AKAzlZY8jBmhmTCC5EDUA9a61ZxrDs3b0+nLtYS2qHOruyZuuMGO9wBoasa6s7KwI0j4dDjmgNV70iggJdbJtWdk/ALAXlox/4fOX11mi819SN5WwzIPpljgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UB4I5cTo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UB4I5cTo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=1qZLIIvcA98YiPeuPHFxWlSduAohzBkhZwQbm3Vby4k=; b=UB4I5cTo+dqtujfZmPiFWBxzGu
	myDZpn7rUTGCGAOoVuMjziGv4q5Yco+1iSUC3746hBhtdOQeyrfD8fMRciJympV582ysip1ogq8EF
	OcVsSs4ZKLETffBksEANT/pDvlsV5wl1R+mDmDgpYMwRqY05JnfDUaSoF6FhqL8EqOTr2LRZZLxFd
	bqMEBFuO8jKjICIpHtiZNRxLwpk7kzLBZ1S+Bw8mNAdrDc+8m5Pc9NTq9mDpCh2lolqFVD+fP86eG
	ySLvY7yQody8sgxoe4+fSF9CduHjj2wrilTLpN6KbzkuoVol7gPEaaRJBESVeSHjaMZdHjO2FCO7b
	aTynfMmw==;
Received: from 3.95.143.157.bbcs.as8758.net ([157.143.95.3] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxMO2-00000001IiZ-0CpK;
	Thu, 18 Apr 2024 07:40:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: fix kernels without v5 support v2
Date: Thu, 18 Apr 2024 09:40:41 +0200
Message-Id: <20240418074046.2326450-1-hch@lst.de>
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

Changes since v1:
 - dropped the already merged patches
 - made xfs/045 work on v5 file systems
 - split out a few v4 test cases insted of disabling the tests
 - added comments on why some tests are disabled at least for now
