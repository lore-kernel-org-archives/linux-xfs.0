Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545E9226187
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808255; cv=none; b=Gk5wVIa3DCpNOmNMVeJ1vege9UDqJSm4gYtWkimPNPgwh9jke0GECLgC6D1JhQlPf6ntu6608O0BBkbeBL21klnbjTgT8I4auxZAp6x/2OAhqqDR89QLuoGp8J3vDgespZFhopkso0kkTax2XdKXa1XUQeMI5e6Df+5SrJG9HGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808255; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WMLiEyG220KUASz+aQfg/QIoY+wMAi9LA/Rx4FCg6iKMaZxCR/7EfQaO9a5BqOD7vf4MuG6DQIIxI6C0UN4MD0Wl/EoUuN1hz56tXcJJ4VFhhhdCxOj4KcxoHZx8DZ/TfOy9G+xR83MvbdnFoUEz8HeHfqsO6QozjPtHFOFAC28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sAfn+E5/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sAfn+E5/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sAfn+E5/2TJVzwc6VkS2lJkVuL
	2e7iJgl79yTec1AoqdGFqf93kYGv+xRK6JgbzvR8TEfE2YvF4EeiZuQNMQBI1uO/QDl0INVmI4Zyp
	rGnC8DLIJv1WPfe6LF1b4+m2DHS5FPcT0eJ1iPwq9d+Q53fxgexJy5qxTm5f0bkTyJPzss2alicP3
	QOVI5HdTphNwSazvRf8OIYXNBidXh9KNmjLgrrYX8ixkdFT6OC9KgEMNkV3Pk9hc1Xcz4g3YlFPNN
	wMC3nk9AaGO3d5u0u1LkXjxZElujCmlEEb+nIjNnvFY1RKn7mF13JajWxxOI1EmsyUjG07xK4SadG
	CWNi6u3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsjF-0000000AH3C-4AoP;
	Tue, 10 Dec 2024 05:24:13 +0000
Date: Mon, 9 Dec 2024 21:24:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: add a utility to generate protofiles
Message-ID: <Z1fQfUBP_8dLIz99@infradead.org>
References: <173352749310.124368.15119896789476594437.stgit@frogsfrogsfrogs>
 <173352749377.124368.8194703433830845301.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352749377.124368.8194703433830845301.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

