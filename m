Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C84A94D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809673; cv=none; b=FY/or6ZCwbfwJnwNAnspzB8xGvHBqosJ1f/Qqh7fgHZLnmOV03qZDxt7vXDtRe8si8n6InocaNNRJCPe+AgfR0OGfMisftB9dgLrJqWVLMtNQ1jPICmznaZxUU65hlj3r2WkFUMMuauQvtI+X2WGrD+9C5D8FLg9jai42oLfJQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809673; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uw4OkCmehwgVZIwGcvFeWqJvgrBFEn7A2/4Bi0cJ6iIb8Wx2Ga7qLjEtQWnOeThlot12/8e5eU7oDJKUgei5hbzwSvhY1HIvkdIE5tjwvAspifMHxf6srINB6jEgxngua8dOlDFs4AMr4c4Tr8BsJZVhQYYVxqsuAe5E8d9hCUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PxsnNr2y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PxsnNr2y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PxsnNr2yH1rNoodt9d9qnkov6r
	6X/f96lxNNOCMNmhDx8cvAZ/ZhTT8q8dSmT7Et5IDPmXVdhHVELnwytM7z5jUgGfkTfqoUJBY1JB9
	Bg/h9c1PHhKm3TCbTdEwVEK11F76yHKpIZ4MrlJUDfo9S92j/wC0psY0WsaZQbbqLJcol974QE7mf
	zs/t4ldFdzOYOYc2Pjw+9/x7SmU2ezlDBo//epDDfkcgSFHtSd/f/eu8kQ3aXhxr03AQ5si+zNW3h
	ft+/lheRpNJ/mGxoADRlU3Lxxoftp7zwCGG2I9i72IQ+REZ3MuC6lgW8jdMcmVFjzfm2VSfwnEmXu
	XlDqGmRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKt68-0000000AJAb-0UTV;
	Tue, 10 Dec 2024 05:47:52 +0000
Date: Mon, 9 Dec 2024 21:47:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/50] xfs_db: dump rt summary blocks
Message-ID: <Z1fWCEDmVzh0Ji9q@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752464.126362.14717338357511129149.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752464.126362.14717338357511129149.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

