Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6F01AC458
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081150; cv=none; b=V6P/EoyEl5OeAdLQWkqA6byJxt41vVYnQ82s7+egl6yW7/zjYibAhb5uJ+fJR9ALqv3sNtLeUMdJOpo49viO8Ni+4UQFIu/XOLYdewqbFLyki4vXwpyRiSsqUBN+tPlzg23Xv4Nuc6SNc4dlWi1EfjUSpyyve9Hjv+5/6CGtruo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081150; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hKfFN+ELo5CdfWxspWrCR1QWP5Nq6o44ou6ssVvboD5DsFnxIKgLky8t7QkG+xwQrJPvVNUlnkyB8v/jYY8kd59Jw6WX9of0de5XnOMSgLOWWvkRFj/0kTaF5RyAvg/xwFjwu2mzPLPB9QRhA5vdGE2Koy4oBFMq+8s8g6AmMDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SW75z6Oq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SW75z6Oq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SW75z6OqNl6+znUa6PhbZZGyL0
	0xS0mbZ8xtENkkK+itaUWozIySrrNK0slSC9GFqvwfyAm1bCl4riURvsYDhLcdeI9UAt8SoPTjScy
	/+33rKA8n7UkKEHz73nKDs1ilTmO7/kP8TXZ+UvjUzv939CBn0bai1rdBzGaZGbTY/amro3JjXEf0
	9i3TYg8/CyVNbK60PBZTevq1R9nt2uOp3jkdB0W/0pqw8uUQHAUreKHRth8TYBWJsvFR1pHswtpa1
	rmPLfZaILgKCQ8QQhiLmtyhyVpTWGUgzQ81id804P0kYzhjFTUYSj2g88nlgCGNpThTN8o/qu3B/3
	DLDhs+1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1in-00000003Ca5-02KT;
	Fri, 13 Dec 2024 09:12:29 +0000
Date: Fri, 13 Dec 2024 01:12:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/43] xfs: wire up realtime refcount btree cursors
Message-ID: <Z1v6fKe6mMrINOD1@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124808.1182620.5439413915170337325.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124808.1182620.5439413915170337325.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

