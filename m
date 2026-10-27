Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114181;
	b=pff/ros8emAciEUw+/S4RlFOqlNtRhq7TDs+m57QdIb9A6MNgcItt6k3/CU85DWXLVRM
	 oBGST84Bta933xW6qCgXH/ovSg01txfbgzful0a1oWMYV2t6RTbKdxOHOoJA8Xqi8eKY6
	 +/8Ik1wVKzB5KU/qV0rTY5AKwNzl4U+Oc7DU/19EaOJRKXEzJXlBntuMeCRFdh8qSwYDI
	 m6R0IFK+ZzAh31tjWyYZxQ9ArNqBkGvmPHGI/iCrSVtZugt0lO46O+0zL30/sgYjUhCZ7
	 ZEkvZgcul+JCghtFY2H6S+Bm6Lib35/4B7rdOFsRi/uRuRZXMl7u7KofMnP4MlfL06g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114181;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=uTmu+uF5YHYFGRmqXWbd0CDPABZJAOhn0b5035Po2XasA6HWwSBfsvltCH56wzDBYP9y
	 JNrCusMmLPjARdFVGsXKa+N6fLO8TjX1qlG9eOLUL2uR6hHGFcnokoN8AofgpQCPZwk9Q
	 f0sVxBV8SQU92Na0xol1Wgbnog3kVHZWs3lUlgesRLBXhI3AiKhtzVulFOnRAwgROlbpT
	 S0q87daMgB/8IBZ3TKIZdO8yyUIAtfChP5t8cJiAU4MKpc8YScCPHj5tLSzdBtc1bTujc
	 uYyDe5xkYE3j+A33ycI9dFT3qZfawgvnBSZkmYJZTYRs+pMP9cxfY4J8ljhLLVqYfmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wGpmr4z6;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CB4606A330;
	Tue, 27 Oct 2026 15:16:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61CB4606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wGpmr4z6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wGpmr4z6FBRpb90baeK8H6tS1C
	QO6YW1RYhqxh06GHWNLdhun+kVnRZpyA+UqwZrxkvl0vfBR5hstBU62SyCd2il5LzeCz35pKa5jrw
	iPgXygHR+vs1s6J30ZO/hMQNxNEucSP4Vpn2omHelB0TmTgHO2dcVpyZjT4xqci8FORqz5a9eZH9y
	ROhxj57iDt9qwkvsYoVLtB2u48iiOlJuHz1IYL39O/7E8YZrCVeI7w+7DDT2NedF/cha5b/2OiRqQ
	6tCT/OObOVH0kREuE6EgZvVYYV35Hn2AR5r/0a172SnHDTw5ihvuRuc4xtZx5WUPYPO5knrOCrMvF
	XPcxBBQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLiuQ-000000058nq-3cWN;
	Tue, 27 Oct 2026 15:16:18 +0000
Date: Tue, 27 Oct 2026 08:16:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Binbin Deng <18983559317@163.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] xfs: set healthmon mount cookie before publishing it
Message-ID: <auDAQmWP3Asgl28Y@infradead.org>
References: <20261015080225.45215-1-18983559317@163.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015080225.45215-1-18983559317@163.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

