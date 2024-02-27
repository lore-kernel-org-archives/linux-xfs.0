Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CFB1386C0
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709048989; cv=none; b=Mg5gstTQzA8W3X4IzTqdPMMlYN3KFcRbLG+97vW7QRX4/5MPAK8KnzrVAd3ew8+MiOCruTgzX4IxJbkzOqF6VKiVW5GdSTtm+ojusetlWf1lmZneLmOvGrqO7vQ66eg9TMCBqXtUTxEaknY5WdUXg+xXFvUKXOjqPlhBqQZils8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709048989; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEw4BqvWmNfhosKX8LU7M7xqXKsjBq5yRM8+h16ZMHj5Lo8yGiGv4udIkfVEhadseVeje6i5B1YlJPOATmLLXa1e8zyrWFebk9afW13JKNsVzTZfb/EcizQiaJSUnltrbEHoZxnd3yjGzIf3GhqWpB3vWY9wLzL39dZrlszQkkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j5WGexea; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j5WGexea"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=j5WGexeakNOU/kvFA1UBsPnPPn
	pnZW01EWRsdoDZcDF8I4MY07+LrbZahchCUlLYkoFlot+iOw1l7fFfuRtg8qiA9ozO+AlRatE+DP3
	DatNN/GMQdR5NTfmRVuw4JhTl+t1XAt+DNLGa8M3LnPM96S/MXpl+F+zlHlGcILmLqRzACaAoBwQ+
	4mF0xxU2HxPog+jknKYqlpsmhcwYRDbaHjm+Rxn0dXVo1gnDMHJIqZRSBurcxGfgoeVQ8AaLQTKma
	YLDMn8bUkvnSYWrL68j6/leBOeuYdimXxyOz8Ur9qaiQWobAHlsUxTkGIm2JegEzJ9TP0STv+EImK
	PqvChTMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reziF-00000005rA2-12RG;
	Tue, 27 Feb 2024 15:49:47 +0000
Date: Tue, 27 Feb 2024 07:49:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/6] xfs: move inode lease breaking functions to
 xfs_inode.c
Message-ID: <Zd4Emwz0r8h2jXZQ@infradead.org>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
 <170900011149.938068.2118965709387421042.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011149.938068.2118965709387421042.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
