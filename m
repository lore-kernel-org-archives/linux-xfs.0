Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115762;
	b=foUiYlTqUNdDpH+TUgIbrQ+Vt7BkkVMpbdYON0T5+1PeAw02XwfomuJ+GsPaF6i2FTsY
	 kdXyDL8iv+G3iYmAZqXDOP8oWDJTU1LVtJYVrWPN+8LIJHTy7mhBRGImv860oixtFPY14
	 gnNinz2jM3VvQoGb0ujrLPdrUBeGWB+/mpbHyu4rTUJnOo16fTPhpDv8sXYfwhqW6ZFT9
	 TIB5v84jFLIBN4omNYC8QRMJtOuxjXHqcmZ19deAQpWX5JDD0GVjufhXlEX3rFBrC3R7N
	 MPcYQTzLMKNAWlkX/VkfKKFZNuI4NEd9Q9EIFDusdHpJiGh/9n9Zc4BFP38c4evAgeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115762;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-SRS-Rewrite;
	bh=T9XHk5QjtQHN1b9m893DqQvsESFYGKc9vBodG8q8nM0=;
	b=4iUjk2XhkywQwjLYcPafYfS9h6a1u3gaP6dMmIv6T01ADvGwO7b7vgKqrKi8yx9ktFJz
	 2lQ3tYXDz7HUkhIYrocegiVFQQXpAx2coarW86L0xmZaa6NIH6mtfYhH1Ah3sXOsztYiX
	 oA9Sv6Hb7wtyYkGaTVPcNBChufJ6zBtKbNJkc14pPuxUpjxjPUoaZgIl3N8R8iXAX36eF
	 0pJRCkWQZUMzrogZiH8ZuJ7ve6W6yDTZYH6+4eMEuMqeEHz4qfa1HOC6ifyi1Rve19JMa
	 z0AqlwOMbLAPEkHEQvZ/xK0UkmLG1AjXyivipGl5WxP27D0J3wSPmgK07sP459ku1dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=bgQZ27oI;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08B5606A31A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A08B5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=bgQZ27oI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=T9XHk5QjtQHN1b9m893DqQvsESFYGKc9vBodG8q8nM0=; b=bgQZ27oIlzngpJsAKZijOFs5Q3
	bfyEiaTtLZ7fj3NdqPONuQmDMIP/xRuj0W4JH2cCO2PJ+5n1hmWqMeFslE4IL3Qt84+35TpNvnLf8
	10Gq1ngKqbdh94k9fzdukZs/dxJFnR4XjfnRg43K52WmcAcqjLRXVBQxFW9aQDhjWEZ09ohe6JwUQ
	XN5gO19EIXcr9sEsC4vWlYGqNgJTxK+RyEPQ9netIXbqKLsmRCluhmg1e18vdQHJXuNYkf81RaKp0
	JKbm6navjfy5ySeZw/H5hj1F5uDN3I4gml0P/cO/T39Y+/1hAorIXIptD0qvLJnbWFEu9jyxKG04A
	dBvZch8w==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjJw-00000005Ftm-37LI;
	Tue, 27 Oct 2026 15:42:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: fix libxfs compiler warnings
Date: Tue, 27 Oct 2026 16:42:14 +0100
Message-ID: <20261027154237.1997484-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series has a few fixes so that xfsprogs compiles warning free on
Debian unstable.
