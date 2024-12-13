Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798081AE00E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081642; cv=none; b=AqJMC/xDzgdDnhXdQ+EG3NysmuTVu3QfmMotjLRiQYb/ceDnTHUgs3VDE2w0NON+YHXZmu6qEqBiD8o5klUVHgQBry6C7EMe/meIvEE+mSDMU7fyfXIpfq0DUIQJIWABVQLFCEZRZHnupEJkuOfbYuulIOPUQGTQUmu760V4POU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081642; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NpOy0/2FLK837DvuTdOBhYyXdioruQ3rqJ0LgNlPUTKxgvPleAxaWoGP3Z5H/k1gCM9X/exvogxmojgL7w0g6Q71uDfuG8ItAISNtpApKWTvpb0zSta7KNPxkcpA8yRx+czi6lUEB5oP2gaqiX/dRUaJG9bS62P2af24oGEMdJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4TxeHHLw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4TxeHHLw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4TxeHHLweaijuMbSdwVuru9h8n
	cFChuO17OKz16OKDdnQvY3mWBxggDiqUAWFLfU+uVUz1avBfaLoRMCJ2/Nj7sg6+QAa4zX3ZH8O6w
	U5AqeCKhLQNtLb6xqiS14KQf5TgeLGGx0UY6Dv/10Wr9e6pNP9kDt7poVk8N1tAeVtvwMBGJovCye
	uvtRsb+txKkEwI9Vpu/8o92CNlt7lfo5O93n6FouDG5QUYzcB6m/ib4syiYcIsW9quC/ahC/ksJ7M
	+GVJ6x307psf40gJlcf4V6Mg631h9yV7uNyWZMEH/qbgMMqf9nZ7REo17vYv0yNvai2WZUIDTCzZG
	YeCCAVvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1qj-00000003EOk-16Pt;
	Fri, 13 Dec 2024 09:20:41 +0000
Date: Fri, 13 Dec 2024 01:20:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/43] xfs: don't flag quota rt block usage on rtreflink
 filesystems
Message-ID: <Z1v8aYlS8djCMm4K@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125167.1182620.9849878961217482999.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125167.1182620.9849878961217482999.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

