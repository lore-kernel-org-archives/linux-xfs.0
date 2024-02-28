Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11F03FB9D
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140658; cv=none; b=WDCMKzIIuBspuVR526lWpwPmCONVyGCfjp3dNmLouQzoopZ3T0Qeqzx4Z0xbjSbEz3T3PBKx+p8fnr3VNrAcGLdJcM6R/vGSr48O1XREibamMYnthLk8Fru3XsKO3P5DVdoHAyoEgR7UNNIOAhqZcT6AWe88eBldHm5nZftLahc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140658; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eF+jHCg9PDLa8l8Tf/t1wa4k9lF4nedpKFlow2ZNQLEXLIJhcl2YjDmqmx8vzi9hExY84HjG/5BMfI7ooB1bvCqZKmZ5ZhdvfeSd5lvsKO9vuAfrGApSXoZM6BADBzSgoAqHfQYb0BagGsmjJk7hM7hhEa62BwjRnJbhl/vdmfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sT7Y/K3R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sT7Y/K3R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sT7Y/K3RYygX0iVsti7MbzS4I9
	VX2nU28lOGsGI/ikUYA+s4P+hXoXnHQDoGUUrXes1yaVYpf5MlBRMFkDLJDwkM/mCRO9zBTomF/ru
	xJzQ9CdSpBKkJObIpM1g2NIrXk7zsNAjgGbp1/dXJIhhhjyOPBBfp9eOblleLnreyNmG/uAI6Hr+d
	qwVELzRw30Rr7wCch7UArX3F+KG8ywC6Cx/s00JCiagv++X4ltl/S7KXmQrPdRik+5kxEli1PBv5P
	AzH5QXuBYZzdntex/z7gIWU9QugFhzzUmmVXMYa2q85d5uTHrLRGgf2rSDuGlvX8K6i0BpY/ey7av
	cGsm8ECg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNYm-0000000AG60-1teI;
	Wed, 28 Feb 2024 17:17:36 +0000
Date: Wed, 28 Feb 2024 09:17:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/4] xfs: online repair of parent pointers
Message-ID: <Zd9qsMy1kHIZCZlW@infradead.org>
References: <170900014444.939516.15598694515763925938.stgit@frogsfrogsfrogs>
 <170900014505.939516.8886194197832685589.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900014505.939516.8886194197832685589.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
