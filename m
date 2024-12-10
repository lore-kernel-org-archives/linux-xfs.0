Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEE9168BE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807922; cv=none; b=C5OXJtZxNS8OnWQXO2El73/sqy6a26LXMzHI1ofdrpaLuhih62iWFHatoAJBQEGegO6h+Jo64sHwaPA3Fstb0UKlOfzILfvDfnbe22cmkchuWZ33y40hJwMo423PVr7bgezrSxAWavczaOZBqffCDALkZLRjK5utz/UpGehkIPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807922; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SxaSZePMxQiWW5XpuUEIziSQQTAt0ygC2A7msZQy5GhOnAtRgFsw3k4vV2zxKzM8mGUMLt0if0gvTbMKdQd63rbEkuYpr17DbAEjdYRvRTO7OO61zKwm2wdDcJDl3APJDs2F7VC36zN/CyQnDJDhTQ1bWbOG0WcyLRslGHOZ9ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OarGkQFp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OarGkQFp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OarGkQFpUNeC6LUaG4ARSabXov
	bysaru9b9klowLHLualVC+8i5tVdlmguWmxy0sSVig2jDNK3KBZRd2faeqku+V3kJ0gOBa/y//Jkf
	3iSBT+6vwq+AGH9yh1R7L9PBQcY4KDm97JAL2EfDU4E9KaUVVW1ojKnR671MBw4GRoRkems+Hes3u
	BQbkaVT54JlxoYlaqHlOlbIJ4OaFxQDzz1HDf0HeoIpRh9olzduxyc+JywPEaZEF+rUcMjG2enwHJ
	rIrUvNpUirSx18qyXuGudy1bKgCXkKir4EPFlovOEbAtrqudiDMb4FekO9mf2lXvzdXKg6mCQXc2U
	oXsbc8Aw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsds-0000000AGPa-4BtS;
	Tue, 10 Dec 2024 05:18:41 +0000
Date: Mon, 9 Dec 2024 21:18:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/41] xfs_repair: mark space used by metadata files
Message-ID: <Z1fPMLoVhmJMsb6j@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748741.122992.1561685220081336465.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748741.122992.1561685220081336465.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

