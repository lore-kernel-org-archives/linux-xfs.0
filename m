Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3303B22619E
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809350; cv=none; b=BlDUwsa2Ujkb6uuzp6LAEESUyN5Ul3lc4N8rfwAdFfftJr+xAenylRsLCGk+TJVQFGTGkqa0oCaF5aIytHFQzY0fUlBZxDyTiKodrUJxWVzu1KzUEYYlAks4ZzuHEp6jjU73KA21npIWHL1Dvu0et3mc6JEJU3W5xD9JE6QNXmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809350; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bv3kB03zgAM7gVaiOUzwBVHfOESfuLvpC2YhAmSR3cSYS8WdY8uy0fm8MwTnPw55JBswK3o6DdwF8qaIi0/RZHwj6BrySC2vQQc20DhtX1vInDRhq9WG3AYmpDKt+kCYViOENPzMiwQhu49/7se1bfEV5mpAbO2pv/eZIM5qpQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z55oQxBm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z55oQxBm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Z55oQxBmzdRX8/bGG7QR3QDY6S
	KSN4QBOqJlLZoAhjPpQMvHSXPzoRLwUm9YSOmhc7Kcg6LuRhCbBqY6mjHd0DSNUY6T+IC+2rvSIuN
	79uFrhUYphuaXxK9iNrBLlJW3mPwgRCUTwlkRVU//4xVXM2+/csPqD4qGm9R/FcHN3Br3/1TC3b4e
	8bPcVVWocPI87+MiQFk0+LjJlOgOarawMZsk5tbMoJiN2pxLE+q6HbYXmEs6yuP9IrvP6QTf9IzCy
	56rD/VYc1xfghfDzw9iSc9ZZBwFuxw2CwIq7Guo8vFd/2ybClXeucFd+ovUyDgNvfUEv0GK/ShUmP
	UpPf2jug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKt0u-0000000AIlF-44KQ;
	Tue, 10 Dec 2024 05:42:28 +0000
Date: Mon, 9 Dec 2024 21:42:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/50] xfs_db: enable conversion of rt space units
Message-ID: <Z1fUxL0oFSmESoLG@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752403.126362.4952280816720663470.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752403.126362.4952280816720663470.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

