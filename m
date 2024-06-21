Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348BBEBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944911; cv=none; b=YYv0sD9hhTRKsMAoUTE6xaiwrCTeAzENoaMLy4nCy0z71CQjRlSVJgC+qitFtG/p/6lRAqzSQWuIwGbIU3NG4tm5QRZAuXl9uCr89wTrFr63L8Cd6JOqok1JZPRo5wyigqHTYgp/JQKp5JUm60OpGusbuYYCwWd6r6Lq26DcWxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944911; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O5l/KhO7mWk/goF0YVqGcmMQ0QoYcxaZQjcGome0dp57AmF90rl17uXR+xIa4fdkgOViqINA+oCx6uiDreugaIoiuRCA2l+5ziOc1RrAoaqMUscVk1KzmH5GLF/Rbylpdc7kKuCERLuRzU20DZJWukuvOK3twmlx5bwN9ZEf/bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=txLpATZB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="txLpATZB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=txLpATZB5yfoim3JU+hVdPVrHR
	g10HxjJjn/1jekcWKrHCX0ShrHiTKz1x6X49OgVlttWlsV+LzEZvDPy9aNww1jdpXG1PP0bVivAib
	AXgSKo/kdU7pPQpO9bDnAISEBguoISs6yU56NmnSU151/Otzlk/5aN3rAqH/MK+G9nhAwfSwjLfIS
	RtI9V04t2ki+bJl4RyeRGt3KP2VQs0cTK5QN8xb7wRj5t5s6BXSoYw0YJO/Wx4QATldeTlfzcS6g9
	Apc/Gdnke3hwcIUDXneB8HRt/JoCzlqw4OksDl0PrWMvkNecnQfD1yKzxBbXQXrBNAjgTTKHT9vkj
	UWlHxwWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW5t-00000007fhy-3ur2;
	Fri, 21 Jun 2024 04:41:49 +0000
Date: Thu, 20 Jun 2024 21:41:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs: hoist xfs_{bump,drop}link to libxfs
Message-ID: <ZnUEjQHv7L3wlqJX@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418137.3183075.9161813667351346245.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418137.3183075.9161813667351346245.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
