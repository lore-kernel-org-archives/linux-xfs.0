Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EDF54650;
	Wed, 19 Jun 2024 06:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777865; cv=none; b=Gfrbn5Jd3gc6xAo2SIY+QZ9wqbRHXi8Ty9Vp0rIQgIFyreOgW7byXjG+XeIE1klMePg9jCzogYq5evB4x/5fDksLfC1U73rLkYESS4023y7XalBbVn4ymSZDvad38tzznsa7jI6L/iD+bCw+ollA2+fygLEYQXJXUnZ9NmqD2ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777865; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9r3s6j9MifOLBnc/fXM2QIsoCmwJORJ2fFjx3FMiHQs68C+CAg036erbUmMRpZRLUDuIJn5dO1oXG8z3sfOLi8CzRCtXD5OgUvlkC4IezRZwh5dL2k62cPSj+AzTUwjnWrPOGR8oQ2qxlKoCc4rpzC2FVhwo0C9E3pHpbuH37Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XYT5PUUV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XYT5PUUV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XYT5PUUVcFlGIoLLMke7xmB8Sm
	/PIsOvW1X7jsQPiMvYBvEAQZoW6Ef+mFybuPmBgZZTuEWENWvvrNKYZY6nEyTw8GKszQzg/dDrGGU
	RvqG4KUFLUihRHUrQJOUxbetjrHQHG4KNGM0hmTHpD/JVQvqkiXv7o7mQ2SBcvOxLARRUU3xcj45q
	9veRMR5WJCYB3iOn4YAzH3USz8SxrvfsJzlIbeog9pHvcAwhyYBJ3oVI5zTGZkOK3SH0G4agDjcqg
	IGIyku/TNijmXArYrLRSTsmOTPc7ZWDrTzhjyR99DhOIFkXiv0dUw1s1DnhnO/72cA+eOS5XUqEbS
	Z52RN1MQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoda-0000000028r-44fs;
	Wed, 19 Jun 2024 06:17:42 +0000
Date: Tue, 18 Jun 2024 23:17:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, Allison Henderson <allison.henderson@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: add parent pointer test
Message-ID: <ZnJ4Bj1b33G5z-6s@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145945.793846.11376043647566822482.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145945.793846.11376043647566822482.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

