Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0461489FA5
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 12:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809107; cv=none; b=YdOFhgVrzBaTTub1A6TskTo5ffjtNgeaQ4rbK6Ld8H1oJQoTOeq81nLkQesfQr6QrcY6oNM5mzS5XWiWpwF5clNbWIRh9pQQqy1Ps029tpI0iZ8DhtuYJYyxUVnu/rqgZdupMmKP0820kzA6d0NCfTej5RGAaZf1TsxiwXTG1Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809107; c=relaxed/simple;
	bh=C8tQQjvWESFHtyzo3vK7eASn5tl1uxw4hMyZiIpgwvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUvA4QkOH+jt8ZlLJgoaiJkUQwEZkqQ6DBKGlMaVdOOeNzPpHk2Az0hakVcpvacAl26c3FsFWqTIIjQHflWrM0cq4hnON/UseVjYj1VlVeBn0qcGX+nSR+IThz1P4soih2iNJmGATANJmnjBlGAjW0O8tkT+mtjx8GNfYBfATW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mzHYwdcJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mzHYwdcJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C8tQQjvWESFHtyzo3vK7eASn5tl1uxw4hMyZiIpgwvA=; b=mzHYwdcJL2D1WI542tWD3bYImj
	dufUxPef40N5ONjyUXmuQZ9aP1VRVDG6CUkdP34REOOP0rfAGj0PvKZwYnisrewrXvKkFbvqA89In
	ZCa5TshvK3iotuawhL7OTv5zWhgR9UlTSeDILlgtfzTG1d5/VcUjrg/OdQ97y3IUnfCcpD0HRnx1I
	nXGLtFHdGcyYiFG/49OCyxs4pglyQLD3ODbIDGbPH1ndFyNW/QsXCh9qhCnwSC1IlcAjkMcs3bmM1
	b2NnPDJy9k2yjGOQkKlWcli+Gt2AdWyoSbbmJc4ahEX968/aucZ1AvXLtvvwMX+gCIPSfJ+XHF4IL
	J7EgWeEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFOs-0000000AUiR-2KHv;
	Mon, 12 Oct 2026 12:45:06 +0000
Date: Mon, 12 Oct 2026 05:45:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs: break out xattr entry checks into separate
 functions
Message-ID: <aszWUjcHL61h15ey@infradead.org>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
 <179151614837.3163896.5021594784263990587.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179151614837.3163896.5021594784263990587.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Much better, thanks!

Reviewed-by: Christoph Hellwig <hch@lst.de>
