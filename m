Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93E5233123
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738904932; cv=none; b=lO/3cTDtOwVxyUOk+EHlssfXZOdM/mdL3inoY7RjIQa5DPXfOTTSpMfyb1iwhSAH7PjkFT+7bk3o6QbbiavygQE9Q260FoBB3+dKmQVURpHsVwVDHh8/W8NWydeqm1aJdYHqN5i5ryVDjneVVy9rayBj7yTrpGCk/uRMj/q0ngc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738904932; c=relaxed/simple;
	bh=t3C1s2dKw1GAKyrPGjBSQtZ/mk9G5XJMIRBYMyiH4OA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eh1z8bvS7/JNbh/REpcu/FOg7WZdydINOn0KpAQtTFQbD1R+DigOPnz7C1z41lRqhYBF22oYjgcHgZfAK75m9FPufw2qSxOUHE9SUo61ylUq9rkUav+7yicE3cEpnAhZ8v0DnW3ic1UbOuk8hoeNU8PEdxXvXkoU+fymRuVE8vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nnrdBlZY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nnrdBlZY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i4uSjMS6JB43IwRjdHIWP5Ypxe33euwY3oYrmvFVgD8=; b=nnrdBlZYJjfxpStbLEOl294ZYn
	jCSVzd84f+A/vGs8zyVijPd5iBTV2tYM7s/tZEFcv/9W2Ph9oegDdACjHYkByxdZX5LZzp51/u553
	1omvTW2j8soWCm9Rq7MYwL6FWb27rIxFIxGBx9ok0/UyxOJW3VIeayDw6ttjSW6UTn83B/LpoQtKz
	Hq3PoNCIiF7VHHOFruV+MPbNVaujreH0V6msclody4BdIueBEmOutbJ+3vCTWTIy7Qu++hTOCyV0O
	meQDaif6VHWzipZMqk7Va+Tl+05qzj5CXy0gY+cdXR3/+gY/YNaEYxYkKht4B6cJSCrhdvRGFqe5C
	PEMmHoig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGbj-00000008LUG-1B3e;
	Fri, 07 Feb 2025 05:08:51 +0000
Date: Thu, 6 Feb 2025 21:08:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/27] man: document userspace API changes due to rt rmap
Message-ID: <Z6WVY5N33Vdyq-Sz@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088157.2741033.18009447992987469682.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088157.2741033.18009447992987469682.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:50:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update documentation to describe userspace ABI changes made for realtime
> rmap support.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
