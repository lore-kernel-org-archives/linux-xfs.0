Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8CE63D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905751; cv=none; b=q6RUSopgtW55VXA1TeQsyKhQ3vCxJr8PNO3tPzCgC1b1jZ3PVEiTc2DnykNjVkK4EBTwH0LfTY4qoZlUMqZtUgGn9hNtF1+VznXMvS/ktJhe1P9IQ9orDO6/11xc4ZScKT+OOEc+kd+e5BX62BmNL2bDWw7IS+wvXPWcRomH+r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905751; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jyrv6cjo9anW/Rk3HbGQoAx/ejeQndwRbz9mahvNjCDx3WRPGXHOw7iffjnt3X1v6fFR/4G3dT8JPFAU5c8a3ex3B2ThZXXqVnXbGQaPHWmJsv+i7avV2xBPQzSJZsgbKU+y2Gp25tcVn/C5vexUAzvT6SRRdDBm3rLs/viiizc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nyzw1k4/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nyzw1k4/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Nyzw1k4/lpX8d4h5r16OC8stuG
	yAV4FKjCGGBPIekK0pjHwxlp76GfwXakwygSnrpHQPoTc9uJvDnk16Fnom8jNdjXTOD28hnfl647Q
	OAQvE5dX81B47C/2EiUZudU861ONoJW8gQRm6qvcmNfpwjZdf7qgB7tc1GBdOlA5DYETjoFXsA+KU
	qTThb1B8y11mPqrBU2ipELiWGjK9T2fg6G3M4hUvevjN5vxw5z0PkgptkaWzHOOQFZ7wF3kbpqAJV
	RFcSZRKhot8YMOQNksEmUH3sjXAcsV0aApIo8UKYhE10hFzEFKp2uq1PzO21R88jsu9qLZxwAacM8
	O0oJcMgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGov-00000008MPJ-3yXT;
	Fri, 07 Feb 2025 05:22:29 +0000
Date: Thu, 6 Feb 2025 21:22:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/27] xfs_repair: create a new set of incore rmap
 information for rt groups
Message-ID: <Z6WYlavhgprfcmhB@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088341.2741033.9571711667950343905.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088341.2741033.9571711667950343905.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
