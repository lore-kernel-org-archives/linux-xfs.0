Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733233D16E4;
	Mon, 13 Jul 2026 08:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932532; cv=none; b=jgAlXFy2EZpBtv5Twlb/EZn0Txh7i2oLEanvKuyhR3mtRIrHonqUXZaay/6peHp6lzVnAmptevgY9RGxx0DTJMPSQWOOkUgEp6KaP9cvTlpIPfpM87rVwVQdN0NjzaHmYpRk+E6EhpKkgkhyaYttkje1RO9aq860TAYQ8RaMO/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932532; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESQckSPZKJQ3MBGj4RROsG1I+z5C9lc9uG+yYKtrqEAmPwBfhv88epWDqxjyvbe55mcfIGXLorHBEGkUyAmgnmNVEcqZyrBEck8qa9z9c5E9AIg0doa1plyYkt2SRQ2Rb4L/KSyCCmIHLamlZD53KTZkuqzfn4Q3k+g/LK/hQbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EvsKzjuE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EvsKzjuE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EvsKzjuEgtRBl9SY7kT0hqytrI
	GbMOVfiYuThDgikEXWNR0WhesLkNUF7ZT0vZDfsz1E5SFFZ9Mn4a8OZtGqyscu/tk0LUek7uBOuhB
	Ovr2M7KdMQN9Yz7uoQLp6VpwRurpRpvDxChydN/x0bmW/thgc6eQ1mkQZtEy+iDk1oXyPd+PrMe+N
	CGAcj2Myb7FlVm47skSep0KK94fz977tl0xaxHdKUWLOLbxmooC5aHlcBZsd4387Q4iF2s/Neh7aR
	3lOOgoHKKvHkZeaf795AcTireWTvRYbnwNcbnf/RzD7pY3L8sogGZT5hjZnND1YtrwCP7Iqp1y2lt
	6JL5/xOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjCL8-00000008dIc-2wRa;
	Mon, 13 Jul 2026 08:48:38 +0000
Date: Mon, 13 Jul 2026 01:48:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
	hch@infradead.org, joannelkoong@gmail.com, yi.zhang@huawei.com,
	yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH v3 4/5] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
Message-ID: <alSmZnXp4aoQimTg@infradead.org>
References: <20260713072906.1726059-1-yi.zhang@huaweicloud.com>
 <20260713072906.1726059-5-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713072906.1726059-5-yi.zhang@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

