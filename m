Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07E817E010
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070182; cv=none; b=NgntNYZTQeDW9qvDUhX7OII69P6H7bjExUnJ3ZfREoKwH4f7gGSp/5qKxI1LypzssuYdKDFOyPFZMa63/PekbrJUkY7/iXoKFgE9QpGaDturDjc/CjPSh8nyFf8SXcHcnVB61TIGS0fsVQHdtBhQYX8nlLJKa6uP4nG5EZJ3ov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070182; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YScccsQWg8HGYJ7Btl1IJaXwOUtz9qk026z0AH24qIrdOTMqtwPV6OJwcFYn9YmIuhUisqQAj5W/64WzW8X6rJzHttCzE787eENJRkxw4N14fwJkDd5weqUmjsHydp7y7NCCYtdxyLs6AF6+tvohfPWyI4wES6FmUgzairrPCTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Arsh6B4l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Arsh6B4l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Arsh6B4l05fyWt3rfQz2vsSpSw
	i1SZHMUXD3T0lSqIpQqhpVgAp6WWtOpCm1KhGUL8m3D5dsawL1nSr7f3LwZoFNDt2NuVUQHaRJFD7
	WI0HjH3EzvRAz0x2MN6p9bi5XeeDx8V8U6ZZ9KBQ/GgmyPRKD+n3k73g/rRx7HJHh+EnRLzbr55Vi
	TEDw0fWEJmm+K9UeRadIZSY4zugZThEI1EBINLA7cnIJfWxrU05ee8NoKQdg6uMzem6T2X8nAJRLL
	C8r2QGtvxCqrtip/CVLPB7hXLqF+UzJRWPkyc8GsZZRNGh+I8WCSSWa0XHyC9cdF5aXrCk1TD7qgI
	dmPZovfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLyrs-00000002qEx-1Myv;
	Fri, 13 Dec 2024 06:09:40 +0000
Date: Thu, 12 Dec 2024 22:09:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: hoist the node iroot update code out of
 xfs_btree_kill_iroot
Message-ID: <Z1vPpLNW_tmPLgLu@infradead.org>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
 <173405122280.1180922.16807915359252437057.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405122280.1180922.16807915359252437057.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

