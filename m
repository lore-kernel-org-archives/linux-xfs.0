Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9873164D4
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771601981; cv=none; b=odFVoIsAsEGyZLL0ha+c0x6laJP2NMJ3UBQQVNbUC+gmu5ARwNE9ThQREjEpfZYBRWxW36FrnKXTa8l0pMZQhh2kzuq4eouYTKuoZTV96/WDTLCQuLYgkDSNrHx+VVP3czan6QWqpbLvVDMPN2dc+QNHCxPb+zgqE5ADh4p+Yes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771601981; c=relaxed/simple;
	bh=P3f8CV5LAPUzExHu68TaXjFh4WBhcyVngskppl2q9Bo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGIo/P+OEYyOM85qW88RiaykWZk5NJS2X5X6FpYFG+2Yjqyi7TE/q3xX/2R7vchTUElHjcd2zhvScGY1Efj5ekTz4a8TunZvye0a16W1X+Z+C4eNHKcBWxCpTA6Lr7hqd8kg4nELYODzySI24xD8pZS2CBcPI1B7QiuZ2gckmvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gF1GMF3j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gF1GMF3j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6NXkuigp/Y9mf+Lo5mvvulQ59YNXCkdOX8CO9v/tBnE=; b=gF1GMF3j1cv9hg7OK6JHwT8TqX
	u48jzCv5P69NXQhBUwgSVOK+xwJ6brx6UWb710oEkLPmbfbOIclP6qv0dpgBVEf358oxljpmA3HXV
	J9c1sk0+BlhJ076hTEC4El2/5f3D6gpDaviYvVj1KxR3ixfB0DwUUZZbqOfiqChFZ9BQcCCkn9MnR
	mEtq0hM/jukutf8jIReoJivZ5Rv4A2fZE0UH6cwdfdwLxHjGZsDbZNkqvM8LaXrEr9JkaYVXoqgj+
	pizbFcf7s8GAfQtS3onCS6Wb1wQzUyTNi3mob83zfBEK+QUCsPdOP9V6Jwf85fThsiAvyXUVfWc7t
	2DrIW6qQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vtSbS-0000000F47V-2wQ9;
	Fri, 20 Feb 2026 15:39:38 +0000
Date: Fri, 20 Feb 2026 07:39:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: remove xlog_in_core_2_t
Message-ID: <aZiAOukwRtc4_Dzy@infradead.org>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
 <177154456837.1285810.1825229967595111728.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177154456837.1285810.1825229967595111728.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The libxlog part looks good.  I actually had a local version, but
you keep beating me on submitting these ports..

