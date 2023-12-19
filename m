Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C902F9E7
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 05:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ECwAMmJu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ECwAMmJuMhhLzPn4RUIYvTMfK+
	/E0FtyozZ3R4GkOsdoBjUEQw2YiWbOKSslSrGb07jLy45442qTDSyQCHNzLZP3XUQtK3MqBJ6Ubt4
	EsLS5Ho35zWRmcdMv46lFka7zFavLEYCaRV6sJtcm43u7Pv6AzRKvV5iRNXVo0g4OQmLtjRShAXk7
	un8SZPLEHC/uJGHr1IoyTuApbICQWXcLuf1YYR5FUMhddW8SvJH9NzWBVDcbJbkjoSYFZzpYQNr/1
	+JV31qZCmlezNiPqv+TeZE5og34Rlg26vTQGxitPDV/NAckmqvwJTDhAtY5yKtKfaV2GwBtW2mUU9
	eCxlC8NQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rFT4a-00CwBz-30;
	Tue, 19 Dec 2023 05:55:20 +0000
Date: Mon, 18 Dec 2023 21:55:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Sam James <sam@gentoo.org>
Cc: linux-xfs@vger.kernel.org, Violet Purcell <vimproved@inventati.org>,
	Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH v3 1/4] Remove use of LFS64 interfaces
Message-ID: <ZYEwSHL0EmiET6Xi@infradead.org>
References: <20231215013657.1995699-1-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215013657.1995699-1-sam@gentoo.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
