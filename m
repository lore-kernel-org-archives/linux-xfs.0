Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8E138B
	for <linux-xfs@vger.kernel.org>; Tue,  4 Jun 2024 04:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717474178; cv=none; b=AX9PSj8MFx3XsZO/6Z0/8Yu+O36v8Oy5pnnwEbpPf+84srQLA5cxL8r9yQHDPwHkRn8iQOtrU5UdVqbD2heNgKqE3MJhESyb8kl/RPPJbCWgIjy7dqCJcRuVyvi1ZTDQNr43jzmIGljJqkuWM4SHN8ZpoExK9YKzFu6yJJoYPHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717474178; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DneaLp7sNOFNhLK8NG80j+zAag6Vk5U3Yyh/0S3UnsKRCOuxSRFzyxcC6IvntWYyCO3xh5GFSJ6CSg4xPCXR8TNqqB56bE0/BB/yCv/xkp4iqhACcMnonVbQ3Kt1NDs6XZOq0Fo9sVFb/PiGngyzYhvRLoRlZ/DLg19Iz/5oIOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bt2hgnWx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bt2hgnWx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bt2hgnWxyUtS31ChmcCnS5ntnr
	Fhzxv1swplrBdmfvrsuU6fQkzjA6SUqr90AzBBjzuSohbTk7TDTCRem194LALtdSIml5wI8V2Tjlg
	8iuN7zjTxwGVg8DjyQSaO/AfbaXGVqa1pKH9LxUkoaiO7NvRPydMHmbOYy/rpMu4+dt2B5K3UKsQ6
	UwOWswC1YR9YIVTqpXAD6/GcF7Mg+QBLwE6ww1t6A9dsTPkqBZ1N2/kT4dKvaYoq6WxVggWr7wOHU
	bB6CasF9FDVLr/5US9k0wUyFIKz5jKlKwUFoR2fp5xzEcn1mV+J9dXjtnAhk4jjmRNiuDcmeE6fu/
	+RXRwj9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sELUO-000000018ud-2N7X;
	Tue, 04 Jun 2024 04:09:36 +0000
Date: Mon, 3 Jun 2024 21:09:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_repair: detect null buf passed to duration
Message-ID: <Zl6TgF227d6v1MLc@infradead.org>
References: <20240531201039.GR52987@frogsfrogsfrogs>
 <20240601175853.GY52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240601175853.GY52987@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

