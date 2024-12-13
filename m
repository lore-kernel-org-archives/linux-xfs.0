Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7F21ADFF6
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081587; cv=none; b=HVGnpE8/NR6jSY4cFSslu9NlvNcbCFjos4XYCxQf2PgFhab6IG5btfbpRyJzEG9ZP3VaPe8PTv13TIgOSHavtw8wVC5C7EQ3cxyl6KGZ9KZA3yFWy8QQxz9p8vR3YbsQBYLighMlmbVzlf8KaTwCwf/fKSX0N+E0gO+L51U9a4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081587; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QF/k4CzyWBldtJ62CTwiGIkWBIFFEVhDCgDRENQshbOWY1MthxQonIkdOYgKfrKmaE30sOAbgZv0GkUrwj3CQ//EGQBb4KJORkANxCqUOKGJptZlZu7UqFB+DO6hjJ+t6vNN2IiI7rj/4LfPyqPB/oL3//rAZdnSro5J01V1x4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ax54E68E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ax54E68E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ax54E68E1Fp1QsA6ZN8InI+0/f
	gRdUwssk+yPfNC4Y2cnGVqbw+2WYOT/03JGk0hDye7Eaki+Rb33iq7GwWLOH/LcEGwPvg5YDKpK7V
	wI1eSSeWy1QZjisguV1Lff8WiIcR0mZEPDFGo+HR9aLukj3YecCVIgy/xJWS7lUWsySk+kDjxHOKV
	6XiYxUuTYeXg+NluO+C2ZgypXoTu1YJZz0kfPbIJG6SRIdZLtUe6t+FJu1emGJ3uZxT1CzY9jbcW9
	8aK2CxjiqN39oVT0yxu3v8c4BIRhHQD+HmuzQ42rjiu7WOaQGPfRhtcKl6MO0OYLv6VCUYZOJhup3
	baTQ77nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1pq-00000003E4V-1OeO;
	Fri, 13 Dec 2024 09:19:46 +0000
Date: Fri, 13 Dec 2024 01:19:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/43] xfs: allow dquot rt block count to exceed rt
 blocks on reflink fs
Message-ID: <Z1v8MkFWytaT2Z06@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125116.1182620.14390017275681061865.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125116.1182620.14390017275681061865.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

