Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE2E38E8C9;
	Fri, 25 Sep 2026 05:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314420; cv=none; b=H9KZrWXmQSsJvQdQKfoWzlkZR/u7bXBEBfViyV8hSXhvl4CfC6Th/bFhk5UyU7q/I0HLdaGep7XFE2yzWH6gjF+BWk8ZP0D23zAIxRzssmYApOzgblnJyWF8jvuGxj8aV2dDdpnt41WjBKD286blNAEkOIMJ0X3//qJlGwlHDf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314420; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ObutX5p/XDimrVRpOC74q9QTQrfvcHuIXQ3znYP3mPVRnbkDz/0hQ7EidUV2UoTAE/8XRrtjbqULJsk8gvFggd/wZ1p4DcfEiRcVFPVmhjhfPp45IofAIam+ckhWIw+xJ2qhMTr7NTFFfyr9ThohfVTjLf2G3GXCTff9PqkdJko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EOGXHcIo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EOGXHcIo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EOGXHcIoDu+1WOHz3e89IpP3EQ
	11ShF+CWsR/aOGxWvhd5Qinsamnf5D4IBTVEjqpOqKt5SsUtov2rUGHvrTin0CElRfZlt0GxB3kD/
	bcXAaM21TPlX9nFOYfyE496E+JDKR/l+j8V0kxZg+Zz8CMIB127X9LZzmCFKlMBmcorDA9jGjYR27
	JKKFzD++aOwDzfBBU0xGUskY3ps12Nio1qvA33n9QLK15DvEuoyTGcWkUDeyeT6acYr04u/U9b0Tc
	r2tPVGtx24Tmv5ksSbjE3oFfAQ1CH7SFORVU0/l3UUanZgyoWWwfalvHITFgdAjPC92cdj8oBxzmD
	GCZXhsfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yZ0-0000000ChVu-3Xoo;
	Fri, 25 Sep 2026 05:33:38 +0000
Date: Thu, 24 Sep 2026 22:33:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: adjust checks for cross-AG reaping issues
Message-ID: <arYHsnuNbJNbYhvt@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932071.3344850.13288640767644794186.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932071.3344850.13288640767644794186.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
