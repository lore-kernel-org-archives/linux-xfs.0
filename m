Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862AF42A82
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104410; cv=none; b=IJYVRbYbS5D7fC6ErDl+JrfZ/l1YMa0wofWZZAPQdJY869iXRrEVgdNs6Bao+Jr8ehqU4AVxKLd5oaCwUd9Xb/wiIfPmIz98LOu7zKsbcPkJLhPEvFQexxaFyLdBCO2pnQ36SnDuJF+68AvJG15a1DPJ7WMDlbsxdVzyiiLpGgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104410; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4qSvAbAn6dLzN+JRNY602omd+qy9/LUa4u3G8b8CTJEvRFwSg0SVlezeM+kAt/W9CyU03p8G8cEXE/j24u61hyIYLcg/kRwW8jXQtlDcPd0MzPgquvN7IvUESseKvQl2xzgz0pSQ8DvhqoWd9XzhnS5UEJOeA0WG9jwjH0nAgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Itf2HmbR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Itf2HmbR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Itf2HmbR8M886haZRMKHhBOjHZ
	1lKPoc5oiEtAb6HiSJYfAvVXsfbOyamqN3YB1aX0yAgbCK0SVgWgdgptZiorNAdjyg0CmO/YX9x18
	PxayUm9xjm7ZxxIkyvL1wUHdvoZG/LbrdFb6uYWkybes2aPdSPTck1GDUfFrA6SxCL1ulA9U/mhL2
	TQpTbzz+oir8eRt8m2FCqURng/qAhTgHjRTjteCHgygvuv4cmbem2vL4Gikzkt9eYvgiJmZNp2VbS
	xB9LADZuO7UyLOtKT7sDHPBpdMpyjJ8olJVBUQf2uLb3aiR8gpc2GBD1T/qLC1FLGW2/DVijv/Kdl
	gXmGdmyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LBo-0000000A6tD-17R9;
	Mon, 28 Oct 2024 08:33:28 +0000
Date: Mon, 28 Oct 2024 01:33:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_io: add a commitrange option to the
 exchangerange command
Message-ID: <Zx9MWHlFygYOoFbf@infradead.org>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
 <172983773420.3040944.255060526461776194.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773420.3040944.255060526461776194.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

