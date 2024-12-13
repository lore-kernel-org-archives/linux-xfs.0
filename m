Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58B51632CA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074398; cv=none; b=DOHBmTq86UXygjcc59wVuk7qVXvRuPW9OGGcEwJZw/hD5WvyNXI22i4qMMOavabLfoVYuGSTpnB9yeaOGc6L+juP6YrDzl2V/85f2cjaBLCC7KAmBN5i06jQxSJQE1gBrRwKZLljWnKt7GKE7n7ImTifUUa1cvoMUlAJMCfsnls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074398; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mlkbAmucb+O/I2ZMQVUnR9WQTfbd1+oKAz+25xsZzg+uT26vonGBSlpJfx4xQd6+lBFOMjwAw9qp5ehfxjBVXANrO9+VTu6qJlJ3qpQVVCHk3GNT5LQPnV5h2fCFGa9J1o+oMXOsk8C7yxqxPhYSRA/LqRr5gh8D0TZvbW8dLVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L/osHG5S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L/osHG5S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=L/osHG5SrSUAU4XDVseoGKvJjV
	yIVzBRHEivCg6LQ9AikWsK0oCm/1TyOU4w9c1MArrJ+HIcAgw0feJpQpBB71vmkFdtWJqlFK0k2YA
	t/zFtn4K9Vjqvh1H6Av8sLiNXbCQ9SR6SZEJIS/WA2bj8+QnEZRrTpz33dOwHj1sFeWvcBz9QK0n5
	deNxWJm0+gGi64667bDXlNMqKfPFtAEBFVczlGuzDjG3+bY+r0Dz7TCq8xbnBM2rgjDwAyaJ3RPDX
	vfFKB5T2qMB6FxQZ9AXHwGkUhBYGG3Pk5+7vBmDghFxSouy5VDVwquHY+XjFWk/WuumwoMX9OWRka
	WWteZpvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzxs-00000002wxi-2vUc;
	Fri, 13 Dec 2024 07:19:56 +0000
Date: Thu, 12 Dec 2024 23:19:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/37] xfs: repair rmap btree inodes
Message-ID: <Z1vgHM6i4fEs8YCz@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123812.1181370.1385680244042469564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123812.1181370.1385680244042469564.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

